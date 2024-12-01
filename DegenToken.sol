// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";  
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";

contract DegenToken is ERC20, Ownable, ERC20Burnable  
 {
    struct StoreItem {
        string name;
        uint256 price;
    }

    mapping(uint256 => StoreItem) public storeItems;
    uint256 public itemCount;

    event TokensMinted(address indexed to, uint256 amount);
    event ItemRedeemed(address indexed player, uint256 itemId);

    constructor() ERC20("Degen", "DGN") {
        addStoreItem("Cyber Vandal", 5);
        addStoreItem("Imperium Phanton", 10);
        addStoreItem("Death Dagger", 15);
        addStoreItem("Tactical Operator", 20);
        addStoreItem("Act 1 Battlepass", 30);
        addStoreItem("Act 2 Battlepass", 35);
    }

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
        emit TokensMinted(to, amount);
    }

    function addStoreItem(string memory name, uint256 price) public onlyOwner {
        storeItems[itemCount] = StoreItem({
            name: name,
            price: price
        });
        itemCount++;
    }

    function getAllStoreItems() public view returns (StoreItem[] memory) {
        StoreItem[] memory items = new StoreItem[](itemCount);
        for (uint256 i = 0; i < itemCount; i++) {
            items[i] = storeItems[i];
        }
        return items;
    }

    function redeemItem(uint256 itemId) public {
        require(itemId < itemCount, "Invalid item ID");
        StoreItem storage item = storeItems[itemId];
        require(balanceOf(msg.sender) >= item.price, "Insufficient tokens");

        _burn(msg.sender, item.price);
        emit ItemRedeemed(msg.sender, itemId);
    }


}