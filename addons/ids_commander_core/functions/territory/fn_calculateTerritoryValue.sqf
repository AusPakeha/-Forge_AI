params
[
    "_factionID"
];

private _locations =
[
    _factionID
]
call IDS_fnc_getFactionLocations;

private _value = 0;

{
    _value =
        _value +
        (_x get "StrategicValue");

} forEach _locations;

_value