
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
    string[] directions;

    struct FlowerStats {
        uint256 level;
        string name;
        string background;
        string font;
        string seed;
    }
  
    mapping(uint256 => FlowerStats) public idToFlowerStats;
    constructor() ERC721 ("Blossom", "BLOSS"){
        // setting all the flower petal directions
        directions.push('matrix(0.678571, 0, 0, 0.717326, 121.009552, -24.106068)');
        directions.push('matrix(0.479822, 0.479822, -0.507226, 0.507226, 338.366028, -43.240444)');
        directions.push('matrix(0, 0.678571, -0.717326, 0, 492.233185, 101.835365)');
        directions.push('matrix(-0.479822, 0.479822, -0.507226, -0.507226, 509.336121, 317.41394)');
        directions.push('matrix(0.678571, 0, 0, 0.717326, 122.53334, 153.415024)');
        directions.push('matrix(-0.479822, -0.479822, 0.507226, -0.507226, 148.681854, 489.907806)');
        directions.push('matrix(0, 0.678571, -0.717326, 0, 314.712097, 103.359146)');
        directions.push('matrix(0.479822, -0.479822, 0.507226, 0.507226, -23.812111, 129.253433)');
    }

    function generateFlower(uint256 id) internal view returns(string memory){
        bytes memory svg = 
        abi.encodePacked(
            '<svg viewBox="13 -4 461 455" xmlns="http://www.w3.org/2000/svg" xmlns:bx="https://www.boxy-svg.com/bx">',
            string(abi.encodePacked("<rect width='100%' height='100%' fill='", getBackgroundColor(id),"'/>")),
            getPetals(id),
            '<ellipse style="fill:#ffc93c;" cx="242.767" cy="223.713" rx="26.285" ry="25.904"/>',
            string(abi.encodePacked("<ellipse style='fill:", getSeedColor(id),";' cx='242.767' cy='223.713' rx='26.285' ry='25.904'/>")),
            string(abi.encodePacked("<text x='50%' y='95%' fill='", getFontColor(id), "' dominant-baseline='middle' text-anchor='middle'>")),
            getName(id), 
            '</text>'
            '</svg>');

        string memory uri = 
              string(abi.encodePacked(
                "data:image/svg+xml;base64,",
                Base64.encode(svg))
              );

        console.log("\n---FLOWER ", id, "---");
        console.log(string(uri));
        console.log("------\n");
        return uri;
    }    
    
    function getName(uint256 id) public view returns (string memory) {
      FlowerStats memory data = idToFlowerStats[id];
      return data.name;
    }

    function getBackgroundColor(uint id) public view returns(string memory) {
      FlowerStats memory data = idToFlowerStats[id];
      return data.background;
    }

    function getFontColor(uint id) public view returns(string memory) {
      FlowerStats memory data = idToFlowerStats[id];
      return data.font;
    }

    function getSeedColor(uint id) public view returns(string memory) {
      FlowerStats memory data = idToFlowerStats[id];
      return data.seed;
    }

    function getPetals(uint id) internal view returns (string memory) {
      FlowerStats memory data = idToFlowerStats[id];
      bytes memory res;
      for(uint256 i = 0; i < data.level; i++) {
        bytes memory currentPetal = abi.encodePacked(
            string(abi.encodePacked("<g transform='", directions[i], "'>")),
            string(abi.encodePacked("<path d='M 177.62 98.002 C 141.811 170.89 142.573 254.444 179.906 348.665' style='stroke: none; fill:",palette[i],";stroke-width:3;stroke:black'/>")),
            string(abi.encodePacked("<path d='M 176.858 98.002 C 211.905 173.175 212.921 256.476 179.906 347.903' style='stroke: none; fill:",palette[i],";stroke-width:3;stroke:black'/>")),
            string(abi.encodePacked("</g>"))
        );
        res = abi.encodePacked(res, currentPetal);
      }
      return string(res);
    }

    function getTokenURI(uint256 id) private view returns (string memory){
      bytes memory dataURI = abi.encodePacked(
          '{',
              '"name": "Blossoming Flower #', id.toString(), '",',
              '"description": "All beings are flowers blooming in a blossoming universe.",',
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

    function mint(string memory name, 
                  string memory background, 
                  string memory font, 
                  string memory seed) public 
    {
        _ids.increment();
        uint256 newFlowerId = _ids.current();
        console.log("New Flower ID:", newFlowerId);
        _safeMint(msg.sender, newFlowerId);

        FlowerStats memory flowerStats = FlowerStats(0, name, background, font, seed);

        idToFlowerStats[newFlowerId] = flowerStats;

        _setTokenURI(newFlowerId, getTokenURI(newFlowerId));
    }

    function water(uint256 id, string memory color) public {
      require(_exists(id));
      require(ownerOf(id) == msg.sender, "You must own this NFT to water it!");
      require(idToFlowerStats[id].level <= 8, "Your flower is done growing.");
      palette.push(color);
      FlowerStats memory currentFlower = idToFlowerStats[id];
      uint256 currentLevel = currentFlower.level;
      currentFlower.level = currentLevel + 1;
      idToFlowerStats[id] = currentFlower;
      _setTokenURI(id, getTokenURI(id));
    }
}