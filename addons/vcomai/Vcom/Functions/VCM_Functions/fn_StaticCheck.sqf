/*
    File: fn_StaticCheck.sqf
    Author: Genesis, restructured + CBA toggle version by [you]

    Description:
        Checks units with statics/UAV backpacks and deploys them if needed.
        Returns a filtered list: only units still carrying deployable statics/UAVs.

    Notes:
        - Respects CBA toggles:
            Vcm_EnableStaticDeploy (default true)
            Vcm_EnableUAVDeploy    (default true)
*/

params [["_StaticList", [], [[]]]];

private _ResultList = [];

private _enableStatic = missionNamespace getVariable ["Vcm_EnableStaticDeploy", true];
private _enableUAV    = missionNamespace getVariable ["Vcm_EnableUAVDeploy", true];

{
    private _unit = objNull;
    private _backpack = "";
    private _hasUAV = false;

    // --- Normalize input and detect UAV backpack safely ---
if (_x isEqualType []) then {
    _unit     = _x param [0, objNull];
    _backpack = _x param [1, ""];
    _hasUAV   = _x param [2, false];
}
else {
    // handle if _x is a unit object or something else
    if (_x isKindOf "Man") then {
        _unit = _x;
        private _bpObj = unitBackpack _unit;
        _backpack = if (isNull _bpObj) then { backpack _unit } else { typeOf _bpObj };
        _hasUAV = (_backpack isKindOf "UAV_01_backpack_base_F");
    } else {
        // not a unit, fallback
        _unit = objNull;
        _backpack = "";
        _hasUAV = false;
    };
};

    if (isNull _unit) exitWith {}; // skip invalid

    // skip if in vehicle
    if !(isNull objectParent _unit) exitWith {
        _ResultList pushBack _x;
    };

    // --- Early exits if feature type disabled ---
    if (_hasUAV && {!_enableUAV}) exitWith { _ResultList pushBack _x; };
    if (!_hasUAV && {!_enableStatic}) exitWith { _ResultList pushBack _x; };

    // --- Proceed only for allowed cases ---
    private _currentBackpack = backpack _unit;
    private _assembleTo = getText (configFile >> "CfgVehicles" >> _currentBackpack >> "assembleInfo" >> "assembleTo");
    if (_assembleTo isEqualTo "") exitWith { _ResultList pushBack _x; };

    // skip if indoors
    private _pos = getPosATL _unit;
    private _objsAbove = lineIntersectsObjs [_pos, [_pos select 0, _pos select 1, (_pos select 2) + 10], objNull, objNull, true, 4];
    if (_objsAbove findIf { _x isKindOf "Building" } >= 0) exitWith { _ResultList pushBack _x; };

    // find enemy once (cheap fallback to ClstEmy)
    private _leader = leader (group _unit);
    private _enemy = _leader findNearestEnemy _leader;
    if (isNull _enemy) then { _enemy = _leader call VCM_fnc_ClstEmy; };

    if (!_hasUAV) then {
        // === STATIC DEPLOY ===
        private _static = _assembleTo createVehicle [0,0,100];

        [_unit, _static, _enemy] spawn {
            params ["_unit","_static","_enemy"];
            private _pos = _unit modelToWorld [0,1,0.35];

            _static allowDamage false;
            _static setVelocity [0,0,0];
            _static setPosATL _pos;
            _static allowDamage true;

            sleep (random 2);
            [_unit,"AinvPknlMstpSnonWnonDnon_Putdown_AmovPknlMstpSnonWnonDnon"] remoteExec ["Vcm_PMN",0];
            sleep 3.5;

            _unit assignAsGunner _static;
            [_unit] orderGetIn true;
            _unit moveInGunner _static;
            removeBackpackGlobal _unit;

            private _dir = _static getDir _enemy;
            _static setDir _dir;
            (vehicle _unit) setDir _dir;
        };

        [_unit, _currentBackpack, _static] spawn VCM_fnc_PackStatic;

    } else {
        // === UAV DEPLOY ===
        [_unit, _enemy, _assembleTo] spawn {
            params ["_unit","_enemy","_assembleTo"];

            sleep (random 2);
            [_unit,"AinvPknlMstpSnonWnonDnon_Putdown_AmovPknlMstpSnonWnonDnon"] remoteExec ["Vcm_PMN",0];
            removeBackpackGlobal _unit;
            sleep 3.5;

            private _uav = _assembleTo createVehicle [0,0,50];
            _uav engineOn true;
            _uav allowDamage false;
            _uav setVelocity [0,0,0];
            _uav setPosATL (_unit modelToWorld [0,1,0.25]);

            createVehicleCrew _uav;
            { [_x] joinSilent (group _unit); } forEach (crew _uav);

            _uav spawn { sleep 30; _this allowDamage true; };
            _uav doMove (getPosATL _enemy);
        };
    };

    // if deployed successfully -> do NOT pushBack (removes from list)
} forEach _StaticList;

_ResultList
