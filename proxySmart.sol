// SPDX-License-Identifier: MIT

//    ,adPPYYba, 88       88 8b,dPPYba,  ,adPPYba,  8b,dPPYba, ,adPPYYba,
//    ""     `Y8 88       88 88P'   "Y8 a8"     "8a 88P'   "Y8 ""     `Y8
//    ,adPPPPP88 88       88 88         8b       d8 88         ,adPPPPP88
//    88,    ,88 "8a,   ,a88 88         "8a,   ,a8" 88         88,    ,88
//    `"8bbdP"Y8  `"YbbdP"'  88          `"YbbdP"'  88         `"8bbdP"Y8  

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract Withdraw is Ownable, ReentrancyGuard {

    address private _ERC20TokenAddress;
    IERC20 private _token;

    mapping(address => uint24) private _royaltyOwners;

    event TransferTo(uint256 amount, address indexed to);

    address[] private _ownersAddresses = [
        0xC154D60c47c1D58106856f2F117d94f722AB182d, // 0
        0xC300638dEDd7a0ce09C88c2D63679Bf4aC3FFb36, // 1
        0x6fd5Ffda42EDE529532FF16Ed77a9E4CEB832baD, // 2
        0x8853fa76B0117B6403CFf58b556e6cB5853b34c3, // 3
        0x0f552eA1eBF83BfBe5C3f80500Fb152e66cAdb66, // 4
        0xed55e1795A87eA7140b5F35977f21d6924BCDfe9  // 5
        // 6
    ];

    constructor(address ERC20TokenAddress, address usersWithdrawalSmart){

        _ERC20TokenAddress = ERC20TokenAddress;
        _token = IERC20(_ERC20TokenAddress);

        _ownersAddresses.push(usersWithdrawalSmart);

        _royaltyOwners[_ownersAddresses[0]] = 10;
        _royaltyOwners[_ownersAddresses[1]] = 10;
        _royaltyOwners[_ownersAddresses[2]] = 20;
        _royaltyOwners[_ownersAddresses[3]] = 10;
        _royaltyOwners[_ownersAddresses[4]] = 10;
        _royaltyOwners[_ownersAddresses[5]] = 10;
        _royaltyOwners[_ownersAddresses[6]] = 30;

    }

    function changeUsersWithdrawalSmartAddress(address withdrawalSmart) public onlyOwner {
        _ownersAddresses[6] = withdrawalSmart;
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

    function withdrawal() external nonReentrant onlyOwner returns(bool){

        require(_getBalanceOnERC20() > 0, "Withdrawal is not possible");
        uint256 currentBalance = _getBalanceOnERC20();

        for (uint i; i < _ownersAddresses.length; i++) {
            address addressReceiver = _ownersAddresses[i];
            _token.transfer(addressReceiver, currentBalance * _royaltyOwners[addressReceiver] / 100);
        }

        return true;
    }

}
