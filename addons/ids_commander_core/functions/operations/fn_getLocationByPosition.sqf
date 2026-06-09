/*
    IDS Commander AI - Get Location by Position

    Returns closest location object/hashmap from IDS_WorldDB "Locations".
*/

params ["_pos"];

private _locs = IDS_WorldDB get "Locations";
if (isNil "_locs") exitWith { objNull };

private _closest = objNull;
private _bestDist = 999999;

{
    private _d = (_pos distance2D (_x get "Position"));

    if (_d < _bestDist) then
    {
        _bestDist = _d;
        _closest = _x;
    };
} forEach _locs;

_closest

