// SPDX-License-Identifier: MIT
pragma solidity ^0.8.1;
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract MyToken{
    using SafeERC20 for MyToken;
    string public _name;
    string public _symbol;
    uint256 public _totalsupply;
    mapping (address => uint) public _balances;
    mapping (address => mapping (address => uint)) public _allowances;

    address public _owner;

    error addressZero();
    error errorToAddr();
    error errorFromAddr();
    error balanceNoEnough();
    error allowanceNoEnough();

    constructor(string memory name, string memory symbol) {
        _name = name;
        _symbol = symbol;
        _owner = msg.sender;
    }
    modifier checkZero(uint amount){
        require(amount > 0 , "amount must bigger than zero");
        _;
    }

    modifier checkOwner(){
        require(_owner == msg.sender , "only owner can do it");
        _;
    }

    function decimals() public pure returns (uint){
        return 18;
    }

    function transfer(address to, uint amount) public virtual {

        uint balance = _balances[msg.sender];
        require(balance >= amount,"balance not enough");
        _update(msg.sender, to, amount);
    }

    function transferFrom(address from,address to,uint amount) public returns (bool){
        _spendAllowance(from,msg.sender,amount);
        _update(from,to,amount);
        return true;
    }

    function approve(address to, uint amount) public returns (bool){
        if (msg.sender == address(0)){
            revert errorFromAddr();
        }
        if (to == address(0) ){
            revert errorToAddr();
        }
        uint balance = _balances[msg.sender];
        require(balance >= amount,"balance not enough");
        _allowances[msg.sender][to] += amount;
        return true;
    }

    function mint(address to, uint amount) public checkZero(amount) checkOwner{
        if (to == address(0)){
            revert errorToAddr();
        }
        _update(address(0),to,amount);
    }

    function burn(address from, uint amount) public checkZero(amount){
        if (from == address(0)){
            revert errorFromAddr();
        }
        _update(from,address(0),amount);
    }
    
    function _update(address from, address to, uint value) internal   {
        if (from == address(0)){
            _totalsupply += value;
        }else {
            uint fromBalance = _balances[from];
            if (fromBalance < value){
                revert balanceNoEnough();
            }
            _balances[from] -= value;
        }

        if (to == address(0)){
            _totalsupply -= value;
        }else{
            _balances[to] += value;
        }

    }

    function _spendAllowance(address from, address spender, uint amount) internal  {
        // 少个最大值判断
        uint currentAllowance = _allowances[from][spender];
        if (currentAllowance < amount){
            revert  allowanceNoEnough();
        }
        _allowances[from][spender] = currentAllowance - amount;
    }

    function balanceOf(address addr) public view returns (uint) {
        return _balances[addr];
    }

}