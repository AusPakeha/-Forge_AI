/*
    File: VCM_fnc_ExplosionHearing.sqf
    Description:
        - Uses ProjectileCreated → Explode chain (global, safe)
        - Small explosions: only investigation
        - Big explosions: suppression (1/3 range) + investigation
        - One idle group moves to investigate each explosion (shared VCM_MOVE2SUP)
        - 60 s global cooldown for investigation
*/

if (!isServer) exitWith {};

if (!isNil "VCM_ExplosionProjEH") exitWith { diag_log "[VCOM EXPLOSION] Already active."; };

private _hearDist = missionNamespace getVariable ["VCM_HEARINGDISTANCE_EXP", 400];
if (_hearDist < 1) exitWith {
    diag_log "[VCOM EXPLOSION] Disabled (distance <1)";
    if (VCM_DebugOld) then { systemChat "[VCOM EXPLOSION] Disabled (distance <1)"; };
};

private _reactChance = missionNamespace getVariable ["VCM_EXP_REACT_CHANCE", 0.2];
if (_reactChance < 0.01) then {
    diag_log "[VCOM EXPLOSION] Investigation reactions disabled (VCM_EXP_REACT_CHANCE < 1)";
    if (VCM_DebugOld) then { systemChat "[VCOM EXPLOSION] Investigation reactions disabled."; };
};

private _suppressionRange = _hearDist * 0.25;
private _cooldown = 60;
missionNamespace setVariable ["VCM_EXP_COOLDOWN_TS", -1];

// === GLOBAL PROJECTILE HANDLER ===
VCM_ExplosionProjEH = addMissionEventHandler ["ProjectileCreated", {
    params ["_proj"];
    if (isNull _proj) exitWith {};
	
	// --- EARLY global cooldown (skip even creating EHs)
    private _lastExpTs = missionNamespace getVariable ["VCM_EXP_LAST_TS", -1];
    if (_lastExpTs >= 0 && {time - _lastExpTs < 3}) exitWith {};  // stop here early
    missionNamespace setVariable ["VCM_EXP_LAST_TS", time];

    private _ammo = typeOf _proj;
    if (_ammo == "") exitWith {};

    private _cfg = configFile >> "CfgAmmo" >> _ammo;
    private _expl = getNumber (_cfg >> "explosive");
    private _ihr  = getNumber (_cfg >> "indirectHitRange");
    private _sim  = toLower getText (_cfg >> "simulation");

    // Filter: only projectiles that can explode
    if ((_expl <= 0 && _ihr <= 0) && {_sim != "shotgrenade"}) exitWith {};

    // Attach one-time explode listener
    _proj addEventHandler ["Explode", {
        params ["_proj", "_posASL"];
        if (isNull _proj) exitWith {};

        private _ammo = typeOf _proj;
        private _cfg  = configFile >> "CfgAmmo" >> _ammo;
        private _pos  = ASLToATL _posASL;

        private _expl = getNumber (_cfg >> "explosive");
        private _ihr  = getNumber (_cfg >> "indirectHitRange");
        private _hit  = getNumber (_cfg >> "hit");
        private _isBig = (_expl > 0.6) || (_ihr > 6) || (_hit > 80);

        private _hearDist = missionNamespace getVariable ["VCM_HEARINGDISTANCE_EXP", 400];
        private _suppressionRange = _hearDist * 0.25;
        private _cooldown = 60;

        if (VCM_DebugOld) then {
            systemChat format ["[VCOM EXP] %1 exploded (expl=%.2f, ihr=%.1f, hit=%.1f)", _ammo, _expl, _ihr, _hit];
        };

        // === 1) SUPPRESSION (only big explosions) ===
        if (_isBig) then {
            private _groupsToSuppress = [];
            {
                private _ldr = leader _x;
                if (!isPlayer _ldr && {_ldr distance2D _pos < _suppressionRange}) then {
                    _groupsToSuppress pushBack _x;
                };
            } forEach allGroups;
        
            {
                {
                    if (local _x) then {
                        private _dist = _x distance2D _pos;
                        _x setSuppression 1;
                        _x suppressFor (1 + random 1);
                        _x doWatch _pos;
                        _x setUnitPos (selectRandom ["MIDDLE", "DOWN"]);
                        _x setBehaviour "COMBAT";
                        [_x] spawn {
                            params ["_u"];
                            sleep (2 + random 2);
                            _u setUnitPos "AUTO";
                            _u setBehaviour "AWARE";
                        };
                        if (VCM_DebugOld) then {
                            systemChat format ["[VCOM EXP] %1 suppressed (%.0fm)", _x, _dist];
                        };
                    };
                } forEach units _x;
            } forEach _groupsToSuppress;
        };


        // === 2) INVESTIGATION (only if enabled and passed random + cooldown) ===

        private _reactChance = missionNamespace getVariable ["VCM_EXP_REACT_CHANCE", 1];
        if (_reactChance < 0.01) exitWith {
            if (VCM_DebugOld) then { systemChat "[VCOM EXP] Investigation logic disabled (VCM_EXP_REACT_CHANCE < 0.01)"; };
        };

        private _rnd = random 1;
        if (_rnd > _reactChance) exitWith {
            if (VCM_DebugOld) then {
                systemChat format ["[VCOM EXP] No investigation (random %.2f > chance %.2f)", _rnd, _reactChance];
            };
        };

        // --- Global cooldown
        private _lastTs = missionNamespace getVariable ["VCM_EXP_COOLDOWN_TS", -1];
        if (_lastTs >= 0 && {time - _lastTs < _cooldown}) exitWith {
            if (VCM_DebugOld) then {
                systemChat format ["[VCOM EXP] Skipping investigation (cooldown %.0fs left)", _cooldown - (time - _lastTs)];
            };
        };

        private _candidateSides = missionNamespace getVariable ["VCM_SIDEENABLED", [west, east, resistance]];
        private _eligible = [];

        {
            private _side = _x;
            private _groups = allGroups select {
                private _ldr = leader _x;
                side _ldr == _side &&
                {!isPlayer _ldr} &&
                {alive _ldr} &&
                {(_ldr distance2D _pos) < _hearDist} &&
                {count (waypoints _x) < 2} &&
                {({alive _x} count units _x) >= 3} &&
                {!(_x getVariable ["VCM_MOVE2SUP", false])}
            };
            if !(_groups isEqualTo []) then { _eligible append _groups; };
        } forEach _candidateSides;

        if (_eligible isEqualTo []) exitWith {
            if (VCM_DebugOld) then { systemChat "[VCOM EXP] No idle groups available to investigate."; };
        };

        private _sorted = [_eligible, [], { leader _x distance2D _pos }, "ASCEND"] call BIS_fnc_sortBy;
        private _grp = _sorted select 0;
        private _ldr = leader _grp;
        private _movePos = _pos getPos [40 + random 30, random 360];

        [_grp, _movePos, 60, "AWARE", "NORMAL", 20, "EXP"] call VCM_fnc_SupMove;

        missionNamespace setVariable ["VCM_EXP_COOLDOWN_TS", time];
        if (VCM_DebugOld) then {
            systemChat format ["[VCOM EXP] %1 (%2) sent to investigate explosion (%.0fm away).",
                _ldr, side _ldr, _ldr distance2D _pos];
        };
    }];
}];

diag_log "[VCOM EXPLOSION] Explosion hearing system initialized.";
if (VCM_DebugOld) then { systemChat "[VCOM EXPLOSION] Explosion hearing system initialized."; };
