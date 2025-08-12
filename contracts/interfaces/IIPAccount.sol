// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import {IIPAccountStorage} from "./IIPAccountStorage.sol";

interface IIPAccount is IIPAccountStorage {
    /// @notice Emitted when a transaction is executed.
    /// @param to The recipient of the transaction.
    /// @param value The amount of Ether sent.
    /// @param data The data sent along with the transaction.
    /// @param nonce The nonce of the transaction.
    event Executed(address indexed to, uint256 value, bytes data, bytes32 nonce);

    /// @notice Emitted when a transaction is executed on behalf of the signer.
    /// @param to The recipient of the transaction.
    /// @param value The amount of Ether sent.
    /// @param data The data sent along with the transaction.
    /// @param nonce The nonce of the transaction.
    /// @param deadline The deadline of the transaction signature.
    /// @param signer The signer of the transaction.
    /// @param signature The signature of the transaction, EIP-712 encoded.
    event ExecutedWithSig(
        address indexed to,
        uint256 value,
        bytes data,
        bytes32 nonce,
        uint256 deadline,
        address indexed signer,
        bytes signature
    );

    receive() external payable;
    function token()
        external
        view
        returns (uint256 chainId, address tokenContract, uint256 tokenId);

    // Serves as a nonce. Prevents Fraud. See Security Considerations in the EIP's page.
    function state() external view returns (bytes32);  // See around Q#4

    // Whether signer is a valid signer. data is an optional but defined data.
    function isValidSigner(address signer, bytes calldata data)
        external
        view
        returns (bytes4 magicValue);
    
    // Owner of the NFT having this account
    function owner() external view returns (address);
    
    // To execute an action by a valid signer
    function execute(address to, uint256 value, bytes calldata data)
        external
        payable
        returns (bytes memory);

    // To execute actions on behalf of a valid signer
    function executeWithSig(
        address to,
        uint256 value,
        bytes calldata data,
        address signer,
        uint256 deadline,
        bytes calldata signature
    ) external payable returns (bytes memory);

    // Can only be called by a registerred module because it will be guided by onlyRegisteredModule modifier.
    // Updates the account's state. Didn't quite understand its importance yet.
    function updateStateForValidSigner(address signer, address to, bytes calldata data) external;
}