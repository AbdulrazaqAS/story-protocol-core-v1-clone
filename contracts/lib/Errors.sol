// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

library Errors {
    /////////////// IP Asset Registry ///////////////
    error IPAssetRegistry__ZeroAddress(string name);

    /////////////// IP Account Storage ///////////////
    error IPAccountStorage__NotRegisteredModule(address module);
    error IPAccountStorage__InvalidBatchLengths();
    error IPAccountStorage__ZeroIpAssetRegistry();
    error IPAccountStorage__ZeroModuleRegistry();
    error IPAccountStorage__ZeroLicenseRegistry();

    /////////////// IP Account (Implementation) ///////////////
    error IPAccount__ZeroAccessController();
    error IPAccount__InvalidCalldata();
}