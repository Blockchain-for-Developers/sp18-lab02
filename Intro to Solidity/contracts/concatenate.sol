pragma solidity 0.4.19;

contract Concatenate {
    
    function concatWithoutImport(string str1, string str2) public constant returns (string) {
        bytes memory _str1 = bytes(str1);
        bytes memory _str2 = bytes(str2);
        string memory _str = new string(_str1.length + _str2.length);
        bytes memory result = bytes(_str);
        for (uint i = 0; i < _str1.length; i++) result[i] = _str1[i];
        for (uint k = 0; k < _str2.length; k++) result[_str1.length + k] = _str2[k];
        return string(result);
    }
    
}
