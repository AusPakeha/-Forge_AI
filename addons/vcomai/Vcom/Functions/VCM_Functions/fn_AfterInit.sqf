
[] spawn
{
	private _id = clientOwner;
	["Vcm_Settings",_id] remoteExec ["VCM_ServerAsk",2,false];
	waitUntil {!(isNil "Vcm_Settings")};
	[] call Vcm_Settings;	
	sleep 2;
	

	
	[] call VCM_fnc_WeaponDefine;
	[] spawn VCM_fnc_AIDRIVEBEHAVIOR;
	[] spawn VCM_fnc_Scheduler;
	//Info sharing low distance
	if ((missionNamespace getVariable ["VCM_SHARE_Distance", 50]) >= 1) then {
    [] spawn VCM_fnc_ShareContact;
    };

	
	if (hasInterface) then
	{
		//Event handlers for players	
		player addEventHandler ["Fired",{_this call VCM_fnc_HearingAids;}];
		//player spawn VCM_fnc_IRCHECK;
		//player addEventHandler ["Respawn",{_this spawn VCM_fnc_IRCHECK;}];
		//if (Vcm_PlayerAISkills) then {[] spawn VCM_fnc_PLAYERSQUAD;};
		
		// --- Keybind: Call Reinforcements (default Ctrl+J)
     [
        "VCOM",
        "VCM_CallReinforcements",
        "Call Reinforcements",
        {
            if (missionNamespace getVariable ["VCM_PlayerReinforce_Enable", true]) then {
                // send the request to the server for processing
                [player] remoteExecCall ["VCM_fnc_RequestReinforcement", 2];
                systemChat "[VCOM] Reinforcement request sent.";
            } else {
                systemChat "[VCOM] Player reinforcement feature is disabled.";
            };
        },
        {}, // key-up handler unused
        [36, [true, false, false]] // default Ctrl+J
    ] call CBA_fnc_addKeybind;
	};

	
	//OnEachFrame monitor for mines. Should make them more responsive, without a significant impact on FPS.
	["VCMMINEMONITOR", "onEachFrame", {[] call VCM_fnc_MineMonitor}] call BIS_fnc_addStackedEventHandler;
	
    if (isServer) then {
        [] execVM "\vcomai\Vcom\Functions\VCM_Functions\fn_ExplosionHearing.sqf";
		[] execVM "\vcomai\Vcom\Functions\VCM_Functions\fn_ITNDetect.sqf";
    };
};
