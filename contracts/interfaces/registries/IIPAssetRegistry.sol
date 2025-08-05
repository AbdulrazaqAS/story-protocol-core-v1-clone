// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import {IIPAccountRegistry} from "./IIPAccountRegistry.sol";

interface IIPAssetRegistry is IIPAccountRegistry {
    event RegistrationFeeSet(address indexed treasury, address indexed feeToken, uint96 feeAmount);

    function getTreasury() external view returns (address);
    function getFeeToken() external view returns (address);
    function getFeeAmount() external view returns (uint96);
    function totalSupply() external view returns (uint256);
    function setRegistrationFee(address treasury, address feeToken, uint96 feeAmount) external;
}