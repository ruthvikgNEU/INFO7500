// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
 
contract ERC20Fallback {
    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;
 
    uint256 private _totalSupply;
    bytes4 private constant TRANSFER = bytes4(keccak256(bytes('transfer(address,uint256)')));
    bytes4 private constant APPROVE = bytes4(keccak256(bytes('approve(address,uint256)')));
    bytes4 private constant BALANCE_OF = bytes4(keccak256(bytes('balanceOf(address)')));
    bytes4 private constant ALLOWANCE = bytes4(keccak256(bytes('allowance(address,address)')));
    bytes4 private constant TOTAL_SUPPLY = bytes4(keccak256(bytes('totalSupply()')));
 
    constructor(uint256 initialSupply) {
        _balances[msg.sender] = initialSupply;
        _totalSupply = initialSupply;
    }
 
    fallback(bytes calldata data) external returns (bytes memory) {
        bytes4 selector;
        assembly {
            selector := calldataload(0)
        }
        if (selector == TRANSFER) {
            (address to, uint256 value) = abi.decode(data[4:], (address, uint256));
            _transfer(msg.sender, to, value);
            return abi.encode(true);
        }  else if (selector == APPROVE) {
            (address spender, uint256 value) = abi.decode(data[4:], (address, uint256));
            _approve(msg.sender, spender, value);
            return abi.encode(true);
        } else if (selector == BALANCE_OF) {
            (address account) = abi.decode(data[4:], (address));
            return abi.encode(_balanceOf(account));
        } else if (selector == ALLOWANCE) {
            (address owner, address spender) = abi.decode(data[4:], (address, address));
            return abi.encode(_allowance(owner, spender));
        } else if (selector == TOTAL_SUPPLY) {
            return abi.encode(_totalSupply);
        } else {
            revert("Function does not exist.");
        }
    }
 
    function _transfer(address sender, address recipient, uint256 amount) internal {
        require(sender != address(0), "sender address not valid");
        require(recipient != address(0), "recipient address not valid");
        require(_balances[sender] >= amount, "transfer balance not available");
 
        _balances[sender] -= amount;
        _balances[recipient] += amount;
    }
 
 
    function _approve(address owner, address spender, uint256 amount) internal {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");
 
        _allowances[owner][spender] = amount;
    }
 
    function _balanceOf(address account) internal view returns (uint256) {
        return _balances[account];
    }
 
    function _allowance(address owner, address spender) internal view returns (uint256) {
        return _allowances[owner][spender];
    }

    function balanceOf(address owner) external view returns (uint256) {
        return _balanceOf(owner);
    }
 
    // Other internal functions can be added below if necessary
}