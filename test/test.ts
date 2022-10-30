import { ethers } from "hardhat";
import { BlossomNFT } from "../typechain-types";

describe("BlossomNFT", function () {
  let contract: BlossomNFT;
  let factory: any;

  beforeEach(async () => {
    [factory] = await Promise.all([
      ethers.getContractFactory("BlossomNFT"),
    ]);
  });

  describe("Deploy BlossomNFT", async () => {
    beforeEach(async () => {
      contract = await factory.deploy();
      await contract.deployed();
    });

    it("generateFlower", async () => {
        let txn = await contract.generateFlower();
        await txn.wait();
    });
  });
 
});