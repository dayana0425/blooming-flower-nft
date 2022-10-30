import { ethers } from "hardhat";

async function main() {
    const contractFactory = await ethers.getContractFactory('BlossomNFT');
    const contract = await contractFactory.deploy();
    console.log("Contract deployed to:", contract.address);
    console.log("Awaiting confirmations");
    await contract.deployed();
    console.log("Completed");
    console.log(`Contract deployed at ${contract.address}`);

  console.log("Minting Flower...");
  let txn = await contract.mint("Dayana", "#8ef6e4", "#9896f1", "#d59bf6");
  await txn.wait();
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});