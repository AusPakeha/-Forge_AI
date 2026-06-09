	//prova portatile
	//SERVER HC CONFIG

		if ( isnil "ODK_DEBUG_FLAG_DEBUG" ) then { ODK_DEBUG_FLAG_DEBUG = false; };
		missionnamespace setvariable [ "ODK_ActivateAI" , true , false ];
		missionnamespace setvariable [ "ODK_ActivateDangerAI" , true , false ];
		missionnamespace setvariable [ "ODKAI_LOOP" , true , false ];


	//PLAYERS SETTINGS
		if ( isnil "ODK_GIVE_PARACHUTE" ) then { ODK_GIVE_PARACHUTE= FALSE; };
	
	//AI SKILLS
		if ( isnil "ODK_COSTUMSKILLS" ) then { ODK_COSTUMSKILLS= FALSE; };

	//UNITS FEATURES
		if ( isnil "ODK_ADDSMOKE" ) then { ODK_ADDSMOKE = TRUE; };
		if ( isnil "ODK_LASERON" ) then { ODK_LASERON = TRUE; };
		if ( isnil "ODK_TORCHON" ) then { ODK_TORCHON = TRUE; };
		if ( isnil "ODK_HEARVEH" ) then { ODK_HEARVEH = TRUE; };
		if ( isnil "ODK_HEARVEH_PROB" ) then { ODK_HEARVEH_PROB = 35; };
		if ( isnil "ODK_SEE_LASER" ) then { ODK_SEE_LASER = TRUE; };
		if ( isnil "ODK_SEE_LASER_RANGE" ) then { ODK_SEE_LASER_RANGE = 500; };
		if ( isnil "ODK_SEE_LASER_PERC" ) then { ODK_SEE_LASER_PERC = 25; };
		if ( isnil "ODK_ROLL" ) then { ODK_ROLL = TRUE; };
		if ( isnil "ODK_SMOKEGRANADES" ) then { ODK_SMOKEGRANADES = TRUE; };
		if ( isnil "ODK_HANDGRANADES" ) then { ODK_HANDGRANADES = TRUE; };
		if ( isnil "ODK_USEMOVEMENTSVEHICLE" ) then { ODK_USEMOVEMENTSVEHICLE = TRUE; };
		if ( isnil "ODK_RANGE_USEVEHICLE" ) then { ODK_RANGE_USEVEHICLE = 90; };
		if ( isnil "ODK_DIST_USEVEHICLE" ) then { ODK_DIST_USEVEHICLE = 300; };
		if ( isnil "ODK_USEARMEDVEH" ) then { ODK_USEARMEDVEH = TRUE; };
		if ( isnil "ODK_USEARMEDAIRVEH" ) then { ODK_USEARMEDAIRVEH = TRUE; };
		if ( isnil "ODK_EN_DEPLOYSTATIC" ) then { ODK_EN_DEPLOYSTATIC = TRUE; };
		if ( isnil "ODK_EN_DROPMINES" ) then { ODK_EN_DROPMINES = TRUE; };

	//STATIC WEAPONS
		if ( isnil "ODK_USESTATICS" ) then { ODK_USESTATICS = true; };
		if ( isnil "ODK_DIST_STATIC" ) then { ODK_DIST_STATIC = 100; };
		if ( isnil "ODK_USEARTILLERY" ) then { ODK_USEARTILLERY = true; };
		if ( isnil "ODK_DIST_ARTILLERY" ) then { ODK_DIST_ARTILLERY = 100; };

	//LAND VEHICLES
		if ( isnil "ODK_DIST_CONVOY" ) then { ODK_DIST_CONVOY = 20; };
	
	if ( isnil "PERCORSO_ODKAI") then { PERCORSO_ODKAI = "z\ODKAI\addons\ODKAI\ODKAI\"; };
	
	//CALL COMPILE FUNCTIONS
	if !( hasInterface && !isServer ) then {

	
		ODK_AI_FSM = PERCORSO_ODKAI+"AIUnits\AICICLE.fsm";
		AIFunctions_PATH = PERCORSO_ODKAI+"AIUnits\Functions\";
		
		call compile preprocessFileLineNumbers ( AIFunctions_PATH+"ODKAI_GlobalFunctions.sqf" );
		call compile preprocessFileLineNumbers ( AIFunctions_PATH+"ODKAI_CircleFunctions.sqf" );
		call compile preprocessFileLineNumbers ( AIFunctions_PATH+"ODKAI_DangerFunctions.sqf" );
		call compile preprocessFileLineNumbers ( AIFunctions_PATH+"ODKAI_Comunications.sqf" );
		call compile preprocessFileLineNumbers ( AIFunctions_PATH+"ODKAI_LandVehicles.sqf" );
		call compile preprocessFileLineNumbers ( AIFunctions_PATH+"ODKAI_UAV.sqf" );
		call compile preprocessFileLineNumbers ( AIFunctions_PATH+"ODKAI_AirVehicles.sqf" );
	};
	
	call compile preprocessFileLineNumbers ( PERCORSO_ODKAI+"ODKAI_Init.sqf" );
	
	[] execVM PERCORSO_ODKAI+ "init.sqf";


