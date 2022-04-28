/*
library for handling dictionary
dictionary is 
[
    ["key", value],
    ["anotherkey", [value1,value2, ..., value_n]]
    ["yet another key", child_dictionary]
]
*/

include <constants.scad>;
/*
    returnType == 0, returns value
    returnType == 1, returns key
    returnType == 2, returns dictionary
*/
function privateGetKVPair(v, key, type = 1, i = 0,  result) = //echo(v=v, key=key, type=type, i=i, result=result)
( result == undef && i < len(v) ?                   //added optimzation.
    privateGetKVPair
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
    : type == undef
    ? result[1]
    : result[type] //[0] returns key, [1] returns value and [2] returns booth
);

function gdv(obj, property) = getDictionaryValue(obj, property);

//functions for modifing dictionary.
function NewGd(x,y,z, move = [0, 0, 0], rotate = [0, 0, 0], color = "LemonChiffon", name = "dictionary") =     
    [ name,
        ["x", x],
        ["y", y],
        ["z", z],
        ["move", move],
        ["rotate", rotate ],
        ["color", color]
    ];

function GdvSetX(properties, newX) =
    [ properties.x ,
        ["x", newX],
        ["y", gdv(properties, "y")],
        ["z",  gdv(properties, "z")],
        ["move",  gdv(properties, "move")],
        ["rotate",  gdv(properties, "rotate") ],
        ["color",  gdv(properties, "color")]
    ];

function GdvSetY(properties, newY) =
    [ properties.x ,
        ["x", gdv(properties, "x")],
        ["y", newY],
        ["z",  gdv(properties, "z")],
        ["move",  gdv(properties, "move")],
        ["rotate",  gdv(properties, "rotate") ],
        ["color",  gdv(properties, "color")]
    ];    

function GdvSetZ(properties, newZ) =
    [ properties.x ,
        ["x", gdv(properties, "x")],
        ["y",  gdv(properties, "y")],
        ["z", newZ],
        ["move",  gdv(properties, "move")],
        ["rotate",  gdv(properties, "rotate") ],
        ["color",  gdv(properties, "color")]
    ];

function GdvSetXY(properties, newX, newY) =
    [ properties.x ,
        ["x", newX],
        ["y", newY],
        ["z",  gdv(properties, "z")],
        ["move",  gdv(properties, "move")],
        ["rotate",  gdv(properties, "rotate") ],
        ["color",  gdv(properties, "color")]
    ];

function GdvSetXYZ(properties, newX, newY, newZ) =
    [ properties.x ,
        ["x", newX],
        ["y", newY],
        ["z",  newZ],
        ["move",  gdv(properties, "move")],
        ["rotate",  gdv(properties, "rotate") ],
        ["color",  gdv(properties, "color")]
    ];    

function getDictionaryValue(v, key) = 
    assert(isVector(v), str("parameter v is not an array. For imported vectors, did you <include file>?"))
    assert(isString(v[0]), str("first element is not a key."))
    let(result = privateGetKVPair(v, key, 1))
    // echo(result = result)
    result;

function getDictionary(v, key) = 
    assert(isVector(v), str("parameter v is not an array."))
    assert(isString(v[0]), str("first element is not a key."))
    let(result = privateGetKVPair(v, key, 2))
    // echo(result = result)
    result;    

// function getDictionaryPathValue(v, keys) = 
//     //assert(isVector(v), str("parameter v is not an array."))
//     //assert(isString(v[0]), str("first element is not a key."))
//     for( i = [0: len(v)-1])
//         let(child = privateGetKVPair(v, key, 0, 0))
//         let(result = privateGetKVPair(v, key, 0, 0))
//         echo(result = result)        

//     result;        

// function dictionaryDepth(v)
function square(size) = [[-size,-size], [-size,size], [size,size], [size,-size]];

    dictionary = [  "animals",
                    [
                        "mamals",
                        ["dog",1],
                        ["cat",2],
                    ],
                    [
                        "Avian",
                        ["bird",3],
                    ],
                    [
                        "Insect",
                        ["bug",4]                        
                    ]
                ];
echo(lenV = len(dictionary));
echo(getDictionaryValue = getDictionaryValue(getDictionary(dictionary, "Avian"), "bird"));  
echo(getDictionary = getDictionary(dictionary, "mamals"));  

// echo(type = type(dictionary[1]));
// echo(fargsEcho("dictionary" , dictionary));
// echo( found = Search("animals" , dictionary));

// echo(square = square(4));
// echo(getChildDictionary = getChildDictionary(dictionary, "cat"));  
// echo(GetDictionary = GetDictionary(dictionary, "animals"));  
echo();
echo();