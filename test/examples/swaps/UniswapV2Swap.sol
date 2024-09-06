// SPDX-License-Identifier: MIT

// The source code of this contract uses the following contracts
// UniswapV2SwapExamples: https://solidity-by-example.org/defi/uniswap-v2/
// For the Router: https://github.com/Uniswap/v2-periphery/blob/master/contracts/UniswapV2Router02.sol
// For the Pairs: https://github.com/Uniswap/v2-core/blob/master/contracts/UniswapV2Pair.sol

pragma solidity ^0.8.24;

interface IERC20 {
    function balanceOf(address owner) external returns (uint256);
    function transfer(address to, uint256 value) external returns (bool);
    function transferFrom(address from, address to, uint256 value) external returns (bool);
    function approve(address spender, uint256 value) external returns (bool);
}

interface IUniswapV2Router02 {
    function swapExactTokensForTokens(uint256 amountIn, uint256 amountOutMin, address[] calldata path, address to)
        external
        returns (uint256[] memory amounts);
    function swapTokensForExactTokens(uint256 amountOut, uint256 amountInMax, address[] calldata path, address to)
        external
        returns (uint256[] memory amounts);
    function get_local_pair(address tokenA, address tokenB) external returns (address pair);
    function sync_local_pair(address tokenA, address tokenB) external;
}

interface IUniswapV2Pair {
    function sync() external;
    function swap(uint256 amount0Out, uint256 amount1Out, address to) external;
    function getReserves() external returns (uint112[] memory reserves);
    function mint(address to) external returns (uint256 liquidity);
}

contract UniswapV2Swap {
    IERC20 public weth;
    IERC20 public dai;
    IERC20 public usdc;
    UniswapV2Router02 public router;

    constructor(address _weth, address _dai, address _usdc) {
        weth = IERC20(_weth);
        dai = IERC20(_dai);
        usdc = IERC20(_usdc);
        router = new UniswapV2Router02();
    }

    function swapSingleHopExactAmountIn(uint256 amountIn, uint256 amountOutMin) external returns (uint256 amountOut) {
        weth.transferFrom(msg.sender, address(this), amountIn);
        weth.approve(address(router), amountIn);

        address[] memory path = new address[](2);
        path[0] = address(weth);
        path[1] = address(dai);

        uint256[] memory amounts = router.swapExactTokensForTokens(amountIn, amountOutMin, path, msg.sender);

        return amounts[1];
    }

    function swapMultiHopExactAmountIn(uint256 amountIn, uint256 amountOutMin) external returns (uint256 amountOut) {
        dai.transferFrom(msg.sender, address(this), amountIn);
        dai.approve(address(router), amountIn);

        address[] memory path = new address[](3);
        path[0] = address(dai);
        path[1] = address(weth);
        path[2] = address(usdc);

        uint256[] memory amounts = router.swapExactTokensForTokens(amountIn, amountOutMin, path, msg.sender);

        return amounts[2];
    }

    function swapSingleHopExactAmountOut(uint256 amountOutDesired, uint256 amountInMax)
        external
        returns (uint256 amountOut)
    {
        weth.transferFrom(msg.sender, address(this), amountInMax);
        weth.approve(address(router), amountInMax);

        address[] memory path = new address[](2);
        path[0] = address(weth);
        path[1] = address(dai);

        uint256[] memory amounts = router.swapTokensForExactTokens(amountOutDesired, amountInMax, path, msg.sender);

        if (amounts[0] < amountInMax) {
            weth.transfer(msg.sender, amountInMax - amounts[0]);
        }

        return amounts[1];
    }

    function swapMultiHopExactAmountOut(uint256 amountOutDesired, uint256 amountInMax)
        external
        returns (uint256 amountOut)
    {
        dai.transferFrom(msg.sender, address(this), amountInMax);
        dai.approve(address(router), amountInMax);

        address[] memory path = new address[](3);
        path[0] = address(dai);
        path[1] = address(weth);
        path[2] = address(usdc);

        uint256[] memory amounts = router.swapTokensForExactTokens(amountOutDesired, amountInMax, path, msg.sender);

        if (amounts[0] < amountInMax) {
            dai.transfer(msg.sender, amountInMax - amounts[0]);
        }

        return amounts[2];
    }
}

contract UniswapV2Router02 {
    mapping(address => mapping(address => address)) public local_pairs;

    function swapExactTokensForTokens(uint256 amountIn, uint256 amountOutMin, address[] calldata path, address to)
        external
        returns (uint256[] memory amounts)
    {
        amounts = uniswapV2Library_getAmountsOut(amountIn, path);
        require(amounts[amounts.length - 1] >= amountOutMin, "UniswapV2Router: INSUFFICIENT_OUTPUT_AMOUNT");
        IERC20(path[0]).transferFrom(msg.sender, uniswapV2Library_pairFor(path[0], path[1]), amounts[0]);
        _swap(amounts, path, to);
    }

    function swapTokensForExactTokens(uint256 amountOut, uint256 amountInMax, address[] calldata path, address to)
        external
        returns (uint256[] memory amounts)
    {
        amounts = uniswapV2Library_getAmountsIn(amountOut, path);
        require(amounts[0] <= amountInMax, "UniswapV2Router: EXCESSIVE_INPUT_AMOUNT");
        IERC20(path[0]).transferFrom(msg.sender, uniswapV2Library_pairFor(path[0], path[1]), amounts[0]);
        _swap(amounts, path, to);
    }

    function addLiquidity(
        address tokenA,
        address tokenB,
        uint256 amountADesired,
        uint256 amountBDesired,
        uint256 amountAMin,
        uint256 amountBMin,
        address to
    ) external returns (uint256[] memory amounts_liq) {
        amounts_liq = new uint256[](3);

        uint256[] memory amounts = _addLiquidity(tokenA, tokenB, amountADesired, amountBDesired, amountAMin, amountBMin);

        amounts_liq[0] = amounts[0];
        amounts_liq[1] = amounts[1];

        address pair = uniswapV2Library_pairFor(tokenA, tokenB);
        IERC20(tokenA).transferFrom(msg.sender, pair, amounts[0]);
        IERC20(tokenB).transferFrom(msg.sender, pair, amounts[1]);
        amounts_liq[2] = IUniswapV2Pair(pair).mint(to);
    }

    function set_local_pair(address tokenA, address tokenB) public {
        address[] memory tokens = uniswapV2Library_sortTokens(tokenA, tokenB);
        local_pairs[tokens[0]][tokens[1]] = address(new UniswapV2Pair(address(tokens[0]), address(tokens[1])));
    }

    function get_local_pair(address tokenA, address tokenB) public returns (address pair) {
        address[] memory tokens = uniswapV2Library_sortTokens(tokenA, tokenB);
        pair = local_pairs[tokens[0]][tokens[1]];
    }

    function sync_local_pair(address tokenA, address tokenB) public {
        address[] memory tokens = uniswapV2Library_sortTokens(tokenA, tokenB);
        UniswapV2Pair(local_pairs[tokens[0]][tokens[1]]).sync();
    }

    function _swap(uint256[] memory amounts, address[] memory path, address _to) private {
        for (uint256 i; i < path.length - 1; i++) {
            address input = path[i];
            address output = path[i + 1];
            address[] memory tokens = uniswapV2Library_sortTokens(input, output);
            uint256 amountOut = amounts[i + 1];

            uint256 amount0Out = input == tokens[0] ? uint256(0) : amountOut;
            uint256 amount1Out = input == tokens[0] ? amountOut : uint256(0);
            address to = i < path.length - 2 ? uniswapV2Library_pairFor(output, path[i + 2]) : _to;
            UniswapV2Pair(uniswapV2Library_pairFor(input, output)).swap(amount0Out, amount1Out, to);
        }
    }

    function _addLiquidity(
        address tokenA,
        address tokenB,
        uint256 amountADesired,
        uint256 amountBDesired,
        uint256 amountAMin,
        uint256 amountBMin
    ) internal returns (uint256[] memory amounts) {
        amounts = new uint256[](2);

        require(_get_local_pair(tokenA, tokenB) != address(0));

        uint256[] memory reserves = uniswapV2Library_getReserves(tokenA, tokenB);
        if (reserves[0] == 0 && reserves[1] == 0) {
            amounts[0] = amountADesired;
            amounts[1] = amountBDesired;
        } else {
            uint256 amountBOptimal = uniswapV2Library_quote(amountADesired, reserves[0], reserves[1]);
            if (amountBOptimal <= amountBDesired) {
                require(amountBOptimal >= amountBMin, "UniswapV2Router: INSUFFICIENT_B_AMOUNT");
                amounts[0] = amountADesired;
                amounts[1] = amountBOptimal;
            } else {
                uint256 amountAOptimal = uniswapV2Library_quote(amountBDesired, reserves[1], reserves[0]);
                assert(amountAOptimal <= amountADesired);
                require(amountAOptimal >= amountAMin, "UniswapV2Router: INSUFFICIENT_A_AMOUNT");
                amounts[0] = amountAOptimal;
                amounts[1] = amountBDesired;
            }
        }
    }

    function uniswapV2Library_pairFor(address tokenA, address tokenB) private returns (address pair) {
        address[] memory tokens = uniswapV2Library_sortTokens(tokenA, tokenB);
        pair = local_pairs[tokens[0]][tokens[1]];
    }

    function uniswapV2Library_sortTokens(address tokenA, address tokenB) private returns (address[] memory tokens) {
        tokens = new address[](2);
        require(tokenA != tokenB, "UniswapV2Library: IDENTICAL_ADDRESSES");
        tokens[0] = tokenA < tokenB ? tokenA : tokenB;
        tokens[1] = tokenA < tokenB ? tokenB : tokenA;
        require(tokens[0] != address(0), "UniswapV2Library: ZERO_ADDRESS");
    }

    function uniswapV2Library_getAmountsOut(uint256 amountIn, address[] memory path)
        private
        returns (uint256[] memory amounts)
    {
        require(path.length >= 2, "UniswapV2Library: INVALID_PATH");
        amounts = new uint256[](path.length);
        amounts[0] = amountIn;
        for (uint256 i; i < path.length - 1; i++) {
            uint256[] memory reserves = uniswapV2Library_getReserves(path[i], path[i + 1]);
            amounts[i + 1] = uniswapV2Library_getAmountOut(amounts[i], reserves[0], reserves[1]);
        }
    }

    function uniswapV2Library_getAmountOut(uint256 amountIn, uint256 reserveIn, uint256 reserveOut)
        private
        returns (uint256 amountOut)
    {
        require(amountIn > 0, "UniswapV2Library: INSUFFICIENT_INPUT_AMOUNT");
        require(reserveIn > 0 && reserveOut > 0, "UniswapV2Library: INSUFFICIENT_LIQUIDITY");
        uint256 amountInWithFee = amountIn * 997;
        uint256 numerator = amountInWithFee * reserveOut;
        uint256 denominator = reserveIn * 1000 + amountInWithFee;
        amountOut = numerator / denominator;
    }

    function uniswapV2Library_getReserves(address tokenA, address tokenB) private returns (uint256[] memory reserves) {
        reserves = new uint256[](2);
        address[] memory tokens = uniswapV2Library_sortTokens(tokenA, tokenB);
        uint112[] memory pair_reserves = UniswapV2Pair(uniswapV2Library_pairFor(tokenA, tokenB)).getReserves();
        reserves[0] = tokenA == tokens[0] ? pair_reserves[0] : pair_reserves[1];
        reserves[1] = tokenA == tokens[0] ? pair_reserves[1] : pair_reserves[0];
    }

    function uniswapV2Library_getAmountsIn(uint256 amountOut, address[] memory path)
        private
        returns (uint256[] memory amounts)
    {
        require(path.length >= 2, "UniswapV2Library: INVALID_PATH");
        amounts = new uint256[](path.length);
        amounts[amounts.length - 1] = amountOut;
        for (uint256 i = path.length - 1; i > 0; i--) {
            uint256[] memory reserves = uniswapV2Library_getReserves(path[i - 1], path[i]);
            amounts[i - 1] = uniswapV2Library_getAmountIn(amounts[i], reserves[0], reserves[1]);
        }
    }

    function uniswapV2Library_getAmountIn(uint256 amountOut, uint256 reserveIn, uint256 reserveOut)
        private
        returns (uint256 amountIn)
    {
        require(amountOut > 0, "UniswapV2Library: INSUFFICIENT_OUTPUT_AMOUNT");
        require(reserveIn > 0 && reserveOut > 0, "UniswapV2Library: INSUFFICIENT_LIQUIDITY");
        uint256 numerator = reserveIn * amountOut * 1000;
        uint256 denominator = (reserveOut - amountOut) * 997;
        amountIn = denominator != 0 ? (numerator / denominator) + 1 : 1;
    }

    function uniswapV2Library_quote(uint256 amountA, uint256 reserveA, uint256 reserveB)
        internal
        returns (uint256 amountB)
    {
        require(amountA > 0, "UniswapV2Library: INSUFFICIENT_AMOUNT");
        require(reserveA > 0 && reserveB > 0, "UniswapV2Library: INSUFFICIENT_LIQUIDITY");
        amountB = (amountA * reserveB) / reserveA;
    }
}

contract UniswapV2Pair {
    uint256 private UINT112_MAX = 0xffffffffffffffffffffffffffff;

    address public token0;
    address public token1;

    uint112 private reserve0;
    uint112 private reserve1;
    uint32 private blockTimestampLast;

    uint256 public MINIMUM_LIQUIDITY = 10 ** 3;
    uint256 public price0CumulativeLast;
    uint256 public price1CumulativeLast;
    uint256 public totalSupply;
    uint256 public kLast;

    mapping(address => uint256) public balanceOf;

    event Sync(uint112 reserve0, uint112 reserve1);
    event Swap(
        address indexed sender,
        uint256 amount0In,
        uint256 amount1In,
        uint256 amount0Out,
        uint256 amount1Out,
        address indexed to
    );

    constructor(address _token0, address _token1) {
        token0 = _token0;
        token1 = _token1;
    }

    function swap(uint256 amount0Out, uint256 amount1Out, address to) external {
        require(amount0Out > 0 || amount1Out > 0, "UniswapV2: INSUFFICIENT_OUTPUT_AMOUNT");
        uint112[] memory reserves = getReserves(); // gas savings
        require(amount0Out < reserves[0] && amount1Out < reserves[1], "UniswapV2: INSUFFICIENT_LIQUIDITY");

        uint256 balance0;
        uint256 balance1;
        {
            // scope for _token{0,1}, avoids stack too deep errors
            address _token0 = token0;
            address _token1 = token1;
            require(to != _token0 && to != _token1, "UniswapV2: INVALID_TO");
            if (amount0Out > 0) IERC20(_token0).transfer(to, amount0Out); // optimistically transfer tokens
            if (amount1Out > 0) IERC20(_token1).transfer(to, amount1Out); // optimistically transfer tokens
            balance0 = IERC20(_token0).balanceOf(address(this));
            balance1 = IERC20(_token1).balanceOf(address(this));
        }
        uint256 amount0In = balance0 > reserves[0] - amount0Out ? balance0 - (reserves[0] - amount0Out) : 0;
        uint256 amount1In = balance1 > reserves[1] - amount1Out ? balance1 - (reserves[1] - amount1Out) : 0;
        require(amount0In > 0 || amount1In > 0, "UniswapV2: INSUFFICIENT_INPUT_AMOUNT");
        {
            // scope for reserve{0,1}Adjusted, avoids stack too deep errors
            uint256 balance0Adjusted = (balance0 * 1000) - (amount0In * 3);
            uint256 balance1Adjusted = (balance1 * 1000) - (amount1In * 3);
            require(
                balance0Adjusted * balance1Adjusted >= uint256(reserves[0]) * reserves[1] * (1000 ** 2), "UniswapV2: K"
            );
        }

        _update(balance0, balance1, reserves[0], reserves[1]);
        emit Swap(msg.sender, amount0In, amount1In, amount0Out, amount1Out, to);
    }

    function mint(address to) external returns (uint256 liquidity) {
        uint112[] memory pair_reserves = _getReserves();
        uint256 balance0 = IERC20(token0).balanceOf(address(this));
        uint256 balance1 = IERC20(token1).balanceOf(address(this));
        uint256 amount0 = balance0 - pair_reserves[0];
        uint256 amount1 = balance1 - pair_reserves[1];

        //bool feeOn = _mintFee(pair_reserves[0], pair_reserves[1]);
        uint256 _totalSupply = totalSupply; // gas savings, must be defined here since totalSupply can update in _mintFee
        if (_totalSupply == 0) {
            liquidity = math_sqrt(amount0 * amount1) - MINIMUM_LIQUIDITY;
            totalSupply = totalSupply + MINIMUM_LIQUIDITY;
            balanceOf[address(0)] = balanceOf[address(0)] + MINIMUM_LIQUIDITY;
        } else {
            liquidity =
                math_min((amount0 * _totalSupply) / pair_reserves[0], (amount1 * _totalSupply) / pair_reserves[1]);
        }
        require(liquidity > 0, "UniswapV2: INSUFFICIENT_LIQUIDITY_MINTED");
        totalSupply = totalSupply + liquidity;
        balanceOf[to] = balanceOf[to] + liquidity;

        _update(balance0, balance1, pair_reserves[0], pair_reserves[1]);
        //if (feeOn) kLast = uint(reserve0) * reserve1; // reserve0 and reserve1 are up-to-date
        emit Mint(msg.sender, amount0, amount1);
    }

    function sync() external {
        _update(IERC20(token0).balanceOf(address(this)), IERC20(token1).balanceOf(address(this)), reserve0, reserve1);
    }

    function getReserves() public returns (uint112[] memory reserves) {
        reserves = new uint112[](3);
        reserves[0] = reserve0;
        reserves[1] = reserve1;
        reserves[2] = blockTimestampLast;
    }

    function math_min(uint256 x, uint256 y) internal returns (uint256 z) {
        z = x < y ? x : y;
    }

    function math_sqrt(uint256 y) internal returns (uint256 z) {
        if (y > 3) {
            z = y;
            uint256 x = y / 2 + 1;
            while (x < z) {
                z = x;
                x = (y / x + x) / 2;
            }
        } else if (y != 0) {
            z = 1;
        }
    }

    function _update(uint256 balance0, uint256 balance1, uint112 _reserve0, uint112 _reserve1) private {
        require(balance0 <= UINT112_MAX && balance1 <= UINT112_MAX, "UniswapV2: OVERFLOW");
        uint32 blockTimestamp = uint32(block.timestamp % 2 ** 32);
        uint32 timeElapsed = blockTimestamp - blockTimestampLast; // overflow is desired
        if (timeElapsed > 0 && _reserve0 != 0 && _reserve1 != 0) {
            price0CumulativeLast = price0CumulativeLast + (_reserve1 / _reserve0) * timeElapsed;
            price1CumulativeLast = price1CumulativeLast + (_reserve0 / _reserve1) * timeElapsed;
        }
        reserve0 = uint112(balance0);
        reserve1 = uint112(balance1);
        blockTimestampLast = blockTimestamp;
        emit Sync(reserve0, reserve1);
    }
}

contract WETHMock {
    uint256 private UINT256_MAX = 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff;

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    event Approval(address indexed owner, address indexed spender, uint256 value);
    event Transfer(address indexed from, address indexed to, uint256 value);

    function decimals() external returns (uint8) {
        return 18;
    }

    function deposit() external payable {
        balanceOf[msg.sender] = balanceOf[msg.sender] + msg.value;
        emit Transfer(address(0), msg.sender, msg.value);
    }

    function approve(address spender, uint256 value) external returns (bool) {
        allowance[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);

        return true;
    }

    function transfer(address to, uint256 value) external returns (bool) {
        if (to != address(0) && to != address(this)) {
            // Transfer
            uint256 balance = balanceOf[msg.sender];
            require(balance >= value, "WETH: transfer amount exceeds balance");

            balanceOf[msg.sender] = balance - value;
            balanceOf[to] = balanceOf[to] + value;
            emit Transfer(msg.sender, to, value);
        } else {
            // Withdraw
            uint256 balance = balanceOf[msg.sender];
            require(balance >= value, "WETH: burn amount exceeds balance");
            balanceOf[msg.sender] = balance - value;
            emit Transfer(msg.sender, address(0), value);

            (bool success,) = msg.sender.call{value: value}("");
            require(success, "WETH: ETH transfer failed");
        }

        return true;
    }

    function transferFrom(address from, address to, uint256 value) external returns (bool) {
        if (from != msg.sender) {
            uint256 allowed = allowance[from][msg.sender];
            if (allowed != UINT256_MAX) {
                require(allowed >= value, "WETH: request exceeds allowance");
                uint256 reduced = allowed - value;
                allowance[from][msg.sender] = reduced;
                emit Approval(from, msg.sender, reduced);
            }
        }

        if (to != address(0) && to != address(this)) {
            uint256 balance = balanceOf[from];
            require(balance >= value, "WETH: transfer amount exceeds balance");

            balanceOf[from] = balance - value;
            balanceOf[to] = balanceOf[to] + value;
            emit Transfer(from, to, value);
        } else {
            uint256 balance = balanceOf[from];
            require(balance >= value, "WETH: burn amount exceeds balance");
            balanceOf[from] = balance - value;
            emit Transfer(from, address(0), value);

            (bool success,) = msg.sender.call{value: value}("");
            require(success, "WETH: ETH transfer failed");
        }

        return true;
    }
}

contract DAIMock {
    uint256 private UINT_MAX = 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff;

    uint256 public totalSupply;

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    event Approval(address indexed src, address indexed guy, uint256 wad);
    event Transfer(address indexed src, address indexed dst, uint256 wad);

    function decimals() external returns (uint8) {
        return 18;
    }

    function mint(address usr, uint256 wad) public {
        balanceOf[usr] = balanceOf[usr] + wad;
        totalSupply = totalSupply + wad;
        emit Transfer(address(0), usr, wad);
    }

    function mintOnDeposit(address usr, uint256 wad) public {
        mint(usr, wad);
    }

    function burn(address usr, uint256 wad) public {
        if (balanceOf[usr] >= wad) {
            balanceOf[usr] = balanceOf[usr] - wad;
            totalSupply = totalSupply - wad;
        }
    }

    function approve(address usr, uint256 wad) external returns (bool) {
        allowance[msg.sender][usr] = wad;
        emit Approval(msg.sender, usr, wad);
        return true;
    }

    function transfer(address dst, uint256 wad) public returns (bool) {
        return transferFrom(msg.sender, dst, wad);
    }

    function transferFrom(address src, address dst, uint256 wad) public returns (bool) {
        require(balanceOf[src] >= wad, "Dai/insufficient-balance");
        if (src != msg.sender && allowance[src][msg.sender] != UINT_MAX) {
            require(allowance[src][msg.sender] >= wad, "Dai/insufficient-allowance");
            allowance[src][msg.sender] = allowance[src][msg.sender] - wad;
        }
        balanceOf[src] = balanceOf[src] - wad;
        balanceOf[dst] = balanceOf[dst] + wad;
        emit Transfer(src, dst, wad);
        return true;
    }

    function safeTransferFrom(address from, address to, uint256 value) external {
        transferFrom(from, to, value);
    }
}

contract USDCMock {
    uint256 private UINT256_MAX = 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff;

    uint256 private _totalSupply;

    mapping(address account => uint256) private _balances;
    mapping(address account => mapping(address spender => uint256)) private _allowances;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    function decimals() external returns (uint8) {
        return 18;
    }

    function mint(address account, uint256 value) public {
        require(account != address(0), "USDC: invalid receiver");
        _update(address(0), account, value);
    }

    function balanceOf(address account) public returns (uint256) {
        return _balances[account];
    }

    function transfer(address to, uint256 value) public returns (bool) {
        address owner = msg.sender;
        _transfer(owner, to, value);
        return true;
    }

    function allowance(address owner, address spender) public returns (uint256) {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 value) public returns (bool) {
        address owner = msg.sender;
        _approve(owner, spender, value, true);
        return true;
    }

    function transferFrom(address from, address to, uint256 value) public returns (bool) {
        address spender = msg.sender;
        _spendAllowance(from, spender, value);
        _transfer(from, to, value);
        return true;
    }

    function _transfer(address from, address to, uint256 value) private {
        require(from != address(0), "USDC: invalid sender");
        require(to != address(0), "USDC: invalid receiver");
        _update(from, to, value);
    }

    function _update(address from, address to, uint256 value) private {
        if (from == address(0)) {
            _totalSupply = _totalSupply + value;
        } else {
            uint256 fromBalance = _balances[from];
            require(fromBalance >= value, "USDC: insufficient balance");
            _balances[from] = fromBalance - value;
        }

        if (to == address(0)) {
            _totalSupply = _totalSupply - value;
        } else {
            _balances[to] = _balances[to] + value;
        }

        emit Transfer(from, to, value);
    }

    function _approve(address owner, address spender, uint256 value, bool emitEvent) private {
        require(owner != address(0), "USDC: invalid approver");
        require(spender != address(0), "USDC: invalid spender");
        _allowances[owner][spender] = value;
        if (emitEvent) {
            emit Approval(owner, spender, value);
        }
    }

    function _spendAllowance(address owner, address spender, uint256 value) private {
        uint256 currentAllowance = allowance(owner, spender);
        if (currentAllowance != UINT256_MAX) {
            require(currentAllowance >= value, "USDC: insufficient allowance");
            _approve(owner, spender, currentAllowance - value, false);
        }
    }
}

contract UniswapV2SwapTest {
    UniswapV2Swap private _uni;
    UniswapV2Router02 private _router;
    WETHMock private _weth;
    DAIMock private _dai;
    USDCMock private _usdc;

    function setUp() public {
        _weth = new WETHMock();
        _dai = new DAIMock();
        _usdc = new USDCMock();
        _uni = new UniswapV2Swap(address(_weth), address(_dai), address(_usdc));
        _router = new UniswapV2Router02();

        address[] memory tokens = _router.uniswapV2Library_sortTokens(address(_weth), address(_dai));
        _router.set_local_pair(tokens[0], tokens[1], address(new UniswapV2Pair(address(tokens[0]), address(tokens[1]))));

        tokens = _router.uniswapV2Library_sortTokens(address(_weth), address(_usdc));
        _router.set_local_pair(tokens[0], tokens[1], address(new UniswapV2Pair(address(tokens[0]), address(tokens[1]))));

        tokens = _router.uniswapV2Library_sortTokens(address(_usdc), address(_dai));
        _router.set_local_pair(tokens[0], tokens[1], address(new UniswapV2Pair(address(tokens[0]), address(tokens[1]))));

        _uni = new UniswapV2Swap(address(_weth), address(_dai), address(_usdc), address(_router));
    }

    function testSwapSingleHopExactAmountIn() public {
        uint256 wethAmount = 1e18;
        _weth.deposit{value: 2 * wethAmount}();
        _weth.approve(address(_uni), 2 * wethAmount);
        _dai.mint(address(this), wethAmount);
        _dai.approve(address(_uni), wethAmount);

        _weth.transfer(_uni.router().get_local_pair(address(_weth), address(_dai)), wethAmount);
        _dai.transfer(_uni.router().get_local_pair(address(_weth), address(_dai)), wethAmount);

        _uni.router().sync_local_pair(address(_weth), address(_dai));

        uint256 daiAmountMin = 1;
        uint256 daiAmountOut = _uni.swapSingleHopExactAmountIn(wethAmount, daiAmountMin);

        assert(daiAmountOut >= daiAmountMin);
    }

    function testSwapMultiHopExactAmountIn() public {
        uint256 wethAmount = 1e18;

        _weth.deposit{value: 4 * wethAmount}();
        _weth.approve(address(_uni), 8 * wethAmount);
        _dai.mint(address(this), 3 * wethAmount);
        _dai.approve(address(_uni), 3 * wethAmount);
        _usdc.mint(address(this), 2 * wethAmount);
        _usdc.approve(address(_uni), 2 * wethAmount);

        _weth.transfer(_uni.router().get_local_pair(address(_weth), address(_dai)), wethAmount);
        _dai.transfer(_uni.router().get_local_pair(address(_weth), address(_dai)), wethAmount);

        _uni.router().sync_local_pair(address(_weth), address(_dai));

        uint256 daiAmountMin = 1;
        _uni.swapSingleHopExactAmountIn(wethAmount, daiAmountMin);

        uint256 daiAmountIn = 1e18;

        _dai.transfer(_uni.router().get_local_pair(address(_dai), address(_weth)), daiAmountIn);
        _weth.transfer(_uni.router().get_local_pair(address(_dai), address(_weth)), daiAmountIn);
        _weth.transfer(_uni.router().get_local_pair(address(_weth), address(_usdc)), daiAmountIn);
        _usdc.transfer(_uni.router().get_local_pair(address(_weth), address(_usdc)), daiAmountIn);

        _uni.router().sync_local_pair(address(_dai), address(_weth));
        _uni.router().sync_local_pair(address(_weth), address(_usdc));

        uint256 usdcAmountOutMin = 1;
        uint256 usdcAmountOut = _uni.swapMultiHopExactAmountIn(daiAmountIn, usdcAmountOutMin);

        assert(usdcAmountOut >= usdcAmountOutMin);
    }

    function testSwapSingleHopExactAmountOut() public {
        uint256 wethAmount = 1e18;
        _weth.deposit{value: 10 * wethAmount}();
        _weth.approve(address(_uni), 6 * wethAmount);
        _dai.mint(address(this), 10 * wethAmount);
        _dai.approve(address(_uni), 4 * wethAmount);

        _weth.transfer(_uni.router().get_local_pair(address(_weth), address(_dai)), 4 * wethAmount);
        _dai.transfer(_uni.router().get_local_pair(address(_weth), address(_dai)), 4 * wethAmount);

        _uni.router().sync_local_pair(address(_weth), address(_dai));

        uint256 daiAmountDesired = 1e18;
        uint256 daiAmountOut = _uni.swapSingleHopExactAmountOut(daiAmountDesired, 2 * wethAmount);

        assert(daiAmountOut == daiAmountDesired);
    }

    function testSwapMultiHopExactAmountOut() public {
        uint256 wethAmount = 1e18;
        _weth.deposit{value: 20 * wethAmount}();
        _weth.approve(address(_uni), 20 * wethAmount);
        _dai.mint(address(this), 20 * wethAmount);
        _dai.approve(address(_uni), 20 * wethAmount);
        _usdc.mint(address(this), 10 * wethAmount);
        _usdc.approve(address(_uni), 10 * wethAmount);

        _weth.transfer(_uni.router().get_local_pair(address(_weth), address(_dai)), 8 * wethAmount);
        _dai.transfer(_uni.router().get_local_pair(address(_weth), address(_dai)), 8 * wethAmount);

        _uni.router().sync_local_pair(address(_weth), address(_dai));

        uint256 daiAmountOut = 2 * 1e18;
        _uni.swapSingleHopExactAmountOut(daiAmountOut, 4 * wethAmount);

        _dai.transfer(_uni.router().get_local_pair(address(_dai), address(_weth)), 2 * daiAmountOut);
        _weth.transfer(_uni.router().get_local_pair(address(_dai), address(_weth)), 2 * daiAmountOut);
        _weth.transfer(_uni.router().get_local_pair(address(_weth), address(_usdc)), 2 * daiAmountOut);
        _usdc.transfer(_uni.router().get_local_pair(address(_weth), address(_usdc)), 2 * daiAmountOut);
        _uni.router().sync_local_pair(address(_dai), address(_weth));
        _uni.router().sync_local_pair(address(_weth), address(_usdc));

        uint256 amountOutDesired = 1e6;
        uint256 amountOut = _uni.swapMultiHopExactAmountOut(amountOutDesired, daiAmountOut);

        assert(amountOut == amountOutDesired);
    }

    function testRouterAddLiquidity() public {
        uint256 testAmount = 131072; // Hex: 0x20000
        _dai.mint(address(this), testAmount);
        _dai.approve(address(_router), testAmount);
        _usdc.mint(address(this), testAmount);
        _usdc.approve(address(_router), testAmount);

        _router.addLiquidity(address(_dai), address(_usdc), 10000, 10000, 0, 0, address(this));

        assert(_dai.balanceOf(address(this)) == 121072);
        assert(_usdc.balanceOf(address(this)) == 121072);
        assert(_dai.balanceOf(_router.get_local_pair(address(_dai), address(_usdc))) == 10000);
        assert(_usdc.balanceOf(_router.get_local_pair(address(_dai), address(_usdc))) == 10000);
        assert(UniswapV2Pair(_router.get_local_pair(address(_dai), address(_usdc))).balanceOf(address(this)) == 9000);
    }
}
