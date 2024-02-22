// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Test, console} from "forge-std/Test.sol";
import {IERC20Permit} from "@openzeppelin/contracts/token/ERC20/extensions/IERC20Permit.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";

/**
 * @notice 默克尔树白名单，Muticalls
 */
contract AirdopMerkleNFTMarket{
    event tokenPermit(address user, uint value, uint deadline);
    event claimNftEvent(uint tokenId, address owner, address buyer, uint price);
    address  public nftAddr;
    address public tokenAddr;
    bytes32 immutable public root;
    using SafeERC20 for IERC20;

    struct Call {
        address target;
        bytes callData;
    }

    constructor(address _nftAddr, address _tokenAddr, bytes32 _root){
        require(_nftAddr != address(0) && _tokenAddr != address(0), "address can't be zero");
        nftAddr = _nftAddr;
        tokenAddr = _tokenAddr;
        root = _root;
    }

    function permitPrePay(
        address _owner,
        uint256 _value,
        uint256 _deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) public returns(bool){
        console.log("msg.sender:",msg.sender);
        console.log("_owner:",_owner);
        IERC20Permit(tokenAddr).permit(_owner,address(this),_value,_deadline,v,r,s);
        emit tokenPermit(_owner,_value,_deadline);
        return true;
    }

    function claimNFT(address spender,uint256 tokenId, uint256 _value, bytes32 leaf, bytes32[] memory proof) public {
        bool vevify = MerkleProof.verify(proof, root, leaf);
        require(vevify,"White list check error");
        address owner = IERC721(nftAddr).ownerOf(tokenId);
        // IERC721(nftAddr).approve(address(this),tokenId);
        IERC20(tokenAddr).safeTransferFrom(spender,owner,_value);
        IERC721(nftAddr).safeTransferFrom(owner,spender,tokenId);
        emit claimNftEvent(tokenId,owner,spender,_value);
    }

    function test1(uint256 a) public {
        uint b = a;
    }

     function aggregate(Call[] calldata calls) public payable returns (uint256 blockNumber)  {
        require(calls.length > 0, "No calls");
        blockNumber = block.number;
        uint256 length = calls.length;
        // returnData = new bytes[](length);
        Call calldata call;
        for (uint256 i = 0; i < length; i++) {
            bool success;
            call = calls[i];
            console.log("call.target",call.target);
            console.logBytes(call.callData);
            (success,) = call.target.call(call.callData);
            console.log("success:",success);
            require(success, "Multicall3: call failed");
        }
    }
}