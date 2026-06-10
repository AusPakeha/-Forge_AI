/*
    IDS Commander AI - Set Operation State (v0.1)

    Params:
        0: STRING - OperationID
        1: STRING - State

    Authority: Server only.
*/

params [
    ["_operationID", ""],
    ["_state", ""]
];

if (!isServer) exitWith {};
if (_operationID isEqualTo "") exitWith {};
if (_state isEqualTo "") exitWith {};

private _operations = missionNamespace getVariable ["IDS_Operations", createHashMap];
private _operation = _operations getOrDefault [_operationID, nil];
if (isNil "_operation") exitWith {};

_operation set ["State", _state];

// Optionally set StartTime when moving out of CREATED
if (_state isEqualTo "ALLOCATING_FORCES") then {
    _operation set ["StartTime", serverTime];
};

_operations set [_operationID, _operation];
missionNamespace setVariable ["IDS_Operations", _operations, true];

true
