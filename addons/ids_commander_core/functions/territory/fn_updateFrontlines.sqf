/*
    IDS Commander AI - Update Frontlines (chat28.sqf)

    Sets "IsFrontline" for each location based on neighbor owners.
    Definition:
      IsFrontline = true if at least one neighbor has a different OwnerFaction.

    Authoritative only.
*/

if !(call IDS_fnc_isAuthority) exitWith {};

private _locations = IDS_WorldDB get "Locations";
if (isNil "_locations") exitWith {};

{
    private _owner = _x get "OwnerFaction";
    private _frontline = false;

    private _neighbors = _x getOrDefault ["Neighbors", []];
    {
        private _neighbor = [_x] call IDS_fnc_getLocationByID;
        if (isNil "_neighbor") exitWith {};

        if ((_neighbor get "OwnerFaction") != _owner) exitWith {_frontline = true};

    } forEach _neighbors;

    _x set ["IsFrontline", _frontline];

} forEach _locations;

true

