pragma solidity ^0.8.24;

interface IERC20 {
    function balanceOf(address owner) external returns (uint);
    function transfer(address to, uint value) external returns (bool);
    function transferFrom(address from, address to, uint value) external returns (bool);
    function approve(address spender, uint256 value) external returns (bool);
}

contract UniswapV2Swap {

    IERC20 public weth;
    IERC20 public dai;
    IERC20 public usdc;
    UniswapV2Router02 public router;

    constructor(address _weth, address _dai, address _usdc){
        weth = IERC20(_weth);
        dai = IERC20(_dai);
        usdc = IERC20(_usdc);
        router = new UniswapV2Router02();
        router.set_local_pair(_weth, _dai);
        router.set_local_pair(_weth, _usdc);
        router.set_local_pair(_usdc, _dai);
    }

    function swapSingleHopExactAmountIn(uint256 amountIn, uint256 amountOutMin)
        external
        returns (uint256 amountOut)
    {
        weth.transferFrom(msg.sender, address(this), amountIn);
        weth.approve(address(router), amountIn);

        address[] memory path;
        path = new address[](2);
        path[0] = address(weth);
        path[1] = address(dai);

        uint256[] memory amounts = router.swapExactTokensForTokens(amountIn, amountOutMin, path, msg.sender);

        return amounts[1];
    }

    function swapMultiHopExactAmountIn(uint256 amountIn, uint256 amountOutMin)
        external
        returns (uint256 amountOut)
    {
        dai.transferFrom(msg.sender, address(this), amountIn);
        dai.approve(address(router), amountIn);

        address[] memory path;
        path = new address[](3);
        path[0] = address(dai);
        path[1] = address(weth);
        path[2] = address(usdc);

        uint256[] memory amounts = router.swapExactTokensForTokens(amountIn, amountOutMin, path, msg.sender);

        return amounts[2];
    }

    function swapSingleHopExactAmountOut(
        uint256 amountOutDesired,
        uint256 amountInMax
    ) external returns (uint256 amountOut) {
        weth.transferFrom(msg.sender, address(this), amountInMax);
        weth.approve(address(router), amountInMax);

        address[] memory path;
        path = new address[](2);
        path[0] = address(weth);
        path[1] = address(dai);

        uint256[] memory amounts = router.swapTokensForExactTokens(amountOutDesired, amountInMax, path, msg.sender);

        if (amounts[0] < amountInMax) {
            weth.transfer(msg.sender, amountInMax - amounts[0]);
        }

        return amounts[1];
    }

    function swapMultiHopExactAmountOut(
        uint256 amountOutDesired,
        uint256 amountInMax
    ) external returns (uint256 amountOut) {
        dai.transferFrom(msg.sender, address(this), amountInMax);
        dai.approve(address(router), amountInMax);

        address[] memory path;
        path = new address[](3);
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

    mapping (address => mapping (address => address)) public local_pairs;

    function swapExactTokensForTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to
    ) external returns (uint[] memory amounts) {
        amounts = uniswapV2Library_getAmountsOut(amountIn, path);
        require(amounts[amounts.length - 1] >= amountOutMin, "UniswapV2Router: INSUFFICIENT_OUTPUT_AMOUNT");
        IERC20(path[0]).transferFrom(msg.sender, uniswapV2Library_pairFor(path[0], path[1]), amounts[0]);
        _swap(amounts, path, to);
    }

    function swapTokensForExactTokens(
        uint amountOut,
        uint amountInMax,
        address[] calldata path,
        address to
    ) external returns (uint[] memory amounts) {
        amounts = uniswapV2Library_getAmountsIn(amountOut, path);
        require(amounts[0] <= amountInMax, "UniswapV2Router: EXCESSIVE_INPUT_AMOUNT");
        IERC20(path[0]).transferFrom(msg.sender, uniswapV2Library_pairFor(path[0], path[1]), amounts[0]);
        _swap(amounts, path, to);
    }

    function set_local_pair(address tokenA, address tokenB) public{
        address token = uniswapV2Library_sortTokens(tokenA, tokenB);
        token = address(new UniswapV2Pair(address(token), address(token)));
    }

    function get_local_pair(address tokenA, address tokenB) public returns(address pair){
        address[] memory tokens = uniswapV2Library_sortTokens(tokenA, tokenB);
        pair = local_pairs[tokens[0]][tokens[1]];
    }

    function sync_local_pair(address tokenA, address tokenB) public{
        address[] memory tokens = uniswapV2Library_sortTokens(tokenA, tokenB);
        UniswapV2Pair(local_pairs[tokens[0]][tokens[1]]).sync();
    }

    function _swap(uint[] memory amounts, address[] memory path, address _to) internal {
        for (uint i; i < path.length - 1; i++) {
            address input = path[i];
            address output = path[i + 1];
            address[] memory tokens = uniswapV2Library_sortTokens(input, output);
            uint amountOut = amounts[i + 1];
            
            uint amount0Out = input == tokens[0] ? uint(0) : amountOut;
            uint amount1Out = input == tokens[0] ? amountOut : uint(0);
            address to = i < path.length - 2 ? uniswapV2Library_pairFor(output, path[i + 2]) : _to;
            UniswapV2Pair(uniswapV2Library_pairFor(input, output)).swap(
                amount0Out, amount1Out, to);
        }
    }

    function uniswapV2Library_pairFor(address tokenA, address tokenB) internal returns (address pair) {
        address[] memory tokens = uniswapV2Library_sortTokens(tokenA, tokenB);
        pair = local_pairs[tokens[0]][tokens[1]];
    }

    function uniswapV2Library_sortTokens(address tokenA, address tokenB) internal returns (address token) {
        require(tokenA != tokenB, "UniswapV2Library: IDENTICAL_ADDRESSES");
        token = tokenA < tokenB ? tokenA : tokenB;
        require(token != address(0), "UniswapV2Library: ZERO_ADDRESS");
    }

    function uniswapV2Library_getAmountsOut(uint amountIn, address[] memory path) internal returns (uint[] memory amounts) {
        require(path.length >= 2, "UniswapV2Library: INVALID_PATH");
        amounts = new uint[](path.length);
        amounts[0] = amountIn;
        for (uint i; i < path.length - 1; i++) {
            uint[] memory reserves = uniswapV2Library_getReserves(path[i], path[i + 1]);
            amounts[i + 1] = uniswapV2Library_getAmountOut(amounts[i], reserves[0], reserves[1]);
        }
    }

    function uniswapV2Library_getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) internal returns (uint amountOut) {
        require(amountIn > 0, "UniswapV2Library: INSUFFICIENT_INPUT_AMOUNT");
        require(reserveIn > 0 && reserveOut > 0, "UniswapV2Library: INSUFFICIENT_LIQUIDITY");
        uint amountInWithFee = amountIn*997;
        uint numerator = amountInWithFee*reserveOut;
        uint denominator = reserveIn*1000 + amountInWithFee;
        amountOut = numerator / denominator;
    }

    function uniswapV2Library_getReserves(address tokenA, address tokenB) internal returns (uint[] memory reserves) {
        reserves = new uint[](2);
        address[] memory tokens = uniswapV2Library_sortTokens(tokenA, tokenB);
        uint112[] memory pair_reserves = UniswapV2Pair(uniswapV2Library_pairFor(tokenA, tokenB)).getReserves();
        reserves[0] = tokenA == tokens[0] ? pair_reserves[0] : pair_reserves[1];
        reserves[1] = tokenA == tokens[0] ? pair_reserves[1] : pair_reserves[0];
    }
    
    function uniswapV2Library_getAmountsIn(uint amountOut, address[] memory path) internal returns (uint[] memory amounts) {
        require(path.length >= 2, "UniswapV2Library: INVALID_PATH");
        amounts = new uint[](path.length);
        amounts[amounts.length - 1] = amountOut;
        for (uint i = path.length - 1; i > 0; i--) {
            uint[] memory reserves = uniswapV2Library_getReserves(path[i - 1], path[i]);
            amounts[i - 1] = uniswapV2Library_getAmountIn(amounts[i], reserves[0], reserves[1]);
        }
    }

    function uniswapV2Library_getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) internal returns (uint amountIn) {
        require(amountOut > 0, "UniswapV2Library: INSUFFICIENT_OUTPUT_AMOUNT");
        require(reserveIn > 0 && reserveOut > 0, "UniswapV2Library: INSUFFICIENT_LIQUIDITY");
        uint numerator = reserveIn*amountOut*1000;
        uint denominator = (reserveOut-amountOut)*997;
        amountIn = denominator != 0 ? (numerator / denominator) + 1 : 1;
    }
}

contract UniswapV2Pair{

    address public token0;
    address public token1;

    uint112 private reserve0;           
    uint112 private reserve1;           
    uint32  private blockTimestampLast; 

    uint public MINIMUM_LIQUIDITY = 1000;
    uint public price0CumulativeLast;
    uint public price1CumulativeLast;
    uint public totalSupply;
    uint public kLast; 
    
    mapping(address => uint) public balanceOf;
    
    constructor(address _token0, address _token1) {
        token0 = _token0;
        token1 = _token1;
    }

    function swap(uint amount0Out, uint amount1Out, address to) external {
        require(amount0Out > 0 || amount1Out > 0, "UniswapV2: INSUFFICIENT_OUTPUT_AMOUNT");
        uint112[] memory reserves = getReserves(); // gas savings
        require(amount0Out < reserves[0] && amount1Out < reserves[1], "UniswapV2: INSUFFICIENT_LIQUIDITY");

        uint balance0;
        uint balance1;
        { // scope for _token{0,1}, avoids stack too deep errors
            address _token0 = token0;
            address _token1 = token1;
            require(to != _token0 && to != _token1, "UniswapV2: INVALID_TO");
            if (amount0Out > 0) IERC20(_token0).transfer(to, amount0Out); // optimistically transfer tokens
            if (amount1Out > 0) IERC20(_token1).transfer(to, amount1Out); // optimistically transfer tokens
            balance0 = IERC20(_token0).balanceOf(address(this));
            balance1 = IERC20(_token1).balanceOf(address(this));
        }
        uint amount0In = balance0 > reserves[0] - amount0Out ? balance0 - (reserves[0] - amount0Out) : 0;
        uint amount1In = balance1 > reserves[1] - amount1Out ? balance1 - (reserves[1] - amount1Out) : 0;
        require(amount0In > 0 || amount1In > 0, "UniswapV2: INSUFFICIENT_INPUT_AMOUNT");
        { // scope for reserve{0,1}Adjusted, avoids stack too deep errors
            uint balance0Adjusted = (balance0*1000)-(amount0In*3);
            uint balance1Adjusted = (balance1*1000)-(amount1In*3);
            require(balance0Adjusted*balance1Adjusted >= uint(reserves[0])*reserves[1]*(1000**2), "UniswapV2: K");
        }

        _update(balance0, balance1, reserves[0], reserves[1]);
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

    function _update(uint balance0, uint balance1, uint112 _reserve0, uint112 _reserve1) private {
        require(balance0 <= type(uint112).max && balance1 <= type(uint112).max, "UniswapV2: OVERFLOW");
        uint32 blockTimestamp = uint32(block.timestamp % 2**32);
        uint32 timeElapsed = blockTimestamp - blockTimestampLast; // overflow is desired
        if (timeElapsed > 0 && _reserve0 != 0 && _reserve1 != 0) {
            price0CumulativeLast = price0CumulativeLast + (_reserve1/_reserve0) * timeElapsed;
            price1CumulativeLast = price1CumulativeLast + (_reserve0/_reserve1) * timeElapsed;
        }
        reserve0 = uint112(balance0);
        reserve1 = uint112(balance1);
        blockTimestampLast = blockTimestamp;
    } 
}

contract WETHMock {

    mapping (address => uint256) public balanceOf;
    mapping (address => mapping (address => uint256)) public allowance;
    
    function decimals() external returns (uint8) {
        return 18;
    }

    function approve(address spender, uint256 value) external returns (bool) {
        allowance[msg.sender][spender] = value;

        return true;
    }

    function transfer(address to, uint256 value) external returns (bool) {
        if (to != address(0) && to != address(this)) { // Transfer
            uint256 balance = balanceOf[msg.sender];
            require(balance >= value, "WETH: transfer amount exceeds balance");

            balanceOf[msg.sender] = balance - value;
            balanceOf[to] = balanceOf[to] + value;
        } else { // Withdraw
            uint256 balance = balanceOf[msg.sender];
            require(balance >= value, "WETH: burn amount exceeds balance");
            balanceOf[msg.sender] = balance - value;

            (bool success, ) = msg.sender.call{value: value}("");
            require(success, "WETH: ETH transfer failed");
        }

        return true;
    }

    function transferFrom(address from, address to, uint256 value) external returns (bool) {
        if (from != msg.sender) {
            uint256 allowed = allowance[from][msg.sender];
            if (allowed != type(uint256).max) {
                require(allowed >= value, "WETH: request exceeds allowance");
                uint256 reduced = allowed - value;
                allowance[from][msg.sender] = reduced;
            }
        }

        if (to != address(0) && to != address(this)) { 
            uint256 balance = balanceOf[from];
            require(balance >= value, "WETH: transfer amount exceeds balance");

            balanceOf[from] = balance - value;
            balanceOf[to] = balanceOf[to] + value;
        } else { 
            uint256 balance = balanceOf[from];
            require(balance >= value, "WETH: burn amount exceeds balance");
            balanceOf[from] = balance - value;

            (bool success, ) = msg.sender.call{value: value}("");
            require(success, "WETH: ETH transfer failed");
        }

        return true;
    }
}

contract DAIMock {

    uint256 public totalSupply;

    mapping (address => uint)                      public balanceOf;
    mapping (address => mapping (address => uint)) public allowance;

    function decimals() external returns (uint8) {
        return 18;
    }

    function mint(address usr, uint wad) public {
        balanceOf[usr] = balanceOf[usr] + wad;
        totalSupply    = totalSupply + wad;
    }

    function mintOnDeposit(address usr, uint wad) public {
        mint(usr, wad);
    }
    
    function burn(address usr, uint wad) public {
        if(balanceOf[usr] >=  wad){
            balanceOf[usr] = balanceOf[usr] - wad;
            totalSupply    = totalSupply - wad;
        }
    }

    function approve(address usr, uint wad) external returns (bool) {
        allowance[msg.sender][usr] = wad;
        return true;
    }

    
    function transfer(address dst, uint wad) public returns (bool) {
        return transferFrom(msg.sender, dst, wad);
    }

    function transferFrom(address src, address dst, uint wad)
        public returns (bool)
    {
        require(balanceOf[src] >= wad, "Dai/insufficient-balance");
        if (src != msg.sender && allowance[src][msg.sender] != type(uint).max) {
            require(allowance[src][msg.sender] >= wad, "Dai/insufficient-allowance");
            allowance[src][msg.sender] = allowance[src][msg.sender] - wad;
        }
        balanceOf[src] = balanceOf[src] - wad;
        balanceOf[dst] = balanceOf[dst] + wad;
        return true;
    }

    function safeTransferFrom(address from, address to, uint256 value) external{
        transferFrom(from, to, value);
    }


}

contract USDCMock {
    uint256 private _totalSupply;
        
    mapping(address account => uint256) private _balances;  
    mapping(address account => mapping(address spender => uint256)) private _allowances;

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

    function _transfer(address from, address to, uint256 value) internal {
        require(from != address(0), "USDC: invalid sender");
        require(to != address(0), "USDC: invalid receiver");
        _update(from, to, value);
    }

    function _update(address from, address to, uint256 value) internal {
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

    }


    function _approve(address owner, address spender, uint256 value, bool emitEvent) internal {
        require(owner != address(0), "USDC: invalid approver");
        require(spender != address(0), "USDC: invalid spender");
        _allowances[owner][spender] = value;
    }

    function _spendAllowance(address owner, address spender, uint256 value) internal {
        uint256 currentAllowance = allowance(owner, spender);
        if (currentAllowance != type(uint256).max) {
            require(currentAllowance >= value, "USDC: insufficient allowance");
            _approve(owner, spender, currentAllowance - value, false);
            
        }
    }
    
    
}

contract UniswapV2SwapTest {

    UniswapV2Swap private _uni;
    WETHMock private _weth;
    DAIMock private _dai;
    USDCMock private _usdc;

    function setUp() public {
        _weth = new WETHMock();
        _dai = new DAIMock();
        _usdc = new USDCMock();
        _uni = new UniswapV2Swap(address(_weth), address(_dai), address(_usdc));
    }

    function testSwapSingleHopExactAmountIn() public {
        uint256 wethAmount = 1e18;
        _weth.approve(address(_uni), 2*wethAmount);
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
        
        _weth.approve(address(_uni), 8*wethAmount);
        _dai.mint(address(this), 3*wethAmount);
        _dai.approve(address(_uni), 3*wethAmount);
        _usdc.mint(address(this), 2*wethAmount);
        _usdc.approve(address(_uni), 2*wethAmount);

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
        uint256 usdcAmountOut =
            _uni.swapMultiHopExactAmountIn(daiAmountIn, usdcAmountOutMin);

        assert(usdcAmountOut >= usdcAmountOutMin);
    }

    function testSwapSingleHopExactAmountOut() public {
        uint256 wethAmount = 1e18;
        _weth.approve(address(_uni), 6*wethAmount);
        _dai.mint(address(this), 10*wethAmount);
        _dai.approve(address(_uni), 4*wethAmount);
        
        _weth.transfer(_uni.router().get_local_pair(address(_weth), address(_dai)), 4*wethAmount);
        _dai.transfer(_uni.router().get_local_pair(address(_weth), address(_dai)), 4*wethAmount);

        _uni.router().sync_local_pair(address(_weth), address(_dai));

        uint256 daiAmountDesired = 1e18;
        uint256 daiAmountOut =
            _uni.swapSingleHopExactAmountOut(daiAmountDesired, 2*wethAmount);

        assert(daiAmountOut == daiAmountDesired);
    }

    function testSwapMultiHopExactAmountOut() public {
        uint256 wethAmount = 1e18;
        _weth.approve(address(_uni), 20*wethAmount);
        _dai.mint(address(this), 20*wethAmount);
        _dai.approve(address(_uni), 20*wethAmount);
        _usdc.mint(address(this), 10*wethAmount);
        _usdc.approve(address(_uni), 10*wethAmount);

        _weth.transfer(_uni.router().get_local_pair(address(_weth), address(_dai)), 8*wethAmount);
        _dai.transfer(_uni.router().get_local_pair(address(_weth), address(_dai)), 8*wethAmount);

        _uni.router().sync_local_pair(address(_weth), address(_dai));

        uint256 daiAmountOut = 2 * 1e18;
        _uni.swapSingleHopExactAmountOut(daiAmountOut, 4*wethAmount);
        
        _dai.transfer(_uni.router().get_local_pair(address(_dai), address(_weth)), 2*daiAmountOut);
        _weth.transfer(_uni.router().get_local_pair(address(_dai), address(_weth)), 2*daiAmountOut);
        _weth.transfer(_uni.router().get_local_pair(address(_weth), address(_usdc)), 2*daiAmountOut);
        _usdc.transfer(_uni.router().get_local_pair(address(_weth), address(_usdc)), 2*daiAmountOut);
        _uni.router().sync_local_pair(address(_dai), address(_weth));
        _uni.router().sync_local_pair(address(_weth), address(_usdc));

        uint256 amountOutDesired = 1e6;
        uint256 amountOut =
            _uni.swapMultiHopExactAmountOut(amountOutDesired, daiAmountOut);

        assert(amountOut == amountOutDesired);
    }
}
