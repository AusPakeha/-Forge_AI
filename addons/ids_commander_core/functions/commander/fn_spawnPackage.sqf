/*
    IDS Commander AI - Spawn Package (Version 1) (chat27.sqf)

    Spawns units from IDS_ForcePackages[packageKey]["Composition"] at _spawnPos.

    Params:
        0: _packageKey (String)
        1: _spawnPos (Position)
        2: _side (Side) optional (default: east)

    Returns:
        group (created group)
*/

params [
    ["_packageKey",""],
    ["_spawnPos", [0,0,0]],
    ["_side", east],
    // v0.1 force-framework: commanderID used for registry ownership
    ["_commanderID", ""]
];

if !(call IDS_fnc_isAuthority) exitWith {grpNull};
if (_packageKey isEqualTo "") exitWith {grpNull};

call IDS_fnc_initForcePackages;

private _pkg = IDS_ForcePackages getOrDefault [_packageKey, createHashMap];
private _composition = _pkg getOrDefault ["Composition", []];

if (typeName _composition != "ARRAY") exitWith {grpNull};

private _grp = createGroup [_side, true];

{
    private _cls = _x;
    if (isText _cls && {_cls != ""}) then
    {
        _grp createUnit [_cls, _spawnPos, [], 5, "FORM"];
    };
} forEach _composition;

_grp setVariable ["IDS_PackageKey", _packageKey];

// Register group in IDS_GroupRegistry.
// Contract note: Groups belong to commanders; in v0.1 we only register if commanderID is known.
if (!(_commanderID isEqualTo "")) then
{
    private _groupId = ["GRP"] call IDS_fnc_generateGroupId;
    _grp setVariable ["IDS_GroupID", _groupId];
    [_groupId, _grp, _commanderID, ""] call IDS_fnc_groupRegistry_register;
};

_grp

