/*
    File: VCM_fnc_ClstWarn.sqf
    Purpose:
        Reinforcement logic with:
        - Arty/turrets excluded (via VCM_fnc_IsTurretOrArty)
        - Vehicle-aware waypoint logic
        - WP cleanup handled via VCM_fnc_SupMove
        - Candidate filtering, cooldowns, debug output
        - New: VCM_WARNDELAY (default 30s) → if whole group dies before, no reinforcements
*/

params ["_unit","_killer"];

private _unitGroup = group _unit;

// --- Exit conditions ---
if (
    _unitGroup getVariable ["VCM_TOUGHSQUAD",false] ||
    _unitGroup getVariable ["Vcm_Disable",false] ||
    _unitGroup getVariable ["VCM_NOFLANK",false] ||
    _unitGroup getVariable ["VCM_RQSTHELP",false] ||
    isPlayer _unit
) exitWith {};

private _warnDist  = missionNamespace getVariable ["VCM_WARNDIST", 800];
if (_warnDist < 1) exitWith {
    diag_log "[VCOM ClstWarn Reinforcements] Disabled (distance <1)";
    if (VCM_DebugOld) then { systemChat "[VCOM ClstWarn] Disabled (distance <1)"; };
	};

// --- Weighted unit counting helper ---
private _countWeighted = {
    params ["_units"];
    private _total = 0;
    {
        if (alive _x) then {
            private _veh = vehicle _x;
            if (_veh == _x) then {
                _total = _total + 1;
            } else {
                if (driver _veh == _x) then {
                    private _crewCount = count crew _veh;
                    _total = _total + (if (_crewCount > 2) then {10} else {3});
                };
            };
        };
    } forEach _units;
    _total
};

// --- Cooldown flag (prevents repeated calls) ---
_unitGroup setVariable ["VCM_RQSTHELP",true];
_unitGroup spawn {
    sleep 200;
    _this setVariable ["VCM_RQSTHELP",false];
};

// --- Require radio ---
if !("ItemRadio" in (assignedItems _unit)) exitWith {};

// --- Settings from CBA ---
private _rad       = missionNamespace getVariable ["VCM_Reinf_Radius", 300];
private _ratio     = missionNamespace getVariable ["VCM_Reinf_Ratio", 2];
private _maxGrp    = missionNamespace getVariable ["VCM_Reinf_MaxGroups", 2];
private _warnDelay = missionNamespace getVariable ["VCM_WARNDELAY", 30];  // seconds before support can be called

// --- Local ratio check around the killed unit ---
private _pos = getPosATL _unit;

// --- Use global artillery/turret exclusion function ---
private _isTurretOrArty = missionNamespace getVariable ["VCM_fnc_IsTurretOrArty", { false }];

// --- Count nearby friendlies and enemies ---
private _friendlies = allUnits select {
    alive _x &&
    {side _x == side _unitGroup} &&
    {_x distance2D _pos < _rad} &&
    {!([_x] call _isTurretOrArty)}
};
private _enemies = allUnits select {
    alive _x &&
    {side _x != side _unitGroup} &&
    {_x distance2D _pos < _rad}
};

private _friendCount = [_friendlies] call _countWeighted;
private _enemyCount  = [_enemies] call _countWeighted;

// --- Group loss threshold (>80% casualties) ---
private _units = units _unitGroup;
private _aliveUnits = { alive _x } count _units;
private _totalUnits = count _units;
private _lossFraction = 1 - (_aliveUnits / (_totalUnits max 1));
private _lostTooMany = _lossFraction > 0.8;

// --- Existing ratio check ---
private _ratioBad = (_friendCount <= 0 || {_enemyCount / _friendCount < _ratio});

// --- Exit if neither condition met ---
if (!(_lostTooMany || !_ratioBad)) exitWith {
    if (missionNamespace getVariable ["VCM_DebugOld", false]) then {
        systemChat format [
            "[VCOM-ClstWarn] No reinforcement triggered (loss %.0f%%, ratio %.2f)",
            _lossFraction * 100, if (_friendCount > 0) then {_enemyCount / _friendCount} else {-1}
        ];
    };
};

// === Conditions met — start VCM_WARNDELAY timer ===
if (missionNamespace getVariable ["VCM_DebugOld", false]) then {
    systemChat format [
        "[VCOM-ClstWarn] Conditions met — waiting %.0fs (VCM_WARNDELAY) to see if anyone survives...",
        _warnDelay
    ];
};

// --- Spawn delayed check ---
[_unitGroup, _killer, _warnDelay, _warnDist, _maxGrp, _isTurretOrArty] spawn {
    params ["_grp", "_killer", "_delay", "_warnDist", "_maxGrp", "_isTurretOrArty"];

    sleep _delay;

    private _aliveNow = { alive _x } count (units _grp);
    if (_aliveNow <= 0) exitWith {
        if (missionNamespace getVariable ["VCM_DebugOld", false]) then {
            systemChat format [
                "[VCOM-ClstWarn] Entire group %1 eliminated within %.0fs — no reinforcements called.",
                groupId _grp, _delay
            ];
        };
    };

    if (missionNamespace getVariable ["VCM_DebugOld", false]) then {
        systemChat format [
            "[VCOM-ClstWarn] Group %1 survived %.0fs — calling reinforcements.",
            groupId _grp, _delay
        ];
    };

    // --- Reinforcement candidate search ---
    private _targetPos = getPosATL _killer;

    private _candidates = allGroups select {
        side _x == side _grp &&
        {!isPlayer (leader _x)} &&
        {(leader _x) distance2D _targetPos < _warnDist} &&
        {(combatMode _x) != "RED"} &&
        {behaviour leader _x != "COMBAT"} &&
        {count (waypoints _x) < 2} &&
        {!(_x getVariable ["VCM_MOVE2SUP",false])} &&
        {!(_x getVariable ["Vcm_Disable",false])} &&
        {!([leader _x] call _isTurretOrArty)}
    };

    private _sorted = [_candidates, [], { leader _x distance2D _targetPos }, "ASCEND"] call BIS_fnc_sortBy;
    private _chosen = _sorted select [0, _maxGrp];

    {
        private _grpSend = _x;
        private _rndPos = [
            _targetPos#0 + (random 200 - 100),
            _targetPos#1 + (random 200 - 100),
            0
        ];

        // Vehicle-aware group redirection
        private _ldr = leader _grpSend;
        private _veh = vehicle _ldr;
        private _moveGrp = _grpSend;
        if (!(_veh isEqualTo _ldr) && {driver _veh != objNull}) then {
            _moveGrp = group (driver _veh);
        };

        [_moveGrp, _rndPos, 50, "AWARE", "NORMAL", 50, "CLST"] call VCM_fnc_SupMove;

        if (missionNamespace getVariable ["VCM_DebugOld", false]) then {
            systemChat format ["[VCOM-ClstWarn] %1 responding to contact near %2 (%.0fm).",
                groupId _moveGrp, mapGridPosition _targetPos, (leader _moveGrp) distance2D _targetPos];
        };
    } forEach _chosen;
};
