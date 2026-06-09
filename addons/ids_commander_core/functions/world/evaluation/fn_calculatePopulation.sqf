params
[
    "_location"
];

private _pos =
_location get "Position";

private _houses =
nearestTerrainObjects
[
    _pos,
    ["HOUSE"],
    300,
    false
];

count _houses