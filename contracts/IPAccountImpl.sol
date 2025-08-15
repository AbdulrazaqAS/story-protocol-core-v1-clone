// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import {IERC165} from "@openzeppelin/contracts/utils/introspection/ERC165.sol";
import {ERC6551} from "solady/src/accounts/ERC6551.sol";
import {Receiver} from "solady/src/accounts/Receiver.sol";
import {IERC721Receiver} from "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import {IERC1155Receiver} from "@openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol";
import {IERC6551Account} from "erc6551/interfaces/IERC6551Account.sol";
import {IERC6551Executable} from "erc6551/interfaces/IERC6551Executable.sol";

import {IPAccountStorage} from "./IPAccountStorage.sol";
import {IIPAccount} from "./interfaces/IIPAccount.sol";
import {IAccessController} from "./interfaces/access/IAccessController.sol";
import {Errors} from "./lib/Errors.sol";

contract IPAccountImpl is ERC6551, IPAccountStorage, IIPAccount {
    address public immutable ACCESS_CONTROLLER;

    constructor(
        address accessController,
        address ipAssetRegistry,
        address licenseRegistry,
        address moduleRegistry
    ) IPAccountStorage(ipAssetRegistry, licenseRegistry, moduleRegistry) {
        if (accessController == address(0)) revert Errors.IPAccount__ZeroAccessController();
        ACCESS_CONTROLLER = accessController;
    }

    function token() public view override(ERC6551, IIPAccount) returns (uint256, address, uint256){
        return super.token();
    }

    function owner() public view override(ERC6551, IIPAccount) returns (address){
        return super.owner();
    }

    function supportsInterface(
        bytes4 interfaceId
    ) public view override(IPAccountStorage, ERC6551, IERC165) returns (bool) {
        return (
            // type(IIPAccountStorage).interfaceId == interfaceId ||
            type(IIPAccount).interfaceId == interfaceId ||
            type(IERC721Receiver).interfaceId == interfaceId ||
            type(IERC1155Receiver).interfaceId == interfaceId ||
            type(IERC6551Executable).interfaceId == interfaceId ||
            type(IERC6551Account).interfaceId == interfaceId ||
            super.supportsInterface(interfaceId)
        );
    }

    // Owner would be able to validate himself even with empty data. In that case
    // address(0) and then an empty data will be used. Inside AccessController,
    // if the owner is the signer, it doesn't check the data it just
    // returns (without an error, same as true)
    function isValidSigner(
        address signer,
        bytes calldata data
    ) public view override(ERC6551, IIPAccount) returns (bytes4 result) {
        address to = address(0);
        bytes memory callData = "";
        // If data is >0 then it must also be >= 32 . Meaning it must contains
        // at least the target(to) (then the data will be empty)
        if (data.length > 0){
            if (data.length < 32) revert Errors.IPAccount__InvalidCalldata();
            (to, callData) = abi.decode(data, (address, bytes));
        }
        // If data length is 0, target(to) will address(0) and callData will be empty("")
        if (this.isValidSigner(signer, to, callData)) {  // See Note#1 (why making a self external call)
            result = IIPAccount.isValidSigner.selector;
        }
    }

    // Read the other isValidSigner
    function isValidSigner(
        address signer,
        address to,
        bytes calldata data
    ) public view returns (bool) {
        // If data is >0 then it must also be >= 4 . Meaning it must be
        // targtting a func (by having the 4 bytes selector)
        if (data.length > 0 && data.length < 4)
            revert Errors.IPAccount__InvalidCalldata();

        bytes4 selector = bytes4(0);
        if (data.length >= 4) selector = bytes4(data[:4]);
        // the check will revert if permission is denied
        IAccessController(ACCESS_CONTROLLER).checkPermission(address(this), signer, to, selector);
        return true;
    }

    function state() public view override(ERC6551, IIPAccount) returns (bytes32) {
        return super.state();
    }

    function execute(address to, uint256 value, bytes calldata data) external payable returns (bytes memory) {}

    function executeWithSig(
        address to,
        uint256 value,
        bytes calldata data,
        address signer,
        uint256 deadline,
        bytes calldata signature
    ) external payable returns (bytes memory) {}

    // Override function from Solady's erc712: erc6551 => erc1271 => EIP712
    function _domainNameAndVersion() internal view override returns (string memory name, string memory version) {
        name = "Story Protocol Clone IP Account";
        version = "1";
    }

    function updateStateForValidSigner(address signer, address to, bytes calldata data) external onlyRegisteredModule {}

    receive() external payable override(Receiver, IIPAccount) {}

    // Updates state after each execution/tx from this account
    function _updateStateForExecute(address to, uint256 value, bytes calldata data) private {
        bytes32 newState = keccak256(abi.encode(
            state(), abi.encodeWithSignature("execute(address,uint256,bytes)", to, value, data)
        ));

        assembly {
            sstore(_ERC6551_STATE_SLOT, newState)
        }
    }
}