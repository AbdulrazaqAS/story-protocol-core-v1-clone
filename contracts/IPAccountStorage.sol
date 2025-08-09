// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import {ERC165, IERC165} from "@openzeppelin/contracts/utils/introspection/ERC165.sol";

import {IIPAccountStorage} from "./interfaces/IIPAccountStorage.sol";
import {IModuleRegistry} from "./interfaces/registries/IModuleRegistry.sol";
import {Errors} from "./lib/Errors.sol";

contract IPAccountStorage is IIPAccountStorage, ERC165 {
    address public immutable IP_ASSET_REGISTRY;
    address public immutable LICENSE_REGISTRY;
    address public immutable MODULE_REGISTRY;

    mapping(bytes32 => mapping(bytes32 => bytes)) public bytesData;
    mapping(bytes32 => mapping(bytes32 => bytes32)) public bytes32Data;

    modifier onlyRegisteredModule() {
        if (  // PO: Module/registry that will use the storage more frequently should be first to be checked in the circuit
            msg.sender != IP_ASSET_REGISTRY &&
            msg.sender != LICENSE_REGISTRY &&
            !IModuleRegistry(MODULE_REGISTRY).isRegistered(msg.sender)
        ) {
            revert Errors.IPAccountStorage__NotRegisteredModule(msg.sender);
        }
        _;
    }

    constructor(address ipAssetRegistry, address ipLicenseRegistry, address ipModuleRegistry) {
        if (ipAssetRegistry == address(0)) revert Errors.IPAccountStorage__ZeroIpAssetRegistry();
        if (ipLicenseRegistry == address(0)) revert Errors.IPAccountStorage__ZeroLicenseRegistry();
        if (ipModuleRegistry == address(0)) revert Errors.IPAccountStorage__ZeroModuleRegistry();
        IP_ASSET_REGISTRY = ipAssetRegistry;
        LICENSE_REGISTRY = ipLicenseRegistry;
        MODULE_REGISTRY = ipModuleRegistry;
    }

    function setBytes(bytes32 key, bytes calldata value) public onlyRegisteredModule {
        bytesData[_toBytes32(msg.sender)][key] = value;
    }

    function getBytes(bytes32 key) public view returns (bytes memory) {
        return bytesData[_toBytes32(msg.sender)][key];
    }

    function getBytes(bytes32 namespace, bytes32 key) public view returns (bytes memory) {
        return bytesData[namespace][key];
    }

    function setBytesBatch(bytes32[] calldata keys, bytes[] calldata values) public onlyRegisteredModule {
        if (keys.length != values.length) revert Errors.IPAccountStorage__InvalidBatchLengths();
        bytes32 namespace = _toBytes32(msg.sender);  // Optimized: namespace cached
        for (uint256 i=0; i < keys.length; i++) {  // PO#0
            bytesData[namespace][keys[i]] = values[i];
        }
    }

    function getBytesBatch(bytes32[] calldata namespaces, bytes32[] calldata keys) public view returns (bytes[] memory values) {
        if (namespaces.length != keys.length) revert Errors.IPAccountStorage__InvalidBatchLengths();
        values = new bytes[](keys.length);
        for (uint256 i=0; i < keys.length; i++) {  // PO#0
            values[i] = bytesData[namespaces[i]][keys[i]];
        }
    }

    function setBytes32(bytes32 key, bytes32 value) public onlyRegisteredModule {
        bytes32Data[_toBytes32(msg.sender)][key] = value;
    }

    function getBytes32(bytes32 key) public view returns (bytes32) {
        return bytes32Data[_toBytes32(msg.sender)][key];
    }

    function getBytes32(bytes32 namespace, bytes32 key) public view returns (bytes32) {
        return bytes32Data[namespace][key];
    }

    function setBytes32Batch(bytes32[] calldata keys, bytes32[] calldata values) public onlyRegisteredModule {
        if (keys.length != values.length) revert Errors.IPAccountStorage__InvalidBatchLengths();
        bytes32 namespace = _toBytes32(msg.sender);  // Optimized: namespace cached
        for (uint256 i=0; i < keys.length; i++) {  // PO#0
            bytes32Data[namespace][keys[i]] = values[i];
        }
    }

    function getBytes32Batch(bytes32[] calldata namespaces, bytes32[] calldata keys) public view returns (bytes32[] memory values) {
        if (namespaces.length != keys.length) revert Errors.IPAccountStorage__InvalidBatchLengths();
        values = new bytes32[](keys.length);
        for (uint256 i=0; i < keys.length; i++) {  // PO#0
            values[i] = bytes32Data[namespaces[i]][keys[i]];
        }
    }

    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
        return interfaceId == type(IIPAccountStorage).interfaceId || super.supportsInterface(interfaceId);
    }

    function _toBytes32(address addr) private pure returns (bytes32) {
        return bytes32(uint256(uint160(addr)));
    }
}