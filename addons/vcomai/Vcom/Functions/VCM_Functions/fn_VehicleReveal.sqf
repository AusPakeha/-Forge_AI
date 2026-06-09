/*
    File: fn_VehicleReveal.sqf
    Author: VCOM Extended
    Purpose:
        Simplified vehicle-based infantry detection helper.
        Run on team leaders inside armed vehicles every ~VCM_VEHREV_TIME seconds.
*/

params ["_leader"];
if (!isServer) exitWith {};
if (isNull _leader || {!alive _leader}) exitWith {};

private _veh = vehicle _leader;
if (_veh == _leader || {!alive _veh}) exitWith {};
if (!canMove _veh) exitWith {};
if (!isEngineOn _veh) exitWith {};        // require running engine
if (VCM_VEHREV_DIST < 1) exitWith {};
if (VCM_VEHREV_CHANCE < 1) exitWith {};

private _dbg = missionNamespace getVariable ["VCM_DebugOld", false];
private _vehType = typeOf _veh;
private _grp = group _leader;
if (_dbg) then { systemChat format ["[VEHREV] %1 running on %2 (%3)", name _leader, _vehType, groupId _grp]; };

// --- Supported vehicle classes
private _vehCfg = configFile >> "CfgVehicles" >> _vehType;
private _sim = toLower getText (_vehCfg >> "simulation");
if !(_sim in ["carx","tankx","helicopterx","helicopterrtd","airplanex"]) exitWith {
    if (_dbg) then { systemChat format ["[VEHREV] %1 - Unsupported sim %2", _vehType, _sim]; };
};

// --- Armed check
private _isArmed = false;
{
    private _weps = getArray (_x >> "weapons");
    if !(_weps isEqualTo []) exitWith {_isArmed = true};
} forEach (configProperties [_vehCfg >> "Turrets", "isClass _x", true]);

if (!_isArmed) then {
    private _vehWeps = weapons _veh;
    if !(_vehWeps isEqualTo []) then {_isArmed = true;};
};
if (!_isArmed) exitWith {
    if (_dbg) then { systemChat format ["[VEHREV] %1 - Unarmed vehicle, skip", _vehType]; };
};

// --- Simplified fixed score table
private _crew = count crew _veh;
private _vehScore = 0.4; // fallback

switch (_sim) do {
    case "tankx": {
        if (_crew >= 3) then {_vehScore = 0.6} else {_vehScore = 0.5};
    };
    case "carx": {
        if (_crew >= 3) then {_vehScore = 0.6} else {_vehScore = 0.5};
    };
    case "helicopterx":   { _vehScore = 0.6 };
    case "helicopterrtd": { _vehScore = 0.5 };
    case "airplanex":     { _vehScore = 0.5 };
};

if (_dbg) then {
    systemChat format [
        "[VEHREV] %1 | score=%2 | crew=%3 | sim=%4",
        _vehType, _vehScore, _crew, _sim
    ];
};


// --- Reveal chance (slightly boosted multiplier for more frequent reveals)
private _baseChance = (VCM_VEHREV_CHANCE / 100);
private _finalChance = (_vehScore * _baseChance * 1.2) min 0.99;
if (random 1 > _finalChance) exitWith {
    if (_dbg) then { systemChat format ["[VEHREV] %1 - Random roll failed (chance %2)", _vehType, _finalChance]; };
};

// --- Distance scaling for air vehicles
private _distLimit = switch (_sim) do {
    case "helicopterx";
    case "helicopterrtd": { VCM_VEHREV_DIST * 3 };
    case "airplanex":     { VCM_VEHREV_DIST * 3 };
    default               { VCM_VEHREV_DIST };
};

// --- Collect potential enemies
private _enemies = (_veh nearEntities ["Man", _distLimit]) select {
    side _x getFriend side _leader < 0.6 && {leader _x == _x && alive _x}
};

if (_enemies isEqualTo []) exitWith {
    if (_dbg) then { systemChat format ["[VEHREV] %1 - No enemies in range (%.0fm)", _vehType, _distLimit]; };
};

private _targets = [_enemies, [], {_veh distance2D _x}, "ASCEND"] call BIS_fnc_sortBy;
if (_dbg) then { systemChat format ["[VEHREV] %1 - Found %2 enemy leaders", _vehType, count _targets]; };

// --- Select reveal targets
private _toReveal = [];

switch (true) do {
    case (_sim in ["helicopterx","helicopterrtd","airplanex"]): {
        // Air vehicles: one nearest vehicle leader, then one nearest infantry leader
        private _vehLeaders = _targets select { vehicle _x != _x }; // (placeholder, all infantry in most cases)
        private _vehTarget = objNull;
        if !(_vehLeaders isEqualTo []) then { _vehTarget = _vehLeaders select 0; };
        private _infTarget = if (count _targets > 0) then {_targets select 0} else {objNull};

        if (!isNull _vehTarget) then { _toReveal pushBack _vehTarget; };
        if (!isNull _infTarget && {_infTarget != _vehTarget}) then { _toReveal pushBack _infTarget; };
    };
    default {
        // Ground: two nearest leaders
        _toReveal = _targets select [0, 2 min (count _targets)];
    };
};

if (_dbg) then { systemChat format ["[VEHREV] %1 - Revealing %2 targets", _vehType, count _toReveal]; };

// --- Reveal with LOS (2 m forward, 3.5 m height)
{
    private _target = _x;
    private _vehPos = getPosASL _veh;
    private _dir = getDir _veh;
    private _startPos = _vehPos vectorAdd [(sin _dir) * 3, (cos _dir) * 3, 3.5];
    private _endPos   = eyePos _target;

    private _los = lineIntersectsSurfaces [
        _startPos, _endPos,
        objNull, _target,
        true, 1, "VIEW", "FIRE"
    ];

    if (_los isEqualTo []) then {
        private _kv = _leader knowsAbout _target;
        private _add = 0.8 + random 0.7; // slightly stronger reveal
        private _newKv = (_kv + _add) min 2.5;
        _leader reveal [_target, _newKv];
        if (_dbg) then { systemChat format ["[VEHREV] %1 revealed %2 (Kv %1)", _vehType, name _target, _newKv]; };
    } else {
        if (_dbg) then { systemChat format ["[VEHREV] %1 skipped %2 (LOS blocked)", _vehType, name _target]; };
    };
} forEach _toReveal;
