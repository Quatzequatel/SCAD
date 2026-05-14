include <constants.scad>;
use <kvpairs.scad>;

/*
    This is a test file for kvpairs.scad. It is not intended to be used as a library.
    It is intended to be used as a test file for kvpairs.scad. It is not intended to be used as a library.
*/
Radius2 = 50;
store = [
    ["name", "quatz"],
    ["X", 10],
    ["Y", 20],
    ["Z", 30],
    ["Radius1", 40],
    ["Radius2", Radius2 / 2],
    ["Color", "brown"],
    ["Move", [10, 20, 30]],
    ["Rotate", [90, 0, 0]]
];

echo(store = store);
echo(name = kv_get(store, "name"));
echo(X = kv_get(store, "X"));
echo(set = kv_set(store, "size", 100));

debugEcho("store", store, true);

/*
OpenSCAD does not have a native dictionary data structure. 
This library provides a way to create and manipulate dictionaries using vectors. 

OpenSCAD is a functional programming language, which means that it does not have variables or mutable state.
This library provides a way to create and manipulate dictionaries using vectors, 
which can be used to store and retrieve data in a way that is similar to how dictionaries work in other programming languages.
*/
//the eaiest way to create a new store is to merge a new store with the old store.
// kv_merge will merge two stores together. If there are duplicate keys, 
// the values from the new store will overwrite the values from the old store.
// key order is not guaranteed to be preserved.
store2 = kv_merge(store, [["X", 20], ["Y", 40], ["Z", 60], ["size", 100], ["Color", "blue"]]);
debugEcho("store2", store2, true);
