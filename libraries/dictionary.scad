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
    returnType == 1, returns key or simple list.
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

//short alias for getDictionaryValue().
// When dictionary value is single value use {gdv(list, lable)} syntax,
// When dictionary value is single dimension list use {gdv(list, lable)[i]} syntax,
// When dictionary value is multiple dimension list then use {gda(list, lable)[i]} syntax,
// Note gdv vs. gda.
function gdv(list, lable) = getDictionaryValue(list, lable);
function gda(list, lable) = getDictionary(list, lable);

/*
    getDictionaryValue where
    v is a vector with a string as the first element.
    key is the lookup key. NOTE key must unique and not a sub string of a previous key.
    Returned is the value of key label.
*/
function getDictionaryValue(v, key) = 
    assert(isVector(v), str("parameter v is not an array. For imported vectors, did you <include file>?"))
    assert(isString(v[0]), str("first element is not a key."))
    let(result = privateGetKVPair(v, key, 1))
    // echo(result = result)
    result;

/*
    Use getDictionaryValue when the returned values is a multiple dimension list.
    getDictionaryValue where
    v is a vector with a string as the first element.
    key is the lookup key. NOTE key must unique and not a sub string of a previous key.
    Returned is the value of key label.
*/
function getDictionary(v, key) = 
    assert(isVector(v), str("parameter v is not an array."))
    assert(isString(v[0]), str("first element is not a key."))
    let(result = privateGetKVPair(v, key, 2))
    // echo(result = result)
    result; 

//functions for modifing dictionary (Data Object).

//function which returns a standard Data Object Dictionary.
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

module drawSquare(properties, center = false)
{
    square(size=[gdv(properties, "x"), gdv(properties, "y")], center=center);    
}

module drawCube(properties, center = false)
{
    linear_extrude(gdv(properties, "z"))
    square(size=[gdv(properties, "x"), gdv(properties, "y")], center=middle);    
}

/*
    locations is a dictionary, 
    where label is element of vector[x,y,z]
    usage => moveTo(locations, "p1") childern();
*/
module moveTo(properties, label)
{
    translate(gdv(properties, label)) children();
}

// use when center=true and want to have corner on [0,0]
module moveToOrigin(properties) 
{
    translate([gdv(properties, "x")/2, gdv(properties, "y")/2]) children();
}

//use to move back to xy center. good prior to any rotations.
module moveToCenter(properties) 
{
    translate([-gdv(properties, "x")/2, -gdv(properties, "y")/2]) children();
}

//use to move cube back to [0, 0, 0]
module moveTo3D_Origin(properties) 
{
    translate([gdv(properties, "x")/2, gdv(properties, "y")/2, gdv(properties, "z")/2]) children();
}

module apply_X_Move(properties) 
{
    translate([gdv(properties, "x"), 0, 0]) children();
}

module apply_Y_Move(properties) 
{
    translate([0, gdv(properties, "y"), 0]) children();
}

module apply_Z_Move(properties) 
{
    translate([0, 0, gdv(properties, "z")]) children();
}

/*
    properties is standard object dictionary.
    template:
        object = 
        [ "verbose description",
            ["x", convert_in2mm(1.75)],
            ["y", convert_in2mm(3.5)],
            ["z", convert_in2mm(58)],
            ["move", [100, 50, 0]],
            ["rotate", [ 0, 90, 0] ],
            ["color", "LightSlateGray"]
        ];   
    usage =>  applyMove(object) applyRotate(object) applyExtrude(object) drawSquare(object);
*/
module applyMove(properties)
{
    translate(gdv(properties, "move")) children();
}

/*
    properties is standard object dictionary.
    template:
        object = 
        [ "verbose description",
            ["x", convert_in2mm(1.75)],
            ["y", convert_in2mm(3.5)],
            ["z", convert_in2mm(58)],
            ["move", [100, 50, 0]],
            ["rotate", [ 0, 90, 0] ],
            ["color", "LightSlateGray"]
        ];   
    usage =>  applyRotate(object) drawCube(object);
*/
module applyRotate(properties)
{
    rotate(gdv(properties, "rotate")) children();
}

/*
    properties is standard object dictionary.
    template:
        object = 
        [ "verbose description",
            ["x", convert_in2mm(1.75)],
            ["y", convert_in2mm(3.5)],
            ["z", convert_in2mm(58)],
            ["move", [100, 50, 0]],
            ["rotate", [ 0, 90, 0] ],
            ["color", "LightSlateGray"]
        ];   
    usage =>  applyColor(object) drawCube(object);
*/
module applyColor(properties, alpha  = 0.5)
{
    color(gdv(properties, "color"), alpha ) children();
}

/*
    properties is standard object dictionary.
    template:
        object = 
        [ "verbose description",
            ["x", convert_in2mm(1.75)],
            ["y", convert_in2mm(3.5)],
            ["z", convert_in2mm(58)],
            ["move", [100, 50, 0]],
            ["rotate", [ 0, 90, 0] ],
            ["color", "LightSlateGray"]
        ];   
    usage =>  applyExtrude(object) drawCube(object);
*/
module applyExtrude(properties)
{
    linear_extrude(gdv(properties, "z")) children();
}   

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