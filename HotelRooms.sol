// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

//creating contract
contract HotelRoom {
    enum Statuses {
        Vacant,
        Occupied
    }
    Statuses public currentStatus; //for storing the current status of the room

    event Occupy(address _occupant, uint256 _value);//logs transaction details

    address payable public owner;//address of the owner of the room
    address Occupant;//adress of the occupant

    constructor() {  
        owner = payable(msg.sender); 
        currentStatus = Statuses.Vacant;
    }

//to ensure that the room is vacant
    modifier onlyWhileVacant() { 
        require(currentStatus == Statuses.Vacant, "Currently occupied.");
        _;
    }

//to ensure that the minimum amount is paid
    modifier costs(uint256 _amount) {
        require(msg.value >= _amount, "Not enough Ether provided.");
        _;
    }
    //to ensure that only occupant can decide to checkout
    modifier occupant(address _address) { 
        require(_address == Occupant,"Only Occupant Can checkout");
        _;
    }

    //to check whether the room is vaccant
    modifier isVacant() 
    {
        require(currentStatus == Statuses.Occupied, "Already Vacant");
        _;
    }

    //Function to book the room by changing the status and confirming the payment to the owner
    function book() public payable onlyWhileVacant costs(2 ether) {
        currentStatus = Statuses.Occupied;

        (bool sent, bytes memory data) = owner.call{value: msg.value}("");
        require(sent);
 Occupant=msg.sender;

        emit Occupy(msg.sender, msg.value);
    }

//Function to checkout from the room only by the occupant
    function leave() public isVacant  occupant(msg.sender) {
        currentStatus= Statuses.Vacant;
    }
    
}