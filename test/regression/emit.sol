pragma solidity ^0.8.24;

contract EmitTest {

  event Approval(address indexed owner, address indexed spender, uint256 value);

  constructor() {
    emit Approval(address(1), address(0), address(2));
  }	
}
