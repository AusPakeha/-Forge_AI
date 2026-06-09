/*
    IDS Commander AI - Update PATROL operation (type-specific update)

    chat26.sqf integration:
    - PATROL should increase observation coverage and avoid capture.

    v0 placeholder implementation:
    - If Patrol is fully implemented later, replace this with:
        * waypoint management
        * sensor/intel emission
        * success/failure conditions

    For now, keep the system stable by mapping PATROL to the existing
    CAPTURE RESOLVE behavior only as a temporary fallback.
*/

params ["_op"];

if (isNil "_op") exitWith {};

// Temporary fallback: reuse CAPTURE resolve/check so operations finish.
// Later: implement patrol-specific lifecycle.

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

