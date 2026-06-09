/*
    IDS Commander AI - Update DEFEND operation (type-specific update)

    chat26.sqf: Operation framework integration.

    v0 placeholder implementation:
    - Preserve existing CAPTURE-based behavior so the system keeps running.
    - Later replace with a real DEFEND lifecycle:
        * maintain minimum garrison inside DefenseRadius
        * succeed after timer
        * fail if location lost
*/

params ["_op"];

if (isNil "_op") exitWith {};

// Temporary: map DEFEND to existing CAPTURE vertical slice.
// Ensure it has the expected phase fields.
if (isNil {_op getOrDefault ["Status", nil]}) then
{
    _op set ["Status","DEPLOY"];
};

// Reuse existing resolve logic and economy feedback.
// If your DEFEND needs a different check, update only this function later.

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

