	ODKAI_AirVehicle = {				
		params [ "_this" ];
				
		private _Commander = ( effectiveCommander ( vehicle _this ) ) isEqualTo _this;
		if !_Commander exitwith {};
		_this call ODKAI_initializeAirVehicles;
		
	};

	ODKAI_initializeAirVehicles = {			
		params [ "_this" ];
		
		private _AirVeh = vehicle _this;
		private _Group = group _this;
		/*
		if ( count crew _AirVeh < count units _Group ) exitwith {
			( crew _AirVeh ) join grpnull;	
			_this call ODKAI_InitHashGroup;
			[ _this , "DEBUGMinor" , "AirVeh Initialized" ] call ODKAI_SetUnitMemory;
			[ { [ _this , "DEBUGMinor" , "" ] call ODKAI_SetUnitMemory; } , _this , 2 ] call CBA_fnc_waitAndExecute;
		};
		*/

	};

	ODKAI_CheckAirLaserDesignator = {
		params [ "_this" , "_Enemy" ];

		private _GotLaserDesignator = "Laserdesignator_mounted" in ( weapons vehicle _this ); 
		private _GotLaserDesignatorPilot = "Laserdesignator_pilotCamera" in ( vehicle _this weaponsTurret [-1] ); 
		if !( _GotLaserDesignator OR _GotLaserDesignatorPilot ) exitwith {};
		[ _this , _Enemy ] call ODKAI_LaserDesignation;
		[ _this , "DEBUGMain" , "AirVeh Design" ] call ODKAI_SetUnitMemory;
	};

	ODKAI_LaserDesignation = {			
		params [ "_this" , "_Enemy" ];
		
		private _lasers = ( position _Enemy nearObjects [ "LaserTarget" , 50 ] );
		if ( _lasers isEqualTo [] ) then { 
			if ( 
				( side ( vehicle _this ) == WEST ) OR 
				{ ( side ( vehicle _this ) == RESISTANCE ) AND ( WEST getFriend RESISTANCE == 1 ) } 
			) then {
				_ODK_LaserTRG = "LaserTargetW" createVehicle getposATL _Enemy;
			};
			if (
				( side ( vehicle _this ) == EAST ) OR
				{ ( side ( vehicle _this ) == RESISTANCE ) AND ( EAST getFriend RESISTANCE == 1 ) }
			) then {
				_ODK_LaserTRG = "LaserTargetE" createVehicle getposATL _Enemy;
			};		
		} else {
			( _lasers select 0 ) setpos position _Enemy;

		};	
	};