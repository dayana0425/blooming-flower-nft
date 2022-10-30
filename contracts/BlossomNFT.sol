
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Base64.sol";

contract BlossomNFT is ERC721URIStorage  {
    using Strings for uint256;
    using Counters for Counters.Counter;
    Counters.Counter private _ids;
    string[] palette;
    string[] tilts;

    struct FlowerStats {
        uint256 level;
        string name;
    }
    

    mapping(uint256 => FlowerStats) public idToFlowerStats;

    constructor() ERC721 ("Blossom", "BLOSS"){
        palette.push("#fac901"); 
        palette.push("#225095"); 

        tilts.push('matrix(0.678571, 0, 0, 0.717326, 121.009552, -24.106068)');
        tilts.push('matrix(0.479822, 0.479822, -0.507226, 0.507226, 338.366028, -43.240444)');
      
    }

    function generateFlower(uint256 id) view internal returns(string memory){
        bytes memory svg = 
        abi.encodePacked(
            '<svg viewBox="13 -4 461 455" xmlns="http://www.w3.org/2000/svg" xmlns:bx="https://www.boxy-svg.com/bx">',
            getPetals(),
            '</svg>');

        string memory uri = 
              string(abi.encodePacked(
                "data:image/svg+xml;base64,",
                Base64.encode(svg))
              );

        console.log("\n--------------------");
        console.log(string(uri));
        console.log("--------------------\n");
        return uri;
    }    
    
    function getName(uint256 id) public view returns (string memory) {
      FlowerStats memory data = idToFlowerStats[id];
      return data.name;
    }

    function getPetals() internal returns (string memory) {
      bytes memory res = ""
      for(uint256 i = 0; i < tilts.length; i++) {
        bytes memory currentPetal = abi.encodePacked(
            string(abi.encodePacked("<g transform='", tilts[i], "'>")),
            string(abi.encodePacked("<path d='M 177.62 98.002 C 141.811 170.89 142.573 254.444 179.906 348.665' style='stroke: none; fill:",palette[i],";stroke-width:3;stroke:black'/>")),
            string(abi.encodePacked("<path d='M 176.858 98.002 C 211.905 173.175 212.921 256.476 179.906 347.903' style='stroke: none; fill:",palette[i],";stroke-width:3;stroke:black'/>")),
            string(abi.encodePacked("</g>"))
        );
        bytes.concat(res, currentPetal);
      }

      return string(res);
    }

    function getTokenURI(uint256 id) private view returns (string memory){
      bytes memory dataURI = abi.encodePacked(
          '{',
              '"name": "Blossom #', id.toString(), '",',
              '"description": "Grow Your Flower",',
              '"image": "', generateFlower(id), '"',
          '}'
      );
      return string(
          abi.encodePacked(
              "data:application/json;base64,",
              Base64.encode(dataURI)
          )
      );
    }

    function mint(string memory name) public {
        _ids.increment();
        uint256 newFlowerId = _ids.current();
        _safeMint(msg.sender, newFlowerId);

        FlowerStats memory flowerStats = FlowerStats(0, name); // level, name

        idToFlowerStats[newFlowerId] = flowerStats;

        _setTokenURI(newFlowerId, getTokenURI(newFlowerId));
    }

    function water(uint256 id) public {
      require(_exists(id));
      require(ownerOf(id) == msg.sender, "You must own this NFT to water it!");
      require(idToFlowerStats[id].level <= 8, "Your flower is done growing.");

      FlowerStats memory currentFlower = idToFlowerStats[id];
      uint256 currentLevel = currentFlower.level;
      currentFlower.level = currentLevel + 1;
      idToFlowerStats[id] = currentFlower;
      _setTokenURI(id, getTokenURI(id));
    }
}