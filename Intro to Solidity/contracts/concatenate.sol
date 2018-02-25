pragma solidity ^0.4.17;

import "../library/strings.sol";

// Q4
contract Concatenate {
    using strings for *;
   
    function addString(string s1, string s2) public constant returns(string){
        var str = s1.toSlice().concat(s2.toSlice());
        return str;
    }
}