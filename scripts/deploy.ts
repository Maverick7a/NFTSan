import { ethers } from "hardhat";

async function main() {
  const ipfsLocation = "https://gateway.pinata.cloud/ipfs/QmXmW9V1ZrSr5NdxfbZCtHaUx7UUqqSPnw7axLjH34Nkp7"


  const NFT = await ethers.getContractFactory("Sanych");
  const nft = await NFT.deploy();

  await nft.deployed();

  console.log(`NFT Sanych deployed to ${nft.address}`);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
