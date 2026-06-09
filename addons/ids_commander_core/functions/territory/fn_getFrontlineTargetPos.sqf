/*
    IDS Commander AI - Get Frontline Target Position (chat28.sqf)

    Chooses a target position for operation generation.

    Params:
      0: _commander (HashMap)
      1: _operationType (String) (CAPTURE/DEFEND/etc.)

    Returns:
      Position array [x,y,z] or []

    Authoritative only.
*/

if !(call IDS_fnc_isAuthority) exitWith {[]};

params ["_commander","_operationType"];

private _focus = [_commander] call IDS_fnc_selectFrontlineFocus;
private _primary = _focus getOrDefault ["Primary", ""];
private _secondary = _focus getOrDefault ["Secondary", ""];

private _regionId = switch (_operationType) do
{
    case "DEFEND": { _primary };
    case "CAPTURE": { _primary };
    default { _primary };
};

if (_regionId isEqualTo "") exitWith {[]};

private _regions = IDS_WorldDB getOrDefault ["FrontlineRegions", []];

private _locIds = [];
{
    if ((_x select 0) isEqualTo _regionId) exitWith {_locIds = _x select 1};
} forEach _regions;

if (_locIds isEqualTo []) exitWith {[]};

private _chosenLocId = selectRandom _locIds;
private _loc = [_chosenLocId] call IDS_fnc_getLocationByID;
if (isNil "_loc") exitWith {[]};

private _pos = _loc getOrDefault ["Position", []];
_pos

