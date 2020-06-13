/*
    
*/

include <constants.scad>;

use <convert.scad>;
use <trigHelpers.scad>;
use <ObjectHelpers.scad>;

build();

module build(args) 
{
    Thing();
}

module Thing()
{
    import("C:\\Users\\quatz\\source\\repos\\Quatzequatel\\SCAD2\\Vika\\Baking\\Bread_Proofing_Baskets-Hemisphere.stl", convexity = 10);
}