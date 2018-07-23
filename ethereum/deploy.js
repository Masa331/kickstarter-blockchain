const HDWalletProvider = require('truffle-hdwallet-provider');
const Web3 = require('web3');
const compiledFactory = require('./build/CampaignFactory.json');

const provider = new HDWalletProvider(
  'seat twenty trap nut coach need cigar brain anchor panic cook hammer',
  'https://rinkeby.infura.io/37Qt7ZfQNTBEaNVKZ7Ff'
);

const web3 = new Web3(provider);

const deploy = async ()=> {
  const accounts = await web3.eth.getAccounts();
  console.log(accounts[0]);

  const contract = await new web3.eth.Contract(JSON.parse(compiledFactory.interface))
    .deploy({ data: '0x' + compiledFactory.bytecode})
    .send({ gas: '1000000', from: accounts[0] });

  console.log('Deployed to: ', contract.options.address);
};

deploy();
// Deployed to:  0x9aD4167D2cBF8C8E554Bd2f8F6BFEc86c84f6ea6
