/*
    IDS Commander AI - Economy Tick (Strategic Persistent War Spec)

    Runs on authority.

    Responsibilities:
    - Territory income tick: owned locations generate Money/Manpower/Influence
    - Reinforcement generation: convert Money/Manpower into ReinforcementPool
*/

if !(call IDS_fnc_isAuthority) exitWith {};

params ["_commander"];

if (isNil "_commander") exitWith {};

// World DB data model
private _worldDB = missionNamespace getVariable ["IDS_WorldDB", objNull];
if (isNull _worldDB) then {_worldDB = IDS_WorldDB};

if (isNil "IDS_WorldDB") exitWith {};

private _locations = IDS_WorldDB getOrDefault ["Locations", []];
if (_locations isEqualTo []) exitWith {};

// Per-faction: commander holds economy state
private _money = _commander getOrDefault ["Money", 0];
private _manpower = _commander getOrDefault ["Manpower", 0];
private _influence = _commander getOrDefault ["Influence", 0];

// Income per tick (periodic). We keep this simple and stable.
// Each location should have an "Income" hash-map with Money/Manpower/Influence.
// If not present, treat as 0.
{
    private _ownerFaction = _x getOrDefault ["OwnerFaction", "FAC_BLUFOR"];

    // Commander faction id mapping: keep consistent with existing territory capture.
    // If you use multiple factions later, this will be adapted.
    private _cmdFaction = _commander getOrDefault ["Faction", "FAC_BLUFOR"];

    if (_ownerFaction isEqualTo _cmdFaction) then
    {
        private _income = _x get "Income";
        if (isNil "_income") then {_income = createHashMap};

        _money = _money + (_income getOrDefault ["Money", 0]);
        _manpower = _manpower + (_income getOrDefault ["Manpower", 0]);
        _influence = _influence + (_income getOrDefault ["Influence", 0]);
    };
} forEach _locations;

// Persist back to commander
_commander set ["Money", _money];
_commander set ["Manpower", _manpower];
_commander set ["Influence", _influence];

// Reinforcement pool init
if (isNil {_commander get "ReinforcementPool"}) then {
    _commander set [
        "ReinforcementPool",
        createHashMapFromArray [
            ["Infantry", 0],
            ["LightVehicles", 0],
            ["HeavyVehicles", 0]
        ]
    ];
};

private _pool = _commander get "ReinforcementPool";

// Conversion rules (stable):
// 100 Money = 1 Squad
// 50 Manpower = 1 Infantry Unit
// Note: For now we do NOT automatically subtract Money/Manpower (to avoid negative feedback loops). We only add to pool.
private _squads = floor (_manpower / 50);
private _vehicles = floor (_money / 200);

_pool set ["Infantry", (_pool getOrDefault ["Infantry", 0]) + _squads];
_pool set ["LightVehicles", (_pool getOrDefault ["LightVehicles", 0]) + _vehicles];

_commander set ["ReinforcementPool", _pool];

true

