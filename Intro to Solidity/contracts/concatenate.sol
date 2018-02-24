pragma solidity 0.4.19;


contract Concatenate {
    function concatWithoutImport(string _s, string _t) public returns (string) {
      bytes memory str1 = bytes(_s);
      bytes memory str2 = bytes(_t);
      string memory _str = new string(str1.length + str2.length);
      bytes memory result = bytes(_str);
      for (uint i = 0; i < str1.length; i++) result[i] = str1[i];
      for (uint k = 0; k < str2.length; k++) result[str1.length + k] = str2[k];
      return string(result);
    }

    /* BONUS */
    function concatWithImport(string s, string t) public returns (string) {
    }
}
