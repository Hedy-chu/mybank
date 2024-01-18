// SPDX-License-Identifier: MIT
pragma solidity ^0.8.1;

import "./TokenBank.sol";
import"@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";


contract TokenBankV1 is TokenBank{
    using SafeERC20 for IERC20;
    IERC20 tokenAddr;
    constructor(address addr) TokenBank(addr){
        tokenAddr = IERC20(addr);
    }

    function tokensReceived(address user, uint amount) public returns (bool){
        if (msg.sender == address(tokenAddr)){
            depositAmount[user] += amount;
            return true;
        }
        return false;
    }

    function deposit(uint amount) public override  {
        uint senderBalance = token.balanceOf((msg.sender));
        require(senderBalance > amount,"deposit fail");
        tokenAddr.safeTransferFrom(msg.sender,address(this),amount);
        depositAmount[msg.sender] += amount;
    }

    function withdrow() public override {
        require(token.balanceOf((address(this))) > 0,"no balance");
        tokenAddr.safeTransferFrom(address(this),msg.sender,token.balanceOf((address(this))));
    }
}