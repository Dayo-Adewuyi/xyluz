pragma solidity 0.8.4;
// SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/access/Ownable.sol";
import "./YourToken.sol";

contract Vendor is Ownable {

  event BuyTokens(address buyer, uint256 ethamount, uint256 tokenAmount);
   event SellTokens(address seller, uint256 tokenAmount);

  YourToken public yourToken;

  constructor(address tokenAddress) {
    yourToken = YourToken(tokenAddress);
  }

  uint256 public constant tokensPerEth = 100;

  // ToDo: create a payable buyTokens() function:
  function buyTokens() public payable{
      uint amount = msg.value * tokensPerEth;
      require(msg.value > 0, "you need to have money boss");
      (bool sent) = yourToken.transfer(msg.sender, amount);
    require(sent, "Failed to transfer token to user");

    emit BuyTokens(msg.sender,msg.value,amount);
  }

  // ToDo: create a withdraw() function that lets the owner withdraw ETH
  function withdraw() public onlyOwner {
    uint256 contractBalance = address(this).balance;
    require(contractBalance > 0, "money don finish");

    (bool sent,) = msg.sender.call{value: address(this).balance}("");
    require(sent, "transfer failed");
  }
  // ToDo: create a sellTokens() function:
 function sellTokens(uint256 amount) public {
    
    require(amount > 0, "must be greater ta zero");

    
    uint256 userBalance = yourToken.balanceOf(msg.sender);
    require(userBalance >= amount, "you can only sell what you have");
   
    uint256 amountToTransfer = amount / tokensPerEth;

    (bool sent) = yourToken.transferFrom(msg.sender, address(this), amount);
    require(sent, "transfer failed");

    (sent,) = msg.sender.call{value: amountToTransfer}("");
    require(sent, "Failed transfer");

    emit SellTokens(msg.sender,amount);
  }

}
