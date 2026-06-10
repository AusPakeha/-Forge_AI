params
[
    "_locations"
];

private _halfX = worldSize / 2;

{
    private _pos = _x getOrDefault ["Position", [0,0,0]];
    private _owner = ((_pos select 0) < _halfX) then {"FAC_BLUFOR"} else {"FAC_OPFOR"};

    _x set ["OwnerFaction", _owner];
    _x set ["LastCaptured", serverTime];
} forEach _locations;

true