// SPDX-License-Identifier: GPL-3.0;

pragma solidity >=0.5.0 <0.9.0;

contract Lottery{
    address payable[] public players;
    address public manager;

    constructor(){
        manager=msg.sender;
        players.push(payable(manager));
    }

    receive() external payable{
        require(msg.value == 0.1 ether);
        require(msg.sender != manager);
        players.push(payable(msg.sender));
    }

    function getBalance() public view returns(uint){
        require(msg.sender == manager);
        return address(this).balance;
    }

    function random() public view returns(uint){
        return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, players.length)));
    }

    function pickWinner() public{
        require(msg.sender == manager, "can be called only by owner");
        require(players.length >=3);

        uint r=random();
        address payable winner;

        uint index=r%players.length;
        winner = players[index];
        (payable(manager)).transfer(getBalance()/10);
        winner.transfer(getBalance());
        players = new address payable[](0);
        players.push(payable(manager));
    }

}