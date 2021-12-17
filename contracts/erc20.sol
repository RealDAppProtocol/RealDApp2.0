pragma solidity 0.8.0;

library safemath {

    function safeSub(uint256 a,uint256 b) internal pure returns (uint256) {
        require(b <= a, "required amount is not allowed");
        uint256 c = a - b;
        return c;
    }

    function safeAdd(uint256 a,uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");
        return c;
    }
}

contract erc20 {
    string public symbol;
    string public  name;
    uint256 public decimals;
    uint256 public _totalSupply;
    address contract_creator;

    mapping(address => uint256) balances;
    mapping(address => mapping(address => uint256)) allowed;

    event Transfer(address indexed from, address indexed to, uint256 tokens,string mssg);
    event Approval(address indexed tokenOwner, address indexed spender, uint256 tokens,string mssg);

   
    //Initializes smart contract and sets symbol,name,decimal,totalSupply of erc20 tokens  
    constructor(string memory sym,string memory nm,uint256 dec,uint256 ts) {
        symbol = sym;
        name = nm;
        decimals = dec;
        _totalSupply = ts;
        contract_creator=msg.sender;
        balances[msg.sender] = _totalSupply;
        emit Transfer(address(0), msg.sender, _totalSupply,"Tokens are transferrd to contract creator");
    }
    
    // Returns total supply of tokens
    function totalSupply() public view returns (uint256) {
        return _totalSupply  - balances[address(0)];
    }
 
    // Returns balanceOf of specific address
    function balanceOf(address tokenOwner) public view returns (uint256 balance) {
        return balances[tokenOwner];
    }
    
    // Transfer tokens from contract deployer to another account
    // to => receiver
    // tokens => number of erc20 tokens
    function transfer(address to, uint256 tokens) public returns (bool success) {
        require(balances[contract_creator]>=tokens,"Insufficient balance");
        balances[msg.sender] = safemath.safeSub(balances[msg.sender], tokens);
        balances[to] = safemath.safeAdd(balances[to], tokens);
        emit Transfer(msg.sender, to, tokens,"Tokens are transferred to receiver from contract creator");
        return true;
    }
 
    // Approve tokens for sending to spender from function caller 
    function approve(address spender, uint256 tokens) public returns (bool success) {
        require(balances[msg.sender] >= tokens,"Sender has Insufficient balance to approve allowance");
        allowed[msg.sender][spender] = tokens;
        emit Approval(msg.sender, spender, tokens,"Tokens are approved for Send");
        return true;
    }
    
    // After approving number of tokens to spender, spender calls this function for transferring tokens to, to account mentioned in the function behlaf of spender account
    function transferFrom(address from, address to, uint256 tokens) public returns (bool success) {
        require(balances[from]>tokens,"Insufficient balance");
        balances[from] = safemath.safeSub(balances[from], tokens);
        allowed[from][msg.sender] = safemath.safeSub(allowed[from][msg.sender], tokens);
        balances[to] = safemath.safeAdd(balances[to], tokens);
        emit Transfer(from, to, tokens,"Tokens are transferred to receiver from sender");
        return true;
    }
 
    // Returns allowance or balance spender has to transfer tokens from allowances of spender
    function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
        return allowed[tokenOwner][spender];
    }
 
}
