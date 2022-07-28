// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract NFTMarketPlace is ReentrancyGuard {
    using Counters for Counters.Counter;
    Counters.Counter private _itemIds;
    Counters.Counter private _itemsSold;

    address private immutable owner;
    uint256 private listingPrice = 0.0025 ether;

    mapping(uint256 => MarketItem) private idToMarketItem;

    constructor(address _owner) {
        owner = _owner;
    }

    struct MarketItem {
        uint256 itemId;
        address nftAddress;
        uint256 tokenId;
        address seller;
        address owner;
        uint256 price;
        bool sold;
    }

    event MarketItemCreated(
        uint256 indexed itemId,
        address indexed nftAddress,
        uint256 indexed tokenId,
        address seller,
        address owner,
        uint256 price,
        bool sold
    );

    function createMarketItem(
        address nftAddress,
        uint256 tokenId,
        uint256 price
    ) public payable nonReentrant {
        require(price > 0, "Price must be greater than 0");
        require(msg.value == listingPrice, "Listing price not matched");

        _itemIds.increment();
        uint256 itemId = _itemIds.current();

        idToMarketItem[itemId] = MarketItem(
            itemId,
            nftAddress,
            tokenId,
            msg.sender,
            address(0),
            price,
            false
        );

        IERC721(nftAddress).transferFrom(msg.sender, address(this), tokenId);

        emit MarketItemCreated(
            itemId,
            nftAddress,
            tokenId,
            msg.sender,
            address(0),
            price,
            false
        );
    }

    function saleMarketItem(address nftAddress, uint256 itemId)
        public
        payable
        nonReentrant
    {
        uint256 price = idToMarketItem[itemId].price;
        uint256 tokenId = idToMarketItem[itemId].tokenId;
        require(msg.value == price, "Item Price not matched");

        IERC721(nftAddress).transferFrom(address(this), msg.sender, tokenId);
        idToMarketItem[itemId].owner = msg.sender;
        idToMarketItem[itemId].sold = true;
        _itemsSold.increment();

        (bool success, ) = payable(idToMarketItem[itemId].seller).call{
            value: msg.value
        }("");

        require(success, "Transfer failed");
    }

    function getItemListingPrice() public view returns (uint256) {
        return listingPrice;
    }
}
