pragma solidity 0.4.19;


contract Greeter {
    string private greeting;

    function Greeter(string _greeting) public {
        greeting = _greeting;
    }
    
    // use view instead of constant tellling the compiler
    // that this function is not modifiying the state
    function greet() public view returns(string) {
        return greeting;
    }
}
