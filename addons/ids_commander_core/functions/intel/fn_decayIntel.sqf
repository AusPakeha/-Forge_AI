private _worldDB = missionNamespace getVariable ["IDS_WorldDB", createHashMap];
private _intelDB = _worldDB getOrDefault ["Intel", createHashMap];
private _intelKeys = keys _intelDB;

{
    private _intel = _intelDB get _x;
    private _age = serverTime - (_intel getOrDefault ["TimeStamp", serverTime]);
    private _confidence = (100 - floor (_age / 10)) max 0;
    _intel set ["Confidence", _confidence];

    if ((_confidence <= 0) || (_age > 600)) then {
        _intelDB remove _x;
    } else {
        _intelDB set [_x, _intel];
    };
} forEach _intelKeys;

_worldDB set ["Intel", _intelDB];
missionNamespace setVariable ["IDS_WorldDB", _worldDB, true];
IDS_WorldDB = _worldDB;

true