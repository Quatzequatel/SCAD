use <kvpairs.scad>;

/*
    This is a test file for kvpairs.scad. It is not intended to be used as a library.
    It is intended to be used as a test file for kvpairs.scad. It is not intended to be used as a library.
*/
Radius2 = 50;
store = [
    ["X", 10],
    ["Y", 20],
    ["Z", 30],
    ["Radius1", 40],
    ["Radius2", Radius2 / 2],
    ["Color", "brown"],
    ["Move", [10, 20, 30]],
    ["Rotate", [90, 0, 0]]
];

echo(str("Variable = ", kv_to_string(store)));