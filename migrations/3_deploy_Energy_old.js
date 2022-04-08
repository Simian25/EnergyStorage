const EnergyStorage = artifacts.require("EnergyStorageOld");

module.exports = function (deployer) {
  deployer.deploy(EnergyStorage);
};
