/*
    IDS Commander AI - Operation Engage

    Lightweight combat check.
    Does not simulate combat; only decides when to resolve ownership.
*/

params ["_op"];

private _grp = _op getOrDefault ["Group", grpNull];
private _targetPos = _op getOrDefault ["TargetPos", []];
private _radius = _op getOrDefault ["Radius",200];

if (isNull _grp) exitWith {};
if (_targetPos isEqualTo []) exitWith {};

private _friendlyCount = { alive _x } count (units _grp);

private _enemyUnits = _targetPos nearEntities ["Man", _radius max 150];
private _enemyCount = { alive _x && { side _x == west } } count _enemyUnits;

if (_friendlyCount == 0) exitWith { _op set ["Status","RESOLVE"]; true };
if (_enemyCount == 0)  exitWith { _op set ["Status","RESOLVE"]; true };

if (_grp distance2D _targetPos < 120) then
{
    _op set ["Status","RESOLVE"];
};

true

