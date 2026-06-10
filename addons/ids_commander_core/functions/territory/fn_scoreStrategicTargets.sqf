params ["_commander"];

private _targets = [];
private _locations = IDS_WorldDB getOrDefault ["Locations", []];
private _locationList = if (typeName _locations == "HASHMAP") then { values _locations } else { _locations };

{
    private _score =
        ((_x getOrDefault ["StrategicValue", 0]) * 3)
        + ((_x getOrDefault ["ResourceValue", 0]) * 2)
        + ((_x getOrDefault ["FrontlineScore", 0]) * 1)
        - ((_x getOrDefault ["ThreatScore", 0]) * 1);

    _targets pushBack [_x, _score];

} forEach _locationList;

_targets = _targets sortBy { _x select 1 };
_targets reverse;

_targets