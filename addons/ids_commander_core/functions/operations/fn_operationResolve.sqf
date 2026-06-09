/*
    IDS Commander AI - Operation Resolve

    Resolves territorial ownership using simplified force balance.
*/

params ["_op"];

private _grp = _op getOrDefault ["Group", grpNull];
private _targetPos = _op getOrDefault ["TargetPos", []];
private _radius = _op getOrDefault ["Radius",200];

if (_targetPos isEqualTo []) exitWith {};

private _enemyUnits = _targetPos nearEntities ["Man", _radius];

private _friendly = { alive _x } count (units _grp);
private _enemy = { alive _x && { side _x == west } } count _enemyUnits;

// Find closest location by position (authoritative world DB).
private _location = [_targetPos] call IDS_fnc_getLocationByPosition;
if (isNil "_location") exitWith { _op set ["Status","COMPLETED"]; true };

// Refresh frontline markers after ownership change decisions.
// (cheap in v0.1; can be interval-based later)
[] call IDS_fnc_updateFrontlines;
[] call IDS_fnc_updateFrontlineRegions;


if (_friendly > _enemy) then
{
    [_location get "ID", "FAC_OPFOR"] call IDS_fnc_captureLocation;
}
else
{
    [_location get "ID", "FAC_BLUFOR"] call IDS_fnc_captureLocation;
};

_op set ["Status","COMPLETED"];

// Feed losses back into economy.
[_op] call IDS_fnc_applyCasualties;

true



