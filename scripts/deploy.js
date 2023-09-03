deployToNetwork = async(_networkName, _deployer, _tokenSymbol) => {
  let networkURL = "https://"
  if (_networkName === "mainnet")
    networkURL += "etherscan.io/address/";
  else
    networkURL += _networkName+".etherscan.io/address/";

  console.log("Deploying " + _tokenSymbol + "To Network", _networkName, "from wallet account:", _deployer.address);
  console.log("Ethereum wallet account balance:", (await _deployer.getBalance()).toString());
  console.log("Etherscan wallet URL:", networkURL + _deployer.address);
  console.log("");

  const tokenFactory = await ethers.getContractFactory(_tokenSymbol);
  const deployedToken = await tokenFactory.deploy();

  console.log("Token contract", await deployedToken.name(),"Deployed to contract address:", deployedToken.address);
  console.log("Etherscan contract URL:", networkURL + deployedToken.address);
}

main = async() => {
  const [deployer] = await ethers.getSigners();
  const networkName = hre.network.name
  const tokenSymbol = "SPCoin"
  await deployToNetwork(networkName, deployer, tokenSymbol);
}
    
main()
  .then(() => process.exit(0))
    .catch((error) => {
      console.error(error);
      process.exit(1);
    });

// modules.exports = {
//   deployToNetwork,
// }

// export default {
//   deployToNetwork
// }    