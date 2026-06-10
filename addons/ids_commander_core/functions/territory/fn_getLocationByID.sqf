/*
    IDS Commander AI - Get Location By ID

    Params:
      0: _id (string)

    Returns:
      location HashMap or objNull
*/

params ["_id"]; 
if (isNil "_id") exitWith {objNull};

private _worldDB = missionNamespace getVariable ["IDS_WorldDB", createHashMap];
private _locations = _worldDB getOrDefault ["Locations", createHashMap];

private _found = objNull;
{
    if ((_x get "ID") isEqualTo _id) then { _found = _x; };
} forEach values _locations;

if (isNull _found) then { objNull } else { _found }
