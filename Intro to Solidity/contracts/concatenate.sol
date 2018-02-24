pragma solidity 0.4.19;


contract Concatenate {
  string a;
  string b;

  function Concatenate(string _a, string _b) { a = _a; b = _b; strConcat(a, b); }

  function strConcat(string _a, string _b) internal returns (string){
    bytes memory _ba = bytes(_a);
    bytes memory _bb = bytes(_b);
    string memory ab = new string(_ba.length + _bb.length);
    bytes memory ba = bytes(ab);
    uint k = 0;
    for (uint i = 0; i < _ba.length; i++) ba[k++] = _ba[i];
    for (i = 0; i < _bb.length; i++) ba[k++] = _bb[i];

    return string(ba);
}

    /* BONUS */
    function concatWithImport(string s, string t) public returns (string) {
    }
}
