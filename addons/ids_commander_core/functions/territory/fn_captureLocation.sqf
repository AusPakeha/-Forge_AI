params
[
    "_locationID",
    "_newFaction"
];

private _locations =
IDS_WorldDB get "Locations";

private _location =
_locations get _locationID;

if (isNil "_location") exitWith
{
    false
};

_location set
[
    "OwnerFaction",
    _newFaction
];

_location set
[
    "LastCaptured",
    serverTime
];

true