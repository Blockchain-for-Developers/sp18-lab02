pragma solidity 0.4.19;

contract XOR {
    
    function xor(uint num1, uint num2) public pure returns (uint) {
        if (num1 == num2) {
            return 0;
        } else {
            return 1;
        }
    }
    
}
