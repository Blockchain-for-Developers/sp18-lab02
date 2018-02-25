pragma solidity ^0.4.17;

// Q3
contract XOR {
    function single_run(uint bitx, uint bity) public pure returns(uint) {
        if (bitx == bity) {
            return 0;
        } else {
            return 1;
        }
    }
}