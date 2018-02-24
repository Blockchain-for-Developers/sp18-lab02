pragma solidity 0.4.19;


contract Fibonacci {
    /* Carry out calculations to find the nth Fibonacci number */
    function fibRecur(uint n) public pure returns (uint) {
        if (n == 0) {
            return 0;
        } else if (n == 1) {
            return 1;
        } else {
            return fibRecur(n-1) + fibRecur(n-2);
        }
    }

    /* Carry out calculations to find the nth Fibonacci number */
    function fibIter(uint n) public returns (uint) {
        uint prev = 0;
        uint cur = 1;
        for (uint i = 0; i < n; i ++) {
            uint save = cur;
            cur = prev + cur;
            prev = save;
        }
        return cur;
    }
}
