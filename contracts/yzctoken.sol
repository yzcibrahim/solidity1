//SPDX-License-Identifier: GPL-3.0
 
pragma solidity >=0.5.0 <0.9.0;
// ----------------------------------------------------------------------------
// EIP-20: ERC-20 Token Standard
// https://eips.ethereum.org/EIPS/eip-20
// -----------------------------------------
 
interface ERC20Interface {
    function totalSupply() external view returns (uint);
    function balanceOf(address tokenOwner) external view returns (uint balance);
    function transfer(address to, uint tokens) external returns (bool success);
    
    function allowance(address tokenOwner, address spender) external view returns (uint remaining);
    function approve(address spender, uint tokens) external returns (bool success);
    function transferFrom(address from, address to, uint tokens) external returns (bool success);
    
    event Transfer(address indexed from, address indexed to, uint tokens);
    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
}

contract MyCryptos is ERC20Interface{
    string public name = "MyYzc";
    string public symbol = "CRPT2";
    uint public decimals = 0;//18
    uint public override totalSupply;

    address public founder;
    mapping(address => uint) public balances;
    //balances[0x111...] = 100;

    mapping(address => mapping(address => uint)) allowed;

    constructor(){
        totalSupply=1000000;
        founder = msg.sender;
        balances[founder]=totalSupply;
    }

    function balanceOf(address tokenOwner) public view override returns (uint balance){
        return balances[tokenOwner];
    }

    function transfer(address to, uint tokens) public override returns(bool success){
        require(balances[msg.sender]>=tokens);

        balances[to] +=tokens;
        balances[msg.sender] -= tokens;
        emit Transfer(msg.sender, to, tokens);
        return true;
    }

    function allowance(address tokenOwner, address spender) view public override returns (uint){
            return allowed[tokenOwner][spender];
    }
    function approve(address spender, uint tokens) public override returns (bool){
            require(balances[msg.sender]>=tokens);
            require(tokens>0);

            allowed[msg.sender][spender]=tokens;

            emit Approval(msg.sender, spender, tokens);

            return true;
    }

     function transferFrom(address from, address to, uint tokens) public override returns (bool){
         require(allowed[from][to] >= tokens);
         require(balances[from] >= tokens);

         balances[from] -= tokens;
         balances[to] += tokens;
         allowed[from][to] -=tokens;
         
         return true;
     }

}