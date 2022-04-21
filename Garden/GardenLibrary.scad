/*
    This library contains dictionaries for Garden objects starting 3/21/2022.

*/

include <constants.scad>;

use <convert.scad>;
use <trigHelpers.scad>;
use <ObjectHelpers.scad>;
use <dictionary.scad>;

EMT_Conduit = 
["1/2 in EMT_Conduit bracket", 
    ["x", convert_in2mm(5)],
    ["y", convert_in2mm(3)],
    ["z", convert_in2mm(0.7)],
    //OD + buffer
    ["OD", convert_in2mm(0.71) + 2],
    ["move", [0, 0, 0]],
    ["rotate", [0, 0, 0]],
    ["color", "LightGrey"]
];

EMT_Conduit_Bracket = 
["1/2 in EMT_Conduit bracket", 
    ["x", convert_in2mm(5)],
    ["y", convert_in2mm(3)],
    //adding -1 to break thru plane.
    ["z",gdv(EMT_Conduit, "z") - 1],
    //ID is conduit OD plus buffer.
    ["ID", gdv(EMT_Conduit, "OD")],
    ["OD", convert_in2mm(1.25)],
    ["hex nut OD", 9],
    ["hex nut ID", 3.4],
    ["hex nut X", gdv(EMT_Conduit, "OD") + 3],
    ["move", [0, 0, 0]],
    ["rotate", [0, 0, 0]],
    ["color", "LightGrey"]
];