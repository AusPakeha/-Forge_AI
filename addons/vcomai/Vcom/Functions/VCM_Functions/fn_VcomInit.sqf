//Parameters
VCM_PublicScript = compileFinal "[] call (_this select 0);";
VCM_ServerAsk = compileFinal "(_this select 1) publicVariableClient (_this select 0);";

/*
"AwareFormationSoft" enableAIFeature false;
"CombatFormationSoft" enableAIFeature false;
*/

if (isServer) then
{
	if (isFilePatchingEnabled) then
	{
		
		private _path = "\userconfig\VCOM_AI\AISettingsV3.4.1.hpp";
		
		if (fileExists _path) then
		{
			[] call compile preprocessFileLineNumbers "\userconfig\VCOM_AI\AISettingsV3.4.1.hpp";
			[Vcm_Settings] remoteExec ["VCM_PublicScript",0,false];		
		}
		else
		{
			[] call compile preprocessFileLineNumbers "vcomai\Vcom\Functions\VCOMAI_DefaultSettings.sqf";
			[Vcm_Settings] remoteExec ["VCM_PublicScript",0,false];			
		};
	}
	else
	{
			[] call compile preprocessFileLineNumbers "vcomai\Vcom\Functions\VCOMAI_DefaultSettings.sqf";
			[Vcm_Settings] remoteExec ["VCM_PublicScript",0,false];
	};
};

//waitUntil {!(isNil "VCM_AIMagLimit")};

//Mod checks
//ACE CHECK
if (!(isNil "ACE_Medical_enableFor") && {ACE_Medical_enableFor isEqualTo 1}) then {VCM_MEDICALACTIVE = true;} else {VCM_MEDICALACTIVE = false;};
//CBA CHECK
if (isClass(configFile >> "CfgPatches" >> "cba_main")) then {CBAACT = true;} else {CBAACT = false;};
//ENHANCED MOVEMENT CHECK
if !(isNil "EM_debug") then {VCOM_EM_ENABLED = true;} else {VCOM_EM_ENABLED = false;};
if !(isNil "emr_main_climbingenabled") then {VCOM_EMR_ENABLED = true;} else {VCOM_EMR_ENABLED = false;};


//Global actions compiles
Vcm_PMN = compileFinal "(_this select 0) playMoveNow (_this select 1);";
Vcm_SM = compileFinal "(_this select 0) switchMove (_this select 1);";
Vcm_PAN = compileFinal "(_this select 0) playActionNow (_this select 1);";
VCOM_MINEARRAY = [];
VCM_CoverQueue = [];

//Hearingaids reveal
VCM_fnc_HearingReveal = {
    params ["_ldr","_tgt","_add"];
    if (alive _ldr) then {
        private _kv = _ldr knowsAbout _tgt;
        _ldr reveal [_tgt, (_kv + _add) min 2.0];
    };
};
publicVariable "VCM_fnc_HearingReveal";   // make it visible on all machines

//VehicleReveal init.
// VehicleReveal init.
if (isServer) then {
    [] spawn {
        // --- wait until CBA settings exist
        waitUntil {!isNil "CBA_fnc_init"};
        sleep 2;

        // --- read once
        private _loopDelay = missionNamespace getVariable ["VCM_VEHREV_TIME", 50];
        private _dist      = missionNamespace getVariable ["VCM_VEHREV_DIST", 400];
        private _enabledSides = missionNamespace getVariable ["VCM_SIDEENABLED", [west,east,resistance]];

        // --- optional small random initial delay based on loop time
        private _initialDelay = random (_loopDelay * 0.75 max 5);
        sleep _initialDelay;

        // --- main loop
        while {true} do {
    {
        private _ldr = leader _x;
        private _grp = _x;
        private _side = side _ldr;

        // Skip groups on disabled sides
        if (!(_side in _enabledSides)) then { continue; };

        // Skip groups with VCOM disabled
        if (_grp getVariable ["Vcm_Disable", false]) then { continue; };

        if (alive _ldr && {vehicle _ldr != _ldr}) then {
            if (_dist >= 1) then {
                [_ldr] spawn {
                    sleep random 15;
                    [_this select 0] call VCM_fnc_VehicleReveal;
                };
            };
        };
    } forEach allGroups;

        sleep _loopDelay;
    };
    };
};





