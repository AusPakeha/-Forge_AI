/*
    IDS Commander AI - Assign Group To Commander Operation

    Params:
        0: STRING - CommanderID
        1: STRING - GroupID
        2: STRING - OperationID

    Returns:
        BOOLEAN
*/

params ["_commanderID", "_groupID", "_operationID"];

if !(call IDS_fnc_isAuthority) exitWith {false};
if (_commanderID isEqualTo "") exitWith {false};
if (_groupID isEqualTo "") exitWith {false};
if (_operationID isEqualTo "") exitWith {false};

private _cmd = [_commanderID] call IDS_fnc_getCommanderData;
if (typeName _cmd != "HASHMAP") exitWith {false};

// Commit the group from reserve into active status.
private _committed = [_commanderID, _groupID] call IDS_fnc_commitForce;
if (!_committed) exitWith {false};

// Attach to the operation record on the commander.
private _ops = _cmd getOrDefault ["Operations", []];
if !(_operationID in _ops) then {
    _ops pushBack _operationID;
    _cmd set ["Operations", _ops];
};

private _assigned = _cmd getOrDefault ["AssignedGroups", []];
if !(_groupID in _assigned) then {
    _assigned pushBack _groupID;
    _cmd set ["AssignedGroups", _assigned];
};

private _activeOps = _cmd getOrDefault ["ActiveOperations", []];
if !(_operationID in _activeOps) then {
    _activeOps pushBack _operationID;
    _cmd set ["ActiveOperations", _activeOps];
};

private _cmds = missionNamespace getVariable ["IDS_Commanders", createHashMap];
_cmds set [_commanderID, _cmd];
missionNamespace setVariable ["IDS_Commanders", _cmds];

true
