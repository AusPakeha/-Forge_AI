/*
    IDS Commander AI - Get Commander Reserve Groups

    Params:
        0: STRING - CommanderID

    Returns:
        ARRAY of Group IDs
*/

params ["_commanderID"];

if (_commanderID isEqualTo "") exitWith {[]};

private _commander = [_commanderID] call IDS_fnc_getCommanderData;
if (typeName _commander != "HASHMAP") exitWith {[]};

private _reserve = _commander getOrDefault ["ReserveGroups", []];
private _copy = [];
{ _copy pushBack _x; } forEach _reserve;

_copy
