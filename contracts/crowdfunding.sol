// SPDX-License-Identifier: GPL-3.0;

pragma solidity >=0.5.0 <0.9.0;

contract CrowdFunding{
    mapping(address => uint) public contributers;
    address public admin;
    uint public noOfContributors;
    uint public minimumContribution;
    uint public deadline; //timestamp
    uint public goal;
    uint public raisedAmount;
    struct Request{
        string description;
        address payable recipient;
        uint value;
        bool completed;
        uint noOfVoters;
        mapping(address=>bool) voters;
    }

    mapping(uint => Request) public requests;

    uint public numRequests;

    constructor(uint _goal, uint _deadline){
        goal = _goal;
        deadline = block.timestamp + _deadline;
        minimumContribution = 100 wei;
        admin=msg.sender;

    }

    function contribute() public payable{
        require(block.timestamp < deadline, "deadline has passed");
        require(msg.value >= minimumContribution, "minimum contribution not met");
        if(contributers[msg.sender]==0){
            noOfContributors++;
        }

        contributers[msg.sender]+=msg.value;
        raisedAmount += msg.value;
    }

    receive() payable external{
        contribute();
    }

    function getBalance() public view returns(uint){
    return address(this).balance;
    }

    function getRefund() public{
        require(block.timestamp > deadline && raisedAmount < goal);
        require(contributers[msg.sender] > 0);

        //  address payable receipient = payable(msg.sender);
        //  uint value = contributers[msg.sender];
        //  receipient.transfer(value);
         
         payable(msg.sender).transfer(contributers[msg.sender]);
         contributers[msg.sender] = 0;
    }

    modifier onlyAdmin(){
        require(msg.sender == admin, " only admin can call this");
        _;
    }

    function createRequest(string memory _description, address payable _recipient, uint _value) public onlyAdmin(){
        Request storage newRequset = requests[numRequests];
        numRequests++;
        newRequset.description = _description;
        newRequset.recipient = _recipient;
        newRequset.value = _value;
        newRequset.completed = false;
        newRequset.noOfVoters = 0;
    }

    function vpteRequest(uint _requestNo) public{
        require(contributers[msg.sender] > 0, "ony contibuters can vote");
        Request storage thisRequest = requests[_requestNo];

        require(thisRequest.voters[msg.sender] == false, "you have already voted");

        thisRequest.voters[msg.sender] = true;
        thisRequest.noOfVoters++;
    }
}