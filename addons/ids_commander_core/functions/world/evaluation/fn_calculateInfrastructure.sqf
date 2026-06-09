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

private _roads =
_pos nearRoads 300;

private _score =
(
(count _houses)
+
(
(count _roads) * 2
)
);

_score min 100