// SPDX-License-Identifier: MIT

//    ,adPPYYba, 88       88 8b,dPPYba,  ,adPPYba,  8b,dPPYba, ,adPPYYba,  
//    ""     `Y8 88       88 88P'   "Y8 a8"     "8a 88P'   "Y8 ""     `Y8  
//    ,adPPPPP88 88       88 88         8b       d8 88         ,adPPPPP88  
//    88,    ,88 "8a,   ,a88 88         "8a,   ,a8" 88         88,    ,88  
//    `"8bbdP"Y8  `"YbbdP"'  88          `"YbbdP"'  88         `"8bbdP"Y8  

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import "@openzeppelin/contracts/interfaces/IERC20.sol";
import "./ERC721A.sol";

contract Avrora is ERC721A, ReentrancyGuard {


    string private _baseTokenURI;


    constructor(
    ) ERC721A("Avrora-Generators", "AVR") {
    }

    function pack(uint32 a, uint32 b) private pure returns (uint64) {
        return (uint64(a) << 32) | uint64(b);
    }

    function unpack(uint64 c) private pure returns (uint32 a, uint32 b) {
        a = uint32(c >> 32);
        b = uint32(c);
    }


    modifier callerIsUser() {
        require(tx.origin == msg.sender, "The caller is another contract.");
        _;
    }


    function mint(address to)
        public
        onlyOwner
        returns(uint256)
    {   
        uint256 id;
        id = _safeMint(to, 1);
        emit Minted(to, id);    
        return id;
    }



    function numberMinted(address owner) public view returns (uint256) {
        return _numberMinted(owner);
    }


    function tokenURI(uint256 tokenId)
        public
        view
        virtual
        override
        returns (string memory)
    {
        if (!_exists(tokenId)) revert URIQueryForNonexistentToken();

        string memory baseURI = _baseURI();
        return
            bytes(baseURI).length != 0
                ? string(abi.encodePacked(baseURI, _toString(tokenId), ".json"))
                : "";
    }


    function _baseURI() internal view virtual override returns (string memory) {
        return _baseTokenURI;
    }


    function setBaseURI(string calldata baseURI) external onlyOwner {
        _baseTokenURI = baseURI;
    }

}

