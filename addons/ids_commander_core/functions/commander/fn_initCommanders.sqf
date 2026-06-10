/*
    IDS Commander AI - Init Commanders

    Ensures the authoritative `IDS_Commanders` registry exists on the server.
*/

if !(call IDS_fnc_isAuthority) exitWith {false};

if (isNil "IDS_Commanders") then {
    missionNamespace setVariable ["IDS_Commanders", createHashMap];
};

true
