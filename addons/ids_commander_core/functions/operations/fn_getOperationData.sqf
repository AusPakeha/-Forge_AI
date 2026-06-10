/*
    IDS Commander AI - Get Operation Data (v0.1)

    Params:
        0: STRING - OperationID

    Returns:
        HASHMAP - Operation entry or empty hash map
*/

params ["_operationID"];

private _operations = missionNamespace getVariable ["IDS_Operations", createHashMap];

_operations getOrDefault [_operationID, createHashMap]
