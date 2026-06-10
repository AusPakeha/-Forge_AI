/*
    IDS Commander AI - Register Group (v0.1)

    Description:
    Registers a newly created group.

    Parameters:
        0: GROUP
        1: STRING - Commander ID
        2: STRING - Force Package

    Returns:
        STRING - Group ID
*/

params [
    ["_group", grpNull],
    ["_commanderID", ""],
    ["_forcePackage", ""]
];

if (!isServer) exitWith {""};
if (isNull _group) exitWith {""};
if (_commanderID isEqualTo "") exitWith {""};

private _groupID = ["GRP"] call IDS_fnc_generateGroupId;
_group setVariable ["IDS_GroupID", _groupID];
_group setVariable ["IDS_PackageKey", _forcePackage];

// Register in the global group registry
[_groupID, _group, _commanderID, ""] call IDS_fnc_groupRegistry_register;

// Notify commander registry to add this group into reserves and update combat-power
[_commanderID, _groupID] call IDS_fnc_registerCommanderGroup;

_groupID
