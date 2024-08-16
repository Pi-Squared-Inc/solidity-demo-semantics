// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0


// The source code of this contract uses the following OpenZeppelin contracts
// ERC1155: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC1155/ERC1155.sol
pragma solidity ^0.8.20;

contract SomeMultiToken{
    
    uint256 public GOLD = 0;
    uint256 public SILVER = 1;
    
    string private _uri;

    mapping(uint256 id => mapping(address account => uint256)) private _balances;
    mapping(address account => mapping(address operator => bool)) private _operatorApprovals;

    event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
    event TransferBatch(
        address indexed operator,
        address indexed from,
        address indexed to,
        uint256[] ids,
        uint256[] values
    );
    event ApprovalForAll(address indexed account, address indexed operator, bool approved);
    event URI(string value, uint256 indexed id);

    error ERC1155InsufficientBalance(address sender, uint256 balance, uint256 needed, uint256 tokenId);
    error ERC1155InvalidSender(address sender);
    error ERC1155InvalidReceiver(address receiver);
    error ERC1155MissingApprovalForAll(address operator, address owner);
    error ERC1155InvalidApprover(address approver);
    error ERC1155InvalidOperator(address operator);
    error ERC1155InvalidArrayLength(uint256 idsLength, uint256 valuesLength);

    constructor(string memory uri_, uint256 init_supply) {
        _setURI(uri_);
        _mint(msg.sender, GOLD, init_supply);
        _mint(msg.sender, SILVER, init_supply);
    }

    function balanceOf(address account, uint256 id) public returns (uint256) {
        return _balances[id][account];
    }

    function balanceOfBatch(
        address[] memory accounts,
        uint256[] memory ids
    ) public returns (uint256[] memory) {
        if (accounts.length != ids.length) {
            revert ERC1155InvalidArrayLength(ids.length, accounts.length);
        }

        uint256[] memory batchBalances = new uint256[](accounts.length);

        for (uint256 i = 0; i < accounts.length; ++i) {
            batchBalances[i] = balanceOf(accounts[i], ids[i]);
        }

        return batchBalances;
    }

    function setApprovalForAll(address operator, bool approved) public {
        _setApprovalForAll(msg.sender, operator, approved);
    }

    function isApprovedForAll(address account, address operator) public returns (bool) {
        return _operatorApprovals[account][operator];
    }

    function safeTransferFrom(address from, address to, uint256 id, uint256 value) public {
        address sender = msg.sender;
        if (from != sender && !isApprovedForAll(from, sender)) {
            revert ERC1155MissingApprovalForAll(sender, from);
        }
        _safeTransferFrom(from, to, id, value);
    }

    function safeBatchTransferFrom(
        address from,
        address to,
        uint256[] memory ids,
        uint256[] memory values
    ) public {
        address sender = msg.sender;
        if (from != sender && !isApprovedForAll(from, sender)) {
            revert ERC1155MissingApprovalForAll(sender, from);
        }
        _safeBatchTransferFrom(from, to, ids, values);
    }

    function _update(address from, address to, uint256[] memory ids, uint256[] memory values) internal {
        if (ids.length != values.length) {
            revert ERC1155InvalidArrayLength(ids.length, values.length);
        }

        address operator = msg.sender;

        for (uint256 i = 0; i < ids.length; ++i) {
            uint256 id = ids[i];
            uint256 value = values[i];

            if (from != address(0)) {
                uint256 fromBalance = _balances[id][from];
                if (fromBalance < value) {
                    revert ERC1155InsufficientBalance(from, fromBalance, value, id);
                }
                _balances[id][from] = fromBalance - value;
                
            }

            if (to != address(0)) {
                _balances[id][to] += value;
            }
        }

        if (ids.length == 1) {
            uint256 id = ids[0];
            uint256 value = values[0];
            emit TransferSingle(operator, from, to, id, value);
        } else {
            emit TransferBatch(operator, from, to, ids, values);
        }
    }

    function _updateWithoutAcceptanceCheck(
        address from,
        address to,
        uint256[] memory ids,
        uint256[] memory values
    ) internal {
        _update(from, to, ids, values);
    }

    function _safeTransferFrom(address from, address to, uint256 id, uint256 value) internal {
        if (to == address(0)) {
            revert ERC1155InvalidReceiver(address(0));
        }
        if (from == address(0)) {
            revert ERC1155InvalidSender(address(0));
        }

        uint256[] memory ids = new uint256[](1);
        uint256[] memory values = new uint256[](1);

        ids[0] = id;
        values[0] = value;

        _updateWithoutAcceptanceCheck(from, to, ids, values);
    }

    function _safeBatchTransferFrom(
        address from,
        address to,
        uint256[] memory ids,
        uint256[] memory values
    ) internal {
        if (to == address(0)) {
            revert ERC1155InvalidReceiver(address(0));
        }
        if (from == address(0)) {
            revert ERC1155InvalidSender(address(0));
        }
        _updateWithoutAcceptanceCheck(from, to, ids, values);
    }

    function _setURI(string memory newuri) internal {
        _uri = newuri;
    }


    function _mint(address to, uint256 id, uint256 value) internal {
        if (to == address(0)) {
            revert ERC1155InvalidReceiver(address(0));
        }
        
        uint256[] memory ids = new uint256[](1);
        uint256[] memory values = new uint256[](1);

        ids[0] = id;
        values[0] = value;

        _updateWithoutAcceptanceCheck(address(0), to, ids, values);
    }


    function _mintBatch(address to, uint256[] memory ids, uint256[] memory values) internal {
        if (to == address(0)) {
            revert ERC1155InvalidReceiver(address(0));
        }
        _updateWithoutAcceptanceCheck(address(0), to, ids, values);
    }


    function _burn(address from, uint256 id, uint256 value) internal {
        if (from == address(0)) {
            revert ERC1155InvalidSender(address(0));
        }
        
        uint256[] memory ids = new uint256[](1);
        uint256[] memory values = new uint256[](1);

        ids[0] = id;
        values[0] = value;
        
        _updateWithoutAcceptanceCheck(from, address(0), ids, values);
    }

    function _burnBatch(address from, uint256[] memory ids, uint256[] memory values) internal {
        if (from == address(0)) {
            revert ERC1155InvalidSender(address(0));
        }
        _updateWithoutAcceptanceCheck(from, address(0), ids, values);
    }


    function _setApprovalForAll(address owner, address operator, bool approved) internal {
        if (operator == address(0)) {
            revert ERC1155InvalidOperator(address(0));
        }
        _operatorApprovals[owner][operator] = approved;
        emit ApprovalForAll(owner, operator, approved);
    }

}