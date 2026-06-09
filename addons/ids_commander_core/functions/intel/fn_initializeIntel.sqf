/*
    IDS Commander AI - Initialize Intel (Version 0.1 placeholder)
*/

if !(call IDS_fnc_isAuthority) exitWith {};

params ["_commander"];

_commander set ["KnownIntel", (_commander getOrDefault ["KnownIntel", []])];

true
