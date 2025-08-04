const { ethers } = require("ethers");

// Calculating // eip7201(id) = keccak256(abi.encode(uint256(keccak256(id)) - 1)) & ~bytes32(uint256(0xff));

id = "story-protocol-clone.IPAssetRegistry"

// Step 1: Get the keccak256 hash of the string
const innerHash = ethers.keccak256(ethers.toUtf8Bytes(id));

// Step 2: Convert to BigInt and subtract 1
const innerBigInt = BigInt(innerHash) - 1n;

// Step 3: ABI encode the uint256
const encoded = ethers.AbiCoder.defaultAbiCoder().encode(["uint256"], [innerBigInt]);

// Step 4: keccak256 of the encoded data
const outerHash = ethers.keccak256(encoded);

// Step 5: Apply bitmask AND with ~0xff (which means mask last byte to zero)
const resultBigInt = BigInt(outerHash) & ~0xffn;

// Step 6: Convert back to bytes32 hex string
const finalHex = "0x" + resultBigInt.toString(16).padStart(64, "0");

console.log("EIP-7201 Hash for id:", id);
console.log(finalHex);
