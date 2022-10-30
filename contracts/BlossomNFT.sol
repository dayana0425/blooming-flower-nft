
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
    string[] directions;

    struct FlowerStats {
        uint256 level;
        string name;
        string background;
        string font;
        string seed;
        bytes currentImage;
        string[] palette;
    }
  
    mapping(uint256 => FlowerStats) public idToFlowerStats;
    constructor() ERC721 ("Blossom", "BLOSS"){
        // setting flower petal directions - same for all flower NFTs
        directions.push('matrix(0.678571, 0, 0, 0.717326, 121.009552, -24.106068)'); // 0
        directions.push('matrix(0.479822, 0.479822, -0.507226, 0.507226, 338.366028, -43.240444)'); // 1
        directions.push('matrix(0, 0.678571, -0.717326, 0, 492.233185, 101.835365)'); // 2
        directions.push('matrix(-0.479822, 0.479822, -0.507226, -0.507226, 509.336121, 317.41394)'); // 3
        directions.push('matrix(0.678571, 0, 0, 0.717326, 122.53334, 153.415024)'); // 4
        directions.push('matrix(-0.479822, -0.479822, 0.507226, -0.507226, 148.681854, 489.907806)'); // 5
        directions.push('matrix(0, 0.678571, -0.717326, 0, 314.712097, 103.359146)'); // 6
        directions.push('matrix(0.479822, -0.479822, 0.507226, 0.507226, -23.812111, 129.253433)'); // 7
    }

    function generateFlower(uint256 id) internal returns(string memory){
        FlowerStats memory data = idToFlowerStats[id];
        bytes memory svg = abi.encodePacked(
            '<svg viewBox="13 -4 461 455" xmlns="http://www.w3.org/2000/svg" xmlns:bx="https://www.boxy-svg.com/bx">',
            string(abi.encodePacked("<rect width='100%' height='100%' fill='", data.background,"'/>")),
            getPetals(id),
            '<ellipse style="fill:#ffc93c;" cx="242.767" cy="223.713" rx="26.285" ry="25.904"/>',
            string(abi.encodePacked("<ellipse style='fill:", data.seed,";' cx='242.767' cy='223.713' rx='26.285' ry='25.904'/>")),
            string(abi.encodePacked("<text x='50%' y='95%' fill='", data.font, "' dominant-baseline='middle' text-anchor='middle'>")),
            data.name, 
            '</text>'
            '</svg>'
        );

        string memory uri = 
              string(abi.encodePacked(
                "data:image/svg+xml;base64,",
                Base64.encode(svg))
              );
        return uri;
    }    
    
    function getPetals(uint id) internal returns(string memory){
      FlowerStats memory data = idToFlowerStats[id];
      uint256 index = data.level;
      if (index >= 1) {
        bytes memory newPetal = abi.encodePacked(
              string(abi.encodePacked("<g transform='", directions[index-1], "'>")),
              string(abi.encodePacked("<path d='M 177.62 98.002 C 141.811 170.89 142.573 254.444 179.906 348.665' style='stroke: none; fill:",data.palette[index-1],";stroke-width:3;stroke:black'/>")),
              string(abi.encodePacked("<path d='M 176.858 98.002 C 211.905 173.175 212.921 256.476 179.906 347.903' style='stroke: none; fill:",data.palette[index-1],";stroke-width:3;stroke:black'/>")),
              string(abi.encodePacked("</g>"))
        );
        data.currentImage = abi.encodePacked(data.currentImage, newPetal);
        idToFlowerStats[id] = data;
        return string(data.currentImage);
      }
      return "";
    }

    function getTokenURI(uint256 id) private returns (string memory){
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
        _safeMint(msg.sender, newFlowerId);
        
        string[] memory colors;
        FlowerStats memory flowerStats = FlowerStats(0, name, background, font, seed, "", colors);

        idToFlowerStats[newFlowerId] = flowerStats;

        _setTokenURI(newFlowerId, getTokenURI(newFlowerId));
    }

    function water(uint256 id, string memory color) public {
      FlowerStats storage currentFlower = idToFlowerStats[id];
      uint256 currentLevel = currentFlower.level;
      require(_exists(id));
      require(ownerOf(id) == msg.sender, "You must own this NFT to water it!");
      require(currentLevel <= 8, "Your flower is done growing.");

      currentFlower.level = currentLevel + 1;
      idToFlowerStats[id] = currentFlower;
      currentFlower.palette.push(color);

      _setTokenURI(id, getTokenURI(id));
    }
}