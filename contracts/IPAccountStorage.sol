// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import {ERC165} from "@openzeppelin/contracts/utils/introspection/ERC165.sol";
import {IERC165} from "@openzeppelin/contracts/utils/introspection/IERC165.sol";

import {IIPAccountStorage} from "./interfaces/IIPAccountStorage.sol";
import {IIPModuleRegistry} from "./interfaces/registries/IIPModuleRegistry.sol";
import {Errors} from "./lib/Errors.sol";

contract IPAccountStorage is IIPAccountStorage, ERC165 {
    address private immutable _IP_ASSET_REGISTRY;
    address private immutable _IP_LICENSE_REGISTRY;
    address private immutable _IP_MODULE_REGISTRY;

    mapping(bytes32 => mapping(bytes32 => bytes)) private _bytesStorage;
    mapping(bytes32 => mapping(bytes32 => bytes32)) private _bytes32Storage;

    modifier onlyRegisteredModule() {
        if (
            msg.sender != _IP_ASSET_REGISTRY &&
            msg.sender != _IP_LICENSE_REGISTRY &&
            !IIPModuleRegistry(_IP_MODULE_REGISTRY).isRegistered(msg.sender)
        ) {
            revert Errors.IPAccountStorage__NonRegisteredModule(msg.sender);
        }
        _;
    }

    constructor(address ipAssetRegistry, address ipLicenseRegistry, address ipModuleRegistry) {
        if (ipAssetRegistry == address(0)) revert Errors.IPAccountStorage__ZeroAddress("assetRegistry");
        if (ipLicenseRegistry == address(0)) revert Errors.IPAccountStorage__ZeroAddress("licenseRegistry");
        if (ipModuleRegistry == address(0)) revert Errors.IPAccountStorage__ZeroAddress("moduleRegistry");

        _IP_ASSET_REGISTRY = ipAssetRegistry;
        _IP_LICENSE_REGISTRY = ipLicenseRegistry;
        _IP_MODULE_REGISTRY = ipModuleRegistry;
    }

    function setBytes(bytes32 key, bytes calldata value) public onlyRegisteredModule {
        _bytesStorage[_toBytes32(msg.sender)][key] = value;
    }

    function getBytes(bytes32 key) public view returns (bytes memory) {
        return _bytesStorage[_toBytes32(msg.sender)][key];
    }

    function getBytes(bytes32 namespace, bytes32 key) public view returns (bytes memory) {
        return _bytesStorage[namespace][key];
    }

    function setBytesBatch(bytes32[] calldata keys, bytes[] calldata values) public onlyRegisteredModule {
        if (keys.length != values.length) revert Errors.IPAccountStorage__KeysValuesLengthMismatch();  // Check
        bytes32 sender = _toBytes32(msg.sender);
        for (uint256 i=0; i < keys.length; i++) {  // PO#0
            _bytesStorage[sender][keys[i]] = values[i];
        }
    }

    function getBytesBatch(bytes32[] calldata namespaces, bytes32[] calldata keys) public view returns (bytes[] memory data) {
        if (namespaces.length != keys.length) revert Errors.IPAccountStorage__KeysValuesLengthMismatch();
        data = new bytes[](keys.length);
        for (uint256 i=0; i < keys.length; i++) {  // PO#0
            data[i] = _bytesStorage[namespaces[i]][keys[i]];
        }
    }

    function setBytes32Batch(bytes32[] calldata keys, bytes32[] calldata values) public onlyRegisteredModule {
        if (keys.length != values.length) revert Errors.IPAccountStorage__KeysValuesLengthMismatch();  // Check
        bytes32 sender = _toBytes32(msg.sender);
        for (uint256 i=0; i < keys.length; i++) {  // PO#0
            _bytes32Storage[sender][keys[i]] = values[i];
        }
    }

    function getBytes32Batch(bytes32[] calldata namespaces, bytes32[] calldata keys) public view returns (bytes32[] memory data) {
        if (namespaces.length != keys.length) revert Errors.IPAccountStorage__KeysValuesLengthMismatch();
        data = new bytes32[](keys.length);
        for (uint256 i=0; i < keys.length; i++) {  // PO#0
            data[i] = _bytes32Storage[namespaces[i]][keys[i]];
        }
    }

    function setBytes32(bytes32 key, bytes32 value) public onlyRegisteredModule {
        _bytes32Storage[_toBytes32(msg.sender)][key] = value;
    }

    function getBytes32(bytes32 key) public view returns (bytes32) {
        return _bytes32Storage[_toBytes32(msg.sender)][key];
    }

    function getBytes32(bytes32 namespace, bytes32 key) public view returns (bytes32) {
        return _bytes32Storage[namespace][key];
    }

    function _toBytes32(address _value) private pure returns (bytes32) {
        return bytes32(uint256(uint160(_value)));
    }

    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
        return interfaceId == type(IIPAccountStorage).interfaceId || super.supportsInterface(interfaceId);
    }
}