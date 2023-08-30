async function main() {
  const networkName = hre.network.name;
  const [deployer] = await ethers.getSigners();
  
  console.log("DEPLOYING TO NETWORK:", networkName);
  console.log("Deploying SPCoin contract with the account:", deployer.address);
  console.log("Account balance:", (await deployer.getBalance()).toString());

  const SPCoin = await ethers.getContractFactory("SPCoin");
  const spCoin = await SPCoin.deploy();

  console.log("SPCoin address:", spCoin.address);
  console.log("SPCoin name:", await spCoin.name());

  let network = "https://"
  if (networkName === "mainnet")
    network += "etherscan.io/address/";
  else
    network += networkName+".etherscan.io/address/";

  // console.log("Contract Address:", network + spCoin.address);
  console.log("Deployer Address:", network + deployer.address);
}

main()
  .then(() => process.exit(0))
    .catch((error) => {
      console.error(error);
      process.exit(1);
    });
