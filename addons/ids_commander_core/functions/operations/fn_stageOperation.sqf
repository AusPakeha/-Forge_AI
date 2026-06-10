/*
    IDS Commander AI - Stage Operation (v0.1)

    Params:
        0: STRING - OperationID

    Authority: Server only.
*/

params ["_operationID"];

if (!isServer) exitWith {};

private _operations = missionNamespace getVariable ["IDS_Operations", createHashMap];
private _operation = _operations getOrDefault [_operationID, createHashMap];
if (typeName _operation != "HASHMAP") exitWith {};

private _targetLocation = [_operation get "TargetLocation"] call IDS_fnc_getLocationData;
private _targetPos = _targetLocation getOrDefault ["Position", []];
if (_targetPos isEqualTo []) exitWith {};

{
    private _group = [_x] call IDS_fnc_getGroupObject;
    if !(isNull _group) then {
        _group move _targetPos;
        [_x, "EXECUTING"] call IDS_fnc_groupRegistry_setStatus;
    };
} forEach (_operation getOrDefault ["AssignedGroups", []]);

_operation set ["StartTime", serverTime];
_operations set [_operationID, _operation];
missionNamespace setVariable ["IDS_Operations", _operations, true];

[_operationID, "EXECUTING"] call IDS_fnc_setOperationState;

true
