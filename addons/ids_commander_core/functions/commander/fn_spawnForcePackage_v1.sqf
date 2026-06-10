/*
    IDS Commander AI - Spawn Force Package (v0.1)

    This is the initial implementation of the Force Package Framework boundary.

    Spawn contract:
        [ _packageType, _spawnPosition, _commanderID ]

    Output:
        [ _groupIDs, _vehicleIDs ]

    Notes (v0.1):
    - Authority: server only.
    - Only FORCE_RIFLE_SQUAD / FORCE_GARRISON / FORCE_MOTORIZED_SQUAD / FORCE_RECON_TEAM are supported
      by IDS_ForcePackages.
    - Currently vehicles not spawned; returns [] for vehicleIDs.
*/

params [
    ["_packageType",""],
    ["_spawnPos", [0,0,0]],
    ["_commanderID",""]
];

if (!isServer) exitWith { [[],[]] };
if (_packageType isEqualTo "") exitWith { [[],[]] };
if (_commanderID isEqualTo "") exitWith { [[],[]] };

call IDS_fnc_initForcePackages;

private _side = east;

private _pkg = IDS_ForcePackages getOrDefault [_packageType, createHashMap];
private _composition = _pkg getOrDefault ["Composition", []];
if (typeName _composition != "ARRAY") exitWith { [[],[]] };

private _groupId = ["GRP"] call IDS_fnc_generateID;
private _grp = createGroup [_side, true];

{
    private _cls = _x;
    if (isText _cls && {_cls != ""}) then {
        _grp createUnit [_cls, _spawnPos, [], 5, "FORM"];
    };
} forEach _composition;

_grp setVariable ["IDS_GroupID", _groupId];
_grp setVariable ["IDS_PackageKey", _packageType];

// Register into IDS_GroupRegistry
[_groupId, _grp, _commanderID, ""] call IDS_fnc_groupRegistry_register;

// Return contract: only IDs to caller.
[
    [_groupId],
    []
]

