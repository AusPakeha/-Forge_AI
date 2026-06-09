/*
    File: fn_HearingAids.sqf
    Description:
        Hearing-based awareness & (optional) investigation trigger.

        Design goals:
        - Gradual reveal to enemy leaders
        - One idle group moves to investigate on 2nd threshold
        - Whole squad uses a visible MOVE waypoint (not ForceMove)
        - Keeps AWARE behaviour & disables AUTOCOMBAT while moving
        - Respects suppressor distances and hearing-distance disable
*/

params ["_unit","_weapon","_muzzle","_mode","_ammo","","",""];

// --- Fast exits
if (_weapon in ["Put","Throw"]) exitWith {};
if !(missionNamespace getVariable ["Vcm_ActivateAI", true]) exitWith {};

// --- Group cooldown check early for performance
private _shooterGrp = group _unit;
private _moveCDActive = _shooterGrp getVariable ["VCM_HEAR_MOVE_CD", false];
if (_moveCDActive) exitWith {};

// Disable entirely when hearing distance is off
private _hearDistBase = missionNamespace getVariable ["VCM_HEARINGDISTANCE", 300];
if (_hearDistBase < 1) exitWith {};

// Soft guard to avoid racing other systems this frame
if (missionNamespace getVariable ["VCM_HearingLock", false]) exitWith {};

// --- Silencer check
private _mzl = currentMuzzle _unit;
private _atts = (_unit weaponAccessories _mzl);
private _muzzleDevice = _atts param [0, ""];
private _isSilenced = false;
if (_muzzleDevice != "") then {
    _isSilenced = (getNumber (configFile >> "CfgWeapons" >> _muzzleDevice >> "ItemInfo" >> "soundTypeIndex")) == 1;
};

// Effective hearing distance (silenced vs normal)
private _hearDistSil = missionNamespace getVariable ["VCM_HEARINGDIST_SIL", 120];
private _hearDist = if (_isSilenced) then {_hearDistSil} else {_hearDistBase};

// --- Rate limit per shooter (2 s)
private _timeShot = _unit getVariable ["VCM_FTH", -60];
if ((_timeShot + 2) >= time) exitWith {};
_unit setVariable ["VCM_FTH", time];

// --- Group-scoped counters (per SHOOTER GROUP)
private _gc = _shooterGrp getVariable ["VCM_HEAR_SHOTCOUNT", [0, 0, time, objNull]]; // [countReveal, countTotal, lastTime, lastShooter]
_gc set [0, (_gc select 0) + 1]; // reveal counter
_gc set [1, (_gc select 1) + 1]; // total counter
_gc set [2, time];
_gc set [3, _unit];
_shooterGrp setVariable ["VCM_HEAR_SHOTCOUNT", _gc];

private _countReveal = _gc select 0;
private _countTotal  = _gc select 1;

private _thReveal = _shooterGrp getVariable ["VCM_HEAR_THR_REVEAL", -1];
private _thMove   = _shooterGrp getVariable ["VCM_HEAR_THR_MOVE", -1];
if (_thReveal < 0) then {
    // reveal after 2–3 shots
	_thReveal = 2 + floor (random 3 + random 1);
    _shooterGrp setVariable ["VCM_HEAR_THR_REVEAL", _thReveal];
};
if (_thMove < 0) then {
    // movement after +6–9 total shots
	_thMove   = _thReveal + floor (random 4 + random 1);
    _shooterGrp setVariable ["VCM_HEAR_THR_MOVE", _thMove];
};

// --- Collect all hearing-range enemy leaders
private _enemyUnits = [];
if (!isNil "VCM_fnc_EnemyArray") then {
    _enemyUnits = (_unit call VCM_fnc_EnemyArray) select {
        alive _x && {(_x distance2D _unit) < _hearDist}
    };
} else {
    _enemyUnits = (getPosATL _unit) nearEntities [["Man"], _hearDist * 1.2];
    _enemyUnits = _enemyUnits select { side _x getFriend side _unit < 0.6 && {alive _x} };
};
if (_enemyUnits isEqualTo []) exitWith {};

private _enemyGrps = (_enemyUnits apply { group _x });
_enemyGrps = _enemyGrps arrayIntersect _enemyGrps; // dedupe
private _leadersInRange = _enemyGrps apply { leader _x };
_leadersInRange = _leadersInRange select {
    alive _x && {(vehicle _x) isEqualTo _x} && {_x distance2D _unit < _hearDist}
};
if (_leadersInRange isEqualTo []) exitWith {};

// --- REVEAL threshold: inform all leaders in range
if (_countReveal >= _thReveal) then {
    private _kvAdd = 0.3 + random 0.2;   // ~0.3–0.5
    private _lastShooter = _gc select 3;

    {
        private _ldr = _x;
        private _add = _kvAdd;
        [_ldr, _lastShooter, _add] remoteExec ["VCM_fnc_HearingReveal", 2];
    } forEach _leadersInRange;

    // reset only the reveal counter
    _gc set [0, 0];
    _shooterGrp setVariable ["VCM_HEAR_SHOTCOUNT", _gc];

    missionNamespace setVariable ["VCM_HearingLock", true];
    [] spawn { uiSleep 0.05; missionNamespace setVariable ["VCM_HearingLock", false]; };
};

// --- MOVEMENT threshold: pick ONE idle group, move via SupMove
if (missionNamespace getVariable ["VCM_DebugOld", false]) then {
    systemChat format ["[VCOM-Hearing] PreMoveCheck total=%1 thMove=%2", _countTotal, _thMove];
};
if (_countTotal >= _thMove) then {

    private _side = side _unit;
    private _sideKey = format ["VCM_HEAR_ACTIVE_%1", _side];
    private _active = missionNamespace getVariable [_sideKey, []];
    _active = _active select { !isNull _x && { alive leader _x } && { _x getVariable ["VCM_MOVE2SUP", false] } };
    missionNamespace setVariable [_sideKey, _active];

    private _maxReact = missionNamespace getVariable ["VCM_HEAR_MAX_MOVERS_PER_SIDE", 2];
    if ((count _active) < _maxReact) then {

        private _idleLeaders = _leadersInRange select {
            private _g = group _x;
            (count (waypoints _g) < 2) &&
            {!(_g getVariable ["Vcm_Disable", false])} &&
            {!(_g getVariable ["VCM_NOFLANK", false])} &&
            {!(_g getVariable ["VCM_MOVE2SUP", false])}
        };
        if (missionNamespace getVariable ["VCM_DebugOld", false]) then {
            systemChat format [
                "[VCOM-Hearing] TriggerCheck total:%1 thMove:%2 active:%3 idleLeaders:%4",
                _countTotal, _thMove, count _active, count _leadersInRange
            ];
        };
        if !(_idleLeaders isEqualTo []) then {
            private _lastShooter = _gc select 3;

            private _sorted = [_idleLeaders, [], { _x distance2D _lastShooter }, "ASCEND"] call BIS_fnc_sortBy;
            private _hearleader = _sorted select 0;
            private _grp = group _hearleader;

            _grp setVariable ["VCM_MOVE2SUP", true, true];

            // --- timeout to auto-clear if waypoint never completes
            //[_grp] spawn {
            //    params ["_g"];
            //    sleep 200;
            //    _g setVariable ["VCM_MOVE2SUP", false, true];
            //};

            missionNamespace setVariable [_sideKey, (missionNamespace getVariable [_sideKey, []]) + [_grp]];

            {
                _x disableAI "AUTOCOMBAT";
                _x setBehaviour "AWARE";
                _x setUnitPos "AUTO";
            } forEach units _grp;

            // Stop existing VCOM FSMs to avoid interference
            private _FSMID = _grp getVariable ["VCOM_FSMH", nil];
            if (!isNil "_FSMID" && { typeName _FSMID == "SCRIPT" } && { !isNull _FSMID }) then {
                terminate _FSMID;
                _grp setVariable ["VCOM_FSMH", nil];
            };

            private _tgtPos = getPosATL _lastShooter;
            private _investigatePos = _tgtPos getPos [30 + random 30, random 360];

            // === use VCM_fnc_SupMove instead of manual WP creation ===
            [_grp, _investigatePos, 40, "AWARE", "NORMAL", 40, "HEAR"] call VCM_fnc_SupMove;

            _shooterGrp setVariable ["VCM_HEAR_MOVE_CD", true];
            [_shooterGrp] spawn { params ['_g']; sleep 120; _g setVariable ['VCM_HEAR_MOVE_CD', false]; };

            // reset total counter after movement
            _gc set [1, 0];
            _shooterGrp setVariable ["VCM_HEAR_SHOTCOUNT", _gc];

            missionNamespace setVariable ["VCM_HearingLock", true];
            [] spawn { uiSleep 0.05; missionNamespace setVariable ["VCM_HearingLock", false]; };

            if (missionNamespace getVariable ["VCM_DebugOld", false]) then {
                systemChat format ["[VCOM-Hearing] %1 investigating shots (%.0fm).",
                    groupId _grp, (leader _grp) distance2D _tgtPos];
            };
        };
    };
};
