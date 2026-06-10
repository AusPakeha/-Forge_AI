params ["_commander"];

private _targetPos =
[
    _commander,
    "CAPTURE"
] call IDS_fnc_getFrontlineTargetPos;

if (_targetPos isEqualTo []) exitWith {};

private _operation =
[
    _commander,
    "CAPTURE",
    _targetPos
] call IDS_fnc_createOperation;

[_operation] call IDS_fnc_allocateOperationForces;