	ODKAI_Autonomous = {				
		params [ "_this" ];
		
		private _Commander = ( effectiveCommander ( vehicle _this ) ) isEqualTo _this;
		if !_Commander exitwith {};
		private _AirDrone = ( tolower ( typeOf ( vehicle _this ) ) isKindOf "air" );
		if !( _AirDrone ) exitWith {};  
		private _SpeedUnder200 = getNumber ( configfile >> "CfgVehicles" >> typeof ( vehicle _this ) >> "maxSpeed" ) < 200;
		
		_this call ODKAI_initializeDrone;
		if ( _SpeedUnder200 ) then {
			_this call ODKAI_DartersInCombat;
			_this call ODKAI_DronesFindEnemy;
		}else{
			_this call ODKAI_DronesInCombat;
			_this call ODKAI_DronesFindEnemy;
		};
	};
	
	ODKAI_initializeDrone = {			
		params [ "_this" ];
		
		private _Drone = vehicle _this;
		private _Group = group _this;
		if ( count crew _Drone < count units _Group ) exitwith {
			( crew _Drone ) join grpnull;	
			_this call ODKAI_InitHashGroup;
			[ _this , "DEBUGMinor" , "Darter Initialized" ] call ODKAI_SetUnitMemory;
			[ { [ _this , "DEBUGMinor" , "" ] call ODKAI_SetUnitMemory; } , _this , 2 ] call CBA_fnc_waitAndExecute;	
		};
		if !( isEngineOn _Drone ) then {
			_Drone engineon true; 
			_WaypointIs = waypointType [ _Group , currentWaypoint _Group ];
			if ( _WaypointIs isEqualTo "" ) then {
				private _pos = _Drone getpos [ 50 , 0 ];
				private _wp0 = _Group addWaypoint [ _pos , 1 ];
				_Group setCurrentWaypoint _wp0;
				[ _this , "DEBUGMinor" , "Darter engine on" ] call ODKAI_SetUnitMemory;
				[ { [ _this , "DEBUGMinor" , "" ] call ODKAI_SetUnitMemory; } , _this , 2 ] call CBA_fnc_waitAndExecute;
			};
		};
	};

	ODKAI_DartersInCombat = {			
		params [ "_this" ];
		
		private _Drone = vehicle _this;
		private _Enemy = ( _this findNearestEnemy getposATL _this );
		if ( isnull _Enemy ) exitwith {};
		private _GotLaserDesignator = "Laserdesignator_mounted" in ( weapons vehicle _this );
		if _GotLaserDesignator then {
			[ _this , _Enemy ] call ODKAI_LaserDesignation;
			[ _this , "DEBUGMain" , "Darter Design" ] call ODKAI_SetUnitMemory;
		};
		if ( _Drone distance _Enemy < 50 ) exitwith {};
		_Drone domove ( position _Enemy );
		[ _this , "DEBUGMinor" , "Darter follow enemy" ] call ODKAI_SetUnitMemory;
		[ { [ _this , "DEBUGMinor" , "" ] call ODKAI_SetUnitMemory; } , _this , 2 ] call CBA_fnc_waitAndExecute;		
	};

	ODKAI_DronesInCombat = {			
		params [ "_this" ];
		
		private _Drone = vehicle _this;
		private _Enemy = ( _this findNearestEnemy getposATL _this );
		if ( isnull _Enemy ) exitwith {};
		private _GotLaserDesignator = "Laserdesignator_mounted" in ( weapons vehicle _this );
		if _GotLaserDesignator then {
			[ _this , _Enemy ] call ODKAI_LaserDesignation;
			[ _this , "DEBUGMain" , "Drone Design" ] call ODKAI_SetUnitMemory;
		};
	};

	ODKAI_DronesFindEnemy = {			
		params [ "_this" ];

		private _Drone = vehicle _this;
		private _pos = _Drone getPos [random 300, random 360];
		private _Entities = ( _pos nearEntities 50 ) select { !( ( side _x ) isEqualTo ( side _this ) ) };
		private _Entities = _Entities select { ( _Drone knowsAbout _x ) < 2 };
		private _Entities = _Entities select { ( [ _Drone , _x ] call ODKAI_CheckVisibility ) };
		if ( _Entities isEqualTo [] ) exitWith {};
		_Entities apply {_Drone dowatch _x;};
		[ _Drone , "DEBUGMain" , "Drone Watch Enemy" ] call ODKAI_SetUnitMemory;
	};
