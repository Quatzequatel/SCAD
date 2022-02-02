/*
library of useful vector functions.
*/
include <constants.scad>;

function diff(i, j) = i - j;
function halfDiff(i, j) = diff(i, j) / 2;
function vHalfDiff(v1, v2) = 
[
    for (i = [ 0 : len(v1) - 1 ] ) halfDiff( v1[i], v2[i]) 
];

function vSwitch(v, x, y) = //echo(vSwitch = v, x = x, y = y)
[
    for(i = [0 : 1 : len(v)-1]) 
         i == x ? v[y] :
            ((i == y) ? v[x] : v[i] )    
];

function privateGetKeyValue(v, key, type, i = 0,  result) = //echo(v=v, key=key, type=type, i=i, result=result)
( result == undef && i < len(v) ?                   //added optimzation.
    privateGetKeyValue
    (
        v = v,
        key = key,
        type = type,
        i = i + 1,
        result = v[i][0] == key
            ? v[i] 
            : v[i] == key ? v[i] 
            : result
    ) 
    : !isVector(result)
    ? result
    : type == 2 
    ? result 
    : type == 0
    ? result[0]
    : result[1] //[0] returns key, [1] returns value and [2] returns booth
);

function vSetValue(v, idx, value)=
[
    for(i = [0 : len(v)-1]) 
        (i == idx ? value : v[i])
];

function vGetValue(v, idx)= v[idx];


/*
    use as a dictionary look up
*/
function getKeyValue(v, key, type) = 
    assert(isVector(v), str("parameter v is not an array."))
    privateGetKeyValue(v, key, type);


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

function vMultiply(v, value) = echo(vMultiply = v, value = value)
[
    for(i = [0 : (len(v) -1) ])
        v[i] * value
];

function vHalf(v) = 
[
    for(i = [0 : len(v) - 1])
        v[i]/2
];

function vAddToAxis(v, axis, value) = 
    let( foo = ISDEBUGEMODE ? fargsEcho("vAddToAxis([0]=v, [1]=axis , [2]=value)", [v, axis, value]) : 0)
    let
    (
        result = [for(i = [0 : len(v)-1]) (i == axis ? v[i] + value : v[i])]
    )
    let( foo = ISDEBUGEMODE ? fargsEcho("vAddToAxis()=> [0]=x, [1]=y, [2]=z", result) : 0)
    result;

function vvAddToAxis(v, axis, value) = 
    let( foo = ISDEBUGEMODE ? fargsEcho("vvAddToAxis([0]=v, [1]=axis , [2]=value)", [v, axis, value]) : 0)
    let
    (
        result = [for(i = [0 : len(v)-1]) 
            vAddToAxis(v = v[i], axis = axis, value = value)]
    )
    let( foo = ISDEBUGEMODE ? fargsEcho("vvAddToAxis()=> []=", result) : 0)
    result;


function getvAxis(v, axis) =
[
    for(i = [0 : len(v)-1]) v[i][axis]
];


function getPointFromValue(v, axis = 0, value) = 
    search(match_value = value, string_or_vector = v, num_returns_per_match = 1, index_col_num = axis );


function getMaxValue(v, axis, i=1, r=[-1000000, -1000000]) =
    (i < len(v) ? getMaxValue(v = v, axis = axis, i = i+1, r = r[axis] < v[i][axis] ? v[i] : r ) : r);

function getMaxValue2(v, axis) = v[getPointFromValue(v, axis, max(getvAxis(v, axis))).x];


function testPass(note, value1, value2) = echo(note = note, input = value1, return = value2) [value1, value2];
Test();

module Test() 
{
    assert(testPass("ApendToV(v=[], value = 3)", [], ApendToV([], 3))[1] == [3]);
    // assert(testPass("vSetValue(v=[1,2,3], value = 2)", [1,2,3], vSetValue([1,2,3], 2, 1))[1] == [1,2,1]);
    // assert(testPass("vSwitch(v=[1,2,3], value = 0,2)", [1,2,3], vSwitch([1,2,3], 0, 2))[1] == [3,2,1]);
    // assert(
    //     testPass
    //         (
    //             "vMultiply(v=[-283.797, 2277.9], value =  0.1)", 
    //             [-283.797, 2277.9], 
    //             vMultiply([-283.797, 2277.9],  0.1)
    //         )
    //         [1] == [-28.3797, 227.79]
    //     );

    squareProperties = 
        [
            [292.1, 292.1], 
            [4, 12.7], 
            [2, 2.08], 
            [2, 2], 
            [2], 
            [true, false, true, false, false, 0, true, false], 
            ["wavetrellis", [10, 50, 0, 2]],
            ["circletrellis", [2, 9, 0, 2]]
        ];

    dictionary = [
                    "dictionary name",
                    ["dog",1],
                    ["cat",2],
                    ["bird",3],
                    ["bug",4],
                    ["squareProperties", squareProperties]
                ];

    points = [[-47.9013, 2265.55], [-63.4829, 2267.13],[-79.0884, 2268.61], [-94.717, 2269.97], [-110.368, 2271.23], [-126.041, 2272.38], [-141.735, 2273.42], [-157.449, 2274.36], [-173.182, 2275.18], [-188.934, 2275.9], [-204.704, 2276.51], [-220.491, 2277], [-236.295, 2277.39], [-252.114, 2277.67], [-267.949, 2277.84], [-283.797, 2277.9], [-299.659, 2277.85], [-315.533, 2277.68], [-331.419, 2277.41], [-347.317, 2277.03], [-363.224, 2276.53], [-379.141, 2275.93], [-395.067, 2275.21], [-411.001, 2274.38], [-426.942, 2273.44], [-442.889, 2272.39], [-458.842, 2271.22], [-474.8, 2269.95], [-490.762, 2268.56], [-506.727, 2267.06], [-522.695, 2265.44], [-538.664, 2263.72], [-554.634, 2261.88], [-570.604, 2259.93], [-586.574, 2257.87], [-602.542, 2255.69], [-618.507, 2253.4], [-634.47, 2251], [-650.429, 2248.48], [-666.383, 2245.85], [-682.331, 2243.11], [-698.273, 2240.26], [-714.209, 2237.29], [-730.136, 2234.21], [-746.054, 2231.01], [-761.963, 2227.71], [-777.862, 2224.29], [-793.749, 2220.75], [-809.625, 2217.1], [-825.487, 2213.34], [-841.337, 2209.47], [-857.172, 2205.48], [-872.991, 2201.38], [-888.795, 2197.16], [-904.582, 2192.83], [-920.351, 2188.39], [-936.102, 2183.84], [-951.834, 2179.17], [-967.545, 2174.39], [-983.236, 2169.49], [-998.905, 2164.49]];
    echo(max = getMaxValue(points, 1));
    echo(value =  vMultiply([-283.797, 2277.9],  0.1));

    echo(circletrellis = getKeyValue(squareProperties, "circletrellis"));
    echo(dictionary=getKeyValue(dictionary, "bug", 0));
    echo(dictionary=getKeyValue(dictionary, "bird", 1));
    echo(dictionary=getKeyValue(dictionary, "dog", 2));
    echo(dictionary=getKeyValue(dictionary, "squareProperties", 2));
    echo(keyValue_of_keyValue=getKeyValue(getKeyValue(dictionary, "squareProperties", 1), "wavetrellis", 1));
    echo(dictionary=getKeyValue(dictionary, "dictionary name", 0));

    assert(testPass("getDictionaryValue(dictionary, 'dog')", "dog", getKeyValue(dictionary, "dog"))[1] == 1);
    assert(testPass("getKeyValue(dictionary, 'bug')", "bug", getKeyValue(dictionary, "bug"))[1] == 4);
    assert
        (
            testPass
                (
                    "getKeyValue(squareProperties, 'wavetrellis')", 
                    "wavetrellis", 
                    getKeyValue(squareProperties, "wavetrellis")
                )[1] ==  [10, 50, 0, 2]
        );
}
