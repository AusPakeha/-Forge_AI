private _locations =
IDS_WorldDB get "Locations";

{
    private _data = _y;

    private _name =
    _data get "Name";

    private _pos =
    _data get "Position";

    createMarkerLocal
    [
        format
        [
            "IDS_LOC_%1",
            _forEachIndex
        ],
        _pos
    ];

    private _marker =
    format
    [
        "IDS_LOC_%1",
        _forEachIndex
    ];

    _marker setMarkerShapeLocal "ICON";

    _marker setMarkerTypeLocal "mil_dot";

    private _strategic = _data get "StrategicValue";

    _marker setMarkerTextLocal format
    [
        "%1 | S:%2",
        _name,
        _strategic
    ];

} forEach _locations;