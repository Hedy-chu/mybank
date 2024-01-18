// SPDX-License-Identifier: MIT
pragma solidity ^0.8.1;

interface IMyToken {
    function transferFrom(address from,address to,uint amount) external returns (bool);
    function transfer(address to, uint amount) external;
    function balanceOf(address addr) external view returns (uint);
}

contract TokenBank {
    IMyToken public immutable token;
    address public owner;
    mapping (address => uint) public depositAmount;
    error withdrowError();

    constructor(address addr) {
        token = IMyToken(addr);
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(owner == msg.sender, "only owner can do it");
        _;
    }

    function deposit(uint amount) public virtual {
        uint senderBalance = token.balanceOf((msg.sender));
        require(senderBalance > amount,"deposit fail");
        bool result = token.transferFrom(msg.sender,address(this),amount);
        if (result){
            depositAmount[msg.sender] += amount;
        }
        
    }



    function withdrow() public onlyOwner virtual{
        require(token.balanceOf((address(this))) > 0,"no balance");
        token.transfer(msg.sender,token.balanceOf((address(this))));
    }

}