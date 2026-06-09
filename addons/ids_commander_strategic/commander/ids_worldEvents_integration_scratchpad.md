# IDS Commander AI - World Event Integration Scratchpad

This file is a temporary development scratchpad and is not loaded by the mod.

Goal: Implement chat31’s “World Event System” concepts into commander code.

## Required commander adapters (to be created)

- `IDS_fnc_updateEvents` (server-side)
- `IDS_fnc_generateWorldEvent` (weighted generation)
- `IDS_fnc_applyWorldEventToState` (economy/territory/intel/misc effects)
- `IDS_fnc_notifyCommanderOfEvents` (RecentEvents)
- Persistence hooks: save/load `ActiveEvents`

## Vertical slice milestone (from chat31)

Implement only:
- Events: `Resource Boom`, `Intel Leak`
- Doctrine: `AGGRESSIVE`, `DEFENSIVE`

## Minimal effects for first implementation

- `Resource Boom`: bump `ResourceMultiplier` on target location and let economy/strategic scoring read it.
- `Intel Leak`: temporarily add to commander’s `KnownLocations` or boost intel confidence.

