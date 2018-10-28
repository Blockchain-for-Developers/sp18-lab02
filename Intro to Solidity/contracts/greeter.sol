pragma solidity 0.4.24;

contract Greeter {
    string private greeting;
    function Greeter() public {
     greeting = "Hello World";
    }
    function greet()public view returns (string){
        return greeting ;
    }
}
