/*
    IDS Commander AI - Spawn Force Package (Force Package Framework)

    Backwards-compatible wrapper used by commander code paths.

    Spawn contract:
        [ _packageType, _spawnPosition, _commanderID ]

    Returns:
        [ _groupIDs, _vehicleIDs ]

    v0.1:
    - Spawns infantry groups only
    - Registers groups in IDS_GroupRegistry
*/

params [
    ["_packageType",""],
    ["_spawnPos", [0,0,0]],
    ["_commanderID","", ""]
];

private _commanderIdStr = _commanderID;

[_packageType, _spawnPos, _commanderIdStr] call IDS_fnc_spawnForcePackage_v1

