/*
    
*/

include <constants.scad>;
include <nuts_and_bolts_v1.9.6.scad>;

use <convert.scad>;
use <trigHelpers.scad>;
use <ObjectHelpers.scad>;
use <dictionary.scad>;

build();

module build(args) 
{
    difference()
    {
        resize(newsize=[0,0,200], auto = true)
        lilly_impeller();
        # hex_nut (0.5, 1/4, 3/8, 1/128, fn, 0, "imperial", 0);        
    }

}

module lilly_impeller()
{
    translate([106, 0, 49.25]) 
    import("Lilly_impeller1.stl");
}