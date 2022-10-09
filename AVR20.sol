pragma solidity ^0.8.7;

// SPDX-License-Identifier: MIT

//    ,adPPYYba, 88       88 8b,dPPYba,  ,adPPYba,  8b,dPPYba, ,adPPYYba,  
//    ""     `Y8 88       88 88P'   "Y8 a8"     "8a 88P'   "Y8 ""     `Y8  
//    ,adPPPPP88 88       88 88         8b       d8 88         ,adPPPPP88  
//    88,    ,88 "8a,   ,a88 88         "8a,   ,a8" 88         88,    ,88  
//    `"8bbdP"Y8  `"YbbdP"'  88          `"YbbdP"'  88         `"8bbdP"Y8

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract AVR is ERC20 {

    using SafeMath for uint256;
    uint8 private _decimals;

    address private _withdrawalsContractAddress;


    event burnAVR(address payee, uint256 amount);

    constructor(
        address withdrawalsContractAddress_,
        address teamRevenue_,
        address marketingWithdrawal_, 
        address liquidWithdrawal_,
        address firstEOALiquidWithdrawal_,
        address reserveWithdrawal_
        ) ERC20("Avrora token", "AVR", 18) {
        _withdrawalsContractAddress = withdrawalsContractAddress_;

        _mint(_withdrawalsContractAddress, 345*1e23); // 34 500 000 AVR
        _mint(teamRevenue_, 55*1e23); // 5 500 000*1e18 AVR
        _mint(marketingWithdrawal_, 45*1e23); // 4 500 000 AVR
        _mint(liquidWithdrawal_, 24*1e23); // 2 400 000 AVR
        _mint(firstEOALiquidWithdrawal_, 1*1e23); // 100 000 AVR
        _mint(reserveWithdrawal_, 30*1e23); // 3 000 000 AVR
    }

    function burn(uint256 amount) public returns(bool) {

        require(address(msg.sender)!=address(0), "AVR Token can't burn from the zero address");
        

        uint256 accountBalance = _balances[msg.sender];
        require(accountBalance >= amount, "You don't have enough AVR tokens =(");

        unchecked {

            _balances[msg.sender] = accountBalance - amount.div(100).mul(91);

            _totalSupply -= amount.div(100).mul(91);
            
            // Send 9% to withdrawals smart contract
            transfer(_withdrawalsContractAddress, amount.div(100).mul(9));


        }
        
        emit burnAVR(msg.sender, amount);



        return true;

    }


}
