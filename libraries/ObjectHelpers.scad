/*
    Library of useful helpers to transform vectors into propery bags.
*/

//enums
enWidth = 0;
enDepth = 1; 
enLength = 2;

enX = 0;
enY = 1;
enZ = 2;

function getValue(v, enum) = v[enum];
function setValue(v, enum, value) = 
[
    for(i = [0: 1 : len(v)-1])  i == enum ? value : v[i]
];

function addValue(v, enum, value) = 
[
    for(i = [0: 1 : len(v)-1])  i == enum ? v[i] + value : v[i]
];

function newVector(v, p1, p2, p3) =
[
    p1 == undef ? v[0] : p1, 
    p2 == undef ? v[1] : p2, 
    p3 == undef ? v[2] : p3
];




Test();

module Test() 
{
    assert(testPass("getValue(1)", [0,2,3], getValue(v = [0,2,3], enum = enY))[enY] == 2);
    assert(testPass("setValue(1) = 3", [0,2,3], setValue(v = [0,2,3], enum = enY, value = 3))[enY] == [0,3,3]);
    assert(testPass("addValue(1) + 3", [0,2,3], addValue(v = [0,2,3], enum = enY, value = 3))[enY] == [0,5,3]);

    assert(testPass(" newVector(v = [], p2 = 1, p3 = 3)", [], newVector(v = [], p2 = enY, p3 = 3))[enY] == [undef,enY,3]);
}

function testPass(note, value1, value2) = echo(note = note, input = value1, return = value2) [value1, value2];