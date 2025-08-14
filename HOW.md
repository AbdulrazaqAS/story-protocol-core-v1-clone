# How functions, modules, and other things work

## How0 `AccessController.checkPermission(...)`
This is the basic of how it works. There's more.
#### Params:
- address ipAccount: The ip account to check the permission on.
- address signer: The signer to check permission for.
- address target: The target the signer is trying to call.
- bytes4 func: The function selector of the intented function the signer is trying to call.

#### Params Interpretation
- Check whether the `signer` is allowed to execute `func` on `target` from this `ipAccount`. Or
- Check whether the `signer` is allowed to ask `ipAccount` to execute `func` on `target`.

The function throws an exception if the signer is not allowed. Else it just finishes silently. It doesn't return anything (like true/false).

If the signer is the owner of the NFT having this account, then it just terminates (returns) and do no further checks. This is to make the owner a valid signer by default and to allow him to execute any function on any target.

It checks permissions by hashing all the params `keccak256(abi.encode(IIPAccount(payable(ipAccount)).owner(), ipAccount, signer, to, func))` and checking the value stored against the result in a mapping.