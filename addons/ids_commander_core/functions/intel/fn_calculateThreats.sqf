params ["_commander", "_intelEntries"];

if (typeName _intelEntries != "ARRAY") exitWith {0};

private _threatScore = 0;
{
    if (typeName _x == "HASHMAP") then {
        private _confidence = _x getOrDefault ["Confidence", 0];
        private _age = serverTime - (_x getOrDefault ["TimeStamp", serverTime]);
        private _decay = ((600 - _age) max 0) / 600;
        _threatScore = _threatScore + (_confidence * _decay);
    };
} forEach _intelEntries;

round (_threatScore / 15)
