/*
    IDS Commander AI - Start system loops (Version 0.1)

    Starts:
    - Commander loop
    - Economy loop
    - Intel loop
    - Operations loop

    Server authority only.
*/

if !(call IDS_fnc_isAuthority) exitWith {};

// Always read tick rates from IDS_Settings.
private _commanderTick = (missionNamespace getVariable ["IDS_Settings", createHashMap]) getOrDefault ["CommanderTick",300];
private _economyTick   = (missionNamespace getVariable ["IDS_Settings", createHashMap]) getOrDefault ["EconomyTick",300];
private _intelTick     = (missionNamespace getVariable ["IDS_Settings", createHashMap]) getOrDefault ["IntelTick",30];
private _operationTick = (missionNamespace getVariable ["IDS_Settings", createHashMap]) getOrDefault ["OperationTick",60];

// Single commander version 0.1: just take first entry.
private _getAnyCommander = {
    if (isNil "IDS_Commanders") exitWith {objNull};
    private _keys = keys IDS_Commanders;
    if (_keys isEqualTo []) exitWith {objNull};
    IDS_Commanders get (_keys select 0)
};

// Prevent multiple loop instances.
if !(isNil "IDS_LoopsStarted") exitWith {};
missionNamespace setVariable ["IDS_LoopsStarted", true];

// Commander loop
[_commanderTick, _getAnyCommander] spawn
{
    params ["_tick", "_getAnyCommander"];
    while {true} do
    {
        private _cmd = call _getAnyCommander;
        if !(isNull _cmd) then {[_cmd] call IDS_fnc_updateCommander};
        sleep _tick;
    };
};

// Economy loop
[_economyTick, _getAnyCommander] spawn
{
    params ["_tick", "_getAnyCommander"];
    while {true} do
    {
        private _cmd = call _getAnyCommander;
        if !(isNull _cmd) then {[_cmd] call IDS_fnc_updateEconomy};
        sleep _tick;
    };
};

// Intel loop
[_intelTick, _getAnyCommander] spawn
{
    params ["_tick", "_getAnyCommander"];
    while {true} do
    {
        private _cmd = call _getAnyCommander;
        if !(isNull _cmd) then {[_cmd] call IDS_fnc_updateIntel};
        sleep _tick;
    };
};

// Operations loop
[_operationTick, _getAnyCommander] spawn
{
    params ["_tick", "_getAnyCommander"];
    while {true} do
    {
        private _cmd = call _getAnyCommander;
        if !(isNull _cmd) then {[_cmd] call IDS_fnc_updateOperations};
        sleep _tick;
    };
};

