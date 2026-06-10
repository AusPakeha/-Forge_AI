/*
    IDS Commander AI - Release Group From Operation

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

// Return group to reserves and clear its committed state.
private _released = [_commanderID, _groupID] call IDS_fnc_releaseForce;
if (!_released) exitWith {false};

// Remove the group from the commander's assigned group list.
private _assigned = _cmd getOrDefault ["AssignedGroups", []];
if (_groupID in _assigned) then {
    _assigned deleteAt (_assigned find _groupID);
    _cmd set ["AssignedGroups", _assigned];
};

// Update the operation record if present.
private _operation = [_operationID] call IDS_fnc_getOperationData;
private _operationAssigned = [];
if (typeName _operation == "HASHMAP") then {
    _operationAssigned = _operation getOrDefault ["AssignedGroups", []];
    if (_groupID in _operationAssigned) then {
        _operationAssigned deleteAt (_operationAssigned find _groupID);
        _operation set ["AssignedGroups", _operationAssigned];
        private _ops = missionNamespace getVariable ["IDS_Operations", createHashMap];
        _ops set [_operationID, _operation];
        missionNamespace setVariable ["IDS_Operations", _ops, true];
    };
};

// Remove the operation from the commander's active operations if the operation has no remaining assigned groups.
private _activeOps = _cmd getOrDefault ["ActiveOperations", []];
if ((_operationID in _activeOps) && (_operationAssigned == [])) then {
    _activeOps deleteAt (_activeOps find _operationID);
    _cmd set ["ActiveOperations", _activeOps];
};

true
