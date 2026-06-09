/*
    IDS Commander AI - Economy Tick (delegates to strategic persistent war economy)

    This is the entrypoint called by fn_startloops.
*/

params ["_commander"];

if !(call IDS_fnc_isAuthority) exitWith {};

// Territory -> resources
[_commander] call IDS_fnc_tickEconomy;

// Operation reinforcement consumption / auto-replacement
[_commander] call IDS_fnc_checkReinforcements;

true

