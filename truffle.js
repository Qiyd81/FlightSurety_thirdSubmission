var HDWalletProvider = require("truffle-hdwallet-provider");
// var mnemonic = "collect cool stomach dinner unfair often galaxy raw future wing cinnamon magic note: this mnemonic is not secure; don't use it on a public blockchain";
var mnemonic = "collect cool stomach dinner unfair often galaxy raw future wing cinnamon magic note: this mnemonic is not secure; don't use it on a public blockchain";

module.exports = {
  networks: {
    development: {
      // provider: function() {
      //   return new HDWalletProvider(mnemonic, "http://127.0.0.1:8545/", 0, 50);
      // },
      network_id: '*',
      // gas: 9999999
      host: '127.0.0.1',
      port: 7545
    }
  },
  compilers: {
    solc: {
      version: "^0.5.16"
    }
  }
};