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

**Side Effects:**
*Tasks done but not in listed in the tasks of the milestone. Done just to **Currently** achieve listed tasks. Like creating an interface with a single function because it is currently needed*

**Fixes:**
*Fixes made to previous commits*


## Milestone2
**Commits:** ac46ac0 - ...

**Goal:**
Create `IIPAccount` which serves as `ERC6551Account` interface which all ERC6551 account implementations must inherit from.

**Background:**
- I'm trying to create `IPAccountRegistry` to create a token bound account for the IP's NFT.
- `IPAccountRegistry` uses `ERC6551Registry` to create a token bound account.
- `ERC6551Registry` requires an `ERC6551Account` implementation address to create the account.
- The `ERC6551Account` implementation (named `IPAccountImpl`) used by Story Protocol is an extended one.
- The account implementation used by Story Protocol inherits the following:
  - `IIPAccount`: Serves as `ERC6551Account` interface which all ERC6551 account implementations must inherit.
  - `ERC6551`: Solady's `ERC6551Account` implementation. This provides the implementation of methods from `IIPAccount`.
  - `IPAccountStorage`: This serves as data storage of the `IPAccountImpl`. (Done at #ML1)
- `IIPAccount` inherits from `IIPAccountStorage` as each account implementation will have a storage. As the account implementation will inherit from `IPAccountStorage`, that will provide the implementation of the functions.

**Tasks:**
- Create `IIPAccount`. Then copy and paste the `ERC6551Account` interface functions signatures from the EIP's web page.
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
  - `IIPAccount`: Serves as `ERC6551Account` interface which all ERC6551 account implementations must inherit.
  - `ERC6551`: Solady's `ERC6551Account` implementation. This provides the implementation of methods from `IIPAccount`.
  - `IPAccountStorage`: This serves as data storage of the `IPAccountImpl`.
- `IPAccountStorage` is a namespaced storage. As there are different modules and registries in the protocol, each one has a dedicated space (hence namespaced) for storing data relevant to it in the storage. Some:
  - Royalty Module: Stores data regarding royalty.
  - Dispute Module: Stores data regarding disputes.
  - Asset Registry: Stores data regarding registration.
  - ...
  - *Q: It uses the module registry for allowing registered modules to write data but hardcoded the registries address as immutables. What if there is need to add another registry given that the storage is not upgradeable?*
    - Can the new registry be registered by the module registry to be given access to the storage?
    - Will they just create another module for to handle writing data of new registries to the storage?
- The storage uses functions like `setBytes`, `setBytesBatch`, `setBytes32`, and `getBytes` for writing and retrieving data. The functions are generic as any form of data can be represented as bytes. This makes the storage highly extensible whereby a contract or library can be used to create specific function from these generic ones. Like `IPAccountStorageOps` library (coming later) which has more specific functions.
- The storage is not upgradeable. The generality of the storage makes it not needed to be upgradeable. With the generic functions and the namespaced storage, many modules and contracts can be given space for writing data.
- *Q: The contract uses `using ShortStrings for *;`, Where is it used?*
  - Seems like it's not used. Just commented and the project still compiles.
- *Q: Shouldn't it also have `getBytesBatch` function that reads a batch from a single namespace?*

**Tasks:**
- Create `IIPAccountStorage`. And write all the functions signatures.
  - Inherits `IERC165` interface for interface detection.
- Create `IPAccountStorage`.
  - Inherits `IIPAccountStorage`
  - Inherits `ERC165` for `IERC165` function implementation. It overrides the only one function in it.
  - Create immutable vars for storing the addresses of the registries.
  - Create `onlyRegisteredModule` modifier for detecting only registered modules and allowed registries.
  - Implement all the functions from `IIPAccountStorage`.

**Side Effects:**
- Created `IModuleRegistry` and add `isRegistered` function signature which is used in `IPAccountStorage` to detect registered modules.

**Fixes:**
- Forgot to call `__UUPSUpgradeable_init` in `IPAssetRegistry` initializer.

## Milestone0
**Commits**: 738ab60 - 7cb6523

**Goal:**
Set floor (or create contracts) for registering IPs

**Background:**
- Starting point is `IPAssetRegistry` because it is the entry point for registering IPs.
- The `IPAssetRegistry` (and all registries) are UUPS upgradeable and have proxy storage struct for the registry variables.
- The registration of an IP is the creation of an ERC-6551 (Token Bound Account) account for the NFT representing it. This is done through `IPAccountRegistry`.
- Each account has a storage contract (will be implemented later)

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
- Create the struct fields setter function (*Q: Why did they use one function for that?*)
  - Is it because they won't be used frequently so one is enough plus it will reduce:
    - deployment cost?
    - functions lookup cost?
  - For clarity?
- Add all public/external functions to the corresponding interface.
