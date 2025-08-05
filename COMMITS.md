### Commit: #5 Set floor (create contracts) for registering assets
**About:**
- Starting point is `IPAssetRegistry` because it is the entry point for registering assets.
- The `IPAssetRegistry` (and all registries) are UUPS upgradeable and have proxy storage struct for the registry variables.
- The registration of an asset is the creation of an ERC-6551 (Token Bound Account) account for it. This is done through `IPAccountRegistry`.
- Each account has a storage contract (will be implemented later)

**Goal:**
Set floor (create contracts) for registering assets

**Tasks:**
- Create `IIPAccountRegistry` for creating token bound account for an asset
- Create `IIPAssetRegistry` for registering the asset
  - Inherits `IIPAccountRegistry`
- Create `UUPSUpgradeable` `IPAssetRegistry`
  - Temporarily use `OwnableUpgradeable` for access control because `_authorizeUpgrade` of `UUPSUpgradeable` must be overriden.
- Create the registry proxy storage struct. It tracks:
  - total assets registered
  - registration fee
  - fee destination (treasury) address
  - fee token address
- Create the struct fields getter functions
- Create the struct fields setter function (Q: Why did they use one function for that?)
  - Is it because they won't be used frequently so one is enough plus it will reduce:
    - deployment cost?
    - functions lookup cost?
  - For clarity?
- Add all public/external functions to the corresponding interface.
