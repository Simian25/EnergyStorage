// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

import '../node_modules/@openzeppelin/contracts/utils/math/SafeMath.sol';

contract Payment {
  using SafeMath for uint256;
  address public owner;
  
  constructor(){
    owner = msg.sender;
  }
  mapping(address => uint256) public addressToAmountFunded;
  event msgCast(address voter, uint256 value);
  function fund() public payable{
    addressToAmountFunded[msg.sender] += msg.value;
    emit msgCast(msg.sender, msg.value);
  }

  

  function withdraw() payable public{
    require(msg.sender==owner);
    address payable addr = payable(msg.sender);
    addr.transfer(address(this).balance);
  }
  }
