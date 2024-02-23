// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./MyToken.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import {ERC20Permit} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";

interface ITokenBankV1 {
    function tokensReceived(address user, uint amount) external returns (bool);
}

interface INftMarket {
    function tokensReceived(
        address user,
        uint amount,
        bytes calldata data
    ) external returns (bool);
}

contract MyTokenCallBack is ERC20, Ownable, ERC20Permit {
    error callBackError();
    error codeError();

    constructor()
        ERC20("MyToken", "MYT")
        Ownable(msg.sender)
        ERC20Permit("MyToken")
    {
        _mint(msg.sender, 100000 * 10 ** 18);
    }

    /**
     * 转入钱之后直接存款
     * @param to bank合约
     * @param amount 存款金额
     */
    function transfer(
        address to,
        uint256 amount
    ) public override returns (bool) {
        uint balance = balanceOf(msg.sender);
        require(balance >= amount, "balance not enough");
        _update(msg.sender, to, amount);

        // Check if the recipient is a contract
        if (to.code.length > 0) {
            bool callBack = ITokenBankV1(to).tokensReceived(msg.sender, amount);
            if (callBack) {
                return true;
            } else {
                revert callBackError();
            }
        }
        return true;
    }

    /**
     * 收到转账后直接调nftMarket的购买方法
     * @param to nftMarket
     * @param amount 价格
     * @param data tokenId+buyer
     */
    function transferForBuyNft(
        address to,
        uint256 amount,
        bytes calldata data
    ) public returns (bool) {
        uint balance = balanceOf(msg.sender);
        require(balance >= amount, "balance not enough");
        _update(msg.sender, to, amount);
        // Check if the recipient is a contract
        if (to.code.length > 0) {
            bool callBack = INftMarket(to).tokensReceived(
                msg.sender,
                amount,
                data
            );
            if (callBack) {
                return true;
            } else {
                revert callBackError();
            }
        }
        return true;
    }

    function mint(address to, uint256 value) public onlyOwner {
        _mint(to, value);
    }

    function getBalance(address user) public view returns (uint256) {
        return balanceOf(user);
    }
}
