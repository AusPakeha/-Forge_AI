/*
    IDS Commander AI - Select Commander Personality (Version 0.1)

    Docs: selectCommander occurs on New Campaign / New Save.
*/

if !(call IDS_fnc_isAuthority) exitWith {"AGGRESSIVE"};

call IDS_fnc_initDoctrineRegistry;

private _choices = ["AGGRESSIVE", "DEFENSIVE"];
private _index = floor (random (count _choices));
private _choice = _choices select _index;

_choice
