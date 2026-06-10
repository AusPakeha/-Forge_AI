params
[
    "_locationID",
    "_newFaction"
];

private _worldDB = missionNamespace getVariable ["IDS_WorldDB", createHashMap];
private _locations = _worldDB getOrDefault ["Locations", createHashMap];
private _location = _locations get _locationID;

if (isNil "_location") exitWith
{
    false
};

_location set ["OwnerFaction", _newFaction];
_location set ["LastCaptured", serverTime];

_locations set [_locationID, _location];
_worldDB set ["Locations", _locations];
missionNamespace setVariable ["IDS_WorldDB", _worldDB, true];
IDS_WorldDB = _worldDB;

true