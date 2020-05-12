/*
library of useful vector functions.
*/

function diff(i, j) = i - j;
function halfDiff(i, j) = diff(i, j) / 2;
function vHalfDiff(v1, v2) = 
[
    for (i = [ 0 : len(v1) - 1 ] ) halfDiff( v1[i], v2[i]) 
];

function vSwitch(v, x, y) = //echo(v = v, x = x, y = y)
[
    for(i = [0 : 1 : len(v)-1]) 
         i == x ? v[y] :
            ((i == y) ? v[x] : v[i] )
    
];

function vSetValue(v, idx, value)=
[
    for(i = [0 : len(v)-1]) 
        (i == idx ? value : v[i])
];

function vGetValue(v, idx)= v[idx];


//append a z value to an [x,y] vector.
function ApendToV(v, value) = 
[
    for(i = [0 : len(v)]) 
        (i == len(v) ? value : v[i])
];

//add value to every element of v.
function vAdd(v, value) = 
[
    for(i = [0 : (len(v) -1) ])
        v[i] + value
];

function vHalf(v) = 
[
    for(i = [0 : len(v) - 1])
        v[i]/2
];

function vAddToAxis(v, axis, value) =
[
    for(i = [0 : len(v)-1]) (i == axis ? v[i] + value : v[i])
];


function testPass(note, value1, value2) = echo(note = note, input = value1, return = value2) [value1, value2];
Test();

module Test() 
{
    assert(testPass("ApendToV(v=[], value = 3)", [], ApendToV([], 3))[1] == [3]);
    assert(testPass("vSetValue(v=[1,2,3], value = 2)", [1,2,3], vSetValue([1,2,3], 2, 1))[1] == [1,2,1]);
    assert(testPass("vSwitch(v=[1,2,3], value = 0,2)", [1,2,3], vSwitch([1,2,3], 0, 2))[1] == [3,2,1]);
}
