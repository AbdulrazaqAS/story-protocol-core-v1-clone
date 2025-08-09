// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

interface IIPModuleRegistry {
    function isRegistered(address module) external view returns (bool);
}