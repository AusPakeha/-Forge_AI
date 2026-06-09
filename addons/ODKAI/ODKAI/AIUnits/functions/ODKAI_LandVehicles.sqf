	ODKAI_LandVehicle = {				
		params [ "_this" , "_isAutonomous" , "_isDisarmed" ];
				

		
		if ( !( _isAutonomous ) AND ( _isDisarmed ) ) then {
			_this  call ODKAI_VehUnload; 
		};
		private _Commander = ( effectiveCommander ( vehicle _this ) ) isEqualTo _this;
		if !_Commander exitwith {};
		
		if ( count ( ( crew ( vehicle _this ) ) select { alive _x } ) == 0 ) exitwith {};
				

		_this call ODKAI_VehConvoy;
	};

	ODKAI_RotateStatic = { 				 

	};

	ODKAI_DismountStatic = { 			 
		params [ "_this" ];
		
		private _vehicle = vehicle _this;
		private _Enemy = ( _this findNearestEnemy getposATL _this );
		//[ "DISMOUNT " + STR _Enemy , "ODKAI_AICIRCLE" ] call ODKAI_LOG;

		if ( ( waypointType [ group _this , currentWaypoint group _this ] ) isEqualTo "HOLD" ) exitwith {};
		private _magazine = ( ( _vehicle magazinesTurret [ 0 ] ) select 0 );
		if ( ( isNull _Enemy ) OR { isnil "_magazine" } ) exitwith { 
			//[ str _vehicle + " non ci sono munizioni o nemici.DISMOUNT" , "ODKAI_AICIRCLE" ] call ODKAI_LOG;
			_this leaveVehicle _Vehicle;
			[ _this ] OrderGetIn false;
			moveOut _this;
		};	

	};
	
	ODKAI_VehUnload = {	
		params [ "_this" ];
		
		private _Vehicle = vehicle _this;			
		private _inCombat = toLowerANSI ( behaviour _this ) isEqualTo "combat";
		private _destination = position _this distance ( waypointPosition [ group _this , currentWaypoint group _this ] );
		
		if _inCombat then {
			if ( speed _Vehicle > 7 ) exitWith { _Vehicle forceSpeed 0; };
			_this leaveVehicle _Vehicle;
			[ _this ] orderGetIn false;
			moveOut _this;
			_this forcespeed -1;
			[ _this , "DEBUGMinor" ,  "Move out veh in combat" ] call ODKAI_SetUnitMemory;
			[ { [ _this , "DEBUGMinor" , "" ] call ODKAI_SetUnitMemory; } , _this , 2 ] call CBA_fnc_waitAndExecute;
		} else {
			if ( ( _destination < 50 ) AND ( count ( waypoints group _this ) <= 2 ) ) then {
				if ( abs speed _Vehicle > 3 ) exitWith { _Vehicle forceSpeed 0; };
				_this leaveVehicle _Vehicle;
				[ _this ] orderGetIn false;
				moveOut _this;
				_this forcespeed -1;
				[ _this , "DEBUGMinor" ,  "Move out veh not in combat" ] call ODKAI_SetUnitMemory;
				[ { [ _this , "DEBUGMinor" , "" ] call ODKAI_SetUnitMemory; } , _this , 2 ] call CBA_fnc_waitAndExecute;
			};
		};
	};
	
	ODKAI_VehTakeGunner = {
		params [ "_this" ];
		
		private _Vehicle = vehicle _this;
		if ( alive Gunner _Vehicle ) exitwith {};
		if ( count ( ( crew _vehicle ) select { alive _x } ) == 1 ) then {
			MoveOut _this; 
			_this moveInGunner _Vehicle;
			[ _this , "DEBUGMinor" , ( "Driver VehTakeGunner " + str _Vehicle ) ] call ODKAI_SetUnitMemory;
			[ { [ _this , "DEBUGMinor" , "" ] call ODKAI_SetUnitMemory; } , _this , 2 ] call CBA_fnc_waitAndExecute;
		} else {
			_man = selectRandom ( ( crew _vehicle - [ driver _vehicle ] ) select { _x in _vehicle } );
			MoveOut _man; 
			_man moveInGunner _Vehicle;
			[ _man , "DEBUGMinor" ,  ( "Any VehTakeGunner " + str _Vehicle ) ] call ODKAI_SetUnitMemory;
			[ { [ _man , "DEBUGMinor" , "" ] call ODKAI_SetUnitMemory; } , _man , 2 ] call CBA_fnc_waitAndExecute;
		};
	};

	ODKAI_VehCanGo = {				
		params ["_this"];
		
		[group _this , "VehCanGo" , false ] call ODKAI_SetGroupMemory;
		[{ [ group _this , "VehCanGo" , true ] call ODKAI_SetGroupMemory; } , _this , 2 ] call CBA_fnc_waitAndExecute;
		private _Vehicle = vehicle _this;
		private _Group = group _this;
		if ( unitReady _Vehicle ) exitWith {};
		if ( count ( waypoints _Vehicle ) == 0 ) exitWith {};
		if ( abs speed _vehicle == 0 ) exitwith {
			_Group setCurrentWaypoint [ _Group , 0 ];
		};
		if ( currentWaypoint _Group == 0 ) then {
			_Group setCurrentWaypoint [ _Group , 1 ];
		};
		[ { [ _this , "DEBUGMinor" , "" ] call ODKAI_SetUnitMemory; } , _this , 2 ] call CBA_fnc_waitAndExecute;
	};

	ODKAI_VehConvoy = {				
		params [ "_this" ];

		private _Vehicles = [];
		private _allmaxspeed = [];
		private _Group = group _this;

		if ( abs speed vehicle _this > 0 ) exitwith {};
		( units _group ) apply { 
			_Vehicles pushBackUnique ( assignedVehicle _x );
			_allmaxspeed pushBackUnique ( getNumber ( configfile >> "CfgVehicles" >> typeof _x >> "maxSpeed" ) );
		};
		if ( count _Vehicles == 1 ) exitWith {
			private _gotGroupLimit = [ _Group , "VehConvoySpeed" ] call ODKAI_GetGroupMemory;
			if ( _gotGroupLimit != 0 ) exitWith {};
			_ConvoySpeed = ( getNumber ( configfile >> "CfgVehicles" >> typeof vehicle _this >> "maxSpeed" ) ) * 0.85;
			[ _Group , "VehConvoySpeed" , _ConvoySpeed ] call ODKAI_SetGroupMemory;
			vehicle _this limitspeed _ConvoySpeed; 
			vehicle _this setConvoySeparation ODK_DIST_CONVOY;
			[ _this , "DEBUGMinor" , "Initilize 1 veh Convoy" ] call ODKAI_SetUnitMemory;
		};
		private _gotGroupLimit = [ _Group , "VehConvoySpeed" ] call ODKAI_GetGroupMemory;
		if ( _gotGroupLimit != 0 ) exitWith {};
		private _ConvoySpeed = [ _allmaxspeed ] call ODKAI_GetVehSpeed;
		[ _Group , "VehConvoySpeed" , _ConvoySpeed ] call ODKAI_SetGroupMemory;
		_Vehicles apply { 
			_x limitspeed _ConvoySpeed; 
			_x setConvoySeparation ODK_DIST_CONVOY;
		};
		[ _this , "DEBUGMinor" , "Initilize more veh Convoy" ] call ODKAI_SetUnitMemory;
		[ { [ _this , "DEBUGMinor" , "" ] call ODKAI_SetUnitMemory; } , _this , 2 ] call CBA_fnc_waitAndExecute;
	};

	ODKAI_GetVehSpeed = {				
		params [ "_allmaxspeed" ];
		
		_allmaxspeed sort true;
		private _ConvoySpeed = ( _allmaxspeed select 0 ) * 0.85;
		_ConvoySpeed
	};
	
	ODKAI_CheckLaserDesignator = {
		params [ "_this" , "_Enemy" ];

		if ( vehicle _this emptyPositions "commander" != 0 ) exitwith {};
		private _GotLaserDesignator = "Laserdesignator_vehicle" in ( vehicle _this weaponsTurret [1] );
		if !_GotLaserDesignator exitwith {};
		[ _this , _Enemy ] call ODKAI_LaserDesignation;
	};
