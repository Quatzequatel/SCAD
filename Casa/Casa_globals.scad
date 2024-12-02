/*
    Global variables for Casa Project.
*/

include <constants.scad>;

use <convert.scad>;
use <trigHelpers.scad>;
use <ObjectHelpers.scad>;
use <dictionary.scad>;

/*
Functions 
*/

function M2mm(M) = M * 1000;

//-------------------------------------------------------------------------------------------------------------------
/*
    Global verables
*/
PropertyDic = 
[
    "Casa property information",
    ["x", convert_in2mm(953)],
    ["y", convert_in2mm(1284)],
    ["z", 0],
];
