pragma solidity 0.4.19;

contract fibonacci {
    uint _curr = 0;
    uint _next = 1;

    function fibonnaci() public {
        _curr = 0;
        _next = 1;
    }


    function fibIter() public returns (uint fib) {
        uint stor = _curr;
        _curr = _next;
        _next = stor + _next;
        return stor;
    }
    
    
    
}
