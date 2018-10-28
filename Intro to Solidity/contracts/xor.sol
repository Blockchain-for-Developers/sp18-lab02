 
pragma solidity 0.4.25;
contract XOR{
    uint c;
    function xor (uint a,uint b) public view returns(uint) {
        if(a == b) {
            c = 0;
            return c;
        }
        else {
            c =1;
            return c;
        }
    }
}
