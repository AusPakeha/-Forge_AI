/*
    IDS Commander AI - Operation March

    Moves the spawned group to TargetPos.
*/

params ["_op"];

private _grp = _op getOrDefault ["Group", grpNull];
private _targetPos = _op getOrDefault ["TargetPos", []];

if (isNull _grp) exitWith {};
if (_targetPos isEqualTo []) exitWith {};

_grp setBehaviour "AWARE";
_grp setSpeedMode "FULL";

// Clear existing waypoints by re-adding a single MOVE waypoint.
private _wp = _grp addWaypoint [_targetPos, 0];
_wp setWaypointType "MOVE";
_wp setWaypointCompletionRadius 50;

_op set ["Status", "ENGAGE"];

true

