{
    private _intel = _y;

    private _age =
    serverTime -
    (_intel get "TimeStamp");

    private _confidence =
    100 -
    (_age / 10);

    _intel set
    [
        "Confidence",
        _confidence
    ];

} forEach _intelDB;