pragma solidity ^0.4.17;

// Q2
contract Fibonacci {
    function fib(uint n) public pure returns(uint) {
        if (n == 1) {
            return 0;
        }
        else if (n <= 3) {
            return 1;
        }
        uint nth_fib = 1;
        uint prev = 0;
        // n-1 : exclude the 0th fib
        for (uint i = 1; i < n - 1; i++) {
            uint temp = nth_fib;
            nth_fib = nth_fib + prev;
            prev = temp;
        }
        return nth_fib;
    }
}