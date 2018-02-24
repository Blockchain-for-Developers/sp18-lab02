var Betting = artifacts.require("./Betting.sol");

module.exports = function(deployer) {
  deployer.deploy(Betting, [1, 3, 4, 5, 8]);
};
