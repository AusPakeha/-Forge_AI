/*
    IDS Commander AI - Update RECON operation (type-specific update)

    chat26.sqf integration:
    - RECON success is: intel generated
    - Failure is typically timeouts or recon force loss

    v0 placeholder implementation:
    - Currently keeps the system running by reusing the legacy
      DEPLOY/MARCH/ENGAGE/RESOLVE phase flow.
    - Later: implement recon-specific lifecycle:
        * recon movement/area coverage
        * intel generation hooks via sensor system
        * delayed reporting / timeouts
*/

params ["_op"];

if (isNil "_op") exitWith {};

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

