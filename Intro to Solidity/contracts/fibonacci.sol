pragma solidity ^0.4.24;
contract Fibbonacci {
    uint a;
    uint b;
    uint c;
    uint n;
    uint i;
    constructor () public{
        a=0;
        b=1;
        i=1;
    }
    
    function fiboIter(uint _n) public returns(uint){
        n=_n;
        for(i=1; i<n; i++){
        c=a+b;
        a=b;
        b=c;
        }
        return c;
    }
    function print()public view returns(uint) {
        return c;   
    }
}
