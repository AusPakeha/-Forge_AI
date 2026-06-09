




//PLAYERS SETTINGS
   [ "ODKAI_Parachutes",
      "CHECKBOX",
      [ "ENABLE PARACHUTES" , "Enable/Disable automatic uses of spawned parachutes for players" ],
      [ "ODKAI Features" , "ODKAI - Players Settings" ],
      TRUE,
      1, // 
      {  
         params [ "_value" ];
         ODK_GIVE_PARACHUTE = _value;
      } 
   ] call CBA_fnc_addSetting;

//AI SKILLS
   [ "ODKAI_AIcostumSkill",
      "CHECKBOX",
      [ "ENABLE COSTUM SKILLS" , "Enable/Disable costum skills,normaly ODKAI use calculated value foreach units but not snipers" ],
      [ "ODKAI Features" , "ODKAI - AI Skills" ],
      true,
      1, // 
      {  
         params [ "_value" ];
         ODK_COSTUMSKILLS = _value;
      } 
   ] call CBA_fnc_addSetting;
   [ "ODKAI_AIAimAccuracy",
      "SLIDER",
      [ "AIMING ACCURACY" , "Set aiming accuracy of all units" ],
      [ "ODKAI Features" , "ODKAI - AI Skills" ],
      [0,1,0.65,2],
      1,
      {   
         params [ "_value" ];
         ODK_AISKILL_AA = _value;
      } 
   ] call CBA_fnc_addSetting;
   [ "ODKAI_AIAimShake",
      "SLIDER",
      [ "AIMING SHAKE" , "Set aiming shake of all units" ],
      [ "ODKAI Features" , "ODKAI - AI Skills" ],
      [0,1,0.65,2],
      1,
      {   
         params [ "_value" ];
         ODK_AISKILL_ASH = _value;
      } 
   ] call CBA_fnc_addSetting;
   [ "ODKAI_AIAimSpeed",
      "SLIDER",
      [ "AIMING SPEED" , "Set aiming speed of all units" ],
      [ "ODKAI Features" , "ODKAI - AI Skills" ],
      [0,1,0.75,2],
      1,
      {   
         params [ "_value" ];
         ODK_AISKILL_ASP = _value;
      } 
   ] call CBA_fnc_addSetting;
   [ "ODKAI_AIComand",
      "SLIDER",
      [ "COMANDING" , "Set comanding of all units" ],
      [ "ODKAI Features" , "ODKAI - AI Skills" ],
      [0,1,0.85,2],
      1,
      {   
         params [ "_value" ];
         ODK_AISKILL_COM = _value;
      } 
   ] call CBA_fnc_addSetting;
   [ "ODKAI_AIGeneral",
      "SLIDER",
      [ "GENERAL SKILL" , "Set general skill of all units" ],
      [ "ODKAI Features" , "ODKAI - AI Skills" ],
      [0,1,0.85,2],
      1,
      {   
         params [ "_value" ];
         ODK_AISKILL_GEN = _value;
      } 
   ] call CBA_fnc_addSetting;
   [ "ODKAI_AICourage",
      "SLIDER",
      [ "COURAGE" , "Set courage of all units" ],
      [ "ODKAI Features" , "ODKAI - AI Skills" ],
      [0,1,0.85,2],
      1,
      {   
         params [ "_value" ];
         ODK_AISKILL_COU = _value;
      } 
   ] call CBA_fnc_addSetting;
   [ "ODKAI_AIReloadSpeed",
      "SLIDER",
      [ "RELOAD SPEED ACCURACY" , "Set reload speed of all units" ],
      [ "ODKAI Features" , "ODKAI - AI Skills" ],
      [0,1,0.85,2],
      1,
      {   
         params [ "_value" ];
         ODK_AISKILL_RS = _value;
      } 
   ] call CBA_fnc_addSetting;
   [ "ODKAI_AISpotDistance",
      "SLIDER",
      [ "SPOT DISTANCE" , "Set spot distance of all units" ],
      [ "ODKAI Features" , "ODKAI - AI Skills" ],
      [0,1,0.85,2],
      1,
      {   
         params [ "_value" ];
         ODK_AISKILL_SD = _value;
      } 
   ] call CBA_fnc_addSetting;
   [ "ODKAI_AISpotTime",
      "SLIDER",
      [ "SPOT TIME" , "Set spot time of all units" ],
      [ "ODKAI Features" , "ODKAI - AI Skills" ],
      [0,1,0.85,2],
      1,
      {   
         params [ "_value" ];
         ODK_AISKILL_ST = _value;
      } 
   ] call CBA_fnc_addSetting;

//UNITS MEDICAL
   [ "ODKAI_SHOWKILLS",  
      "CHECKBOX",
      [ "Messages AI kill AI " , "Enable to show player messages AI kill AI" ],
      [ "ODKAI Features" , "ODKAI - Units Medical" ],
      true,
      1,
      {  
         params [ "_value" ];
         ODK_SHOWKILLS = _value;
      } 
   ] call CBA_fnc_addSetting;
   [ "ODKAI_AddSmokes",  
      "CHECKBOX",
      [ "ADD FirstAidKit(2) on AI" , "Enable to add FirstAidKit (2) at start on AI inventory" ],
      [ "ODKAI Features" , "ODKAI - Units Medical" ],
      true,
      1,
      {  
         params [ "_value" ];
         ODK_ADDSMOKE = _value;
      } 
   ] call CBA_fnc_addSetting;
   [ "ODKAI_AUTOHEAL",  
      "CHECKBOX",
      [ "ADD AUTOHEAL on AI" , "Enable to use AI Autoheal if have FirstAidKit in inventory" ],
      [ "ODKAI Features" , "ODKAI - Units Medical" ],
      true,
      1,
      {  
         params [ "_value" ];
         ODK_AUTOHEAL = _value;
      } 
   ] call CBA_fnc_addSetting;
   [ "ODKAI_SECONDCHANCEWEST",  
      "CHECKBOX",
      [ "SECOND CHANCE BLUFOR on AI" , "Enable to AI gives a chance not to die the first time. Need FirstAidKit." ],
      [ "ODKAI Features" , "ODKAI - Units Medical" ],
      true,
      1,
      {  
         params [ "_value" ];
         ODK_SECONDCHANCEWEST = _value;
      } 
   ] call CBA_fnc_addSetting;
   [ "ODKAI_SECONDCHANCEEAST",  
      "CHECKBOX",
      [ "SECOND CHANCE OPFOR on AI" , "Enable to AI gives a chance not to die the first time. Need FirstAidKit." ],
      [ "ODKAI Features" , "ODKAI - Units Medical" ],
      true,
      1,
      {  
         params [ "_value" ];
         ODK_SECONDCHANCEEAST = _value;
      } 
   ] call CBA_fnc_addSetting;
   [ "ODKAI_SECONDCHANCEINDEPENDENT",  
      "CHECKBOX",
      [ "SECOND CHANCE INDEPENDENT on AI" , "Enable to AI gives a chance not to die the first time. Need FirstAidKit." ],
      [ "ODKAI Features" , "ODKAI - Units Medical" ],
      true,
      1,
      {  
         params [ "_value" ];
         ODK_SECONDCHANCEINDEPENDENT = _value;
      } 
   ] call CBA_fnc_addSetting;
   [ "ODKAI_SECONDCHANCE",
      "SLIDER",
      [ "SECOND CHANCE in %" , "Gives a chance in %" ],
      [ "ODKAI Features" , "ODKAI - Units Medical" ],
      [ 0 , 100 , 50 , 0 ],
      1,
      {   
         params [ "_value" ];
         ODK_SECONDCHANCE = _value;
      } 
   ] call CBA_fnc_addSetting;

//UNITS FEATURES
   [ "ODKAI_AILaserOn" ,
      "CHECKBOX",
      [ "LASER ON" , "Enable the use of lasers when is night, when wearing NVGs and IR laser is equipped" ],
      [ "ODKAI Features" , "ODKAI - Units Features" ],
      True,
      1,
      {  
         params [ "_value" ];
         ODK_LASERON = _value;
      } 
   ] call CBA_fnc_addSetting;
   [ "ODKAI_AILightOn",
      "CHECKBOX" ,
      [ "Flashlight ON" , "Enable the use of Gun light when is night, and if the weapons module is empty then it adds Flashlights all units" ],
      [ "ODKAI Features" , "ODKAI - Units Features" ],
      True,
      1,
      {  
         params [ "_value" ];
         ODK_TORCHON = _value;
      } 
   ] call CBA_fnc_addSetting;

   [ "ODKAI_AISeeLaser",
      "CHECKBOX",
      [ "SEE LASERS" , "Allow units to see lasers when wearing NVGs" ],
      [ "ODKAI Features" , "ODKAI - Units Features" ],
      True,
      1,
      {  
         params [ "_value" ];
         ODK_SEE_LASER = _value;
      } 
   ] call CBA_fnc_addSetting; 
   [ "ODKAI_AIPercSeeLaser",
      "SLIDER",
      [ "SEE LASERS PROBABILITY" , "Probability units see lasers when wearing NVGs,this cicle every about 1 second" ],
      [ "ODKAI Features" , "ODKAI - Units Features" ],
      [ 0 , 100 , 25 , 0 ],
      1,
      {   
         params [ "_value" ];
         ODK_SEE_LASER_PERC = _value;
      } 
   ] call CBA_fnc_addSetting; 
   [ "ODKAI_AIRangeSeeLaser",
      "SLIDER",
      [ "SEE LASERS RANGE" , "Range for see lasers when wearing NVGs" ],
      [ "ODKAI Features" , "ODKAI - Units Features" ],
      [ 0 , 1500 , 500 , 0 ],
      1,
      {  
         params [ "_value" ];
         ODK_SEE_LASER_RANGE = _value;
      } 
   ] call CBA_fnc_addSetting;
   [ "ODKAI_AIRoll",
      "CHECKBOX",
      [ "UNITS SIDE ROLL" , "Enable Side Roll of Evade based on stance and get Suppression" ],
      [ "ODKAI Features" , "ODKAI - Units Features" ],
      True,
      1,
      {  
         params [ "_value" ];
         ODK_ROLL = _value;
      } 
   ] call CBA_fnc_addSetting;
   [ "ODKAI_AISmokes",
      "CHECKBOX",
      [ "SMOKE GRANADES" , "Enable the use of Smoke Granades of Units Damaged or Suppressed" ],
      [ "ODKAI Features" , "ODKAI - Units Features" ],
      True,
      1,
      {  
         params [ "_value" ];
         ODK_SMOKEGRANADES = _value;
      } 
   ] call CBA_fnc_addSetting;
   [ "ODKAI_AIHandGranades",
      "CHECKBOX",
      [ "HAND GRANADES" , "Enable the use of Hand Granades and IRGrenade" ],
      [ "ODKAI Features" , "ODKAI - Units Features" ],
      True,
      1,
      {  
         params [ "_value" ];
         ODK_HANDGRANADES = _value;
      } 
   ] call CBA_fnc_addSetting;
   [ "ODKAI_AIUseVeh",
      "CHECKBOX",
      [ "UNITS USE VEHICLE FOR MOVEMENTS" , "Enable the use of vehicles nearby for movements" ],
      [ "ODKAI Features" , "ODKAI - Units Features" ],
      True,
      1,
      {  
         params [ "_value" ];
         ODK_USEMOVEMENTSVEHICLE = _value;
      } 
   ] call CBA_fnc_addSetting;
   [ "ODKAI_AIDistanceUseVeh",
      "SLIDER",
      [ "MINIMAL DISTANCE FOR USE VEHICLES FOR MOVEMENTS" , "Minimal distance from current waypoint for allow units to use nearby vehicles" ],
      [ "ODKAI Features" , "ODKAI - Units Features" ],
      [ 100 , 2000 , 500 , 0 ],
	   1,
      {   
         params [ "_value" ];
         ODK_DIST_USEVEHICLE = _value;
      } 
   ] call CBA_fnc_addSetting;
    [ "ODKAI_AIDistanceSeachVeh",
      "SLIDER",
      [ "MINIMAL RANGE FOR SEARCH NEARBY VEHICLES FOR MOVEMENTS" , "Range around leader for search vehicle for movements with vehicles" ],
      [ "ODKAI Features" , "ODKAI - Units Features" ],
      [ 10 , 200 , 200 , 0 ],
	   1,
      {   
         params [ "_value" ];
         ODK_RANGE_USEVEHICLE = _value;
      } 
   ] call CBA_fnc_addSetting;
   [ "ODKAI_AIUseArmedVeh",
      "CHECKBOX",
      [ "USE STATICS NEARBY" , "Enable to use statics nearby" ],
      [ "ODKAI Features" , "ODKAI - Static Weapons" ],
      True,
      1,
      {  
         params [ "_value" ];
         ODK_USEARMEDVEH = _value;
      } 
   ] call CBA_fnc_addSetting;
   [ "ODKAI_AIUseArmedAirVeh",
      "CHECKBOX",
      [ "UNITS PACK STATIC" , "Enable PACK Static Weapons to Backpack." ],
      [ "ODKAI Features" , "ODKAI - Static Weapons" ],
      True,
      1,
      {  
         params [ "_value" ];
         ODK_USEARMEDAIRVEH = _value;
      } 
   ] call CBA_fnc_addSetting;
   [ "ODKAI_AIDeployStatic",
      "CHECKBOX",
      [ "UNITS DEPLOY STATIC" , "Enable to Deploy Static Weapons from Backpack." ],
 	   [ "ODKAI Features" , "ODKAI - Static Weapons" ],
      True,
      1,
      {  
         params ["_value"];
         ODK_EN_DEPLOYSTATIC = _value;
      } 
   ] call CBA_fnc_addSetting;
   [ "ODKAI_AIMines",
      "CHECKBOX",
      ["UNITS MINES","Enable the use all kind of mines."],
 	   ["ODKAI Features" , "ODKAI - Units Features"],
      True,
      1,
      {  
         params ["_value"];
         ODK_EN_DROPMINES = _value;
      } 
   ] call CBA_fnc_addSetting;

   [ "ODKAI_UseArtillery",  
      "CHECKBOX",
      [ "USE DEPLOY DRONES" , "Enable to Deploy any Drones from Backpack" ],
      [ "ODKAI Features" , "ODKAI - Units Features" ],
      true,
      1,
      {  
         params [ "_value" ];
         ODK_USEARTILLERY = _value;
      } 
   ] call CBA_fnc_addSetting;

//STATIC WEAPONS

   [ "ODKAI_AIDistanceUseStatic",
      "SLIDER",
      [ "STATIC TO USE WEAPONS DISTANCE" , "Distance to get into Static Weapons (Mortar,AT,GMG,HMG,AA)" ],
      [ "ODKAI Features" , "ODKAI - Static Weapons" ],
      [ 10 , 300 , 150 , 0 ],
      1,
      {   
         params [ "_value" ];
         ODK_DIST_STATIC = _value;
      } 
   ] call CBA_fnc_addSetting;

   [ "ODKAI_AIDistanceUseArtillery",
      "SLIDER",
      [ "STATIC TO PACK WEAPONS DISTANCE" , "Distance to any pack Weapons (Mortar,AT,GMG,HMG,AA)" ],
      [ "ODKAI Features" , "ODKAI - Static Weapons" ],
      [ 10 , 300 , 50 , 0 ],
      1,
      {   
         params [ "_value" ];
         ODK_DIST_ARTILLERY = _value;
      } 
   ] call CBA_fnc_addSetting;

//LAND VEHICLES
   [ "ODKAI_AIDistanceConvoy",
      "SLIDER",
      [ "DISTANCE CONVOY" , "Set distance between vehicles in the same group in Convoy" ],
      [ "ODKAI Features" , "ODKAI - Land Vehicles" ],
      [10,50,30,0],
      1,
      {   
         params [ "_value" ];
         ODK_DIST_CONVOY = _value;
      } 
   ] call CBA_fnc_addSetting;

   [ "ODKAI_UseStatics",  
      "CHECKBOX",
      [ "DISABLE RADIOPROTOCOL" , "When bots spam radio messages you can off/on radio" ],
      [ "ODKAI Features" , "ODKAI - Units Features" ],
      false,
      1,
      {  
         params [ "_value" ];
         ODK_USESTATICS = _value;
      } 
   ] call CBA_fnc_addSetting;
