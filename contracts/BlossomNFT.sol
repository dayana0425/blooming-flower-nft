
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Base64.sol";

contract BlossomNFT is ERC721URIStorage  {
    using Strings for uint256;
    using Counters for Counters.Counter;
    Counters.Counter private _ids;

    struct FlowerStats {
        uint256 level;
        string name;
    }
    

    mapping(uint256 => FlowerStats) public idToFlowerStats;

    constructor() ERC721 ("Blossom", "BLOSS"){

    }

    function generateFlower(uint256 id) public returns(string memory){
        // Flower Seed + Name Only
        bytes memory svg = 
        abi.encodePacked(
            '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350">',
            '<rect width="100%" height="100%" fill="purple"/>',

            '<g transform="matrix(0.678571, 0, 0, 0.717326, 121.009552, -24.106068)">',
            '<path d="M 177.62 98.002 C 141.811 170.89 142.573 254.444 179.906 348.665" style="stroke: none; fill:', 
            getColor1(id),";",
            'bx:origin="0.265 0.5"/>',
            '<ellipse style="fill:green;" cx="242.767" y="223.713" rx="26.285" ry="25.904"/>',
            '<path d="M 176.858 98.002 C 211.905 173.175 212.921 256.476 179.906 347.903" style="stroke: none; fill:', 
            getColor1(id),";",
            '" bx:origin="0.729 0.5"/>',
            '</g>',
            '<g transform="matrix(0.479822, 0.479822, -0.507226, 0.507226, 338.366028, -43.240444)">',
            '<path d="M 177.62 98.002 C 141.811 170.89 142.573 254.444 179.906 348.665" style="stroke: none; fill:', 
            getColor2(id),";",
            'bx:origin="0.265 0.5"/>',
            '<ellipse style="fill:green;" cx="242.767" y="223.713" rx="26.285" ry="25.904"/>',
            '<path d="M 176.858 98.002 C 211.905 173.175 212.921 256.476 179.906 347.903" style="stroke: none; fill:', 
            getColor2(id),";",
            '" bx:origin="0.729 0.5"/>',
            '</g>',
            '<text x="50%" y="95%" fill="white" dominant-baseline="middle" text-anchor="middle">', 
            getName(id), 
            '</text>'
            '</svg>'
        );
        return string(
            abi.encodePacked(
                "data:image/svg+xml;base64,",
                Base64.encode(svg)
            )    
        );
    }    
    
    function getName(uint256 id) public view returns (string memory) {
      FlowerStats memory data = idToFlowerStats[id];
      return data.name;
    }

    function getColor1(uint256 id) public view returns (string memory) {
      FlowerStats memory data = FlowerStats[id];
      if(data.level >= 1) {
        return "rgb(255,255,0)";
      }
      else {
        return "purple";
      } 
    }

    function getColor2(uint256 id) public view returns (string memory) {
      FlowerStats memory data = FlowerStats[id];
      if(data.level >= 2) {
        return "rgb(255,182,193)";
      }
      else {
        return "purple";
      } 
    }


    function getTokenURI(uint256 id) public returns (string memory){
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
      currentFlower.level = currentFlower + 1;
      idToFlowerStats[id] = currentFlower;
      _setTokenURI(id, getTokenURI(id));
    }
}