/*
    IDS Commander AI - Initialize Operations (Version 0.1 placeholder)
*/

if !(call IDS_fnc_isAuthority) exitWith {};

params ["_commander"];

_commander set ["Operations", (_commander getOrDefault ["Operations", []])];

true
