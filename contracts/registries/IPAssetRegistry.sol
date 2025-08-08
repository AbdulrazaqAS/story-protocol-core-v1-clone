// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import {UUPSUpgradeable} from "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

import {IIPAssetRegistry} from "../interfaces/registries/IIPAssetRegistry.sol";
import {Errors} from "../lib/Errors.sol";

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

    function initialize(address _owner) external initializer {
        __Ownable_init(_owner);  // Temporarily used before updating to access manager
        __UUPSUpgradeable_init();
    }

    function setRegistrationFee(address treasury, address feeToken, uint96 feeAmount) public onlyOwner {
        if (feeAmount > 0) {
            if (treasury == address(0)) revert Errors.IPAssetRegistry__ZeroAddress("treasury");
            if (feeToken == address(0)) revert Errors.IPAssetRegistry__ZeroAddress("feeToken");
        }
        
        IPAssetRegistryStorage storage $ = _getIPAssetRegistryStorage();
        $.treasury = treasury;
        $.feeToken = feeToken;
        $.feeAmount = feeAmount;
    }

    function totalSupply() external view returns (uint256) {
        return _getIPAssetRegistryStorage().totalSupply;
    }

    function getFeeAmount() external view returns (uint96) {
        return _getIPAssetRegistryStorage().feeAmount;
    }

    function getFeeToken() external view returns (address) {
        return _getIPAssetRegistryStorage().feeToken;
    }

    function getTreasury() external view returns (address) {
        return _getIPAssetRegistryStorage().treasury;
    }

    function _getIPAssetRegistryStorage() private pure returns (IPAssetRegistryStorage storage $) {
        assembly {
            $.slot := IPAssetRegistryStorageLocation
        }
    }

    // Must be overridden to include access restriction to the upgrade mechanism
    // TODO: Temporary version. Will be replaced with access manager later.
    function _authorizeUpgrade(address newImplementation) internal override onlyOwner {}

}