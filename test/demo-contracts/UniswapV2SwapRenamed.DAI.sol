// SPDX-License-Identifier: MIT

// The source code of this contract uses the following contracts
// UniswapV2SwapExamples: https://solidity-by-example.org/defi/uniswap-v2/

pragma solidity ^0.8.24;

contract dAIMock {

    uint private constUINTMAX = 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff;

    uint256 public totalSupply;

    mapping (address daiact => uint)                      public balanceOf;
    mapping (address daiownr => mapping (address daispdr => uint)) public allowance;

    event approvalEvent(address indexed src, address indexed guy, uint wad);
    event transferEvent(address indexed src, address indexed dst, uint wad);

    function decimals() external returns (uint8) {
        uint8 dec = 18;
        return dec;
    }

    function name() public returns (string memory) {
        return "DAI Coin";
    }

    function symbol() public returns (string memory) {
        return "DAI";
    }

    function mint(address usr, uint wad) public {
        balanceOf[usr] = balanceOf[usr] + wad;
        totalSupply    = totalSupply + wad;
        emit transferEvent(address(0), usr, wad);
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
        emit approvalEvent(msg.sender, usr, wad);
        return true;
    }

    
    function transfer(address dst, uint wad) public returns (bool) {
        return transferFrom(msg.sender, dst, wad);
    }

    function transferFrom(address src, address dst, uint wad)
        public returns (bool)
    {
        require(balanceOf[src] >= wad, "Dai/insufficient-balance");
        if (src != msg.sender && allowance[src][msg.sender] != constUINTMAX) {
            require(allowance[src][msg.sender] >= wad, "Dai/insufficient-allowance");
            allowance[src][msg.sender] = allowance[src][msg.sender] - wad;
        }
        balanceOf[src] = balanceOf[src] - wad;
        balanceOf[dst] = balanceOf[dst] + wad;
        emit transferEvent(src, dst, wad);
        return true;
    }

    function safeTransferFrom(address from, address to, uint256 value) external{
        transferFrom(from, to, value);
    }


}
