/*
    IDS Commander AI - Select Commander Personality (Version 0.1)

    Docs: selectCommander occurs on New Campaign / New Save.
    Current implementation returns default personality.
*/

if !(call IDS_fnc_isAuthority) exitWith {"AGGRESSIVE"};

call IDS_fnc_initDoctrineRegistry;

// First implementation: only AGGRESSIVE and DEFENSIVE doctrines.
// Personality/doctrine persistence is handled by save/load.
"AGGRESSIVE"
