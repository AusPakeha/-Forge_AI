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

private _knownIntel = _commander getOrDefault ["KnownIntel", []];
private _tl = [_commander, _knownIntel] call IDS_fnc_calculateThreats;
_commander set ["ThreatLevel", _tl];
_commander set ["EnemyStrength", _tl];

// Doctrine registry + data backfill (safe to repeat)
call IDS_fnc_initDoctrineRegistry;

// ----------------------------
// Strategic Planning & Campaign Goals (chat30)
// ----------------------------
private _strategicTickLast = _commander getOrDefault ["StrategicTickLast", -1];
private _strategicTickPeriod = _commander getOrDefault ["StrategicTickPeriod", 900]; // 15 minutes

if ((serverTime - _strategicTickLast) >= _strategicTickPeriod) then {
    _commander set ["StrategicTickLast", serverTime];

    private _previousGoals = _commander getOrDefault ["PreviousGoals", []];
    private _enemyStrength = _commander getOrDefault ["EnemyStrength", 0];

    private _goalCandidates = [
        createHashMapFromArray [["ID","GOAL_CAPTURE_REGION"],["Type","CAPTURE_REGION"],["Priority",100]],
        createHashMapFromArray [["ID","GOAL_SECURE_FRONTLINE"],["Type","SECURE_FRONTLINE"],["Priority",80]],
        createHashMapFromArray [["ID","GOAL_CAPTURE_RESOURCES"],["Type","CAPTURE_RESOURCES"],["Priority",75]],
        createHashMapFromArray [["ID","GOAL_WEAKEN_ENEMY"],["Type","WEAKEN_ENEMY"],["Priority",70]]
    ];

    private _scoreGoal = {
        params ["_goal","_personality","_enemyStrength"];
        private _gType = _goal getOrDefault ["Type","CAPTURE_REGION"];
        private _bonus = 0;

        switch (_personality) do {
            case "AGGRESSIVE": { if (_gType == "CAPTURE_REGION") then {_bonus = 200}; if (_gType == "WEAKEN_ENEMY") then {_bonus = 40}; };
            case "DEFENSIVE" : { if (_gType == "SECURE_FRONTLINE") then {_bonus = 200}; };
            default { _bonus = 0; };
        };

        private _cost = _enemyStrength * 0.1;
        private _risk = 0;
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

        private _gid = _best getOrDefault ["ID", ""];
        if (_gid != "") then {
            _previousGoals pushBack _gid;
            if ((count _previousGoals) > 10) then { _previousGoals deleteAt 0; };
            _commander set ["PreviousGoals", _previousGoals];
        };

        _commander set ["CurrentGoalNeedsReplan", true];
    };
};

// ----------------------------
// Force Allocation Pass (chat29)
// ----------------------------
private _factionId = _commander getOrDefault ["Faction", "FAC_BLUFOR"];
private _opsTracked = _commander getOrDefault ["Operations", []];
[_commander, _factionId, _opsTracked] call IDS_fnc_fn_forceAllocationPass;

// ----------------------------
// Operation creation intent (Vertical Slice v0.1)
// ----------------------------
if ((_commander getOrDefault ["CurrentGoalNeedsReplan", false]) isEqualTo true) then {
    private _goal = _commander getOrDefault ["CurrentGoal", createHashMap];
    private _gType = _goal getOrDefault ["Type", ""];

    switch (_gType) do {
        case "CAPTURE_REGION": {
            private _worldDB = missionNamespace getVariable ["IDS_WorldDB", createHashMap];
            private _locations = _worldDB getOrDefault ["Locations", createHashMap];
            private _targetLoc = objNull;
            private _highestValue = -1e9;
            private _myFaction = _commander getOrDefault ["Faction", "FAC_OPFOR"];
            private _ownedLocations = [];

            {
                private _owner = _x getOrDefault ["OwnerFaction", ""];
                if (_owner isEqualTo _myFaction) then {
                    _ownedLocations pushBack _x;
                } else {
                    private _value = _x getOrDefault ["StrategicValue", 0];
                    if (_value > _highestValue) then {
                        _highestValue = _value;
                        _targetLoc = _x;
                    };
                };
            } forEach values _locations;

            if (!isNull _targetLoc) then {
                private _originLoc = objNull;
                if (!(_ownedLocations isEqualTo [])) then {
                    _originLoc = _ownedLocations select 0;
                } else {
                    _originLoc = [_targetLoc get "Position"] call IDS_fnc_getLocationByPosition;
                };

                if (!isNull _originLoc) then {
                    private _operationID = [_commander get "ID", "CAPTURE", (_originLoc get "ID"), (_targetLoc get "ID")] call IDS_fnc_createOperation;
                    if !(_operationID isEqualTo "") then {
                        private _ops = _commander getOrDefault ["Operations", []];
                        _ops pushBack _operationID;
                        _commander set ["Operations", _ops];

                        private _activeOps = _commander getOrDefault ["ActiveOperations", []];
                        _activeOps pushBack _operationID;
                        _commander set ["ActiveOperations", _activeOps];
                    };
                };
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

