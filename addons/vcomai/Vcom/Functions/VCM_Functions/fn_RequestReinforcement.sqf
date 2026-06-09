/*
    File: VCM_fnc_RequestReinforcement.sqf
    Purpose: Player-requested reinforcement (1 nearest eligible group)
*/

params ["_caller"]; // should be the player object

// --- Sanity & prerequisites
if (isNull _caller) exitWith { diag_log "[VCM-REINF] EXIT: caller was null"; };

if ((_caller getVariable ["VCM_REINF_COOLDOWN", false]) == true) exitWith {
    systemChat "[VCOM] Reinforcement request is on cooldown.";
};

if !("ItemRadio" in (assignedItems _caller)) exitWith {
    systemChat "[VCOM] You need a radio to call reinforcements.";
};

// --- Cooldown per player
_caller setVariable ["VCM_REINF_COOLDOWN", true];
_caller spawn {
    sleep 180;
    _this setVariable ["VCM_REINF_COOLDOWN", false];
};

// --- Helper definitions
private _isArty = {
    params ["_veh"];
    if (_veh isKindOf "Man") exitWith {false};
    if (_veh isKindOf "Artillery_Base_F") exitWith {true};
    if (getNumber (configOf _veh >> "artilleryScanner") == 1) exitWith {true};
    {
        if (getNumber (configFile >> "CfgMagazines" >> _x >> "artilleryCharge") > 0) exitWith {true};
    } forEach getArray (configOf _veh >> "magazines");
    false
};
private _isTurretOrArty = {
    params ["_unit"];
    private _veh = vehicle _unit;
    if (_veh isKindOf "StaticWeapon") exitWith {true};
    if ([_veh] call _isArty) exitWith {true};
    false
};
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
                    if (_crewCount > 2) then { _total = _total + 10; }
                    else { _total = _total + 3; };
                };
            };
        };
    } forEach _units;
    _total
};

// --- Settings
private _rad = missionNamespace getVariable ["VCM_WARNDIST", 1000];
private _minWeighted = 2;
private _callerPos = getPosATL _caller;

// --- Find candidate groups
private _candidates = allGroups select {
    private _ldr = leader _x;
    private _ldrPos = getPosATL _ldr;
    private _dist = _callerPos distance2D _ldrPos;

    side _x == side group _caller &&
    {!isPlayer _ldr} &&
    {count (waypoints _x) < 2} &&
    {!(_x getVariable ["VCM_MOVE2SUP",false])} &&
    {!(_x getVariable ["Vcm_Disable",false])} &&
    {!([_ldr] call _isTurretOrArty)} &&
    {([units _x] call _countWeighted) >= _minWeighted} &&
    {_dist < _rad} &&
    {_dist > 150}
};

if (_candidates isEqualTo []) exitWith {
    ["[VCOM] Request denied. No reinforcement groups available."] remoteExec ["systemChat", _caller];
};

// --- Choose nearest eligible group
private _sorted = [_candidates, [], { leader _x distance2D _callerPos }, "ASCEND"] call BIS_fnc_sortBy;
private _chosen = _sorted select 0;
private _ldr = leader _chosen;

// --- Announce and mark busy
["[VCOM] Reinforcement responding: " + name _ldr] remoteExec ["systemChat", _caller];
_chosen setVariable ["VCM_MOVE2SUP", true, true];

// --- Failsafe timeout (180s)
//[_chosen] spawn {
//    params ["_g"];
//    sleep 200;
//    if (_g getVariable ["VCM_MOVE2SUP", false]) then {
//        _g setVariable ["VCM_MOVE2SUP", false, true];
//        if (missionNamespace getVariable ["VCM_DEBUG", false]) then {
//            systemChat format ["[VCOM-Reinf] Timeout cleared MOVE2SUP for %1", groupId _g];
//        };
//    };
//};

// --- Random landing / arrival position near player
private _rndPos = [
    (_callerPos select 0) + (random 120 - 60),
    (_callerPos select 1) + (random 120 - 60),
    0
];

// === Universal movement (via SupMove) ===
[_chosen, _rndPos, 50, "AWARE", "FULL", 25, "REINF"] call VCM_fnc_SupMove;


// --- Arrival feedback
if (missionNamespace getVariable ["VCM_DebugOld", false]) then {
    systemChat format ["[VCOM-Reinf] %1 moving to assist %2 (%.0fm).",
        groupId _chosen, name _caller, (leader _chosen) distance2D _caller];
};
