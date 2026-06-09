	//PLAYER SECTION
		if ( hasInterface ) then { [] call ODKAI_PlayerInit; };	

	//PLAYER EXIT ?? NON PUOI FARE UN EXITWITH SOPRA ??
		if ( hasInterface && !isServer ) exitwith {};	
		
	//SERVER SECTION ?? PERCHE' NON DEDICATED ??							
		if ( isServer ) then {				
			[] call ODKAI_ServerInit;
			diag_log "ODKAI START.";
			[] spawn ODKAI_ServerLoop;
		};	
	
		
	
	//ODKAI_AICIRCLELOOP
		ODKAI_UnitControlled = [];
		[] spawn {
			private _sleepTime = 1;	
			while { missionnamespace getvariable [ "ODKAI_LOOP" , true ] } do {
				ODKAI_LOOP2_TimeStart = diag_tickTime;	
				if ( missionnamespace getvariable [ "ODK_ActivateAI" , true ] ) then {
					_Units =  ( allUnits - ODKAI_UnitControlled ) select { local _x };
					_Units = _Units select { !( isplayer _x ) };
					_Units = _Units select { simulationEnabled _x };
					_Units = _Units select { !( ( side _x ) isEqualTo civilian ) };
					_Units = _Units select {  alive _x };
					_Units = _Units select { !( _x getvariable [ "odkai_Disabled" , false ] ) };
					_Units = _Units select { !( isUAVConnected ( vehicle _x ) ) };
					_Units = _Units select { !( vehicle _x getvariable [ "odkai_UAVDisabled" , false ] ) };	
					if !( _Units isEqualTo [] ) then {
						_Units apply {
							diag_log ( str _x + " start AICIRCLE." );
							private _ConsideringUnit = _x;
							_ConsideringUnit execFSM ODK_AI_FSM;
							ODKAI_UnitControlled pushback _ConsideringUnit;
	
						};
					};
				};
				private _timing = ( diag_tickTime - ODKAI_LOOP2_TimeStart );
				uisleep _sleepTime;
			};
		};	