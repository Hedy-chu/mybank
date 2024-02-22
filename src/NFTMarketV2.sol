// SPDX-License-Identifier: MIT
pragma solidity ^0.8.3;

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "@openzeppelin/contracts-upgradeable/utils/cryptography/EIP712Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/NoncesUpgradeable.sol";

/**
 * @title NftMarketV2版本，新增离线上线，透明代理逻辑合约 version1
 */
interface IMyERC721 {
    function safeTransferFrom(address from, address to, uint256 tokenId) external ; 
    function approve(address to, uint256 tokenId) external;
    function getApproved(uint256 tokenId) external view returns (address);
    function ownerOf(uint256 tokenId) external view returns (address);
}
contract NFTMarketV2 is OwnableUpgradeable, IERC721Receiver, EIP712Upgradeable, NoncesUpgradeable {
    bytes32 private constant _PERMIT_TYPEHASH = keccak256("Storage(address allowUser,uint256 nonce)");
    IMyERC721 public nft;
    IERC20 public token;
    using SafeERC20 for IERC20;
    mapping (uint => mapping (address=> uint)) public listNft; //tokenId => address =>price
    mapping (uint => bool) public onSale; 

    error notOnSale();
    error hasBeBuyError();
    error priceError();
    error onSaled();
    event listToken(address user, uint256 tokenId, uint256 price );
    event buy(address user, uint256 tokenId, uint256 amount );
    event buyWithWL(address user, uint256 tokenId, uint256 amount );

    // bytes32 private constant _BUYBYSIG_TYPEHASH = keccak256("BuyBySig(uint256 tokenId,uint256 price,uint256 nonce)");

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    function initialize(address nftAddr,address tokenAddr) initializer public {
        __EIP712_init("NFTMarket","1");
        __Ownable_init(msg.sender);
        nft = IMyERC721(nftAddr);
        token = IERC20(tokenAddr);
        
    }

    modifier checkPrice(uint price){
        require(price > 0, "price must bigger than zero");
        _;
    }

    /**
     * 如果合约想接受nft必须实现该方法
     */
    function onERC721Received(
        address /*operator*/,
        address /*from*/,
        uint256 /*tokenId*/,
        bytes calldata  /*data*/
    ) external override pure returns (bytes4) {
      return this.onERC721Received.selector;
    }

    /**
     * nft上架
     */
    function list(uint tokenId, uint price) public checkPrice(price){
        if (onSale[tokenId]){
            revert onSaled();
        }
        nft.safeTransferFrom(msg.sender,address(this),tokenId);
        nft.approve(msg.sender,tokenId);
        listNft[tokenId][msg.sender] = price;
        onSale[tokenId] = true;
        emit listToken(msg.sender, tokenId, price);
    }
    /**
     * 购买nft
     * @param tokenId tokenid
     * @param amount 价格
     */

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
        emit buy(msg.sender, tokenId, amount);
    }

    /**
     * nft授权给market，token合约收到转账后直接调这个方法
     * @param user buyer
     * @param amount 数量
     * @param data tokenId+buyer
     */
    function tokensReceived(address user, uint amount, bytes calldata data) public returns (bool){
        (uint256 tokenId,address buyer) = abi.decode(data,(uint256,address));
        address approved = nft.getApproved(tokenId);
         if (!onSale[tokenId]){
            revert notOnSale();
        }
        if (amount < listNft[tokenId][approved]){
            revert priceError();
        }
        nft.safeTransferFrom(address(this),buyer,tokenId);
        token.safeTransfer(approved,amount);
        onSale[tokenId] = false;
        return true;
    }

    /**
     * 只有有白名单的人才可以购买
     */
    function buyNftWithWL(uint tokenId, uint amount,uint8 v, bytes32 r, bytes32 s) public {
        permit(msg.sender, v, r, s);
        buyNft(tokenId,amount);
    }
    
    /**
     * 验签方法
     * @param allowUser 给谁授权
     * @param v v
     * @param r r
     * @param s s
     */
    function permit(address allowUser, uint8 v, bytes32 r, bytes32 s) internal returns(bool){

        bytes32 structHash = keccak256(abi.encode(_PERMIT_TYPEHASH, allowUser,_useNonce(msg.sender)));

        bytes32 hash = _hashTypedDataV4(structHash);
        address signer = ECDSA.recover(hash, v, r, s);
        require(owner() == signer, "Permit: invalid signature");
        return owner() == signer;
    }
}