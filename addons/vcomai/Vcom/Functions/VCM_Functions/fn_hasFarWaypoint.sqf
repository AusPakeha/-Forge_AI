/*
  Returns TRUE if the group has any waypoint at all.
*/
params [
  ["_grp", grpNull, [grpNull]]
];

if (isNull _grp) exitWith { false };
if (isNull (leader _grp)) exitWith { false };

// `waypoints` returns array of all WPs. If count > 0 -> has waypoints
(count (waypoints _grp)) > 1
