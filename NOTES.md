# Notes Reference

## Note#0 OPTIMIZATION
```solidity
for (uint256 i=0; i< keys.length;) {
    ...
    uncheck {
        ++i;
    }
}
```

## Note#1 INFO QUESTION OPTIMIZATION
Why making a self external call here (IPAccountImpl.isValidSigner())
`if (this.isValidSigner(signer, to, callData)) {}` and not `if (isValidSigner(signer, to, callData)) {}`?

- `this.isValidSigner(...)` makes an external call to the same contract.
- Because to convert data in memory to calldata as required by the func.
- Inside the same contract, internal calls can’t convert `bytes memory` to `bytes calldata` without copying.

### But which is gas optimized? Making a self external call (and having the price of external call and cost for copy from memory to calldata) or making the function receive `bytes memory` (and do an internal call)?

#### Case 1 — External self-call (this.isValidSigner(...))
- This costs a lot more gas because:
    - You pay the full external call overhead (~700 gas just for the call frame, plus memory expansion & calldata copy).
    - You pay to re-read your own code and re-enter the function.
    - You lose access to the current memory — everything is serialized and passed in calldata.
- This is by far the less gas-efficient option for passing bytes between two functions in the same contract.

#### Case 2 — Internal call with bytes memory
- This avoids the ABI encoding step entirely.
- The compiler just passes a pointer & length to the function — zero data copy, no external call overhead.
- Only cost is what you already paid when allocating callData (a var in the func) in the first place.

### Why they used this here, the external call
So that:
- Permissions checks happen through the external ABI exactly like an off-chain signer call would.
- It forces the function to run in the same code path for both external users and internal callers — less risk of inconsistent logic.
- The gas cost tradeoff is accepted for consistency & security.

### Security differences
- A normal call would pass memory arguments directly, which might skip security logic that depends on reading calldata exactly as an external user sends it.
- Using `this.` means the check runs as if it came from any other transaction — including the full calldata parsing, permission checks, and msg.sender behavior.
