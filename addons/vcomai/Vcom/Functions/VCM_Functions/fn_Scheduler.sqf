private _T1 = diag_ticktime + 1;
private _T2 = diag_ticktime + 13;

waitUntil
{
	// Every 10 seconds
	if (diag_ticktime > _T2) then
	{
		if (Vcm_ActivateAI) then
		{
			{
				if (local _x && {simulationEnabled (leader _x)} && {!(isPlayer (leader _x))} && {(leader _x) isKindOf "Man"}) then
				{
					private _Grp = _x;

					// Attach FSM once (original VCOM behavior)
					if !(_Grp in VcmAI_ActiveList) then
					{
						if !(((units _Grp) findIf {alive _x}) isEqualTo -1) then
						{
							_x call VCM_fnc_SquadExc;
						};
					};

					/* ==============================
					 *  IDLE-NEAR-BUILDING GARRISON CYCLE (CBA-toggle)
					 * ============================== */
					private _idleGarrisonEnabled = missionNamespace getVariable ["VCM_GarrisonIdle", true];
					if (_idleGarrisonEnabled) then
					{
						private _igStateEarly = _Grp getVariable ["vcm_ig_state", "NONE"];
						private _skipIG = false;

						// EARLY EXIT: group still has a waypoint farther than 20 m? -> skip IG
						if (_igStateEarly isNotEqualTo "GARRISONED" && {[_Grp, 20] call VCM_fnc_hasFarWaypoint}) then
						{
							_Grp setVariable ["vcm_ig_state", "MOVING"];
							_Grp setVariable ["VCM_IDLE_NEAR_BLD_T", -1];
							_skipIG = true;
						};

						// EARLY EXIT: group has only 2 alive units -> skip IG
						if (!_skipIG && {_igStateEarly isNotEqualTo "GARRISONED"} && {({alive _x} count (units _Grp)) <= 2}) then
						{
							_Grp setVariable ["vcm_ig_state", "TOO_SMALL"];
							_Grp setVariable ["VCM_IDLE_NEAR_BLD_T", -1];
							_skipIG = true;
						};

						if (!_skipIG) then
						{
							// Bookkeeping vars
							if (isNil {_Grp getVariable "vcm_ig_state"}) then { _Grp setVariable ["vcm_ig_state", "NONE"]; };
							if (isNil {_Grp getVariable "vcm_ig_start"}) then { _Grp setVariable ["vcm_ig_start", 0]; };
							if (isNil {_Grp getVariable "VCM_IG_Delay"}) then { _Grp setVariable ["VCM_IG_Delay", 0]; };
							if (isNil {_Grp getVariable "VCM_IG_ReturnAt"}) then { _Grp setVariable ["VCM_IG_ReturnAt", 0]; };
							if (isNil {_Grp getVariable "VCM_IG_CombatAt"}) then { _Grp setVariable ["VCM_IG_CombatAt", 0]; };
							if (isNil {_Grp getVariable "vcm_ig_home"}) then { _Grp setVariable ["vcm_ig_home", [0,0,0]]; };
							if (isNil {_Grp getVariable "VCM_IG_NextEligible"}) then { _Grp setVariable ["VCM_IG_NextEligible", 0]; };

							private _state        = _Grp getVariable ["vcm_ig_state", "NONE"];
							private _now          = time;
							private _nextEligible = _Grp getVariable ["VCM_IG_NextEligible", 0];
							private _ldr2         = leader _Grp;
							private _addIGCombatHandlers = {
								params ["_grp"];
								{
									private _unit = _x;
									if (alive _unit) then
									{
										private _oldHit = _unit getVariable ["VCM_IG_HitEH", -1];
										if (_oldHit >= 0) then { _unit removeEventHandler ["Hit", _oldHit]; };

										private _hitId = _unit addEventHandler ["Hit", {
											params ["_unit"];
											private _grp = group _unit;
											if (_grp getVariable ["vcm_ig_state", "NONE"] isEqualTo "GARRISONED") then
											{
												private _combatAt = _grp getVariable ["VCM_IG_CombatAt", 0];
												if (_combatAt <= 0) then
												{
													_grp setVariable ["VCM_IG_CombatAt", time + 15];
												};
											};
										}];
										_unit setVariable ["VCM_IG_HitEH", _hitId];
									};
								} forEach units _grp;
							};
							private _removeIGCombatHandlers = {
								params ["_grp"];
								{
									private _unit = _x;
									private _hitId = _unit getVariable ["VCM_IG_HitEH", -1];
									if (_hitId >= 0) then { _unit removeEventHandler ["Hit", _hitId]; _unit setVariable ["VCM_IG_HitEH", -1]; };
								} forEach units _grp;
							};

							if (!isNull _ldr2 && {alive _ldr2}) then
							{
								private _idle2 = (speed _ldr2 < 2) && {!(combatMode _Grp in ["RED"])} && {(behaviour _ldr2) in ["SAFE","AWARE"]};

								// Find nearby enterable building
								private _nearBld = objNull;
								{
									if !((_x buildingPos -1) isEqualTo []) exitWith { _nearBld = _x; };
								} forEach (nearestObjects [_ldr2, ["House","Building"], 35]);

								switch (_state) do
								{
									case "NONE":
									{
										if (_idle2 && {!isNull _nearBld} && {_now >= _nextEligible}) then
										{
											_Grp setVariable ["vcm_ig_start", _now];
											_Grp setVariable ["VCM_IG_Delay", 60 + floor (random 120)];  // Interval 60-180s
											_Grp setVariable ["vcm_ig_state", "WAITING"];
										};
									};

									case "WAITING":
									{
										if (!_idle2 || {isNull _nearBld}) then
										{
											_Grp setVariable ["vcm_ig_state", "NONE"];
										}
										else
										{
											private _start = _Grp getVariable ["vcm_ig_start", _now];
											private _delay = _Grp getVariable ["VCM_IG_Delay", 90];
											if (_now >= (_start + _delay)) then
											{
												// Trigger garrison
												_Grp setVariable ["vcm_ig_home", getPosATL _ldr2];
												_Grp spawn VCM_fnc_GarrisonLight;

												// Stay garrisoned 80..230s unless combat shortens it
												_Grp setVariable ["VCM_IG_ReturnAt", _now + 80 + floor (random 151)];
												_Grp setVariable ["VCM_IG_CombatAt", 0];
												_Grp setVariable ["vcm_ig_state", "GARRISONED"];
												[_Grp] call _addIGCombatHandlers;
											};
										};
									};

									case "GARRISONED":
									{
										private _combatAt = _Grp getVariable ["VCM_IG_CombatAt", 0];
										private _retAt = _Grp getVariable ["VCM_IG_ReturnAt", 0];

										private _combatExitDue = (_combatAt > 0) && {_now >= _combatAt};
										if (_combatExitDue || {_now >= _retAt}) then
										{
											_Grp setVariable ["vcm_ig_state", "NONE"];
											[_Grp] call _removeIGCombatHandlers;
											private _home = _Grp getVariable ["vcm_ig_home", getPosATL _ldr2];
											private _dest = [
												_home, 20, 10, 5, 0, 20, 0, []
											] call BIS_fnc_findSafePos;

											{
												_x enableAI "PATH";
												_x setUnitPos "AUTO";
												if (alive _x && {canMove _x} && {!(_dest isEqualTo [0,0,0])}) then
												{
													private _unitDest = [
														_dest, 3, 12, 3, 0, 20, 0, []
													] call BIS_fnc_findSafePos;
													if (_unitDest isEqualTo [0,0,0]) then { _unitDest = _dest; };
													_x doMove _unitDest;
												};
											} forEach units _Grp;

											if !(_dest isEqualTo [0,0,0]) then
											{
												_ldr2 doMove _dest;
												_Grp setBehaviourStrong "AWARE";
											};

											_Grp setVariable ["VCM_IG_NextEligible", _now + 60];
											_Grp setVariable ["VCM_IG_CombatAt", 0];
										};
									};
								};
							};
						};
					};
					/* ===============Garrison-end=============== */

					/* =============GLOBAL ANTI-FREEZE CHECK (scheduler)======================= */
					private _ldr = leader _Grp;
					if (!isNull _ldr) then
					{
						if (canMove _ldr && {alive _ldr} && {isNull objectParent _ldr}) then
						{
							if !([_ldr] call VCM_fnc_isTurretOrArty) then
							{
								if ((count (waypoints _Grp)) >= 2) then
								{
									private _data = _Grp getVariable ["VCM_LastMoveCheck", [getPosATL _ldr, time]];
									private _lastPos  = _data#0;
									private _lastTime = _data#1;
									private _curPos   = getPosATL _ldr;

									if ((_ldr distance2D _lastPos) < 3 && {time - _lastTime > 60}) then
									{
										_ldr switchMove "";
										_ldr playActionNow "STOP";

										private _dir = random 360;
										private _newPos = _curPos vectorAdd [(sin _dir)*2, (cos _dir)*2, 0];
										if (!surfaceIsWater _newPos) then { _ldr setPosATL _newPos; };

										_Grp setBehaviourStrong "AWARE";
										_Grp setFormation "WEDGE";
										_Grp setSpeedMode "NORMAL";
										{ if (canMove _x) then { _x doFollow _ldr; }; } forEach (units _Grp);

										if (VCM_DebugFSM) then
										{
											systemChat format [
												"[VCOM] Anti-freeze: %1 (leader %2) reset & nudged 2 m.",
												groupId _Grp, name _ldr
											];
										};
									};

									_Grp setVariable ["VCM_LastMoveCheck", [_curPos, time]];
								};
							};
						};
					};
					/*-----Antifreeze-end----*/

					/*-----Group regroup check-----*/
                    if (!isPlayer (leader _Grp)) then
                    {
                        private _ldr = leader _Grp;
                        {
                            if ((leader _Grp distance2D _x) > 200 && {canMove _x}) then
                            {
                                _x doFollow _ldr;
                                if (VCM_DebugFSM) then
                                {
                                    systemChat format [
                                        "[VCOM] %1 re-formed to %2 (was %.0fm away)",
                                        name _x, name _ldr, _ldr distance2D _x
                                    ];
                                };
                            };
                        } forEach (units _Grp);
                    };
                    /*-----Group regroup-end-----*/

				};
			} forEach allGroups;
		};
		_T2 = diag_ticktime + 10;
	};
	sleep 1;
	false;
};
