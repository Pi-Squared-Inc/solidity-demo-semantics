// SPDX-License-Identifier: MIT

// The source code of this contract uses the following contracts
// UniswapV2SwapExamples: https://solidity-by-example.org/defi/uniswap-v2/

pragma solidity ^0.8.24;

contract uSDCMock {
    uint256 private constUINT256MAX = 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff;

    uint256 private vidTotalSupply;
        
    mapping(address account => uint256) private vidBalances;  
    mapping(address account => mapping(address spender => uint256)) private vidAllowances;

    event transferEvent(address indexed from, address indexed to, uint256 value);
    event approvalEvent(address indexed owner, address indexed spender, uint256 value);

    function decimals() external returns (uint8) {
        return 18;
    }

    function mint(address account, uint256 value) public {
        require(account != address(0), "USDC: invalid receiver");
        fidUpdate(address(0), account, value);
    }

    function balanceOf(address account) public returns (uint256) {
        return vidBalances[account];
    }

    function transfer(address to, uint256 value) public returns (bool) {
        address owner = msg.sender;
        fidTransfer(owner, to, value);
        return true;
    }

    function allowance(address owner, address spender) public returns (uint256) {
        return vidAllowances[owner][spender];
    }

    function approve(address spender, uint256 value) public returns (bool) {
        address owner = msg.sender;
        fidApprove(owner, spender, value, true);
        return true;
    }

    function transferFrom(address from, address to, uint256 value) public returns (bool) {
        address spender = msg.sender;
        fidSpendAllowance(from, spender, value);
        fidTransfer(from, to, value);
        return true;
    }

    function fidTransfer(address from, address to, uint256 value) private {
        require(from != address(0), "USDC: invalid sender");
        require(to != address(0), "USDC: invalid receiver");
        fidUpdate(from, to, value);
    }

    function fidUpdate(address from, address to, uint256 value) private {
        if (from == address(0)) {
            vidTotalSupply = vidTotalSupply + value;
        } else {
            uint256 fromBalance = vidBalances[from];
            require(fromBalance >= value, "USDC: insufficient balance");
            vidBalances[from] = fromBalance - value;
            
        }

        if (to == address(0)) {
            vidTotalSupply = vidTotalSupply - value;
            
        } else {
            vidBalances[to] = vidBalances[to] + value;
        }

        emit transferEvent(from, to, value);
    }


    function fidApprove(address owner, address spender, uint256 value, bool emitEvent) private {
        require(owner != address(0), "USDC: invalid approver");
        require(spender != address(0), "USDC: invalid spender");
        vidAllowances[owner][spender] = value;
        if (emitEvent) {
            emit approvalEvent(owner, spender, value);
        }
    }

    function fidSpendAllowance(address owner, address spender, uint256 value) private {
        uint256 currentAllowance = allowance(owner, spender);
        if (currentAllowance != constUINT256MAX) {
            require(currentAllowance >= value, "USDC: insufficient allowance");
            fidApprove(owner, spender, currentAllowance - value, false);
            
        }
    }
    
    
}
