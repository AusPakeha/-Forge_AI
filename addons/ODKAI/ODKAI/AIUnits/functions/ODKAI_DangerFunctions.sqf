	
	/*
	comment "0  DCEnemyDetected";
	comment "1  DCFire";
	comment "2  DCHit";
	comment "3  DCEnemyNear";
	comment "4  DCExplosion";
	comment "5  DCDeadBodyGroup";
	comment "6  DCDeadBody";
	comment "7  DCScream";
	comment "8  DCCanFire";
	comment "9  DCBulletClose";
	*/

	ODKAI_Danger = {					
		params [ "_this" , "_dangerCause" ];
		
		switch ( _dangerCause ) do {
			case 1: {
				[ _this , "DEBUGDanger" , "DCFire" ] call ODKAI_SetUnitMemory;
				[ { [ _this , "DEBUGDanger" , "" ] call ODKAI_SetUnitMemory; } , _this , 2 ] call CBA_fnc_waitAndExecute;
			};
			case 2: {
				[ _this , "DEBUGDanger" , "DCHit" ] call ODKAI_SetUnitMemory;
				[ { [ _this , "DEBUGDanger" , "" ] call ODKAI_SetUnitMemory; } , _this , 2 ] call CBA_fnc_waitAndExecute;
			};
			case 3: {
				[ _this , "DEBUGDanger" , "DCEnemyNear" ] call ODKAI_SetUnitMemory;
				[ { [ _this , "DEBUGDanger" , "" ] call ODKAI_SetUnitMemory; } , _this , 2 ] call CBA_fnc_waitAndExecute;
			};
			case 4: {
				[ _this , "DEBUGDanger" , "DCExplosion" ] call ODKAI_SetUnitMemory;
				[ { [ _this , "DEBUGDanger" , "" ] call ODKAI_SetUnitMemory; } , _this , 2 ] call CBA_fnc_waitAndExecute;
			};
			case 5: {
				[ _this , "DEBUGDanger" , "DCDeadBodyGroup" ] call ODKAI_SetUnitMemory;
				[ { [ _this , "DEBUGDanger" , "" ] call ODKAI_SetUnitMemory; } , _this , 2 ] call CBA_fnc_waitAndExecute;
			};
			case 6: {
				[ _this , "DEBUGDanger" , "DCDeadBody" ] call ODKAI_SetUnitMemory;
				[ { [ _this , "DEBUGDanger" , "" ] call ODKAI_SetUnitMemory; } , _this , 2 ] call CBA_fnc_waitAndExecute;
			};
			case 7: {
				[ _this , "DEBUGDanger" , "DCScream" ] call ODKAI_SetUnitMemory;
				[ { [ _this , "DEBUGDanger" , "" ] call ODKAI_SetUnitMemory; } , _this , 2 ] call CBA_fnc_waitAndExecute;
			};
			case 8: {
				[ _this , "DEBUGDanger" , "DCCanFire" ] call ODKAI_SetUnitMemory;
				[ { [ _this , "DEBUGDanger" , "" ] call ODKAI_SetUnitMemory; } , _this , 2 ] call CBA_fnc_waitAndExecute;
			};
			case 9: {
				[ _this , "DEBUGDanger" , "DCBulletClose" ] call ODKAI_SetUnitMemory;
				[ { [ _this , "DEBUGDanger" , "" ] call ODKAI_SetUnitMemory; } , _this , 2 ] call CBA_fnc_waitAndExecute;
			};
			default {};		
		};
	};

	ODKAI_InfantryReaction = {			
		params [ "_this" , "_enemy" ];
		
		if ( abs speed _this == 0 ) then {
			private _escaping = [ _this , "escaping" ] call ODKAI_GetUnitMemory;
			if !_escaping then { [ _this , _Enemy ] spawn ODKAI_Evade; };
			private _throwingSmoke = [ _this , "throwingsmoke" ] call ODKAI_GetUnitMemory;
			if !_throwingSmoke then { [ _this , _Enemy ] spawn ODKAI_Smoke; };
			private _throwingGroupGranade = [ _this , "throwingGranade" ] call ODKAI_GetUnitMemory;
			if !_throwingGroupGranade then { [ _this , _Enemy ] spawn ODKAI_Granade; };
			

		};	
	};

	ODKAI_InfantryReaction1 = {			
		params [ "_this" , "_enemy" ];
		

			private _escaping = [ _this , "escaping" ] call ODKAI_GetUnitMemory;
			if !_escaping then { [ _this , _Enemy ] spawn ODKAI_Evade; };

			

	};
	
	ODKAI_Evade = {						
		params [ "_this" , "_Enemy" ];
		
		if !ODK_ROLL exitWith {};
		private _suppressed = linearConversion [ 0 , 1 , getSuppression _this , 0 , 100 , false ];
		if ( _suppressed > 1 ) then {
			[ _this , "escaping" , true ] call ODKAI_SetUnitMemory;	
			[ _this , "DEBUGDanger" , "Evade" ] call ODKAI_SetUnitMemory;
			[{ [ _this , "DEBUGDanger" , "" ] call ODKAI_SetUnitMemory; } , _this , 3 ] call CBA_fnc_waitAndExecute;	
			_this call ODKAI_LittleMove;
			[{ [ _this , "escaping" , false ] call ODKAI_SetUnitMemory; } , _this , 2 + random 1 ] call CBA_fnc_waitAndExecute;
		};
	};
	
	ODKAI_Smoke = {						
		params [ "_this" , "_Enemy" ];
		if !ODK_SMOKEGRANADES exitWith {};		
		private _damage = damage _this;
		private _suppressed = linearConversion [0, 1, getSuppression _this , 0, 100, false];
		if ( ( _damage > 0.90 ) OR { _suppressed > ( 50 + random 40 ) } ) then {
		if ( random 100 > 85 ) then { 
			[ _this , "throwingsmoke" , true ] call ODKAI_SetUnitMemory;
			[ _this , "DEBUGDanger" , "throwing smoke" ] call ODKAI_SetUnitMemory;
			[{ [ _this , "DEBUGDanger" , "" ] call ODKAI_SetUnitMemory; } , _this , 3 ] call CBA_fnc_waitAndExecute;				
			_distanzaDilancio = 3; 
			_posP = getpos _this; 
			_posT = getpos _Enemy; 
			_fromTo = ( _posP vectorFromTo _posT ) vectorMultiply ( ( vectorMagnitude wind ) + _distanzaDilancio ); 
			_posizioneGranata = _posP vectorAdd ( _fromTo vectorAdd ( wind vectorMultiply -1 ) ); 
			private _magazines = magazinesAmmoFull _this;
			_magazines apply {
				if ( ( ( _x select 0) isKindOf "SmokeShell" ) AND ( _x select 2 ) AND !( "chemlight" in ( toLowerANSI ( _x select 0) ) ) ) then {		
					private _muzzle = ( _x select 4 );
					_this dowatch _posizioneGranata;
					waitUntil { 
						( abs ( getdir _this - ( [ _this , _posizioneGranata ] call BIS_fnc_dirTo ) ) < 8 ) OR 
						{ (abs ( getdir _this - ( [ _this , _Enemy ] call BIS_fnc_dirTo) ) < 8 ) }
					};
					_this forceWeaponFire [ _muzzle , _muzzle ]; 
_this groupChat  format ["Smoke!"];
					[ { [ _this , "throwingsmoke" , false ] call ODKAI_SetUnitMemory; } , _this , 30 + random 20 ] call CBA_fnc_waitAndExecute;
				};
			};
		};
		};

	};
	
	ODKAI_Granade = {					
		params [ "_this" , "_Enemy" ];
		private	_Enemy = ( _this findNearestEnemy getposATL _this );
		if ! ODK_HANDGRANADES exitWith {};
		if ( _Enemy isKindOf "Man" ) then {  
		if ( _this distance2d _Enemy < 45 ) then { 
		private _CanSee = [ _this , _Enemy ] call ODKAI_CheckVisibility;
		if !_CanSee exitWith {};
		[ _this , "throwingGranade" , true ] call ODKAI_SetUnitMemory;
		[ _this , "DEBUGDanger" ,  "throwing Granade" ] call ODKAI_SetUnitMemory;
		[{ [ _this , "DEBUGDanger" , "" ] call ODKAI_SetUnitMemory; } , _this , 3 ] call CBA_fnc_waitAndExecute;	
		[ group _this , "throwingGranade" , true ] call ODKAI_SetGroupMemory;
		private _magazines = magazinesAmmoFull _this;
		_magazines apply {
			private _ammo = getText (configfile >> "CfgMagazines" >> ( _x select 0) >> "ammo" );
			if ( ("grenade" in toLowerANSI _ammo) AND ( _x select 2) AND !("chemlight" in (toLowerANSI( _x select 0) )) ) then {		
				private _muzzle = ( _x select 4);
				_this dowatch _Enemy;
				waitUntil {abs (getdir _this - ([ _this ,_Enemy] call BIS_fnc_dirTo) ) < 50};
				_this forceWeaponFire [ _muzzle,_muzzle]; 
_this groupChat  format ["Grenade take cover!!!"];
				[{ [ _this , "throwingGranade" ,false ] call ODKAI_SetUnitMemory; } , _this , 45 + random 10 ] call CBA_fnc_waitAndExecute;
				[{ [ group _this , "throwingGranade" ,false ] call ODKAI_SetGroupMemory; } , _this , 15 + random 10 ] call CBA_fnc_waitAndExecute;
			};
		};
		};
		};

		if ( _Enemy isKindOf "Man" ) then {  
		if ( _this distance2d _Enemy < 45 ) then {  
		if ( random 100 > 95 ) then { 
		private _CanSee = [ _this , _Enemy ] call ODKAI_CheckVisibility;
		if !_CanSee exitWith {};
		_this dowatch _Enemy;
		_this fire ["IRGrenade","IRGrenade"]; 
		_this forceWeaponFire ["IRGrenade","IRGrenade"];
_this groupChat  format ["IRGrenade in land!!!"];
		};
		};
		};

		if ( _Enemy isKindOf "CAR" ) then {  
		if ( _this distance2d _Enemy < 45 ) then { 
		private _CanSee = [ _this , _Enemy ] call ODKAI_CheckVisibility;
		if !_CanSee exitWith {};
		_this dowatch _Enemy;
		_this fire ["IRGrenade","IRGrenade"]; 
		_this forceWeaponFire ["IRGrenade","IRGrenade"];
_this groupChat  format ["IRGrenade in land!!!"];
		};
		};

		if ( _Enemy isKindOf "tank" ) then {  
		if ( _this distance2d _Enemy < 45 ) then {  
		private _CanSee = [ _this , _Enemy ] call ODKAI_CheckVisibility;
		if !_CanSee exitWith {};
		_this dowatch _Enemy;
		_this fire ["IRGrenade","IRGrenade"]; 
		_this forceWeaponFire ["IRGrenade","IRGrenade"];
_this groupChat  format ["IRGrenade in land!!!"];
		};
		};




	};
	


	ODKAI_He40mm = {					//in lavorazione
		params [ "_this" ];
		private	_Enemy = ( _this findNearestEnemy getposATL _this );
		private _CanSee = [ _this , _Enemy ] call ODKAI_CheckVisibility;
		if ( _Enemy isKindOf "Man" ) then {  
		if !_CanSee exitWith {};
		if ( _this distance2d _Enemy < 45 ) then { 
		if ( random 100 > 50 ) then {  
private _launcher1     = primaryWeapon _this;

_this selectWeapon _launcher1;
_this forceWeaponFire [_launcher1, "FullAuto"];


         	};  
         	};  
         	};  
	};

	ODKAI_LittleMove = {				//apposto
		params [ "_this" ];
		private [ "_TypeWeapon" , "_mvmUp" , "_mvmMiddle" , "_mvmDown" , "_mvm" ];
		/* rfl = fucile pst = pistola Perc = up pknl = middle used playmove because playaction bugged and don't perform moviment effect lag on server */
		
		_TypeWeapon = toLowerANSI ( ( ( currentWeapon _this ) call bis_fnc_itemType ) select 1 );


		if ( ( "binocular" in _TypeWeapon ) OR { "rocketlauncher" in _TypeWeapon } ) exitWith {};
		if ( ( "rifle" in _TypeWeapon ) OR { ( "machinegun" in _TypeWeapon ) OR { "sniperrifle" in _TypeWeapon } } ) then {
			_mvmUp = [ "AmovPercMrunSrasWrflDfl_AmovPercMrunSrasWrflDfr" , "AmovPercMrunSrasWrflDfr_AmovPercMrunSrasWrflDfl" , "AmovPercMevaSrasWrflDfl_AmovPknlMstpSrasWrflDnon" , "AmovPercMevaSrasWrflDfr_AmovPknlMstpSrasWrflDnon" , "AmovPknlMtacSrasWrflDbr" , "AmovPknlMtacSrasWrflDb" , "AmovPknlMtacSrasWrflDbl" , "AmovPercMevaSrasWrflDr" , "AmovPercMevaSrasWrflDfr_AmovPknlMstpSrasWrflDnon" , "AmovPercMevaSrasWrflDl" , "AmovPercMevaSrasWrflDfl_AmovPknlMstpSrasWrflDnon" , "AmovPercMtacSrasWrflDf" , "AmovPercMtacSrasWrflDfl" , "AmovPercMtacSrasWrflDfr" , "AmovPercMtacSrasWrflDl" , "AmovPercMtacSrasWrflDr" , "AmovPercMstpSrasWrflDnon_AadjPpneMstpSrasWrflDleft" , "AmovPercMstpSrasWrflDnon_AadjPpneMstpSrasWrflDright" ];
			_mvmMiddle = [ "AmovPknlMstpSrasWrflDnon_AadjPpneMstpSrasWrflDleft" , "AmovPknlMstpSrasWrflDnon_AadjPpneMstpSrasWrflDright" , "AmovPknlMrunSrasWrflDb" , "AmovPknlMrunSrasWrflDbl" , "AmovPknlMrunSrasWrflDbr" , "AmovPknlMrunSrasWrflDf" , "AmovPknlMrunSrasWrflDfl" , "AmovPknlMrunSrasWrflDfr" , "AmovPknlMrunSrasWrflDl" , "AmovPknlMrunSrasWrflDr" ];
			_mvmDown = [ "AmovPpneMstpSrasWrflDnon_AadjPpneMstpSrasWrflDup" , "AmovPpneMstpSrasWrflDnon_AadjPpneMstpSrasWrflDdown" , "AmovPpneMstpSrasWrflDnon_AmovPpneMevaSlowWrflDl" , "AmovPpneMstpSrasWrflDnon_AmovPpneMevaSlowWrflDr" , "AmovPpneMstpSrasWrflDnon_AadjPpneMstpSrasWrflDright" , "AmovPpneMstpSrasWrflDnon_AadjPpneMstpSrasWrflDleft" ];
		};
		if ( "handgun" in _TypeWeapon ) then {
			_mvmUp = [ "amovPercmrunsraswPercdl" , "amovPercmrunsraswPercdfl" , "amovPercmrunsraswPercdbl" , "amovPercmrunsraswPercdr" , "amovPercmrunsraswPercdfr" , "amovPercmrunsraswPercdbr" ];
			_mvmMiddle = [ "amovpknlmrunsraswPercdl" , "amovpknlmrunsraswPercdfl" , "amovpknlmrunsraswPercdbl" , "amovpknlmrunsraswPercdr" , "amovpknlmrunsraswPercdfr" , "amovpknlmrunsraswPercdbr" ];
			_mvmDown = [ "AmovPpneMstpSrasWPercDnon_AmovPpneMevaSlowWPercDl" , "AmovPpneMstpSrasWPercDnon_AmovPpneMevaSlowWPercDr" , "AmovPpneMstpSrasWPercDnon_AmovPpneMevaSlowWPercDl" , "AmovPpneMstpSrasWPercDnon_AmovPpneMevaSlowWPercDr" , "AmovPpneMstpSrasWrflDnon_AadjPpneMstpSrasWrflDright" , "AmovPpneMstpSrasWrflDnon_AadjPpneMstpSrasWrflDleft"  ];
		};
		if ( ( isnil "_mvmUp" ) OR { ( isnil "_mvmMiddle" ) OR { isnil "_mvmDown" } } ) exitWith {};

		switch toLowerANSI ( stance _this ) do {
			case "stand": { 
				_mvm = selectRandom _mvmUp;
				_this setAnimSpeedCoef 1.15;
				_this playmove _mvm;
				sleep 10;
				_this playMoveNow "AmovPercMstpSrasWrflDnon";

			};
			case "crouch": {
				_mvm = selectRandom _mvmMiddle;
				_this setAnimSpeedCoef 1.15;
				_this playmove _mvm;
				sleep 10;
				_this playMoveNow "AmovPercMstpSrasWrflDnon";
			};
			case "prone": { 
				_mvm = selectRandom _mvmDown;
				_this setAnimSpeedCoef 1.15;
				_this playmove _mvm;
				sleep 10;
				_this playMoveNow "AmovPercMstpSrasWrflDnon";
			};
			default {};		
		};
	};

