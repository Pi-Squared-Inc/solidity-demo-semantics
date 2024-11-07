// SPDX-License-Identifier: MIT

// The source code of this contract uses the following contracts
// UniswapV2SwapExamples: https://solidity-by-example.org/defi/uniswap-v2/

pragma solidity ^0.8.24;

contract USDCMock {
    uint256 private UINT256_MAX = 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff;

    uint256 private _totalSupply;
        
    mapping(address account => uint256) private _balances;  
    mapping(address account => mapping(address spender => uint256)) private _allowances;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    function decimals() external returns (uint8) {
        uint8 dec = 18;
        return dec;
    }

    function name() public returns (string memory) {
        return "USD Coin";
    }

    function symbol() public returns (string memory) {
        return "USDC";
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
