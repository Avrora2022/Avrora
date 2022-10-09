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

contract Team is Ownable, ReentrancyGuard  {

    uint256 public lastWithdrawalTimestamp;
    AVR private _avrToken;
    

    mapping(address => uint8) private _royaltyOwners;
    address[] private _ownersAddresses;


    constructor() {
        
        _royaltyOwners[0xf5cE22eC351683466ddA09c1863A10490fc27346] = 100;

        lastWithdrawalTimestamp = block.timestamp;
    }

    modifier thirtyDaysPassed() {
        require(block.timestamp - lastWithdrawalTimestamp >= 30 days, "30 days have not passed");
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

    // When withdrawal will be possible
    function allowedWithdrawalTimestamp() public view returns(uint256) {
        return lastWithdrawalTimestamp + 30 days;
    }

    function sendRevenue(uint8 percent) public thirtyDaysPassed avrInstanceInited  onlyOwner nonReentrant returns(bool){

        require(percent <= 10, "Exceeding the possible percentage");
        require(getBalance() > 0, "Withdrawal is not possible");
        uint256 allowedAmount = getBalance() * percent / 100;

        // Send proceeds to owners
        for (uint i; i < _ownersAddresses.length;) {
            address addressReceiver = _ownersAddresses[i];
            _avrToken.transfer(addressReceiver, allowedAmount * _royaltyOwners[addressReceiver] / 100);
            unchecked {
                i++; 
                }
        }
        
        // Change lastWithdrawalTimestamp
        lastWithdrawalTimestamp = block.timestamp;

        return true;
    }


}