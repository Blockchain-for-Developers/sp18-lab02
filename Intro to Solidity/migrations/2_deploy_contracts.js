var Greeter = artifacts.require("./greeter.sol");
var Fibonacci = artifacts.require("./fibonacci.sol");
var XOR = artifacts.require("./xor.sol");
var Concatenate = artifacts.require("./concatenate.sol");

module.exports = function(deployer) {
  deployer.deploy(Greeter, "hello");
  deployer.deploy(Fibonacci);
  deployer.deploy(XOR);
  deployer.deploy(Concatenate);
};
