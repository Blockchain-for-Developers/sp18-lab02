pragma solidity 0.4.19;


contract XOR {
    function xor(uint inputA, uint inputB) public pure returns (uint) {
      if (inputA == 0 && inputB == 0) { return 1; }
      if (inputA == 1 && inputB == 1) { return 1; }
      if (inputA == 0 && inputB == 1) { return 0; }
      if (inputA == 1 && inputB == 0) { return 0; }
    }
}
