pragma solidity ^0.4.17;

// Q1
contract Greeter {
    string greeting;
    
    function Greetier (string _greeting) public {
        greeting = _greeting;
    }
    
    function greet() public constant returns (string) {
        return greeting;
    }
} 
