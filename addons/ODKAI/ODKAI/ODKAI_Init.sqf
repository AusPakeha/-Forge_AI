	ODKAI_LOG = {

		private _testo = _this select 0;
		private _log = _this select 1;
		if !( isNil "c_logF" ) then {
			[ _log , _testo ] call c_logF;
		} else {
			diag_log _testo;
			systemchat _testo;
		};
	};

	ODKAI_PlayerInit = {


		ODKAI_fnc_parachute = {
			if (((getpos player select 2) > 40) and (vehicle player == player)) then {
				_backpack= backpack player;
				_backpackitems = backpackItems player;
				removeBackpack player;
				player addBackpack "B_Parachute";
				waitUntil {(getpos player select 2) <= 2 AND (speed player) <= 5};
				removeBackpack player;
				player addBackpack _backpack;
				_backpa = unitBackpack player;
				clearMagazineCargoGlobal _backpa;
				clearWeaponCargoGlobal _backpa;
				clearItemCargoGlobal _backpa;
				{player addItemToBackpack _x;} forEach _backpackitems;
			};
			if (vehicle player == player) then {unassignVehicle player;};
		};
		[] spawn {
			while { true } do {
				sleep 0.1;
				if ODK_GIVE_PARACHUTE then {
					[] call ODKAI_fnc_parachute;
				};
				if ( isNull objectParent player ) then { 
					[] call ODKAI_Change_AudioCoef;
				};
			};
		};
		[] spawn {
			waitUntil{ !( isNil "ODKAI_LocalUav" ) };
			while {true} do {
				sleep 3;
				[] call ODKAI_GetOwnerShip;
				[] call ODKAI_LocalUav;
			};
		};
		[] spawn {
			waitUntil { !isnil "ODK_Debug_Message" };
			systemchat format [ "ODKDEBUG : %1 for open ODKAI DEBUG Console.", str ( keyimage ( ( ( [ "ODKAI" , "ODKDEBUG" ] call CBA_fnc_getKeybind) SELECT 5) SELECT 0) ) ];		
		};
		player addEventHandler [ "WeaponAssembled" , {
			params [ "_unit" , "_staticWeapon" ];
			if ( toLower (getText ( configfile >> "CfgVehicles" >> ( typeof _staticWeapon ) >> "vehicleClass") ) isEqualTo "autonomous" ) then { 
				( _staticWeapon ) setVariable ["odkai_UAVDisabled" , true , true ];
			};
		}];
	};	
	
	ODKAI_ServerInit = {
		
		ODK_JIP_UAV_OWNER = { 
			( _this select 0 ) setGroupOwner ( _this select 1 );
		};
		
		ODKAI_LocalUav = {
			if ( !( ( getConnectedUAV player ) isequalto objnull ) ) then {
				private _myUavGroup = group ( getConnectedUAV player );
				if ( !( local _myUavGroup ) ) then {
					( getConnectedUAV player ) setVariable [ "odkai_UAVDisabled" , true , true ];
					[ _myUavGroup , clientOwner ] remoteExec [ "ODK_JIP_UAV_OWNER" , 2 , false ]; 
				};
			};			
		};	
		ODKAI_GetOwnerShip = {
			if ( !( local ( group player ) ) ) then {
				[ group player , clientOwner ] remoteExec [ "ODK_JIP_UAV_OWNER" , 2 , false ]; 
			};		
		};	
		publicvariable "ODK_JIP_UAV_OWNER";
		publicvariable "ODKAI_LocalUav";
		publicvariable "ODKAI_GetOwnerShip";

	};

	ODKAI_ServerLoop = {

	};

	ODKAI_Change_AudioCoef = {	

		private _Speed = linearconversion [ 0 , 21 , abs speed player , 1 , 50 , true ];
		private _Load = linearconversion [ 0 , 60 , loadAbs player / 22 , 1 , 5 , true ];
		private _ActStance = tolowerANSI ( stance player );									
		private _Stance = 1;
		if ( _ActStance isEqualTo "stand" ) then { _Stance = 1; };
		if ( _ActStance isEqualTo "crouch" ) then { _Stance = 0.5; };
		if ( _ActStance isEqualTo "prone" ) then { _Stance = 0.1; };
		
		private _AudioCoef = sqrt ( ( 1.01 - rain ) * _Speed * _Load * _stance );
		//systemChat str _AudioCoef;
		player setUnitTrait [ "audibleCoef", _AudioCoef ];

	};
