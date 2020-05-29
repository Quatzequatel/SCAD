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
function privateGetKVPair(v, key, i = 0, result) = echo(v = v, i=i, result=result)
( result == undef && i < len(v) ? 
    privateGetKVPair
    (
        v = v,
        key = key,
        i = i + 1,
        result = echo(hello = i, vi = v[i]) ( v[i][0] == key ?  v[i] : undef )
    ) : echo(result=result) result //[0] returns ket, [1] returns value and nothing returns pair
);

// function GetDictionary(v, key, i = 0, result) = echo(GetDictionary = 0, v=v, key=key, i=i, result=result)
// ( result == undef && i < len(v) ? 
//     GetDictionary
//     (
//         v = v,
//         key = key,
//         i = i + 1,
//         result = v[i] == key 
//             ? v[i][0] : result
//     ) : result //[0] returns ket, [1] returns value and nothing returns pair
// );

// function foo(v, key) =
//     echo(v = v, key = key)
//     let
//     (
//         result = for( i = [0: len(v)-1]) v[i][0] == key ? v[i] : undef
//     )
//     echo(result = result)
//     result;


function getDictionaryValue(v, key) = 
    assert(isVector(v), str("parameter v is not an array."))
    let(result = privateGetKVPair(v, key))
    echo(result = result)
    result[1];

function getChildDictionary(v, key) = 
    assert(isVector(v), str("parameter v is not an array."))
    let(result = privateGetKVPair(v, key, 1))
    echo(result = result)
    result;

// function dictionaryDepth(v)


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
echo(fargsEcho("dictionary" , dictionary));
// echo(getChildDictionary = getChildDictionary(dictionary, "cat"));  
// echo(GetDictionary = GetDictionary(dictionary, "animals"));  