/*
    IDS Commander AI - Fail Operation (v0.1)

    Params:
        0: STRING - OperationID

    Authority: Server only.
*/

params ["_operationID"];

if (!isServer) exitWith {};

private _operations = missionNamespace getVariable ["IDS_Operations", createHashMap];
private _operation = _operations getOrDefault [_operationID, createHashMap];
if (typeName _operation != "HASHMAP") exitWith {};

_operation set ["EndTime", serverTime];
_operations set [_operationID, _operation];
missionNamespace setVariable ["IDS_Operations", _operations, true];

[_operationID, "FAILED"] call IDS_fnc_setOperationState;

true
