/*
    
*/

include <constants.scad>;

use <convert.scad>;
use <trigHelpers.scad>;
use <ObjectHelpers.scad>;
use <dictionary.scad>;

fvs = 
[
    "funnel values",
    ["inside diameter", convert_in2mm(6)],
    ["pail bottom diameter", convert_in2mm(12)],
    ["wall thickness", 4 * NozzleWidth],
    ["", value]
];

build();

module build(args) 
{
    block_funnel(fvs);
}

module block_funnel(values)
{
    circle(d = gdv(values, "pail bottom diameter"));
}