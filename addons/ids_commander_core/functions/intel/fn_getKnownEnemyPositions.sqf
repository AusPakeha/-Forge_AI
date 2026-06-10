params ["_intelEntries", ["_minConfidence", 20]];

if (typeName _intelEntries != "ARRAY") exitWith {[]};

private _result = [];
{
    if (typeName _x == "HASHMAP") then {
        if ((_x getOrDefault ["Type", ""] ) isEqualTo "EnemyContact") then {
            private _confidence = _x getOrDefault ["Confidence", 0];
            if (_confidence >= _minConfidence) then {
                private _pos = _x getOrDefault ["Position", []];
                if (!(_pos isEqualTo [])) then {
                    _result pushBack _pos;
                };
            };
        };
    };
} forEach _intelEntries;

_result
