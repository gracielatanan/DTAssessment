// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract DegenToken is ERC20 {
	mapping (address => uint256) public itemBalances;
	mapping (uint256 => uint256) public itemPrices;
	uint256 public nextItemId = 1;

    constructor() ERC20("DegenToken", "DGN") {
		addItem(100); // Item ID 1: Shoes, Price: 100 tokens
		addItem(200); // Item ID 2: Shirt, Price: 200 tokens
		addItem(300); // Item ID 3: Sweater, Price: 300 tokens 
	}
    
    function mint(address to, uint256 amount) public {
        _mint(to, amount);
    }

    function transfer(address to, uint256 amount) public override returns (bool) {
        require(amount <= balanceOf(msg.sender), "Insufficient balance");
        _transfer(msg.sender, to, amount);
        return true;
    }

	function addItem(uint256 price) public {
		itemPrices[nextItemId] = price;
		nextItemId++;
	}

    function redeem(uint256 amount, uint256 itemId) public {
        require(amount <= balanceOf(msg.sender), "Insufficient balance");
		require(itemPrices[itemId] > 0, "Invalid item ID");

		uint256 totalPrice = itemPrices[itemId] * amount;
		require(totalPrice <= balanceOf(msg.sender), "Insufficient balance");

        _burn(msg.sender, totalPrice);
        itemBalances[msg.sender] += amount;
    }

	function getItemBalance(address account) public view returns (uint256) {
		return itemBalances[account];
	}

    function burn(uint256 amount) public {
        require(amount <= balanceOf(msg.sender), "Insufficient balance");
        _burn(msg.sender, amount);
    }
}
