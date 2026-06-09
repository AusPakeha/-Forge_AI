/*
    File: VCM_fnc_SupMove.sqf
    Author: b0s

    Description:
        Universal "support move" helper for all VCOM reaction scripts.
        - Clears existing waypoints
        - Adds TWO safe MOVE waypoints near target (to satisfy VCOM ">1 WP" checks)
        - Marks group busy with VCM_MOVE2SUP
        - Cleans up on arrival or robust timeout

    Usage:
        [_grp, _targetPos, _radius, _behaviour, _speed, _completeRadius, _debugLabel] call VCM_fnc_SupMove;

    Examples:
        [_grp, _pos, 100] call VCM_fnc_SupMove;                                 // defaults
        [_grp, _investigatePos, 40, "AWARE", "NORMAL", 40, "HEAR"] call VCM_fnc_SupMove;
        [_grp, _rndPos, 70, "AWARE", "FULL", 25, "REINF"] call VCM_fnc_SupMove;
*/

params [
    ["_grp", grpNull, [grpNull]],
    ["_pos", [0,0,0], [[]]],
    ["_radius", 100, [0]],
    ["_behaviour", "AWARE", [""]],
    ["_speed", "NORMAL", [""]],
    ["_completion", 30, [0]],
    ["_debugLabel", "", [""]]
];

if (isNull _grp) exitWith {};

// --- helper: add safe MOVE WP (avoid water / silly terrain)
private _safeAddWP = {
    params ["_grp","_pos","_radius","_beh","_spd","_comp"];

    private _p = +_pos;

    if (surfaceIsWater _p || {getTerrainHeightASL _p < 0.5}) then {
        // try nearest building
        private _blds = nearestObjects [_p, ["House","Building"], 300];
        if (!(_blds isEqualTo [])) then { _p = getPosATL (_blds select 0); } else {
            // fallback: leader position
            _p = getPosATL (leader _grp);
        };
    };

    private _wp = _grp addWaypoint [_p, _radius];
    _wp setWaypointType "MOVE";
    _wp setWaypointBehaviour _beh;
    _wp setWaypointSpeed _spd;
    [_grp, _wp select 1] setWaypointCompletionRadius _comp;
    _wp
};

// --- Clear existing WPs first
while { count (waypoints _grp) > 0 } do { deleteWaypoint ((waypoints _grp) select 0); };

// --- Mark group as busy
_grp setVariable ["VCM_MOVE2SUP", true, true];

// --- Build two-step movement: approach leg + final leg
private _tgt = +_pos;
private _lead = leader _grp;

// approach: nudge ~60–100m offset toward target from leader bearing
private _dir = [_lead, _tgt] call BIS_fnc_dirTo;
private _legDist = 30 + random 30;
private _approach = (getPosATL _lead) getPos [_legDist, _dir + (random 40 - 20)];

// final: small randomization around target
private _final = _tgt getPos [20 + random 30, random 360];

// First WP (approach)
private _wp0 = [_grp, _approach, _radius max 50, _behaviour, _speed, _completion] call _safeAddWP;
// Second WP (final)
private _wp1 = [_grp, _final, _radius, _behaviour, _speed, _completion] call _safeAddWP;

// Ensure the first is current
if (!isNull (_wp0 select 0)) then { _grp setCurrentWaypoint [_grp, (_wp0 select 1)]; };

// --- On-complete cleanup of the LAST waypoint (group arrives)
_wp1 setWaypointStatements [
    "true",
    "
    private _g = group this;
    while {count (waypoints _g) > 0} do { deleteWaypoint ((waypoints _g) select 0); };
    _g setVariable ['VCM_MOVE2SUP', false, true];
    { if (alive _x) then { _x enableAI 'AUTOCOMBAT'; }; } forEach units _g;
    "
];

// --- Robust failsafe monitor
[_grp, _pos, _debugLabel] spawn {
    params ["_g","_goal","_dbg"];    
    private _t0 = time;
    private _startWP = currentWaypoint _g;
    private _lastAdvance = time;

    while { _g getVariable ["VCM_MOVE2SUP", false] } do {
        sleep 5;
        // progress conditions: waypoint index increased OR distance reduced significantly
        private _wpIdx = currentWaypoint _g;
        private _dist = (leader _g) distance2D _goal;
        if (_wpIdx > _startWP || { _dist < 40 }) exitWith {};
        if (time - _t0 > 200) exitWith {};
    };

    // grace period for cleanup if still flagged
    if (_g getVariable ["VCM_MOVE2SUP", false]) then {
        _g setVariable ["VCM_MOVE2SUP", false, true];
        if (missionNamespace getVariable ["VCM_DebugOld", false]) then {
            systemChat format ["[SUPMOVE] Timeout cleared MOVE2SUP for %1 (%2)", groupId _g, _dbg];
        };
    };
};

if (missionNamespace getVariable ["VCM_DebugOld", false]) then {
    systemChat format ["[SUPMOVE] %1 → 2x MOVE near %2 (%3)", groupId _grp, mapGridPosition _pos, _debugLabel];
};
