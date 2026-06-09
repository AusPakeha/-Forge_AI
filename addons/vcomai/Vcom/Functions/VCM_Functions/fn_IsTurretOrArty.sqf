/*
    File: VCM_fnc_IsTurretOrArty.sqf
    Description:
        Determines if a given unit/vehicle is a turret or artillery piece.
        Uses missionNamespace caches for performance.
*/

params ["_unit"];
if (isNull _unit) exitWith {false};

// --- Init caches once ---
if (isNil {missionNamespace getVariable "VCM_CACHE_ARTY"}) then {
    missionNamespace setVariable ["VCM_CACHE_ARTY", createHashMap];
};
if (isNil {missionNamespace getVariable "VCM_CACHE_TURRET"}) then {
    missionNamespace setVariable ["VCM_CACHE_TURRET", createHashMap];
};

private _artyCache   = missionNamespace getVariable "VCM_CACHE_ARTY";
private _turretCache = missionNamespace getVariable "VCM_CACHE_TURRET";

// --- Local helper for artillery detection ---
private _isArty = {
    params ["_veh"];
    if (isNull _veh) exitWith {false};

    private _type = typeOf _veh;
    if (_type == "") exitWith {false};

    private _cached = _artyCache getOrDefault [_type, -1];
    if !(_cached isEqualTo -1) exitWith { _cached };

    private _cfg = configOf _veh;
    private _isArt = false;

    if (!(_veh isKindOf "Man")) then {
        if (_veh isKindOf "Artillery_Base_F") then {
            _isArt = true;
        } else {
            if (getNumber (_cfg >> "artilleryScanner") == 1) then {
                _isArt = true;
            } else {
                {
                    if (getNumber (configFile >> "CfgMagazines" >> _x >> "artilleryCharge") > 0) exitWith { _isArt = true };
                } forEach getArray (_cfg >> "magazines");
            };
        };
    };

    _artyCache set [_type, _isArt];
    _isArt
};

// --- Main turret/artillery detection ---
private _veh  = vehicle _unit;
private _type = typeOf _veh;
if (_type == "") exitWith {false};

private _cached = _turretCache getOrDefault [_type, -1];
if !(_cached isEqualTo -1) exitWith { _cached };

private _isTur = false;

if (_veh isKindOf "StaticWeapon") then {
    _isTur = true;
} else {
    if ([_veh] call _isArty) then { _isTur = true; };
};

_turretCache set [_type, _isTur];
_isTur
