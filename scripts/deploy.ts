import { ethers } from "hardhat";
import * as jsonFile from "../artifacts/contracts/BlossomNFT.sol/BlossomNFT.json";

// This key is already public on Herong's Tutorial Examples - v1.03, by Dr. Herong Yang
// Do never expose your keys like this
const EXPOSED_KEY =
  "8da4ef21b864d2cc526dbdb2a120bd2874c36c9d0a1fb7f8c63d7f7a8b41de8f";

async function main() {
  const wallet =
    process.env.MNEMONIC && process.env.MNEMONIC.length > 0
      ? ethers.Wallet.fromMnemonic(process.env.MNEMONIC)
      : new ethers.Wallet(process.env.PRIVATE_KEY ?? EXPOSED_KEY);
  console.log(`Using address ${wallet.address}`);
  const provider = new ethers.providers.AlchemyProvider(
    "maticmum",
    process.env.MUMBAI_ALCHEMY_KEY
  );
  const signer = wallet.connect(provider);
  const balanceBN = await signer.getBalance();
  const balance = Number(ethers.utils.formatEther(balanceBN));
  console.log(`Wallet balance ${balance}`);
  if (balance < 0.01) {
    throw new Error("Not enough ether");
  }
  console.log("Deploying contract");
  const contractFactory = new ethers.ContractFactory(
    jsonFile.abi,
    jsonFile.bytecode,
    signer
  );
  const contract = await contractFactory.deploy();
  console.log("Awaiting confirmations");
  await contract.deployed();
  console.log("Completed");
  console.log(`Contract deployed at ${contract.address}`);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});