/*
    IDS Commander AI - Update Frontline Regions (chat28.sqf)

    Groups nearby frontline locations into connected regions.

    Region definition (v0.1):
    - A location is part of a region if it is frontline
    - and is connected to other frontline locations via graph neighbors.

    Output:
    - Each frontline location gets:
        "RegionID" = "FRONT_<n>"
    - A commander/world-level array is stored:
        IDS_WorldDB get "FrontlineRegions" = [
            ["FRONT_0", [locId1, locId2, ...]],
            ...
        ]

    Authoritative only.
*/

if !(call IDS_fnc_isAuthority) exitWith {};

private _locations = IDS_WorldDB get "Locations";
if (isNil "_locations") exitWith {};

// Reset/ensure region storage
IDS_WorldDB set ["FrontlineRegions", []];

private _frontlineLocIds = [];
{
    if (_x getOrDefault ["IsFrontline", false]) then {
        _frontlineLocIds pushBack (_x get "ID");
    };
} forEach _locations;

private _visited = createHashMap;
private _regions = [];
private _regionIdx = 0;

// Build region by BFS/DFS over neighbor graph
{
    private _startId = _x;
    if (_visited getOrDefault [_startId, false]) exitWith {};

    private _regionLocs = [];
    private _stack = [_startId];

    while {count _stack > 0} do
    {
        private _curId = _stack deleteAt 0;

        if (_visited getOrDefault [_curId, false]) exitWith {};
        _visited set [_curId, true];

        private _curLoc = [_curId] call IDS_fnc_getLocationByID;
        if (isNil "_curLoc") exitWith {};
        if !(_curLoc getOrDefault ["IsFrontline", false]) exitWith {};

        _regionLocs pushBack _curId;

        private _neighbors = _curLoc getOrDefault ["Neighbors", []];
        {
            if !(_visited getOrDefault [_x, false]) then {
                _stack pushBack _x;
            };
        } forEach _neighbors;
    };

    if (count _regionLocs > 0) then
    {
        private _regionId = format ["FRONT_%1", _regionIdx];
        {
            private _loc = [_x] call IDS_fnc_getLocationByID;
            if !(isNil "_loc") then {
                _loc set ["RegionID", _regionId];
            };
        } forEach _regionLocs;

        _regions pushBack [_regionId, _regionLocs];
        _regionIdx = _regionIdx + 1;
    };

} forEach _frontlineLocIds;

IDS_WorldDB set ["FrontlineRegions", _regions];

true

