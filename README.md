# Blossoming Flower NFT - A Customizable Dynamic NFT

### Mint Your Blossoming Flower NFT
* Minting Inputs:
  * Name of your flower (ex: Your name...)
  * Background Color (CSS Hex Input, ex: "#8ef6e4")
  * Font Color of your flower's name (CSS Hex Input, ex: "#9896f1")
  * Seed Color (CSS Hex Input, ex: "#9896f1")

Example Mint Call: 
```
let txn = await contract.mint("Dayana", "#8ef6e4", "#9896f1", "#9896f1");
```

### Water Your Flower
* Watering Inputs
  * Provide your flower's token ID (ex: 1)
  * Provide color for new petal (CSS Hex Input, ex: "#f5c7f7")
  * You can only water your flower 8 times for it to complete.

Example Water Call:
```
txn = await contract.water(1, "#f5c7f7");
```
### Example Outputs of Completed Flowers: 
![Figure 1](images/f1.png)
![Figure 2](images/f2.png)

### Quick Start 
* First, Fork & Clone Repository
```shell
yarn compile
yarn deploy
yarn test
```
