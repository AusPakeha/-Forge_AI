params
[
    "_population",
    "_infrastructure",
    "_military"
];

private _score =
(
(_population * 0.3)
+
(_infrastructure * 0.4)
+
(_military * 0.3)
);

_score min 100