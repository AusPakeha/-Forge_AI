/*
    IDS Commander AI - Add Reserve Group

    Params:
        0: STRING - CommanderID
        1: STRING - GroupID

    Returns:
        BOOLEAN
*/

params ["_commanderID", "_groupID"];

if !(call IDS_fnc_isAuthority) exitWith {false};
if (_commanderID isEqualTo "") exitWith {false};
if (_groupID isEqualTo "") exitWith {false};

[_commanderID, _groupID] call IDS_fnc_registerCommanderGroup
