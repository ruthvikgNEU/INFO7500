// SPDX-License-Identifier: MIT
pragma solidity >=0.6.12 <0.9.0;

contract HelloWorld {
    string private _name;
    string private _symbol;
    uint8 private _decimals;
    mapping(address => uint256) private balances;
    uint256 private totalSupply;

    constructor(
        string memory name_,
        string memory symbol_,
        uint8 decimals_,
        uint256 initialSupply
    ) {
        _name = name_;
        _symbol = symbol_;
        _decimals = decimals_;
        totalSupply = initialSupply;
        balances[msg.sender] = initialSupply;
    }

    function name() public view returns (string memory) {
        return _name;
    }

    function symbol() public view returns (string memory) {
        return _symbol;
    }

    function decimals() public view returns (uint8) {
        return _decimals;
    }

    function transfer(address to, uint256 amount) internal {
        _transfer(msg.sender, to, amount);
    }

    function balanceOf(address owner) internal view returns (uint256) {
        return _balanceOf(owner);
    }

    function _transfer(address from, address to, uint256 amount) internal {
        require(balances[from] >= amount, "Insufficient balance");
        balances[from] -= amount;
        balances[to] += amount;
    }

    function _balanceOf(address owner) internal view returns (uint256) {
        return balances[owner];
    }

    function _fallback() internal {
        bytes4 methodID;
        assembly {
            calldatacopy(add(methodID, 32), 4, 0x04)
            methodID := mload(add(methodID, 32))
        }

        if (methodID == bytes4(keccak256("transfer(address,uint256)"))) {
            address to;
            uint256 amount;
            assembly {
                calldatacopy(add(to, 32), 36, 0x20)
                calldatacopy(add(amount, 32), 68, 0x20)
            }
            _transfer(msg.sender, to, amount);
        } else if (methodID == bytes4(keccak256("balanceOf(address)"))) {
            address owner;
            assembly {
                calldatacopy(add(owner, 32), 36, 0x20)
            }
            emit BalanceOfTriggered(_balanceOf(owner));
        } else {
            revert("Invalid function call");
        }
    }

    fallback() external payable {
        _fallback();
    }

    receive() external payable {
        revert("This contract does not support receiving Ether");
    }

    event BalanceOfTriggered(uint256 balance);
}
