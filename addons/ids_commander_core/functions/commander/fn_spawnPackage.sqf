/*
    IDS Commander AI - Spawn Package (v0.1)

    Description:
    Spawns a force package.

    Parameters:
        0: STRING - Package Type
        1: STRING - Faction ID
        2: POSITION
        3: STRING - Commander ID

    Returns:
        ARRAY
*/

params [
    ["_packageType",""],
    ["_factionID",""],
    ["_spawnPos", [0,0,0]],
    ["_commanderID", ""]
];

if (!isServer) exitWith { [[],[]] };
if (_packageType isEqualTo "") exitWith { [[],[]] };
if (_factionID isEqualTo "") exitWith { [[],[]] };
if (_commanderID isEqualTo "") exitWith { [[],[]] };

private _template = [_factionID] call IDS_fnc_getFactionTemplate;
if (typeName _template != "HASHMAP") exitWith { [[],[]] };

private _groupIDs = [];
private _vehicleIDs = [];

switch (_packageType) do {
    case "FORCE_RIFLE_SQUAD": {
        private _side = _template get "Side";
        private _group = createGroup [_side, true];

        _group createUnit [
            _template get "Leader",
            _spawnPos,
            [],
            0,
            "NONE"
        ];

        _group createUnit [
            _template get "Autorifleman",
            _spawnPos,
            [],
            0,
            "NONE"
        ];

        _group createUnit [
            _template get "Grenadier",
            _spawnPos,
            [],
            0,
            "NONE"
        ];

        for "_i" from 1 to 5 do {
            _group createUnit [
                _template get "Rifleman",
                _spawnPos,
                [],
                0,
                "NONE"
            ];
        };

        private _groupID = [_group, _commanderID, _packageType] call IDS_fnc_registerGroup;
        _groupIDs pushBack _groupID;
    };
};

[
    _groupIDs,
    _vehicleIDs
]

