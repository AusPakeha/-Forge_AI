/*
    IDS Commander AI - Release Force

    Releases a committed/active group back to reserves and adjusts combat-power accounting.

    Params:
        0: STRING - CommanderID
        1: STRING - GroupID
*/

params ["_commanderID", "_groupID"];

if !(call IDS_fnc_isAuthority) exitWith {false};
if (_commanderID isEqualTo "") exitWith {false};
if (_groupID isEqualTo "") exitWith {false};

private _cmds = missionNamespace getVariable ["IDS_Commanders", createHashMap];
if (typeName _cmds != "HASHMAP") exitWith {false};
if !(_cmds hasKey _commanderID) exitWith {false};

private _cmd = _cmds get _commanderID;
private _g = [_groupID] call IDS_fnc_groupRegistry_get;
private _cp = _g getOrDefault ["CombatPower", 100];

// Remove from active groups
private _active = _cmd getOrDefault ["ActiveGroups", []];
if (_groupID in _active) then { _active deleteAt (_active find _groupID); _cmd set ["ActiveGroups", _active]; };

// Add back to reserve
private _reserve = _cmd getOrDefault ["ReserveGroups", []];
if !(_groupID in _reserve) then { _reserve pushBack _groupID; _cmd set ["ReserveGroups", _reserve]; };

// Adjust combat power accounting
private _avail = _cmd getOrDefault ["AvailableCombatPower", 0];
private _committed = _cmd getOrDefault ["CommittedCombatPower", 0];

_avail = _avail + _cp;
_committed = (_committed - _cp) max 0;

_cmd set ["AvailableCombatPower", _avail];
_cmd set ["CommittedCombatPower", _committed];

// Update group registry status
[_groupID, "AVAILABLE"] call IDS_fnc_groupRegistry_setStatus;

_cmds set [_commanderID, _cmd];
missionNamespace setVariable ["IDS_Commanders", _cmds];

true
