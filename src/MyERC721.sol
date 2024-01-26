// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Nonces.sol";

contract MyERC721 is Ownable,ERC721URIStorage,Nonces{
     Nonces  tokenIds;
    
    constructor () ERC721("MyErc721", "MY721")Ownable(msg.sender){
    }

    function mint(address to) public onlyOwner{
        uint256 tokenId = nonces(address(this));
        _mint(to, tokenId);
        _useNonce(address(this));
    }
    
    function setTokenURI(uint256 tokenId, string memory _tokenURI) public  {
        _setTokenURI(tokenId, _tokenURI);
    }

    function currentTokenId() public view returns(uint){
        return nonces(address(this)) -1;
    }

    function getNftBalance(address user) public view returns(uint256){
        return balanceOf(user);
    }


}