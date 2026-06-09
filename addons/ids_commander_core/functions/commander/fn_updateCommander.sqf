/*
    IDS Commander AI - Commander Strategic Tick (Version 0.1)

    Responsibilities (Version 0.1 placeholder):
    - Evaluate threats
    - Analyze economy/territory
    - Select objective
    - Create operations (future versions)
*/

params ["_commander"];

if !(call IDS_fnc_isAuthority) exitWith {true};

// Placeholder: update threat level to 0; real threat evaluation arrives in later versions.
private _tl = 0;
_commander set ["ThreatLevel", _tl];

// Doctrine registry + data backfill (safe to repeat)
call IDS_fnc_initDoctrineRegistry;

// ----------------------------
// Strategic Planning & Campaign Goals (chat30)
// ----------------------------
// Goal selection must not run every tick; current integration runs once per commander update call.
// This is a repo placeholder until explicit strategic tick scheduling exists.

private _strategicTickLast = _commander getOrDefault ["StrategicTickLast", -1];
private _strategicTickPeriod = _commander getOrDefault ["StrategicTickPeriod", 900]; // 15 minutes

if ((serverTime - _strategicTickLast) >= _strategicTickPeriod) then {
    _commander set ["StrategicTickLast", serverTime];

    // Anti-oscillation / long-term memory
    private _previousGoals = _commander getOrDefault ["PreviousGoals", []];

    // Inputs (best-effort from existing state)
    private _enemyStrength  = _commander getOrDefault ["EnemyStrength", 0];

    // Candidate goal pool (start small)
    private _goalCandidates = [
        createHashMapFromArray [["ID","GOAL_CAPTURE_REGION"],["Type","CAPTURE_REGION"],["Target","REGION_WEST"],["Priority",100]],
        createHashMapFromArray [["ID","GOAL_SECURE_FRONTLINE"],["Type","SECURE_FRONTLINE"],["Priority",80]],
        createHashMapFromArray [["ID","GOAL_CAPTURE_RESOURCES"],["Type","CAPTURE_RESOURCES"],["Priority",75]],
        createHashMapFromArray [["ID","GOAL_WEAKEN_ENEMY"],["Type","WEAKEN_ENEMY"],["Priority",70]]
    ];

    // Simple scoring framework (placeholder):
    // GoalScore = Priority + DoctrineBonus - EnemyPressureCost + Risk
    private _scoreGoal = {
        params ["_goal","_personality","_enemyStrength"];
        private _gType = _goal getOrDefault ["Type","CAPTURE_REGION"];

        // Doctrine bonuses based on personality
        private _bonus = 0;
        switch (_personality) do {
            case "AGGRESSIVE": { if (_gType == "CAPTURE_REGION") then {_bonus = 200}; if (_gType == "WEAKEN_ENEMY") then {_bonus = 40}; };
            case "DEFENSIVE" : { if (_gType == "SECURE_FRONTLINE") then {_bonus = 200}; };
            case "PMC"        : { if (_gType == "CAPTURE_RESOURCES") then {_bonus = 200}; };
            case "SUPPORT"   : { if (_gType == "WEAKEN_ENEMY") then {_bonus = 140}; };
            case "GUERILLA"  : { if (_gType == "WEAKEN_ENEMY") then {_bonus = 160}; };
            default { _bonus = 0; };
        };

        // Cost/risk approximations
        private _risk = 0;
        private _cost = _enemyStrength * 0.1;

        if (_gType == "SECURE_FRONTLINE") then {_risk = 10};
        if (_gType == "CAPTURE_REGION")  then {_risk = -5};

        private _prevPenalty = 0;
        if ((_goal get "ID") in _previousGoals) then { _prevPenalty = -50 };

        (_goal getOrDefault ["Priority",0]) + _bonus - _cost + _risk + _prevPenalty
    };

    private _personality = _commander getOrDefault ["Personality","AGGRESSIVE"];

    private _best = objNull;
    private _bestScore = -1e9;
    {
        private _sc = [_x,_personality,_enemyStrength] call _scoreGoal;
        if (_sc > _bestScore) then {
            _bestScore = _sc;
            _best = _x;
        };
    } forEach _goalCandidates;

    if (!isNull _best) then {
        private _status = "ACTIVE";
        _best set ["Status", _status];
        _best set ["Created", serverTime];

        _commander set ["CurrentGoal", _best];
        _commander set ["CurrentGoalStatus", _status];

        // Remember last goal id to reduce oscillation
        private _gid = _best getOrDefault ["ID","" ];
        if (_gid != "") then {
            _previousGoals pushBack _gid;
            if ((count _previousGoals) > 10) then { _previousGoals deleteAt 0; };
            _commander set ["PreviousGoals", _previousGoals];
        };

        // Goal decomposition is not implemented yet: instead tag intent for later operation generation.
        _commander set ["CurrentGoalNeedsReplan", true];
    };
};


// ----------------------------
// Force Allocation Pass (chat29)
// ----------------------------
// First integration step: compute reserve-aware budget and tag allowed operations.
// Full allocation of groups requires later helpers (getAvailableForces/assignForces).

private _factionId = _commander getOrDefault ["Faction", "FAC_BLUFOR"];
private _opsTracked = _commander getOrDefault ["Operations", []];
[_commander, _factionId, _opsTracked] call IDS_fnc_fn_forceAllocationPass;

// ----------------------------
// Operation creation intent (Vertical Slice v0.1)
// ----------------------------
// If we selected a CAPTURE_REGION goal, request a CAPTURE operation.
// Operation generation itself is provided by the operations layer functions.
// This file only sets the expected intent fields so existing systems can react.

if ((_commander getOrDefault ["CurrentGoalNeedsReplan", false]) isEqualTo true) then {
    private _goal = _commander getOrDefault ["CurrentGoal", createHashMap];
    private _gType = _goal getOrDefault ["Type", ""];

    switch (_gType) do {
        case "CAPTURE_REGION": {
            // Find a target location; best-effort using existing world DB.
            private _worldDB = missionNamespace getVariable ["IDS_WorldDB", objNull];
            private _locations = if (isNull _worldDB) then {[]} else {_worldDB getOrDefault ["Locations", []]};

            private _targetLoc = objNull;
            {
                private _locId = _x getOrDefault ["ID", ""]; 
                // If a specific region target exists, use it; otherwise pick first not owned.
                private _region = _goal getOrDefault ["Target", ""]; // e.g. REGION_WEST

                if (!isNull _targetLoc) exitWith {};

                private _locRegion = _x getOrDefault ["Region", ""]; 
                if ((_region isEqualTo "") || {_locRegion == _region}) then {
                    private _owner = _x getOrDefault ["OwnerFaction", "" ];
                    private _myFaction = _commander getOrDefault ["Faction", "FAC_BLUFOR"]; 
                    if !(_owner isEqualTo _myFaction) then {_targetLoc = _x};
                };
            } forEach _locations;

            if (!isNull _targetLoc) then {
                // Tag capture operation creation intent.
                private _ops = _commander getOrDefault ["Operations", []];
                private _opObj = createHashMap;
                _opObj set ["Type", "CAPTURE"]; 
                _opObj set ["Status", "DEPLOY"]; 
                _opObj set ["TargetLocation", _targetLoc];

                // Derive position / radius from location if available.
                private _pos = _targetLoc getOrDefault ["Position", getPosATL leader grpNull];
                _opObj set ["TargetPos", _pos];
                _opObj set ["Radius", _targetLoc getOrDefault ["Radius", 250]];

                _ops pushBack _opObj;
                _commander set ["Operations", _ops];
            };
        };
        default {};
    };

    _commander set ["CurrentGoalNeedsReplan", false];
};

// ----------------------------
// World Events integration (chat31)
// ----------------------------
private _worldEvents = missionNamespace getVariable ["IDS_WorldEvents", createHashMap];
private _activeEvents = _worldEvents getOrDefault ["ActiveEvents", []];
if (typeName _activeEvents == "ARRAY") then {
    [_commander, _worldEvents, _activeEvents] call IDS_fnc_applyWorldEventsToState;
};

private _doctrineKey = _commander getOrDefault ["Doctrine", objNull];
if (isNull _doctrineKey) then {
    _doctrineKey = _commander getOrDefault ["Personality","AGGRESSIVE"];
    _commander set ["Doctrine", _doctrineKey];
};

private _doctrineData = IDS_Doctrines getOrDefault [_doctrineKey, createHashMap];
_commander set ["DoctrineData", _doctrineData];

true

