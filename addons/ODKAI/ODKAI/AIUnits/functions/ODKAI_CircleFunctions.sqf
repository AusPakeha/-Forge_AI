	ODKAI_AI_Init = { 					 
		/*
		ODKAI_AI_Init
		inizialize all parameters by unit
		 - turn on light/laser if night
		 - inizialize multiarray
		 - set unit skill
		 - add smoke granades
		 all sub functions can be finded in function.sqf
		*/	
		
		params [ "_this" ];

		private _Group = group _this;
		private _Vehicle = vehicle _this;
		_this call ODKAI_InitHashUnit;
		
		if ( leader _this isEqualTo _this ) then { 
			_this call ODKAI_InitHashGroup; 		
		};

		private _flashlight = (primaryWeaponItems _this)#1;
		if ( sunorMoon < 0.5 ) then { 
		if ODK_TORCHON then {
		_this enablegunlights "forceOn"; 
		if (!isNil "_flashlight") then {
		if (_flashlight == "") then {
                    _this addPrimaryWeaponItem "acc_flashlight";
                };
		};
		};
		};

		if ODK_COSTUMSKILLS then { 
			_this setSkill [ "aimingAccuracy" , ODK_AISKILL_AA ];
			_this setSkill [ "aimingShake" , ODK_AISKILL_ASH ];
			_this setSkill [ "aimingSpeed" , ODK_AISKILL_ASP ];
			_this setSkill [ "commanding" , ODK_AISKILL_COM ];
			_this setSkill [ "general" , ODK_AISKILL_GEN ];
			_this setSkill [ "courage" , ODK_AISKILL_COU ];
			_this setSkill [ "reloadSpeed" , ODK_AISKILL_RS ];
			_this setSkill [ "spotDistance" , ODK_AISKILL_SD ];
			_this setSkill [ "spotTime" , ODK_AISKILL_ST ];
		} else { 	
			private _TypeWeapon = toLowerANSI ( ( ( currentWeapon _this ) call bis_fnc_itemType ) select 1 );
			if ( "sniperrifle" in _TypeWeapon ) then { 
				_this setSkill [ "aimingAccuracy" , ( 0.8 + ( random 0.1 ) ) ];
				_this setSkill [ "aimingShake" , ( 0.8 + ( random 0.1 ) ) ];
				_this setSkill [ "aimingSpeed" , ( 0.8 + ( random 0.1 ) ) ];
				_this setSkill [ "commanding" , ( 0.8 + ( random 0.1 ) ) ];
				_this setSkill [ "general" , ( 0.8 + ( random 0.1 ) ) ];
				_this setSkill [ "courage" , 0.5 ];
				_this setSkill [ "reloadSpeed" , ( 0.8 + ( random 0.1 ) ) ];
				_this setSkill [ "spotDistance" , 1 ];
				_this setSkill [ "spotTime" , 1 ];
			} else { 
				_this setSkill [ "aimingAccuracy" , ( 0.6 + ( random 0.1 ) ) ];
				_this setSkill [ "aimingShake" , ( 0.6 + ( random 0.1 ) ) ];
				_this setSkill [ "aimingSpeed" , ( 0.8 + ( random 0.1 ) ) ];
				_this setSkill [ "commanding" , ( 0.8 + ( random 0.1 ) ) ];
				_this setSkill [ "general" , ( 0.8 + ( random 0.1 ) ) ];
				_this setSkill [ "courage" , ( 0.7 + ( random 0.1 ) ) ];
				_this setSkill [ "reloadSpeed" , ( 0.8 + ( random 0.1 ) ) ];
				_this setSkill [ "spotDistance" , ( 0.8 + ( random 0.1 ) ) ];
				_this setSkill [ "spotTime" , ( 0.8 + ( random 0.1 ) ) ];
			};
		};
		if ODK_ADDSMOKE then { _this call ODKAI_AddSmoke };
		if ODK_SHOWKILLS then { _this call ODKAI_SHOWKILL };					
		[ _this , "DEBUGMinor" , "Unit Initialized" ] call ODKAI_SetUnitMemory;
		[ { [ _this , "DEBUGMinor" , "" ] call ODKAI_SetUnitMemory; } , _this , 2 ] call CBA_fnc_waitAndExecute;
	};

	ODKAI_LaserDesignationMan = {	
		params [ "_this" , "_Enemy" ];
		private	_Enemy = ( _this findNearestEnemy getposATL _this );
		private [ "_TypeWeapon"];
		_TypeWeapon = toLowerANSI ( ( ( currentWeapon _this ) call bis_fnc_itemType ) select 1 );


		if ( _Enemy isKindOf "Man" ) then {  
		if ( "binocular" in _TypeWeapon ) then {
		if ( _this distance2d _Enemy > 250 ) then { 
		_this forceWeaponFire ["Laserdesignator","Laserdesignator"];
		};
		};
		};

		if ( _Enemy isKindOf "CAR" ) then {  
		if ( "binocular" in _TypeWeapon ) then {
		_this forceWeaponFire ["Laserdesignator","Laserdesignator"];
		};
		};

		if ( _Enemy isKindOf "tank" ) then {  
		if ( "binocular" in _TypeWeapon ) then {
		_this forceWeaponFire ["Laserdesignator","Laserdesignator"];
		};
		};

	};


	ODKAI_AddSmoke = { 	

_this addItem "FirstAidKit";
_this addItem "FirstAidKit";

	};

	ODKAI_SHOWKILL = { 
params ["_unit", "_killer"];

_unit addEventHandler ["killed", {
params ["_unit", "_killer"];

0 = [[_unit, _killer],{
        params [["_unit",objNull,[objNull]],["_killer",objNull,[objNull]]];
        removeAllActions _unit;
        systemChat format ["%2 has killed %1",name _unit,name _killer];
    }] remoteExecCall ["bis_fnc_call", [0,-2] select isDedicated,false];
}];

	};

	ODKAI_AUTOMEDIC = { 			 
IF !ODK_AUTOHEAL exitWith {};
	params [ "_this" , "_Enemy" ];
	private	_Enemy = ( _this findNearestEnemy getposATL _this );	
	private _damage = (_this getHitPointDamage "hitlegs");
	if ( _this distance2d _Enemy > 400 ) then { 
	if ( (_damage > 0.45) || (damage _this > 0.45) ) then
	{
		private _items = (items _this);
		
		if ("FirstAidKit" in _items) then
		{
			_this action ["HealSoldierSelf", _this];
			
		};

		if ("Medikit" in _items) then
		{
			_this action ["HealSoldierSelf", _this];
			
		};

	};
	};	
			
			
	};	



	ODKAI_WEST = { 

if (ODK_SECONDCHANCE > (random 100)) then { 
if (!isServer) exitWith {};
_time = 10 + ( random 15 );
params [["_unit",objNull,[objNull]],["_hp_unit",20,[20]],["_lives_unit",3,[3]],["_downtime_unit",_time,[0]]];
if (side _unit == west) then { 
_hp_orig_unit = 1/_hp_unit;
_hp_curr_unit = _hp_orig_unit;
private _myOwner = owner _unit;

_unit setVariable ["unit_orig_hp",_hp_orig_unit,true];
_unit setVariable ["downtime_unit",_downtime_unit,true];
_unit setVariable ["lives_left_unit",_lives_unit,true];
_unit setVariable ["unit_dam_total",_hp_curr_unit,true];
_unit setVariable ["unit_dam_incr",_hp_curr_unit,true];

_unit removeAllEventHandlers "HandleDamage";

_unit addEventhandler ["HandleDamage",{
params ["_unit","_hitSelection","_damage","_source","_projectile"];

_orig_dam = (_unit getVariable "unit_orig_hp");
_lives_left = (_unit getVariable "lives_left_unit");

_curr_dam = (_unit getVariable "unit_dam_total") + (_unit getVariable "unit_dam_incr");
_unit setVariable ["unit_dam_total",_curr_dam,true];

if (_lives_left < 1) exitWith {_unit removeAllEventHandlers "HandleDamage";};

if ((_projectile=="") or ((_unit getVariable "unit_dam_total")<1)) then {0} else {
    _unit setUnconscious true;

    [_unit,"I was wounded, but survived."] remoteExec ["groupChat" ,0];
    _unit disableAI "ANIM";
    _lives_left = _lives_left - 1;
    _unit setVariable ["lives_left_unit",_lives_left,true]; // Stores the new lives left.
    _unit setVariable ["unit_dam_total",_orig_dam,true]; // Ai back to full health.
    [_unit] Spawn {
    params ["_unit"];
    _downtime_seconds = (_unit getVariable "downtime_unit");
    sleep _downtime_seconds;
    _unit setDamage 0;
    _unit enableAI "ANIM";
    _unit setUnconscious false;
    sleep 1;
    _unit setUnitPos "UP";

    };
}
}];
	
[
    _unit, 
    "Revive NPC", 
    "\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_reviveMedic_ca.paa",  
    "\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_reviveMedic_ca.paa",   
    "(_this distance _target < 4) && (lifeState _target == ""INCAPACITATED"")",                                                      
    "_caller distance _target < 4",
    {},
    {hintsilent format ["Healing Progress :%1 / 24",_this select 4] }, 
    { 
    params ["_target", "_caller", "_actionId", "_arguments"];
    sleep 0.1;
    private _orig_dam = (_target getVariable "unit_orig_hp");
    private _myOwner = _arguments select 0;
    _target setDamage 0;
    0 = [_target, {
        params[ ["_object",objNull,[objNull]] ];
        _object enableAI "ANIM";
        _object setUnconscious false;
        _object setUnitPos "UP";
        _object setCaptive false;
    }] remoteExecCall ["bis_fnc_call", _myOwner];
    _target setVariable ["unit_dam_total",_orig_dam,true];
    0 = [_target,"Thanks, I feel fine again!"] remoteExec ["sidechat" ,[0,-2] select isDedicated,false];
    }, 
    {}, 
    [_myOwner], 
    10,
    1000, 
    false,
    true                                                                        
] remoteExec ["BIS_fnc_holdActionAdd",[0,-2] select isDedicated,_unit];



};
};

	};

	ODKAI_EAST = { 

if (ODK_SECONDCHANCE > (random 100)) then { 
if (!isServer) exitWith {};
_time = 10 + ( random 15 );
params [["_unit",objNull,[objNull]],["_hp_unit",20,[20]],["_lives_unit",3,[3]],["_downtime_unit",_time,[0]]];
if (side _unit == east) then { 
_hp_orig_unit = 1/_hp_unit;
_hp_curr_unit = _hp_orig_unit;
private _myOwner = owner _unit;

_unit setVariable ["unit_orig_hp",_hp_orig_unit,true];
_unit setVariable ["downtime_unit",_downtime_unit,true];
_unit setVariable ["lives_left_unit",_lives_unit,true];
_unit setVariable ["unit_dam_total",_hp_curr_unit,true];
_unit setVariable ["unit_dam_incr",_hp_curr_unit,true];

_unit removeAllEventHandlers "HandleDamage";

_unit addEventhandler ["HandleDamage",{
params ["_unit","_hitSelection","_damage","_source","_projectile"];

_orig_dam = (_unit getVariable "unit_orig_hp");
_lives_left = (_unit getVariable "lives_left_unit");

_curr_dam = (_unit getVariable "unit_dam_total") + (_unit getVariable "unit_dam_incr");
_unit setVariable ["unit_dam_total",_curr_dam,true];

if (_lives_left < 1) exitWith {_unit removeAllEventHandlers "HandleDamage";};

if ((_projectile=="") or ((_unit getVariable "unit_dam_total")<1)) then {0} else {
    _unit setUnconscious true;

    [_unit,"I was wounded, but survived."] remoteExec ["groupChat" ,0];
    _unit disableAI "ANIM";
    _lives_left = _lives_left - 1;
    _unit setVariable ["lives_left_unit",_lives_left,true]; // Stores the new lives left.
    _unit setVariable ["unit_dam_total",_orig_dam,true]; // Ai back to full health.
    [_unit] Spawn {
    params ["_unit"];
    _downtime_seconds = (_unit getVariable "downtime_unit");
    sleep _downtime_seconds;
    _unit setDamage 0;
    _unit enableAI "ANIM";
    _unit setUnconscious false;
    sleep 1;
    _unit setUnitPos "UP";

    };
}
}];



[
    _unit, 
    "Revive NPC", 
    "\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_reviveMedic_ca.paa",  
    "\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_reviveMedic_ca.paa",   
    "(_this distance _target < 4) && (lifeState _target == ""INCAPACITATED"")",                                                      
    "_caller distance _target < 4",
    {},
    {hintsilent format ["Healing Progress :%1 / 24",_this select 4] }, 
    { 
    params ["_target", "_caller", "_actionId", "_arguments"];
    sleep 0.1;
    private _orig_dam = (_target getVariable "unit_orig_hp");
    private _myOwner = _arguments select 0;
    _target setDamage 0;
    0 = [_target, {
        params[ ["_object",objNull,[objNull]] ];
        _object enableAI "ANIM";
        _object setUnconscious false;
        _object setUnitPos "UP";
        _object setCaptive false;
    }] remoteExecCall ["bis_fnc_call", _myOwner];
    _target setVariable ["unit_dam_total",_orig_dam,true];
    0 = [_target,"Thanks, I feel fine again!"] remoteExec ["sidechat" ,[0,-2] select isDedicated,false];
    }, 
    {}, 
    [_myOwner], 
    10,
    1000, 
    false,
    true                                                                        
] remoteExec ["BIS_fnc_holdActionAdd",[0,-2] select isDedicated,_unit];


};	
};
	};

	ODKAI_INDEPEND = { 

if (ODK_SECONDCHANCE > (random 100)) then { 
if (!isServer) exitWith {};
_time = 10 + ( random 15 );
params [["_unit",objNull,[objNull]],["_hp_unit",20,[20]],["_lives_unit",3,[3]],["_downtime_unit",_time,[0]]];
if (side _unit == independent) then { 
_hp_orig_unit = 1/_hp_unit;
_hp_curr_unit = _hp_orig_unit;
private _myOwner = owner _unit;

_unit setVariable ["unit_orig_hp",_hp_orig_unit,true];
_unit setVariable ["downtime_unit",_downtime_unit,true];
_unit setVariable ["lives_left_unit",_lives_unit,true];
_unit setVariable ["unit_dam_total",_hp_curr_unit,true];
_unit setVariable ["unit_dam_incr",_hp_curr_unit,true];

_unit removeAllEventHandlers "HandleDamage";

_unit addEventhandler ["HandleDamage",{
params ["_unit","_hitSelection","_damage","_source","_projectile"];

_orig_dam = (_unit getVariable "unit_orig_hp");
_lives_left = (_unit getVariable "lives_left_unit");

_curr_dam = (_unit getVariable "unit_dam_total") + (_unit getVariable "unit_dam_incr");
_unit setVariable ["unit_dam_total",_curr_dam,true];

if (_lives_left < 1) exitWith {_unit removeAllEventHandlers "HandleDamage";};

if ((_projectile=="") or ((_unit getVariable "unit_dam_total")<1)) then {0} else {
    _unit setUnconscious true;

    [_unit,"I was wounded, but survived."] remoteExec ["groupChat" ,0];
    _unit disableAI "ANIM";
    _lives_left = _lives_left - 1;
    _unit setVariable ["lives_left_unit",_lives_left,true]; // Stores the new lives left.
    _unit setVariable ["unit_dam_total",_orig_dam,true]; // Ai back to full health.
    [_unit] Spawn {
    params ["_unit"];
    _downtime_seconds = (_unit getVariable "downtime_unit");
    sleep _downtime_seconds;
    _unit setDamage 0;
    _unit enableAI "ANIM";
    _unit setUnconscious false;
    sleep 1;
    _unit setUnitPos "UP";

    };
}
}];



[
    _unit, 
    "Revive NPC", 
    "\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_reviveMedic_ca.paa",  
    "\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_reviveMedic_ca.paa",   
    "(_this distance _target < 4) && (lifeState _target == ""INCAPACITATED"")",                                                      
    "_caller distance _target < 4",
    {},
    {hintsilent format ["Healing Progress :%1 / 24",_this select 4] }, 
    { 
    params ["_target", "_caller", "_actionId", "_arguments"];
    sleep 0.1;
    private _orig_dam = (_target getVariable "unit_orig_hp");
    private _myOwner = _arguments select 0;
    _target setDamage 0;
    0 = [_target, {
        params[ ["_object",objNull,[objNull]] ];
        _object enableAI "ANIM";
        _object setUnconscious false;
        _object setUnitPos "UP";
        _object setCaptive false;
    }] remoteExecCall ["bis_fnc_call", _myOwner];
    _target setVariable ["unit_dam_total",_orig_dam,true];
    0 = [_target,"Thanks, I feel fine again!"] remoteExec ["sidechat" ,[0,-2] select isDedicated,false];
    }, 
    {}, 
    [_myOwner], 
    10,
    1000, 
    false,
    true                                                                        
] remoteExec ["BIS_fnc_holdActionAdd",[0,-2] select isDedicated,_unit];



};	
};
	};

	ODKAI_TANK = { 
params [ "_this" ];
private _CanSee = [ _this , _Enemy ] call ODKAI_CheckVisibility;
private _launcher     = secondaryWeapon _this;
private	_Enemy = ( _this findNearestEnemy getposATL _this );
if ( _Enemy isKindOf "Man" ) then {  
if !_CanSee exitWith {};
if ( random 100 > 90 ) then { 


_this setUnitPos "up";
_this selectWeapon _launcher;
_this fire _launcher;








};
};



	};

	ODKAI_DRONE = { 
IF !ODK_USEARTILLERY exitWith {};
params [ "_this" ];
private	_Enemy = ( _this findNearestEnemy getposATL _this );
private _backpack = backpack _this;
if ( _backpack isEqualTo "" ) exitwith {};

if ( random 100 > 95 ) then { 
private _DisplayName = ( toLowerANSI getText ( configfile >> "CfgVehicles" >> _backpack >> "assembleInfo" >> "assembleTo" ) );
if (( "uav" in _DisplayName ) || {("ugv" in _DisplayName )}) then { 
_this playMoveNow "AinvPknlMstpSnonWnonDnon_Putdown_AmovPknlMstpSnonWnonDnon";
private _uav = ( getText (configfile >> "CfgVehicles" >> _backpack >> "assembleInfo" >> "assembleTo") ) createVehicle position _this;
removeBackpack _this;
createVehicleCrew _uav;
_uav engineon true;
_uav setAutonomous true;
_uav domove (getposATL _Enemy);
_this groupChat  format ["Drone is deploy!!!"];
};
};



	};



	ODKAI_ChangeBehaviour = { 			 
		params [ "_this" ];
		private _Group = Group _this;
		private	_Enemy = ( _this findNearestEnemy getposATL _this );
		private _isStatic = ( typeOf ( vehicle _this ) ) isKindOf "StaticWeapon";
		/* OUT OF COMBAT */
			if ( isNull _Enemy ) exitwith { 
				if ( ( behaviour _this ) isEqualTo "COMBAT" ) then { 
					_Group setbehaviour "AWARE";
					_Group setCombatMode "WHITE";
					_Group setFormation "FILE";
					_Group setSpeedMode "NORMAL";
					units _Group apply { _x setUnitPos "UP" };

				};			
			};

		/* IN COMBAT */
			if ( ( ( behaviour _this ) isEqualTo "AWARE" ) OR { ( behaviour _this ) isEqualTo "SAFE" } ) then { 
				/*INFANTRY*/
					if ( isNull objectParent _this ) then { 					//_onFoot
						if ( _Enemy isKindOf "Man" ) then { 
							_Group setbehaviour "COMBAT";
							_Group setCombatMode "RED";
							_Group setFormation "VEE";

						};
						if ( ( _Enemy isKindOf "PLANE" ) OR { _Enemy isKindOf "HELICOPTER" } ) then { 	
							_Group setbehaviour "COMBAT";
							_Group setCombatMode "RED";
							_Group setFormation "VEE";

						};
						if ( _Enemy isKindOf "TANK" ) then { 
							_Group setbehaviour "COMBAT";
							_Group setCombatMode "RED";
							_Group setFormation "VEE";

						};
						if ( ( _Enemy isKindOf "SHIP" ) AND ( ( _Enemy distance _this ) < 400 ) ) then { 
							_Group setbehaviour "COMBAT";
							_Group setCombatMode "RED";
							_Group setFormation "VEE";

						};
						if ( _Enemy isKindOf "CAR" ) then { 
							_Group setbehaviour "COMBAT";
							_Group setCombatMode "RED";
							_Group setFormation "VEE";

						};
					};

				
				/*AIR VEHICLE*/
					private _Vehicle = Vehicle _this;
					if ( ( typeOf _Vehicle ) isKindOf "AIR" ) then { 									
						_Group setbehaviour "COMBAT";
						_Group setCombatMode "RED";									

					};	
				/*TANK VEHICLE*/
					private _Vehicle = Vehicle _this;
					if ( ( typeOf _Vehicle ) isKindOf "TANK" ) then { 									
						_Group setbehaviour "COMBAT";
						_Group setCombatMode "RED";					

					};	
				

			};
	};	

	ODKAI_ReturnFormation = { 			 
		params [ "_this" ];
		private _Group = Group _this;
		private	_Enemy = ( _this findNearestEnemy getposATL _this );
		/* OUT OF COMBAT */
			if ( isNull _Enemy ) exitwith { 
				if ( ( behaviour _this ) isEqualTo "COMBAT" ) then { 
				_this doFollow (leader group _this);

				};			
			};


	};						 





	ODKAI_ArtilleryNearby = { 			

	};

	ODKAI_CheckLoadout = { 				
		params [ "_this" ];

		_this call ODKAI_CheckLoadoutBackpacks;


		
		[ _this , "DEBUGMinor" , "Check Laodout" ] call ODKAI_SetUnitMemory;
		[ { [ _this , "DEBUGMinor" , "" ] call ODKAI_SetUnitMemory; } , _this , 2 ] call CBA_fnc_waitAndExecute;
	};

	ODKAI_CheckLoadoutBackpacks = {
		params [ "_this" ];

		private _backpack = backpack _this;
		if ( _backpack isEqualTo "" ) exitwith {};
		if ( ( ( getNumber ( configfile >> "CfgVehicles" >> _backpack >> "maximumLoad" ) ) isEqualTo 0 ) AND
			 ( getNumber ( configfile >> "CfgVehicles" >> _backpack >> "mass" ) > 179 ) 
		) then {
			//UAV-UGV
			private _DisplayName = ( toLowerANSI getText ( configfile >> "CfgVehicles" >> _backpack >> "displayName" ) );
			if ( ( random 100 > 10 ) AND ( ( "uav" in _DisplayName ) OR { "ugv" in _DisplayName } ) ) then { 
				private _uav = ( getText ( configfile >> "CfgVehicles" >> _backpack >> "assembleInfo" >> "assembleTo" ) ) createVehicle position _this;
				removeBackpack _this;
				createVehicleCrew _uav;
			};
			//DEPLOYABLE STATIC	
			if ( getNumber ( configfile >> "CfgVehicles" >> _backpack >> "assembleInfo" >> "primary" ) isEqualTo 0 ) then {
				[ _this , "GotStaticBase" , true ] call ODKAI_SetUnitMemory;
			};
			private _GetBase = getarray ( configfile >> "CfgVehicles" >> _backpack >> "assembleInfo" >> "base" );
			if ( ( getNumber ( configfile >> "CfgVehicles" >> _backpack >> "assembleInfo" >> "primary" ) isEqualTo 1 ) AND
				 !( _GetBase isEqualTo [] )
			) then {
				[ _this , "GotStaticPrimary" , true ] call ODKAI_SetUnitMemory;
			};
		}; 
	};

	ODKAI_CheckLoadoutLaunchers = {


	};

	ODKAI_CheckLoadoutRemotes = {			

	};
	
	ODKAI_CheckLoadoutMines = {		

	};



	ODKAI_SeeLaser = { 					
		params [ "_this" ];
		private	_Enemy = ( _this findNearestEnemy getposATL _this );
		private _CanSee = [ _this , _Enemy ] call ODKAI_CheckVisibility;
		if ( sunorMoon < 0.5 ) then { 
		if ( _Enemy isKindOf "Man" ) then { 
		if !_CanSee exitWith {};
			if ODK_LASERON then { _this enableIRLasers true; };
		};





		};



		if ( !ODK_SEE_LASER OR 
			{ ( ( random 100 ) > ODK_SEE_LASER_PERC ) OR 
			{ ( hmd _this ) isEqualTo "" } OR 
			{ sunorMoon > 0.5 } } 
		 ) exitWith {}; 
		private _EnemyLaserSee = ( ( position _this ) nearEntities [ [ "MAN" ] , ODK_SEE_LASER_RANGE ] ) select { !( side _x isEqualTo side _this ) };
		_EnemyLaserSee = _EnemyLaserSee select { ( _x isIRLaserOn currentWeapon _x ) };
		if ( _EnemyLaserSee isEqualTo [] ) exitWith {};

 		_EnemyLaserSee apply { 
			_this dowatch _x;
			[ _this , "DEBUGMinor" , "See Laser Origin" ] call ODKAI_SetUnitMemory;
			[ { [ _this , "DEBUGMinor" , "" ] call ODKAI_SetUnitMemory; } , _this , 2 ] call CBA_fnc_waitAndExecute;
 		}; 
	};

	ODKAI_MoveinVehicle = { 			
		params [ "_this" ];
		if ( behaviour _this isEqualTo "COMBAT" ) ExitWith {};
		IF !ODK_USEMOVEMENTSVEHICLE exitWith {};
		private _Group = group _this;
		if ! ( isnull ( assignedVehicle _this ) ) ExitWith {}; 
		private _Destination = ( ( expectedDestination _this ) select 0 );
		if ( isNil "_Destination" ) ExitWith {};
		if ( surfaceIsWater _Destination ) ExitWith {};
		if ( ( _Destination distance position _this < ODK_DIST_USEVEHICLE ) AND !( _Destination call ODKAI_Fix000 ) ) exitWith {};
		private _vehicles = ( nearestObjects [ _this , [ "LandVehicle" , "ship" , "Air" , "Tank"  ] , ODK_RANGE_USEVEHICLE , true ] ) select { 
			!( _x getvariable [ "odkai_VEhDisabled" , false ] ) AND 
			( ( fuel _x ) > 0.1 ) AND 
			!( locked _x isEqualTo 2 ) 
		};
		if ( isnil "_vehicles" ) ExitWith {};
		_vehicles = [ _vehicles , [ _this ] , { _input0 distance _x } , "ASCEND" ] call BIS_fnc_sortBy;
		private _num_Group = count units _Group;
		_vehicles apply	 { 
			if ( ( isNull ( driver _x ) ) AND ( _num_Group <= ( count fullcrew [ _x , "" , true ] ) ) ) ExitWith { 
				_Group addVehicle _x;
				private _vehicle = _x;
				( units _Group ) apply
				{ 	
					[ _x ] OrderGetIn true;
				};
				_num_Group = 0;
				[ _this , "DEBUGMinor" , "1 veh assigned,take it" ] call ODKAI_SetUnitMemory;
				[ { [ _this , "DEBUGMinor" , "" ] call ODKAI_SetUnitMemory; } , _this , 2 ] call CBA_fnc_waitAndExecute;
			};
		};
		if ( _num_Group isEqualTo 0 ) ExitWith {};
		private _vehicles_can_use = [];	
		private _allmaxspeed = [];
		_vehicles apply { 
			if ( ( isNull ( driver _x ) ) AND ( ( count fullcrew [ _x , "" , true ] ) >= 2 ) ) then { 
				_vehicles_can_use pushback _x;
				_num_Group = _num_Group - ( count fullcrew [ _x , "" , true ] );
			};
			if ( _num_Group <= 0 ) ExitWith { 
				_allmaxspeed = [];
				_vehicles_can_use apply
				{ 
					_vehicle = _x;
					_Group addVehicle _vehicle;
					_allmaxspeed pushback ( getNumber ( configfile >> "CfgVehicles" >> typeof _x >> "maxSpeed" ) );
					( units _Group ) apply
					 { 
						[ _x ] OrderGetIn true;
					};
				};
				private _ConvoySpeed = [ _allmaxspeed ] call ODKAI_GetVehSpeed;
				[ _Group , "VehVelocity" , _ConvoySpeed ] call ODKAI_SetGroupMemory;
				[ _this , "DEBUGMinor" , "more veh assigned,take all" ] call ODKAI_SetUnitMemory;
				[ { [ _this , "DEBUGMinor" , "" ] call ODKAI_SetUnitMemory; } , _this , 2 ] call CBA_fnc_waitAndExecute;
			};
		};

	};

	ODKAI_InCombat = { 					
		params [ "_this" ];
		
		_this call ODKAI_UnitPos;
		_this call ODKAI_AirArmedVehicleNearby;	
	};



	ODKAI_UnitPos = { 					
		params [ "_this" ];
		private	_Enemy = ( _this findNearestEnemy getposATL _this );
		private _suppressed = linearConversion [0, 1, getSuppression _this , 0, 100, false];
		private _TypeWeapon = toLowerANSI ( ( ( currentWeapon _this ) call bis_fnc_itemType ) select 1 );
		if ( "sniperrifle" in _TypeWeapon ) exitWith { 
			[ _this , "DEBUGMinor" , "sniper change unit pos" ] call ODKAI_SetUnitMemory;
			[ { [ _this , "DEBUGMinor" , "" ] call ODKAI_SetUnitMemory; } , _this , 2 ] call CBA_fnc_waitAndExecute;
			if ( random 100 > 30 ) then { 
				_this setUnitPos "middle";
			} else { 
				_this setUnitPos "down";
			};

		};
		if ( "rifle" in _TypeWeapon ) exitWith { 
			[ _this , "DEBUGMinor" , "change unit pos" ] call ODKAI_SetUnitMemory;
			[ { [ _this , "DEBUGMinor" , "" ] call ODKAI_SetUnitMemory; } , _this , 2 ] call CBA_fnc_waitAndExecute;
			if ( random 100 > 30 ) then { 
				_this setUnitPos "middle";
			} else { 
				_this setUnitPos "up";
			};
			if ( _suppressed > 1 ) then {
				_this setUnitPos "down";
			};

		};
		if ( "machinegun" in _TypeWeapon ) exitWith { 
			[ _this , "DEBUGMinor" , "change unit pos" ] call ODKAI_SetUnitMemory;
			[ { [ _this , "DEBUGMinor" , "" ] call ODKAI_SetUnitMemory; } , _this , 2 ] call CBA_fnc_waitAndExecute;
			if ( random 100 > 30 ) then { 
				_this setUnitPos "middle";
			} else { 
				_this setUnitPos "up";
			};
			if ( _suppressed > 1 ) then {
				_this setUnitPos "down";
			};

		};
	};

	ODKAI_StaticNearby = { 				

	};

	ODKAI_ArmedVehNearby = { 			
		params [ "_this" ];
		
		if !ODK_USEARMEDVEH exitWith {}; 
		private _isStatic = ( typeOf ( vehicle _this ) ) isKindOf "StaticWeapon";	

		if _isStatic exitWith { 
			private _Rotate = [ _this , "RotateStatic" ] call ODKAI_GetUnitMemory;

			_this call ODKAI_DismountStatic;		
		};
		if ( _this distance _Enemy < 500 ) then {
		if !( assignedVehicleRole _this isEqualTo [] ) exitWith {};
		private _GotAT = [ _this , "GotAT" ] call ODKAI_GetUnitMemory;
		if _GotAT exitwith {};
		private _GotAA = [ _this , "GotAA" ] call ODKAI_GetUnitMemory;
		if _GotAA exitwith {};
								
		private _vehicles = ( nearestObjects [ _this , [ "LandVehicle" , "ship" ] , ODK_DIST_STATIC , true ] ) select { !( _x getvariable [ "odkai_VEhDisabled" , false ] ) };
		_vehicles = _vehicles select { _x emptyPositions "gunner" >= 0 };
		_vehicles = _vehicles select { !( locked _x isEqualTo 2 ) };
		_vehicles = _vehicles select { ( ( fuel _x ) > 0.1 ) };
		_vehicles = _vehicles select { !( ( _x magazinesTurret [ [ 0 ] , false ] ) isEqualTo [] ) };
		_vehicles apply
		 { 
			if ( ( ( _x emptyPositions "gunner" ) > 0 ) AND ( isnull assignedGunner _x ) ) exitWith { 
				_this setUnitPos "UP";
				_this assignAsGunner _x;
				[ _this ] OrderGetIn true;	
				[ _this , "DEBUGMinor" ,  "take Gunner ArmedVehNearby" ] call ODKAI_SetUnitMemory;
				[ { [ _this , "DEBUGMinor" , "" ] call ODKAI_SetUnitMemory; } , _this , 2 ] call CBA_fnc_waitAndExecute;
			};	
			if ( ( ( _x emptyPositions "gunner" ) == 0 ) AND ( ( _x emptyPositions "driver" ) > 0 ) AND ( isnull assignedDriver _x ) ) exitWith { 
				_this setUnitPos "UP";
				_this assignAsDriver _x;
				[ _this ] OrderGetIn true;
				[ _this , "DEBUGMinor" ,  "take Driver ArmedVehNearby" ] call ODKAI_SetUnitMemory;
				[ { [ _this , "DEBUGMinor" , "" ] call ODKAI_SetUnitMemory; } , _this , 2 ] call CBA_fnc_waitAndExecute;
			};	
			if ( ( ( _x emptyPositions "gunner" ) == 0 ) AND ( ( _x emptyPositions "driver" ) == 0 ) AND ( ( _x emptyPositions "commander" ) > 0 ) AND ( isnull assignedCommander _x ) ) exitWith { 
				_this setUnitPos "UP";
				_this assignAsCommander _x;
				[ _this ] OrderGetIn true;
				[ _this , "DEBUGMinor" ,  "take Commander ArmedVehNearby" ] call ODKAI_SetUnitMemory;
				[ { [ _this , "DEBUGMinor" , "" ] call ODKAI_SetUnitMemory; } , _this , 2 ] call CBA_fnc_waitAndExecute;
			};	
		};
	};
	};

	ODKAI_AirArmedVehicleNearby = { 	

	};
	
	ODKAI_LeaderCombatDecision = { 			

	};
		
	ODKAI_CombatHQComunications = { 	

	};

	ODKAI_Flank = { 					

	};


	

	




	ODKAI_GetBuilding = {
		params [ "_this" ];
	
		if !( _this isKindOf "MAN" ) exitwith { objnull };
		private _Position = getposASL _this;
		private _Objects = lineIntersectsWith [ _Position vectorAdd [ 0 , 0 , 6 ] , _Position vectorAdd [ 0 , 0 , -6 ] , _this , objNull , true ];
		if ( _Objects isEqualTo [] ) exitwith { objnull };
		_Building = _Objects select 0;
		if ( ( _Building isKindOf "house" ) AND ( count ( _Building buildingPos -1 ) >= 2 ) ) then { 
			_Building
		} else { 
			objnull
		};
	};

	ODKAI_CheckIsInBuilding = { 	
		params [ "_this" ];
	
		private _Position = getposASL _this;
		private _Objects = lineIntersectsWith [ _Position vectorAdd [ 0 , 0 , 6 ] , _Position vectorAdd [ 0 , 0 , -6 ] , _this , objNull , true ];
		if ( _Objects isEqualTo [] ) exitwith { false };
		_Building = _Objects select 0;
		if ( ( _Building isKindOf "house" ) AND ( count ( _Building buildingPos -1 ) >= 2 ) ) then { 
			true
		} else { 
			false
		};
	};



	ODKAI_DeployFoldStatic = {
		params ["_this"];

		if !ODK_EN_DEPLOYSTATIC exitWith {};
		if ( _this distance _Enemy < 500 ) then {

			//DeployStatics
			private _GotStaticBase = ( units group _this ) findif { [ _x , "GotStaticBase" ] call ODKAI_GetUnitMemory } > 0;
			private _GotStaticPrimary = ( units group _this ) findif { [ _x , "GotStaticPrimary" ] call ODKAI_GetUnitMemory } > 0;
			if !( _GotStaticBase OR _GotStaticPrimary ) exitwith {};
			
			private _deassembling = [ group _this , "DeassemblingStatic" , true ] call ODKAI_GetGroupMemory;
			[{ [ group _this , "DeassemblingStatic" , false ] call ODKAI_SetGroupMemory; } , _this , 6 ] call CBA_fnc_waitAndExecute;
			[_this ] spawn {
				params [ "_this" ];
				( units group _this ) apply {	
					if ( [ _x , "GotStaticBase" ] call ODKAI_GetUnitMemory ) then {
						_x action ["PutBag"];
						[ _x , "GotStaticBase" , false ] call ODKAI_SetUnitMemory;
						[ _this , "DEBUGMinor" , "Put Static Base" ] call ODKAI_SetUnitMemory;
						[ { [ _this , "DEBUGMinor" , "" ] call ODKAI_SetUnitMemory; } , _this , 2 ] call CBA_fnc_waitAndExecute;
					};
				}; 
				sleep 2;
				( units group _this ) apply {	
					if ( [ _x , "GotStaticPrimary" ] call ODKAI_GetUnitMemory ) then {
						private _GetBase = getarray ( configfile >> "CfgVehicles" >> backpack _x >> "assembleInfo" >> "base" );
						private _AllBaseReady = ( position _x nearObjects [ "GroundWeaponHolder" , 40 ] ) select { ( ( backpackCargo _x ) select 0 ) in _GetBase };
						if ( _AllBaseReady isEqualTo [] ) exitWith {};
						private _BaseReady = selectrandom _AllBaseReady;
						_x action [ "Assemble" , _BaseReady ];
_this groupChat  format ["Static is deploy and ready"];	
						[ _this , "DEBUGMinor" , "Unit Asssmbly Static" ] call ODKAI_SetUnitMemory;
						[ { [ _this , "DEBUGMinor" , "" ] call ODKAI_SetUnitMemory; } , _this , 2 ] call CBA_fnc_waitAndExecute;
						[ _x , "GotStaticPrimary" , false ] call ODKAI_SetUnitMemory;
						[ _x , _BaseReady ] spawn {
							params [ "_x" , "_object" ];
							sleep 2;
							deletevehicle _object;
						};
					};
					sleep 2;
				}; 
			};
		} else {
			//FoldStatics
			if !ODK_USEARMEDAIRVEH exitWith {};
			if ( behaviour _this isEqualTo "COMBAT" ) ExitWith {};

			if ( count ( ( units group _this ) select { ( isnull ( unitBackpack _x ) ) AND !( _x isEqualTo leader _x ) } ) < 1 ) exitWith {}; 
			
			private _Statics = ( nearestObjects [ _this , [ "Staticweapon" ] , ODK_DIST_ARTILLERY , true ] ) select { !( _x getvariable [ "odkai_VEhDisabled" , false ] ) };
			_Statics = _Statics select { _x emptyPositions "gunner" > 0 };
			_Statics = _Statics select { ( isNull ( assignedGunner _x ) ) };
			_Statics = _Statics select { !( locked _x isEqualTo 2 ) };
			_Statics = _Statics select { !( ( _x magazinesTurret [ [ 0 ] , false ] ) isEqualTo [] ) };

			if ( _Statics IsEqualTo [] ) exitWith {};
			private _index = _this addEventHandler [ "WeaponDisassembled" , {
				params [ "_this" , "_primaryBag" , "_secondaryBag" ];
				
				private _Units = ( units group _this ) select { ( isnull ( unitBackpack _x ) ) AND !( _x isEqualTo leader _x ) };
				if ( count _Units < 1 ) exitwith { _this removeEventHandler [ "WeaponDisassembled" , _thisEventHandler ]; };
				private _First = _Units select 0;
				private _Second = _Units select 1;
				_First action [ "TakeBag" , _primaryBag ];
				_Second action [ "TakeBag" , _secondaryBag ];
				[ _this , "DEBUGMinor" , "Unit get dismounted static" ] call ODKAI_SetUnitMemory;
				[ { [ _this , "DEBUGMinor" , "" ] call ODKAI_SetUnitMemory; } , _this , 2 ] call CBA_fnc_waitAndExecute;
				[ _First , _Second ] spawn {
					params [ "_First" , "_Second" ];
					sleep 3;
					_First call ODKAI_CheckLoadoutBackpacks;

				};
				_this removeEventHandler [ "WeaponDisassembled" , _thisEventHandler ];
			} ];
			private _deassembling = [ group _this , "DeassemblingStatic" , true ] call ODKAI_GetGroupMemory;
			[ { [ group _this , "DeassemblingStatic" , false ] call ODKAI_SetGroupMemory; } , _this , 3 ] call CBA_fnc_waitAndExecute;
			_this action [ "Disassemble" , ( _Statics select 0 ) ];
			_this groupChat  format ["Static is pack"];

		};
	};

	ODKAI_MinesRoads = {


		if !ODK_EN_DROPMINES exitwith {};
		params [ "_this","_mine" ];
		private	_Enemy = ( _this findNearestEnemy getposATL _this );
		if ( magazines _this isEqualto [] ) ExitWith {};
		private _mines = ( magazines [ _this , false ] ) select { "mine" in ( ( toLowerANSI _x ) ) };
		if ( _mines isEqualto [] ) ExitWith {};



		if ( "APERSTripMine_Wire_Mag" in _mines ) then {
		if ( _Enemy isKindOf "Man" ) then {  
		if ( ( _this distance _Enemy > 50 ) OR { _this distance _Enemy < 150 } ) then { 
		if ( random 100 > 90 ) then { 
		_this playMove "AinvPknlMstpSnonWnonDnon_Putdown_AmovPknlMstpSnonWnonDnon";
		_this fire [ "ClassicMineWireMuzzle" , "ClassicMineWireMuzzle" , "APERSTripMine_Wire_Mag" ];
_this groupChat  format ["Mine is deploy be careful!!!"];

	};
	};
	};
	};

		if ( "APERSMine_Range_Mag" in _mines ) then {
		if ( _Enemy isKindOf "Man" ) then {  
		if ( ( _this distance _Enemy > 50 ) OR { _this distance _Enemy < 150 } ) then { 
		if ( random 100 > 90 ) then { 
		_this playMove "AinvPknlMstpSnonWnonDnon_Putdown_AmovPknlMstpSnonWnonDnon";
		_this fire [ "ClassicMineRangeMuzzle" , "ClassicMineRangeMuzzle" , "APERSMine_Range_Mag" ];
_this groupChat  format ["Mine is deploy be careful!!!"];

	};
	};
	};
	};

		if ( "APERSBoundingMine_Range_Mag" in _mines ) then {
		if ( _Enemy isKindOf "Man" ) then {  
		if ( _this distance _Enemy < 30 ) then { 
		if ( random 100 > 90 ) then { 
		_this playMove "AinvPknlMstpSnonWnonDnon_Putdown_AmovPknlMstpSnonWnonDnon";
		_this fire [ "BoundingMineRangeMuzzle" , "BoundingMineRangeMuzzle" , "APERSBoundingMine_Range_Mag" ];
_this groupChat  format ["Mine is deploy be careful!!!"];

	};
	};
	};
	};

		if ( "ATMine_Range_Mag" in _mines ) then {
		if ( _Enemy isKindOf "LandVehicle" ) then {  
		if ( _this distance _Enemy < 300 ) then { 
		if ( random 100 > 70 ) then { 
		_this playMove "AinvPknlMstpSnonWnonDnon_Putdown_AmovPknlMstpSnonWnonDnon";
		_this fire [ "MineMuzzle" , "MineMuzzle" , "ATMine_Range_Mag" ];
_this groupChat  format ["Mine is deploy be careful!!!"];

	};
	};
	};
	};

		if ( "SLAMDirectionalMine_Wire_Mag" in _mines ) then {
		if ( _Enemy isKindOf "LandVehicle" ) then {  
		if ( _this distance _Enemy < 300 ) then { 
		if ( random 100 > 70 ) then { 
		_this playMove "AinvPknlMstpSnonWnonDnon_Putdown_AmovPknlMstpSnonWnonDnon";
		_this fire [ "DirectionalMineRangeMuzzle" , "DirectionalMineRangeMuzzle" , "SLAMDirectionalMine_Wire_Mag" ];
_this groupChat  format ["Mine is deploy be careful!!!"];

	};
	};
	};
	};


	};

	ODKAI_RequestSuppression = {


	};

	ODKAI_ExpertExplosive1 = {

	};

	ODKAI_ExpertExplosive2 = {



	};