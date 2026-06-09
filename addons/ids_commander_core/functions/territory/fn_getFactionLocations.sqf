params
[
    "_factionID"
];

private _result = [];

private _locations =
IDS_WorldDB get "Locations";

{
    if
    (
        (_y get "OwnerFaction")
        isEqualTo
        _factionID
    )
    then
    {
        _result pushBack _y;
    };

}
forEach _locations;

_result