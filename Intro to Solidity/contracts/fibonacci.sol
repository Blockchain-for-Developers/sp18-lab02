pragma solidity 0.4.19;


contract Fibonacci {
    /* Carry out calculations to find the nth Fibonacci number */
    function fibRecur(uint n) public pure returns (uint) {
      if (n == 0)
        return 0;
      else if (n == 1)
        return 1;
      return fibRecur(n-1) + fibRecur(n-2);
    }

    /* Carry out calculations to find the nth Fibonacci number */
    function fibIter(uint n) public returns (uint) {
      uint prev = 0;
      uint curr = 1;
      uint counter = 1;
      while (counter < n) {
        uint temp = curr;
        curr = curr + prev;
        prev = temp;
        counter = counter + 1;
      }

      return curr;
    }
}
