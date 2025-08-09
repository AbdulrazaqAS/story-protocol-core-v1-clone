// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import {IERC165} from "@openzeppelin/contracts/utils/introspection/IERC165.sol";

interface IIPAccountStorage is IERC165 {
    function setBytes(bytes32 key, bytes calldata value) external;
    function getBytes(bytes32 key) external view returns (bytes memory);
    function getBytes(bytes32 namespace, bytes32 key) external view returns (bytes memory);

    function setBytesBatch(bytes32[] calldata keys, bytes[] calldata values) external;
    function getBytesBatch(bytes32[] calldata namespaces, bytes32[] calldata keys) external view returns (bytes[] memory);

    function setBytes32(bytes32 key, bytes32 value) external;
    function getBytes32(bytes32 key) external view returns (bytes32);
    function getBytes32(bytes32 namespace, bytes32 key) external view returns (bytes32);
    
    function setBytes32Batch(bytes32[] calldata keys, bytes32[] calldata values) external;
    function getBytes32Batch(bytes32[] calldata namespaces, bytes32[] calldata keys) external view returns (bytes32[] memory);
}