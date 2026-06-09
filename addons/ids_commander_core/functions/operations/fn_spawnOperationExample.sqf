/*
    IDS Commander AI - Spawn Operation Example (debug/dev)

    Not used by the system automatically.
    Creates a single operation in IDS_Operations.
*/

if !(call IDS_fnc_isAuthority) exitWith {};

params [
    ["_targetPos",[]],
    ["_radius",200]
];

if (_targetPos isEqualTo []) exitWith {};

private _ops = missionNamespace getVariable ["IDS_Operations", createHashMap];

private _opId = ["OP"] call IDS_fnc_generateUID;

private _op = createHashMapFromArray
[
    ["ID", _opId],
    ["Status","DEPLOY"],
    ["Group", grpNull],
    ["TargetPos", _targetPos],
    ["OriginPos",[]],
    ["Radius", _radius]
];

_ops set [_opId, _op];
missionNamespace setVariable ["IDS_Operations", _ops];

_op

