const storeCertificates = artifacts.require("StoreCertificate");

module.exports = function (deployer) {
  deployer.deploy(storeCertificates);
};
