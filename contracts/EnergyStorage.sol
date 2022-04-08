// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;
contract EnergyStorage {
  struct Account{
      uint256 cost;
      uint256 profit;
      int256 funds;
      bool isAccount;
  }
    address[] public accountList;
    address public owner ;
    int256 public marketPay;

    mapping(address => Account) public addressToAccount;

    modifier onlyOwner() {
        require(owner == msg.sender, "Ownable: caller is not the owner");
        _;
    }
    event notEnoughFunds(address _address, int256 _funds);
    event amountWithdrawn(uint256 amount);

  constructor(){
    owner = msg.sender;
  }
  function isAccount(address _address) public view returns(bool isIndeed) {
      return addressToAccount[_address].isAccount;
  }
  
  function updateAccount(address  _address, uint256 _cost,uint256 _profit) public{
    if(isAccount(_address)){
      addressToAccount[_address].cost+=_cost;
    addressToAccount[_address].profit+=_profit;
    }else{
      addressToAccount[_address].cost+=_cost;
      addressToAccount[_address].profit+=_profit;
      addressToAccount[_address].isAccount = true;
      accountList.push(_address);
    }
    
  }

  function fund() public payable{ // 1 ethereum is 1000 euro
      addressToAccount[msg.sender].funds+=int(msg.value);
  }
  function settle() onlyOwner public returns(int256){
    int256 temp;
    for (uint i=0; i<accountList.length; i++) {
            address acc = accountList[i];
            addressToAccount[acc].funds-=int(addressToAccount[acc].cost)-int(addressToAccount[acc].profit);
            temp+=int(addressToAccount[acc].cost)-int(addressToAccount[acc].profit);
            addressToAccount[acc].cost=0;
            addressToAccount[acc].profit=0;
            if(addressToAccount[acc].funds<0){
            emit notEnoughFunds(accountList[i], addressToAccount[acc].funds);
            }
        }
    marketPay =temp;
    return temp;
  }
  function test() onlyOwner public{
    marketPay=5*10**12;
  }
  function getDifferentAccount(address _address) onlyOwner public view returns(Account memory) {
     return addressToAccount[_address];
  }
  function withDrawMarket() onlyOwner public{
    address payable addr = payable(msg.sender);
    require(marketPay>0,"Energy surplus");
    require(uint(marketPay)<address(this).balance,"Not enough funds");
    addr.transfer(uint(marketPay));
    emit amountWithdrawn(uint(marketPay));
  }
  function withdraw() public{
    require(addressToAccount[msg.sender].funds>0);
    require(address(this).balance>uint(addressToAccount[msg.sender].funds),"Not Enough funds");

    address payable addr = payable(msg.sender);
    addr.transfer(uint(addressToAccount[msg.sender].funds));
    emit amountWithdrawn(uint(addressToAccount[msg.sender].funds));
    addressToAccount[msg.sender].funds=0;
  }
  function getAccount() public view returns(Account memory){
    return addressToAccount[msg.sender];
  }
}
