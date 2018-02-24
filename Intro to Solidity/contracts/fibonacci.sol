pragma solidity 0.4.19;


contract Fibonacci {
    /* Carry out calculations to find the nth Fibonacci number */
    function fibRecur(uint n) public pure returns (uint) {
      if (n == 0) {
        return 0;
      }
      if (n == 1) {
        return 1;
      }
      if (n >= 2) {
        return fibRecur(n - 1) + fibRecur(n - 2);
      }
    }

    /* Carry out calculations to find the nth Fibonacci number */
    function fibIter(uint n) public returns (uint) {
      uint prev = 0;
      uint curr = 1;
      uint result = prev + curr;

      for (uint256 i = 0; i < n; i++) {
        prev = curr;
        curr = result;
        result = prev + curr;
      }

      return result;
    }
}
