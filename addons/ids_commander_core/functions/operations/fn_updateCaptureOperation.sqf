/*
    IDS Commander AI - Update CAPTURE operation (type-specific update)

    chat26.sqf integration:
    - Adds operation type router entrypoint for CAPTURE
    - Currently preserves legacy behavior via DEPLOY/MARCH/ENGAGE/RESOLVE
*/

params ["_op"];

if (isNil "_op") exitWith {};

// CAPTURE expects TargetPos/Radius/Group fields used by existing functions.
// If legacy operations use Status instead of Type, this still works.

private _status = _op getOrDefault ["Status", "DEPLOY"];

switch (_status) do
{
    case "DEPLOY":   { [_op] call IDS_fnc_operationDeploy; };
    case "MARCH":    { [_op] call IDS_fnc_operationMarch; };
    case "ENGAGE":   { [_op] call IDS_fnc_operationEngage; };
    case "RESOLVE":  { [_op] call IDS_fnc_operationResolve; };

    default
    {
        _op set ["Status","COMPLETED"];
    };
};

true

