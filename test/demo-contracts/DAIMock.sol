// SPDX-License-Identifier: MIT

// The source code of this contract uses the following contracts
// UniswapV2SwapExamples: https://solidity-by-example.org/defi/uniswap-v2/

pragma solidity ^0.8.24;

contract DAIMock {

    uint private UINT_MAX = 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff;

    uint256 public totalSupply;

    mapping (address => uint)                      public balanceOf;
    mapping (address => mapping (address => uint)) public allowance;

    event Approval(address indexed src, address indexed guy, uint wad);
    event Transfer(address indexed src, address indexed dst, uint wad);

    function decimals() external returns (uint8) {
        uint8 dec = 18;
        return dec;
    }

    function mint(address usr, uint wad) public {
        balanceOf[usr] = balanceOf[usr] + wad;
        totalSupply    = totalSupply + wad;
        emit Transfer(address(0), usr, wad);
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
        emit Approval(msg.sender, usr, wad);
        return true;
    }

    
    function transfer(address dst, uint wad) public returns (bool) {
        return transferFrom(msg.sender, dst, wad);
    }

    function transferFrom(address src, address dst, uint wad)
        public returns (bool)
    {
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

    function safeTransferFrom(address from, address to, uint256 value) external{
        transferFrom(from, to, value);
    }


}
