import { ethers } from "hardhat";

async function main() {
    const contractFactory = await ethers.getContractFactory('BlossomNFT');
    const contract = await contractFactory.deploy();
    console.log("Contract deployed to:", contract.address);
    console.log("Awaiting confirmations");
    await contract.deployed();
    console.log("Completed");
    console.log(`Contract deployed at ${contract.address}`);
    const [deployer, address1] = await ethers.getSigners();

    // deployer
    console.log("Minting Flower #1...");
    let txn = await contract.mint("Dayana", "#8ef6e4", "#9896f1", "#d59bf6");
    await txn.wait();
    console.log("Minted!");

    console.log("Watering Flower...");
    txn = await contract.water(1, "#f5c7f7");
    await txn.wait();
    console.log("Done Watering! Pedal #1 Blossomed.");

    console.log("Watering Flower...");
    txn = await contract.water(1, "#f5c7f7");
    await txn.wait();
    console.log("Done Watering! Pedal #2 Blossomed.");

    console.log("Watering Flower...");
    txn = await contract.water(1, "#f5c7f7");
    await txn.wait();
    console.log("Done Watering! Pedal #3 Blossomed.");

    console.log("Watering Flower...");
    txn = await contract.water(1, "#f5c7f7");
    await txn.wait();
    console.log("Done Watering! Pedal #4 Blossomed.");

    console.log("Watering Flower...");
    txn = await contract.water(1, "#f5c7f7");
    await txn.wait();
    console.log("Done Watering! Pedal #5 Blossomed.");

    console.log("Watering Flower...");
    txn = await contract.water(1, "#f5c7f7");
    await txn.wait();
    console.log("Done Watering! Pedal #6 Blossomed.");

    console.log("Watering Flower...");
    txn = await contract.water(1, "#f5c7f7");
    await txn.wait();
    console.log("Done Watering! Pedal #7 Blossomed.");

    console.log("Watering Flower...");
    txn = await contract.water(1, "#f5c7f7");
    await txn.wait();
    console.log("Done Watering! Pedal #8 Blossomed.");

    // address 1
    console.log("Minting Flower #2...");
    txn = await contract.connect(address1).mint("Brendon", "#00204a", "#005792", "#00bbf0");
    await txn.wait();
    console.log("Minted!");

    console.log("Watering Flower...");
    txn = await contract.connect(address1).water(2, "#fdb44b");
    await txn.wait();
    console.log("Done Watering! Pedal #1 Blossomed.");

    console.log("Watering Flower...");
    txn = await contract.connect(address1).water(2, "#fdb44b");
    await txn.wait();
    console.log("Done Watering! Pedal #2 Blossomed.");

    console.log("Watering Flower...");
    txn = await contract.connect(address1).water(2, "#fdb44b");
    await txn.wait();
    console.log("Done Watering! Pedal #3 Blossomed.");

    console.log("Watering Flower...");
    txn = await contract.connect(address1).water(2, "#fdb44b");
    await txn.wait();
    console.log("Done Watering! Pedal #4 Blossomed.");

    console.log("Watering Flower...");
    txn = await contract.connect(address1).water(2, "#fdb44b");
    await txn.wait();
    console.log("Done Watering! Pedal #5 Blossomed.");

    console.log("Watering Flower...");
    txn = await contract.connect(address1).water(2, "#fdb44b");
    await txn.wait();
    console.log("Done Watering! Pedal #6 Blossomed.");

    console.log("Watering Flower...");
    txn = await contract.connect(address1).water(2, "#fdb44b");
    await txn.wait();
    console.log("Done Watering! Pedal #7 Blossomed.");

    console.log("Watering Flower...");
    txn = await contract.connect(address1).water(2, "#fdb44b");
    await txn.wait();
    console.log("Done Watering! Pedal #8 Blossomed.");
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});