IDS_WorldDB = createHashMapFromArray
[
    ["Locations",createHashMap],
    ["Resources",createHashMap],
    ["Operations",createHashMap],
    ["Intel",createHashMap]
];

["Building World Database"] call IDS_fnc_log;

private _locations =
[] call IDS_fnc_scanLocations;

private _locationDB =
createHashMap;

{
    _locationDB set
    [
        _x get "ID",
        _x
    ];

} forEach _locations;

IDS_WorldDB set
[
    "Locations",
    _locationDB
];

missionNamespace setVariable ["IDS_WorldDB", IDS_WorldDB, true];
missionNamespace setVariable ["IDS_Locations", _locationDB, true];
IDS_Locations = _locationDB;

[
    format
    [
        "Generated %1 locations",
        count _locations
    ]
] call IDS_fnc_log;

{
    _x =
    [
        _x
    ] call IDS_fnc_evaluateLocation;

} forEach _locations;

[_locations] call IDS_fnc_initializeOwnership;

// Build frontline/territory graph (chat28.sqf).
// This must run after IDS_WorldDB "Locations" is populated and evaluated.
[] call IDS_fnc_buildLocationGraph;
