// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

interface IAccessController {
    function checkPermission(
        address ipAccount,
        address signer,
        address target,
        bytes4 func
    ) external view;
}