const EnergyStorage = artifacts.require("EnergyStorage");

module.exports = function (deployer) {
  deployer.deploy(EnergyStorage);
};
