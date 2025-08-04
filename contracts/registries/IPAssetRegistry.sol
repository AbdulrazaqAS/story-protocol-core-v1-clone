// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import {UUPSUpgradeable} from "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

import {IIPAssetRegistry} from "../interfaces/registries/IIPAssetRegistry.sol";

contract IPAssetRegistry is IIPAssetRegistry, OwnableUpgradeable, UUPSUpgradeable {
    /// @custom:storage-location erc7201:story-protocol-clone.IPAssetRegistry
    struct IPAssetRegistryStorage {
        uint256 totalSupply;  // Total number of registered assets
        address feeToken;  // Token used for paying fees
        address treasury;  // Address where fees are collected
        uint96 feeAmount;  // Amount of fee to be paid for asset registration.
    }

    // erc7201(story-protocol-clone.IPAssetRegistry)
    // keccak256(abi.encode(uint256(keccak256("story-protocol-clone.IPAssetRegistry")) - 1)) & ~bytes32(uint256(0xff));
    bytes32 private constant IPAssetRegistryStorageLocation = 0x09dfb5fccc754b3771dfd48d9355aaf026c07703881852d08df8238c9fc22600;

    function initialize(address owner) external initializer {
        __Ownable_init(owner);
    }

    // Must be overridden to include access restriction to the upgrade mechanism
    // TODO: Temporary version. Will be replaced with access manager later.
    function _authorizeUpgrade(address newImplementation) internal override onlyOwner {}
}