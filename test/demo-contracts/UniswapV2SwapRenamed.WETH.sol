// SPDX-License-Identifier: MIT

// The source code of this contract uses the following contracts
// UniswapV2SwapExamples: https://solidity-by-example.org/defi/uniswap-v2/

pragma solidity ^0.8.24;

contract wETHMock {

    uint256 private constUINT256MAX = 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff;

    mapping (address wethact => uint256) public balanceOf;
    mapping (address wethownr => mapping (address wethspdr => uint256)) public allowance;
    
    event approvalEvent(address indexed owner, address indexed spender, uint256 value);
    event transferEvent(address indexed from, address indexed to, uint256 value);

    function decimals() external returns (uint8) {
        return 18;
    }

    function deposit() external payable {
        balanceOf[msg.sender] = balanceOf[msg.sender] + msg.value;
        emit transferEvent(address(0), msg.sender, msg.value);
    }
    
    function approve(address spender, uint256 value) external returns (bool) {
        allowance[msg.sender][spender] = value;
        emit approvalEvent(msg.sender, spender, value);

        return true;
    }

    function transfer(address to, uint256 value) external returns (bool) {
        if (to != address(0) && to != address(this)) { // Transfer
            uint256 balance = balanceOf[msg.sender];
            require(balance >= value, "WETH: transfer amount exceeds balance");

            balanceOf[msg.sender] = balance - value;
            balanceOf[to] = balanceOf[to] + value;
            emit transferEvent(msg.sender, to, value);
        } else { // Withdraw
            uint256 balance = balanceOf[msg.sender];
            require(balance >= value, "WETH: burn amount exceeds balance");
            balanceOf[msg.sender] = balance - value;
            emit transferEvent(msg.sender, address(0), value);

            (bool success, ) = msg.sender.call{value: value}("");
            require(success, "WETH: ETH transfer failed");
        }

        return true;
    }

    function transferFrom(address from, address to, uint256 value) external returns (bool) {
        if (from != msg.sender) {
            uint256 allowed = allowance[from][msg.sender];
            if (allowed != constUINT256MAX) {
                require(allowed >= value, "WETH: request exceeds allowance");
                uint256 reduced = allowed - value;
                allowance[from][msg.sender] = reduced;
                emit approvalEvent(from, msg.sender, reduced);
            }
        }

        if (to != address(0) && to != address(this)) { 
            uint256 balance = balanceOf[from];
            require(balance >= value, "WETH: transfer amount exceeds balance");

            balanceOf[from] = balance - value;
            balanceOf[to] = balanceOf[to] + value;
            emit transferEvent(from, to, value);
        } else { 
            uint256 balance = balanceOf[from];
            require(balance >= value, "WETH: burn amount exceeds balance");
            balanceOf[from] = balance - value;
            emit transferEvent(from, address(0), value);

            (bool success, ) = msg.sender.call{value: value}("");
            require(success, "WETH: ETH transfer failed");
        }

        return true;
    }
}
