// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

library Errors {
    /////////////// IP Asset Registry ///////////////
    error IPAssetRegistry__ZeroAddress(string name);

    /////////////// IP Account Storage ///////////////
    error IPAccountStorage__NonRegisteredModule(address module);  // Check
    error IPAccountStorage__KeysValuesLengthMismatch();  // Check
    error IPAccountStorage__ZeroAddress(string name);  // Check
}