//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";
import './CCToken.sol';

contract CCExchange {
    string public name = "CleverCoin Exchange";
    uint rate = 100;

    event CCTokenPurchased (
        address account,
        address token,
        uint amount,
        uint rate
    );

    event CCTokenSold (
        address account,
        address token,
        uint amount,
        uint rate
    );

    CCToken public ccToken;

    constructor(CCToken _ccToken) {
        ccToken = _ccToken;
    }

    function getName() external view returns (string memory) {
        console.log("Contract name:", name);
        return name;
    }

    function buyTokens() public payable {
        uint tokenAmount = msg.value * rate;
        require(
            ccToken.balanceOf(address(this))  >= tokenAmount,
            "Not enough tokens in contract"
        );

        ccToken.transfer(msg.sender, tokenAmount);
        //Emit event
        emit CCTokenPurchased(msg.sender, address(ccToken), tokenAmount, rate);
    }

    function sellTokens(uint _amount) public payable{
        uint etherAmount = _amount / rate;
        require(
            address(this).balance >= etherAmount, "Not enough ether in contract"
        );

        payable(msg.sender).transfer(etherAmount);
        ccToken.transferFrom(msg.sender, address(this), _amount);
        emit CCTokenSold(msg.sender, address(ccToken), _amount, rate);
    }

}

