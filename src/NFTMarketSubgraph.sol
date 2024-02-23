// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "@openzeppelin/contracts/utils/cryptography/EIP712.sol";
import "@openzeppelin/contracts/utils/Nonces.sol";

/**
 * @title the graph实现可以查询nft owner
 */
interface IMyERC721 {
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external;

    function approve(address to, uint256 tokenId) external;

    function getApproved(uint256 tokenId) external view returns (address);

    function ownerOf(uint256 tokenId) external view returns (address);
}

contract NFTMarketSubgraph is Ownable, IERC721Receiver, EIP712, Nonces {
    bytes32 private constant _PERMIT_TYPEHASH =
        keccak256("Storage(address allowUser,uint256 nonce)");
    IMyERC721 public nft;
    IERC20 public token;
    using SafeERC20 for IERC20;
    mapping(uint => uint) public listPrice; //tokenId =>price
    mapping(uint => bool) public onSale;
    mapping(uint => address) public nftOwner; // tokenId => address

    error notOnSale();
    error hasBeBuyError();
    error priceError();
    error onSaled();
    event listToken(address user, uint256 tokenId, uint256 price);
    event buy(address seller, address buyer, uint256 tokenId, uint256 amount);
    event buyWithWL(address user, uint256 tokenId, uint256 amount);

    constructor(
        address nftAddr,
        address tokenAddr
    ) Ownable(msg.sender) EIP712("NFTMarket", "1") {
        nft = IMyERC721(nftAddr);
        token = IERC20(tokenAddr);
    }

    modifier checkPrice(uint price) {
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
        bytes calldata /*data*/
    ) external pure override returns (bytes4) {
        return this.onERC721Received.selector;
    }

    /**
     * nft上架
     */
    function list(uint tokenId, uint price) public checkPrice(price) {
        if (onSale[tokenId]) {
            revert onSaled();
        }
        nft.safeTransferFrom(msg.sender, address(this), tokenId);
        nft.approve(msg.sender, tokenId);
        listPrice[tokenId] = price;
        nftOwner[tokenId] = msg.sender;
        onSale[tokenId] = true;
        emit listToken(msg.sender, tokenId, price);
    }

    /**
     * 购买nft
     * @param tokenId tokenid
     * @param amount 价格
     */

    function buyNft(uint tokenId, uint amount) public {
        if (!onSale[tokenId]) {
            revert notOnSale();
        }
        if (amount < listPrice[tokenId]) {
            revert priceError();
        }
        token.safeTransferFrom(msg.sender, address(this), amount);
        nft.safeTransferFrom(address(this), msg.sender, tokenId);
        onSale[tokenId] = false;
        emit buy(nftOwner[tokenId], msg.sender, tokenId, amount);
    }

    /**
     * nft授权给market，token合约收到转账后直接调这个方法
     * @param user buyer
     * @param amount 数量
     * @param data tokenId+buyer
     */
    function tokensReceived(
        address user,
        uint amount,
        bytes calldata data
    ) public returns (bool) {
        (uint256 tokenId, address buyer) = abi.decode(data, (uint256, address));
        address approved = nft.getApproved(tokenId);
        if (!onSale[tokenId]) {
            revert notOnSale();
        }
        if (amount < listPrice[tokenId]) {
            revert priceError();
        }
        nft.safeTransferFrom(address(this), buyer, tokenId);
        token.safeTransfer(approved, amount);
        onSale[tokenId] = false;
        return true;
    }

    /**
     * 只有有白名单的人才可以购买
     */
    function buyNftWithWL(
        uint tokenId,
        uint amount,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) public {
        permit(msg.sender, v, r, s);
        buyNft(tokenId, amount);
    }

    /**
     * 验签方法
     * @param allowUser 给谁授权
     */
    function permit(
        address allowUser,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) internal returns (bool) {
        bytes32 structHash = keccak256(
            abi.encode(_PERMIT_TYPEHASH, allowUser, _useNonce(msg.sender))
        );

        bytes32 hash = _hashTypedDataV4(structHash);
        address signer = ECDSA.recover(hash, v, r, s);
        require(owner() == signer, "Permit: invalid signature");
        return owner() == signer;
    }
}
