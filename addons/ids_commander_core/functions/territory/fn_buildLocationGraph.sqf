/*
    IDS Commander AI - Build Location Graph (chat28.sqf)

    Adds neighbor relationships to each location in IDS_WorldDB "Locations".
    Authoritative only.

    Neighbor rule (v0.1):
    - Any other location within 3000m in 2D becomes a neighbor.
*/

if !(call IDS_fnc_isAuthority) exitWith {};

private _locations = IDS_WorldDB get "Locations";
if (isNil "_locations") exitWith {};

// Avoid re-building if already present.
// If you want rebuild each mission, remove this guard.
private _already = (_locations param [0, createHashMap]) getOrDefault ["Neighbors", []];
if !(_already isEqualTo []) exitWith {true};

{
    private _neighbors = [];

    {
        if (_x isNotEqualTo _y) then
        {
            private _dx = (_x get "Position") distance2D (_y get "Position");
            if (_dx < 3000) then
            {
                _neighbors pushBack (_y get "ID");
            };
        };
    } forEach _locations;

    _x set ["Neighbors", _neighbors];

} forEach _locations;

true

