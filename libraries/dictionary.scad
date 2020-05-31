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
function privateGetKVPair(v, key, i = 0, type = 0, result=undef) = //echo(v = v, i=i, vi=v[i], result=result)
    result != undef  ? result 
    : i == len(v)      ? result 
    : v[i] == key      ? 
        type == 0      ? v[i+1] 
        : type == 1      ? v[i] 
                         : [v[i], v[i+1]]
                     : privateGetKVPair(v,key, i+1, type, result);


function getDictionaryValue(v, key) = 
    assert(isVector(v), str("parameter v is not an array."))
    assert(isString(v[0]), str("first element is not a key."))
    let(result = privateGetKVPair(v, key, 0, 0))
    echo(result = result)
    result;

function getDictionary(v, key) = 
    assert(isVector(v), str("parameter v is not an array."))
    assert(isString(v[0]), str("first element is not a key."))
    let(result = privateGetKVPair(v, key, 0, 2))
    echo(result = result)
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
                        ["dog",1],
                        ["cat",2],
                        ["bird",3],
                        ["bug",4],
                    ]
                ];
echo(lenV = len(dictionary));
echo(getDictionaryValue = getDictionaryValue(dictionary, "animals"));  
echo(getDictionary = getDictionary(dictionary, "animals"));  

// echo(type = type(dictionary[1]));
// echo(fargsEcho("dictionary" , dictionary));
// echo( found = Search("animals" , dictionary));

// echo(square = square(4));
// echo(getChildDictionary = getChildDictionary(dictionary, "cat"));  
// echo(GetDictionary = GetDictionary(dictionary, "animals"));  
echo();
echo();