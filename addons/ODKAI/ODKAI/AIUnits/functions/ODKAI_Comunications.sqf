	ODKAI_CommHQPos = {					//apposto
		//Result: 0.0087 ms Cycles: 10000/10000 Code: _Unit call ODKAI_CommHQPos;
		params [ "_this" ];
		
		[ _this , "DEBUGMinor" , "Send Position to HQ" ] call ODKAI_SetUnitMemory;
		if ( isNull objectParent _this ) then {
			_this playmove "Acts_listeningToRadio_in";
			_this playmove "Acts_listeningToRadio_out";
		};
		sleep 2 + random 2;
		[ _this , "DEBUGMinor" , "" ] call ODKAI_SetUnitMemory;					
		if !( alive _this ) exitWith {};
		[ group _this , 20 , getposATL _this ] spawn HQ_FN_SEND_COMM;
	};

	ODKAI_CommHQSpot = {				//apposto
		params [ "_this", "_EnemySpot", "_EnemySpotPos" ];
			
		[ _this , "DEBUGMinor" , "Send SPOT to HQ" ] call ODKAI_SetUnitMemory;
		if ( isNull objectParent _this ) then {
			_this playmove "Acts_listeningToRadio_in";
			_this playmove "Acts_listeningToRadio_out";
		};
		sleep 2 + random 2;
		[ _this , "DEBUGMinor" , "" ] call ODKAI_SetUnitMemory;
		if !( alive _this ) exitWith {};
		[ group _this , 0 , getposATL _this , [ _EnemySpot , _EnemySpotPos ] ] spawn HQ_FN_SEND_COMM;
	};

	ODKAI_CommHQDown = {				//apposto
		params [ "_this", "_KilledBy", "_KilledByPos" ];
		private [ "_this", "_KilledBy", "_KilledByPos" ];
		
		[ _this , "DEBUGMinor" , "Send Unit Down to HQ" ] call ODKAI_SetUnitMemory;
		if ( isNull objectParent _this ) then {
			_this playmove "Acts_listeningToRadio_in";
			_this playmove "Acts_listeningToRadio_out";
		};
		sleep 2 + random 2;
		[ _this , "DEBUGMinor" , "" ] call ODKAI_SetUnitMemory;
		if !( alive _this ) exitWith {};
		[ group _this , 2 , getposATL _this , [ _KilledBy , _KilledByPos ] ] spawn HQ_FN_SEND_COMM;
		
	};