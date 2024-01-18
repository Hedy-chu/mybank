// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";

interface IMyERC721 {
    function safeTransferFrom(address from, address to, uint256 tokenId) external ; 
    function approve(address to, uint256 tokenId) external;
    function getApproved(uint256 tokenId) external view returns (address);
}
contract NFTMarket is Ownable,IERC721Receiver{
    IMyERC721 public nft;
    IERC20 public token;
    using SafeERC20 for IERC20;
    mapping (uint => mapping (address=> uint)) public listNft;
    mapping (uint => bool) public onSale;
    error notOnSale();
    error hasBeBuyError();
    error priceError();
    error onSaled();

    constructor(address nftAddr,address tokenAddr) Ownable(msg.sender){
        nft = IMyERC721(nftAddr);
        token = IERC20(tokenAddr);
    }
    modifier checkPrice(uint price){
        require(price > 0, "price must bigger than zero");
        _;
    }

    function onERC721Received(
        address /*operator*/,
        address /*from*/,
        uint256 /*tokenId*/,
        bytes calldata  /*data*/
    ) external override pure returns (bytes4) {
      return this.onERC721Received.selector;
    }

    function list(uint tokenId, uint price) public checkPrice(price){
        if (onSale[tokenId]){
            revert onSaled();
        }
        nft.safeTransferFrom(msg.sender,address(this),tokenId);
        nft.approve(msg.sender,tokenId);
        listNft[tokenId][msg.sender] = price;
        onSale[tokenId] = true;
    }

    function buyNft(uint tokenId, uint amount) public {
        if (!onSale[tokenId]){
            revert notOnSale();
        }
        if (amount < listNft[tokenId][msg.sender]){
            revert priceError();
        }
        token.safeTransferFrom(msg.sender,address(this),amount);
        nft.safeTransferFrom(address(this),msg.sender,tokenId);
        onSale[tokenId] = false;
    }

    function tokensReceived(address user, uint amount, bytes calldata data) public returns (bool){
        (uint256 tokenId,address buyer) = abi.decode(data,(uint256,address));
        address owner = nft.getApproved(tokenId);
         if (!onSale[tokenId]){
            revert notOnSale();
        }
        if (amount < listNft[tokenId][owner]){
            revert priceError();
        }
        nft.safeTransferFrom(address(this),buyer,tokenId);
        token.safeTransfer(owner,amount);
        onSale[tokenId] = false;
        return true;
    }
}