**IP** stands for **Intellectual Property**
## Note:
- Phrases like "...create `IIPAssetRegistry` for registering IPs" or "...creating token bound account for an IP" means
  - Create `IIPAssetRegistry` for registering the NFTs representing the IPs, or
  - ...creating token bound account for an NFT representing an IP.
  - IPs like arts, music, vidoes, and other creative works are represented on-chain by an NFT.
- Read from buttom upwards


## MilestoneId
**Commits:**
*Range of commits regarding this milestone*

**Goal:**
*Goal to be achieved in the milstone*

**Background:**
*Some info/rationale regarding the milestone*

**Tasks:**
*Task to be done to achieve the goal*

**Fixes:**
*Fixes made to previous commits*


## Milestone5
**Commits:** 92999c1 - ...

**Goal:**
Create `IPAccountImpl` (Phase2): Implement the `execute` functions.

**Background:**
- I'm trying to create `IPAccountRegistry` to create a token bound account for IP's NFT.
- `IPAccountRegistry` uses `ERC6551Registry` to create a token bound account.
- `ERC6551Registry` requires an `ERC6551Account` implementation address to create the account.
- The `ERC6551Account` implementation (named `IPAccountImpl`) used by Story Protocol is an extended one.
- The account implementation used by Story Protocol inherits from `ERC6551`, `IPAccountStorage`, and `IIPAccount`. It also uses `AccessController` for managing permissions.

**Tasks:**
- Implement the two `execute` functions. The both take `to, value, data` and the signer is `msg.sender`
  - The ERC6551 one has an additional `operation` param to specify the operation type. Only `call` is supported currently.
  - *Q#10: Are they payable so that the value specified in the function can be sent to the account in that same tx?*

**Fixes:**
- Changed mutability of `IPAccountImpl._domainNameAndVersion()` to view as Story Protocol did it.

## Milestone4
**Commits:** 0561d66 - 92999c1

**Goal:**
Create `IPAccountImpl` (Phase1): Implement the `isValidSigner` functions.

**Background:**
- I'm trying to create `IPAccountRegistry` to create a token bound account for IP's NFT.
- `IPAccountRegistry` uses `ERC6551Registry` to create a token bound account.
- `ERC6551Registry` requires an `ERC6551Account` implementation address to create the account.
- The `ERC6551Account` implementation (named `IPAccountImpl`) used by Story Protocol is an extended one.
- The account implementation used by Story Protocol inherits from `ERC6551`, `IPAccountStorage`, and `IIPAccount`. It also uses `AccessController` for managing permissions.

**Tasks:**
- Create `IAccessController` which will be used for checking valid signers.
  - Add `checkPermission` function signature.
- Implement `isValidSigner` functions.
  - Has two `isValidSigner`. The ERC6551 specification one, and another one (not in any interface).
    - *Q#9: Why is the `isValidSigner` not in any interface?*
    - One (ERC6551 one) take `signer, context`, the other takes `signer, to, data`. (`context is also named as data in the code)
      - First one is converted to `signer, to, data` and forwarded to the second one.

**Fixes:**
- Removed **Side Effects** from Milestone Details.


## Milestone3
**Commits:** 2209f49 - 0561d66

**Goal:**
Create `IPAccountImpl` which will be used by `IPAccountRegistry` to create token bound accounts. `IPAccountImpl` is a little much, so it will be broken into multiple milestones. Phase0: Just create the file, inherit from parents, and write all the functions without bodies.

**Background:**
- I'm trying to create `IPAccountRegistry` to create a token bound account for IP's NFT.
- `IPAccountRegistry` uses `ERC6551Registry` to create a token bound account.
- `ERC6551Registry` requires an `ERC6551Account` implementation address to create the account.
- The `ERC6551Account` implementation (named `IPAccountImpl`) used by Story Protocol is an extended one.
- The account implementation used by Story Protocol inherits the following:
  - `ERC6551`: Solady's `ERC6551Account` implementation. This provides the implementation of methods from `IIPAccount`
  - `IPAccountStorage`: This serves as data storage of the `IPAccountImpl`. (Done at #ML1)
  - `IIPAccount`: Serves as interface which provides some of the functions signatures which each `ERC6551Account` must implement. (Done at #ML2)
- `IPAccountImpl` uses `AccessController` for managing permissions. Who and who can execute actions on/from this account.(`AccessController` is coming later)

**Tasks:**
- Create `IPAccountImpl`.
  - Inherits: Solady's `ERC6551`, `IPAccountStorage`, and `IIPAccount`.
  - constructor params:
    - Address of accessController. Has a public immutable for storing it.
    - Addresses of: ipAssetRegistry, licenseRegistry, moduleRegistry. These will be passed to `IPAccountStorage`
- `npm install solady erc6551`: erc6551 to be used in `supportsInterface` function.
  - *Q#7: Why doesn't the function include support for IIPAccountStorage?*
- Write all the functions as empty functions.
  - Has two `execute`. One from Solady's ERC6551, the other from `IIPAccount`.
  - *Q#8: Why is `executeBatch` not in any interface?*

**Fixes:**
- Modified **#ML0** and **#ML1** details.


## Milestone2
**Commits:** ac46ac0 - 2209f49

**Goal:**
Create `IIPAccount` which serves as interface which provides some of the functions signatures which each `ERC6551Account` must implement.

**Background:**
- I'm trying to create `IPAccountRegistry` to create a token bound account for IP's NFT.
- `IPAccountRegistry` uses `ERC6551Registry` to create a token bound account.
- `ERC6551Registry` requires an `ERC6551Account` implementation address to create the account.
- The `ERC6551Account` implementation (named `IPAccountImpl`) used by Story Protocol is an extended one.
- The account implementation used by Story Protocol inherits the following:
  - `ERC6551`: Solady's `ERC6551Account` implementation. This provides the implementation of methods from `IIPAccount`
  - `IPAccountStorage`: This serves as data storage of the `IPAccountImpl`. (Done at #ML1)
  - `IIPAccount`: Serves as interface which provides some of the functions signatures which each `ERC6551Account` must implement.
    - Only has the following functions among those specified in ERC6551 (`IERC6551Executable` and `IERC6551Account`): `receive`, `token`, `isValidSigner`.
      - It has `execute` but doesn't have the `operation` parameter. Original one is provided to `IPAccountImpl` by Solady's ERC6551.
      - It has `state` but returns `bytes32` instead of `uint256`.
    - *Q#4: Why not just inherit from `IERC6551Executable` and `IERC6551Account`?*
    - Even though `IPAccountImpl` inherits Solady's `ERC6551` which provides all the required ERC6551 functions, but it's `state` function return type too is `bytes32` not `uint256`.
      - *Q#6: Why are they both returning `bytes34` and not `uint256`? Did I miss something?*
    - *Q#5: Why `IPAccountImpl` has two functions for updating state: `updateStateForValidSigner` and `_updateStateForExecute`? For execute is intuitive, but for valid signer is not.*
- `IIPAccount` inherits from `IIPAccountStorage` as each account implementation will have a storage. As the account implementation will inherit from `IPAccountStorage`, that will provide the implementation of the functions.

**Tasks:**
- Create `IIPAccount`.
  - Inherits `IIPAccountStorage`.


## Milestone1
**Commits:** 7cb6523 - ac46ac0

**Goal:**
Create `IPAccountStorage` used by token bound accounts as their storage.

**Background:**
- Based on the previous milestone, the next thing should be registering IPs.
- But that depends on `IPAccountRegistry` to create a token bound account for the IP's NFT.
- `IPAccountRegistry` uses `ERC6551Registry` to create a token bound account.
- `ERC6551Registry` requires an `ERC6551Account` implementation address to create the account.
- The `ERC6551Account` implementation (named `IPAccountImpl`) used by Story Protocol is an extended one. It has a dedicated storage contract.
- The account implementation used by Story Protocol inherits the following:
  - `IIPAccount`: Serves as interface which provides some of the functions signatures which each `ERC6551Account` must implement.
  - `ERC6551`: Solady's `ERC6551Account` implementation. This provides the implementation of methods from `IIPAccount`.
  - `IPAccountStorage`: This serves as data storage of the `IPAccountImpl`.
- `IPAccountStorage` is a namespaced storage. As there are different modules and registries in the protocol, each one has a dedicated space (hence namespaced) for storing data relevant to it in the storage. Some:
  - Royalty Module: Stores data regarding royalty.
  - Dispute Module: Stores data regarding disputes.
  - Asset Registry: Stores data regarding registration.
  - ...
  - It is `IModuleRegistry` to check whether a calling module is registered.
  - *Q#3: It uses the module registry for allowing registered modules to write data but hardcoded the registries address as immutables. What if there is need to add another registry given that the storage is not upgradeable?*
    - Can the new registry be registered by the module registry to be given access to the storage?
    - Will they just create another module for to handle writing data of new registries to the storage?
- The storage uses functions like `setBytes`, `setBytesBatch`, `setBytes32`, and `getBytes` for writing and retrieving data. The functions are generic as any form of data can be represented as bytes. This makes the storage highly extensible whereby a contract or library can be used to create specific function from these generic ones. Like `IPAccountStorageOps` library (coming later) which has more specific functions.
- The storage is not upgradeable. The generality of the storage makes it not needed to be upgradeable. With the generic functions and the namespaced storage, many modules and contracts can be given space for writing data.
- *Q#2: The contract uses `using ShortStrings for *;`, Where is it used?*
  - Seems like it's not used. Just commented and the project still compiles.
- *Q#1: Shouldn't it also have `getBytesBatch` function that reads a batch from a single namespace?*

**Tasks:**
- Create `IIPAccountStorage`. And write all the functions signatures.
  - Inherits `IERC165` interface for interface detection.
- Create `IPAccountStorage`.
  - Inherits `IIPAccountStorage`
  - Inherits `ERC165` for `IERC165` function implementation. It overrides the only one function in it.
  - Constructor params:
    - Address of the three registries: ipAssetRegistry, licenseRegistry, moduleRegistry.
  - Create immutable vars for storing the address of the registries.
  - Create `IModuleRegistry` and add `isRegistered` function signature which will be used to check whether a module is registered.
  - Create `onlyRegisteredModule` modifier for detecting only registered modules and allowed registries.
  - Implement all the functions from `IIPAccountStorage`.

**Fixes:**
- Forgot to call `__UUPSUpgradeable_init` in `IPAssetRegistry` initializer.

## Milestone0
**Commits**: 738ab60 - 7cb6523

**Goal:**
Create `IPAssetRegistry`. Create its proxy storage struct. Write the most independent functions, others will come later.

**Background:**
- Starting point is `IPAssetRegistry` because it is the entry point for registering IPs.
- The `IPAssetRegistry` (and all registries) are UUPS upgradeable and have proxy storage struct for the registry variables.
- The registration of an IP is the creation of an ERC-6551 (Token Bound Account) account for the NFT representing it. This is done through `IPAccountRegistry`.
- Each account has an (`IPAccountStorage`) storage contract (will be implemented later).

**Tasks:**
- Create `IIPAccountRegistry` for creating token bound account for an IP
- Create `IIPAssetRegistry` for registering the IP
  - Inherits `IIPAccountRegistry`
- Create `UUPSUpgradeable` `IPAssetRegistry`
  - Temporarily use `OwnableUpgradeable` for access control because `_authorizeUpgrade` of `UUPSUpgradeable` must be overriden.
- Create the registry proxy storage struct. It tracks:
  - total IPs registered
  - registration fee
  - fee destination (treasury) address
  - fee token address
- Create the struct fields getter functions
- Create the struct fields setter function (*Q#0: Why did they use one function for that?*)
  - Is it because they won't be used frequently so one is enough plus it will reduce:
    - deployment cost?
    - functions lookup cost?
  - For clarity?
- Add all public/external functions to the corresponding interface.
