	
	ODKAI_InitHashGroup = {				
		params [ "_this" ];
		
		private _check = ( group _this ) getvariable "ODKAI_HashMap";
		if !( isnil "_check" ) exitwith {};
		
		private _Group = group _this;
		_Group setvariable [ "ODKAI_HashMap" ,createHashMapFromArray [
			[ "GroupSpotted" , [] ], 
			[ "EnemySpot" , Objnull ], 
			[ "EnemySpotPos" , [0,0,0] ],
			[ "KilledBy" , Objnull ],
			[ "KilledByPos" , [0,0,0] ],
			[ "throwingGranade" , false ],
			[ "DropMines" , false ],
			[ "GotRemote" , false ],
			[ "GotMineAT" , false ],
			[ "Flank" , false ],
			[ "Destroy" , false ],
			[ "InDestroy" , false ],
			[ "Clear" , false ],
			[ "InClear" , false ],
			[ "BuildingCover" , false ],
			[ "InBuildingCover" , false ],
			[ "BuildingCoverBuilding" , Objnull ],
			[ "Flanked" , false ],
			[ "FlankedDir" , 0 ],
			[ "VehCanGo" , true ],
			[ "VehVelocity" , 0 ],
			[ "VehConvoySpeed" , 0 ],
			[ "DeassemblingStatic" , false ]
		] ];
	};

	ODKAI_SetGroupMemory = {			
		//[ group _this , "InClear" , true ] call ODKAI_SetGroupMemory;
		params [ "_group" , "_key" , "_value" ];

		( _group getVariable "ODKAI_HashMap" ) set [ _key , _value ];
	};

	ODKAI_GetGroupMemory = {			
		//[ group _this , "InClear" ] call ODKAI_GetGroupMemory;
		params [ "_group" , "_key" ];
		
		//( _group getVariable "ODKAI_HashMap" ) getOrDefault [_key, "NotFound" ];
		( _group getVariable "ODKAI_HashMap" ) get _key
	};

	ODKAI_InitHashUnit = {				
		params [ "_this" ];
		
		_this setvariable [ "ODKAI_HashMapUnit" , createHashMapFromArray [
			[ "FSM" , Objnull ],
			[ "throwingsmoke" , false ],
			[ "throwingGranade" , false ],
			[ "DropMines" , false ],
			[ "escaping" , false ],
			[ "RotateStatic" , false ],
			[ "TheStatic" , objnull ],
			[ "GotRemote" , false ],
			[ "RemoteCharge" , [] ],
			[ "GotMineAP" , false ],
			[ "MineChargeAP" , [] ],
			[ "GotMineAT" , false ],
			[ "MineChargeAT" , [] ],
			[ "InDestroyExp" , false ],
			[ "GotStaticBase" , false ],
			[ "GotStaticPrimary" , false ],
			[ "InBuildingCover" , false ],
			[ "GotAA" , false ],
			[ "GotAT" , false ],
			[ "GotAC" , false ],
			[ "DEBUGMain" , "" ],
			[ "DEBUGMinor" , "" ],
			[ "DEBUGDanger" , "" ]
		] ];
	};

	ODKAI_SetUnitMemory = {					
		//[ _this , "InDestroyExp" , true ] call ODKAI_SetUnitMemory;
		params [ "_this" , "_key" , "_value" ];

		( _this getVariable "ODKAI_HashMapUnit" ) set [ _key , _value ];
	};

	ODKAI_GetUnitMemory = {					
		//[ _this , "InDestroyExp" ] call ODKAI_GetUnitMemory;
		params [ "_this" , "_key" ];

		//( _this getVariable "ODKAI_HashMapUnit" ) getOrDefault [ _key , "NotFound" ];
		( _this getVariable "ODKAI_HashMapUnit" ) get _key
	};

	ODKAI_CheckVisibility = {			
		params [ "_this" , "_Target" ];
		_CanSee = ( [ vehicle _this , "VIEW" , vehicle _Target ] checkVisibility [ eyePos vehicle _this , eyePos _Target ] ) > 0.5;
		_CanSee
	};

	ODKAI_getflags = {					
		private _Usage = _this select 0;
		_Usage = _Usage splitString "+";
		_Usage = _Usage apply { call compile _x };
		_Usage
	};
	
	ODKAI_Fix000 = {						
		params [ "_posX" , "_posY" , "_posZ" ];
		
		if ( ( _posX isEqualTo 0 ) AND ( _posY isEqualTo 0 ) ) then { true } else { false };  
	};
	