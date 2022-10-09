pragma solidity ^0.8.7;

// SPDX-License-Identifier: MIT

//    ,adPPYYba, 88       88 8b,dPPYba,  ,adPPYba,  8b,dPPYba, ,adPPYYba,  
//    ""     `Y8 88       88 88P'   "Y8 a8"     "8a 88P'   "Y8 ""     `Y8  
//    ,adPPPPP88 88       88 88         8b       d8 88         ,adPPPPP88  
//    88,    ,88 "8a,   ,a88 88         "8a,   ,a8" 88         88,    ,88  
//    `"8bbdP"Y8  `"YbbdP"'  88          `"YbbdP"'  88         `"8bbdP"Y8

import "./AVR20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract reserveWithdrawal is Ownable, ReentrancyGuard {
    
    uint256 public lastWithdrawalTimestamp;
    AVR private _avrToken;
    
    address private _ownerAddress;

    constructor(){

        lastWithdrawalTimestamp = block.timestamp;

    }

    modifier twoSeventy() {
        require(block.timestamp - lastWithdrawalTimestamp >= 270 days, "30 days have not passed");
        _;
    }

    modifier avrInstanceInited() {
        require(address(_avrToken)!=address(0), "AVR token can't be equal to genesis address");
        _;
    }

    // Create AVRtoken instance
    function createAVRTokenInstance(address avrTokenAddress_) public onlyOwner {
        _avrToken = AVR(avrTokenAddress_);
    }

    function getBEP20Address() public view returns(address) {
        return address(_avrToken);
    }

    function getBalance() public view returns(uint256){
        return _avrToken.balanceOf(address(this));
    }

    function allowedWithdrawalTimestamp() public view returns(uint256) {
        return lastWithdrawalTimestamp + 270 days;
    }

    function sendReserve() public twoSeventy avrInstanceInited onlyOwner nonReentrant returns(bool){

        require(getBalance() > 0, "Withdrawal is not possible");
        uint256 allowedAmount = getBalance();

        // Send proceeds to owners
        _avrToken.transfer(0xD783684ad1d0FEE4A4f5b038D09c6E7c9117659f, allowedAmount);
        
        return true;
    }

}