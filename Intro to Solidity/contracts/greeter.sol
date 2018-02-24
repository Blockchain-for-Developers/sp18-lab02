pragma solidity 0.4.19;


contract Greeter {

    string private greeting = 'hello world!';

    function Greeter() public {
    }

    function greet() public constant returns (string) {
        return greeting;
    }
}
