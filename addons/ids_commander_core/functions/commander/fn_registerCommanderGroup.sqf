/*
    IDS Commander AI - Register Commander Group

    Adds a spawned group into the commander's reserve pool and updates combat-power accounting.

    Params:
        0: STRING - CommanderID
        1: STRING - GroupID
*/

params [
    ["_commanderID", ""],
    ["_groupID", ""]
];

if !(call IDS_fnc_isAuthority) exitWith {false};
if (_commanderID isEqualTo "") exitWith {false};
if (_groupID isEqualTo "") exitWith {false};

private _cmds = missionNamespace getVariable ["IDS_Commanders", createHashMap];
if (typeName _cmds != "HASHMAP") exitWith {false};
if !(_cmds hasKey _commanderID) exitWith {false};

private _cmd = _cmds get _commanderID;

// Ensure ReserveGroups exists and add
private _reserve = _cmd getOrDefault ["ReserveGroups", []];
if !(_groupID in _reserve) then {
    _reserve pushBack _groupID;
    _cmd set ["ReserveGroups", _reserve];
};

// Read combat power from group registry (best-effort)
private _g = [_groupID] call IDS_fnc_groupRegistry_get;
private _cp = _g getOrDefault ["CombatPower", 100];

private _avail = _cmd getOrDefault ["AvailableCombatPower", 0];
_avail = _avail + _cp;
_cmd set ["AvailableCombatPower", _avail];

_cmds set [_commanderID, _cmd];
missionNamespace setVariable ["IDS_Commanders", _cmds];

true
