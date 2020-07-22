/*
    
*/

include <constants.scad>;
include <GreenHouseProperties.scad>;

use <convert.scad>;
use <trigHelpers.scad>;
use <ObjectHelpers.scad>;
use <dictionary.scad>;

use <morphology.scad>;

TrussProperties = 
[
    "truss properties",
        ["bearing angle", RoofAngle],
        ["peak angle", 90 - RoofAngle],
        ["width", HouseWidth], //x
        ["length", HouseLength/2], //y
        ["peak height", sideAaB(side_b = HouseLength/2, aB = AngleOpposite(RoofAngle))],
        ["rafter length", sideC_B(side_b = HouseLength/2, aA = RoofAngle) + sideC_B(side_b = RoofOverHangDepth, aA = RoofAngle)],
        ["spacing", StudSpacing]
];

build();
debugEcho("truss Properties", TrussProperties, true);
debugEcho("Stud Properties", StudProperties, true);

module build(args) 
{
    Truss();
}

module Truss()
{
    
}