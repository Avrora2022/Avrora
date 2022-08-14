// SPDX-License-Identifier: MIT

//    ,adPPYYba, 88       88 8b,dPPYba,  ,adPPYba,  8b,dPPYba, ,adPPYYba,
//    ""     `Y8 88       88 88P'   "Y8 a8"     "8a 88P'   "Y8 ""     `Y8
//    ,adPPPPP88 88       88 88         8b       d8 88         ,adPPPPP88
//    88,    ,88 "8a,   ,a88 88         "8a,   ,a8" 88         88,    ,88
//    `"8bbdP"Y8  `"YbbdP"'  88          `"YbbdP"'  88         `"8bbdP"Y8  

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract usersWithdrawal is Ownable {
    
    address private _ERC20TokenAddress;
    IERC20 private _token;

    constructor(address ERC20TokenAddress) {
        _ERC20TokenAddress = ERC20TokenAddress;
        _token = IERC20(_ERC20TokenAddress);
    }

    function changeERC20TokenAddress(address erc20Address) public onlyOwner {
        _token = IERC20(erc20Address);
    }

    function getERC20Address() public view returns(address) {
        return _ERC20TokenAddress;
    }

    function _getBalanceOnERC20() private view returns(uint256){
        uint256 balance = _token.balanceOf(address(this));
        return balance;
    }


    function withdraw(address to, uint256 amount) public onlyOwner returns(bool){

        require(_getBalanceOnERC20() >= amount, "Withdrawal is not possible");

        _token.transfer(to, amount);

        return true;

    }

}