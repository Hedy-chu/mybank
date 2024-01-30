// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Nonces.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "@openzeppelin/contracts/utils/cryptography/EIP712.sol";

contract MyERC721 is Ownable,ERC721URIStorage,Nonces,EIP712{
    Nonces  tokenIds;
    bytes32 private constant _PERMIT_TYPEHASH = keccak256("Permit(address toAddr,uint256 nonce,uint256 deadline)");

    constructor () ERC721("MyErc721", "MY721")Ownable(msg.sender)EIP712("MyERC721","1"){
    }

    function mint(address to) public onlyOwner{
        uint256 tokenId = nonces(address(this));
        _mint(to, tokenId);
        _useNonce(address(this));
    }
    
    function setTokenURI(uint256 tokenId, string memory _tokenURI) public  {
        _setTokenURI(tokenId, _tokenURI);
    }

    /**
     * 当前的tokenId
     */
    function currentTokenId() public view returns(uint){
        return nonces(address(this)) -1;
    }

    function getNftBalance(address user) public view returns(uint256){
        return balanceOf(user);
    }

    /**
     * 离线签名全部授权
     * @param toAddr 授权给谁
     * @param deadline 截止日期
     * @param v v
     * @param r r
     * @param s s
     */
    function offlineApprove(address toAddr, uint256 deadline, uint8 v, bytes32 r, bytes32 s) public  returns (bool) {
        bytes32 structHash = keccak256(abi.encode(_PERMIT_TYPEHASH, toAddr,_useNonce(msg.sender),deadline));

        bytes32 hash = _hashTypedDataV4(structHash);
        address signer = ECDSA.recover(hash, v, r, s);
        require(owner() == signer, "Permit: invalid signature");
        setApprovalForAll(toAddr, true);
    }



}