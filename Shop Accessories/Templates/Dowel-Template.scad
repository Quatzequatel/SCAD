/*
    
*/

include <constants.scad>;

use <convert.scad>;
use <trigHelpers.scad>;
use <ObjectHelpers.scad>;
use <dictionary.scad>;

board = 
        [
            "standard board",
            ["x", convert_in2mm(3.5)],
            ["y", convert_in2mm(1.5)]
        ];

support = 
        [
            "support x",
            ["x", convert_in2mm(3.5)],
            ["y", convert_in2mm(0.2)]
        ];   

support2 = 
        [
            "support y",
            ["x", convert_in2mm(0.2)],
            ["y", convert_in2mm(1.5) + gdv(support, "y")]
        ];      

//add a pinch, it's extremely tight fit.
dowel = convert_in2mm(3/8) + 1;

build(mirror = false);

module build(mirror = true) 
{
    properties_echo(board);

    template();
    
    support(mirror);
    
}

module template()
{
    linear_extrude(height = convert_in2mm(0.5))
    difference()
    {
        union()
        {
            square(size=[gdv(board, "x"), gdv(board, "y")], center=false);


        }
        

        translate([gdv(board, "x")/2, gdv(board, "y")/2])
        circle(d=dowel, $fn=60);

        translate([gdv(board, "x")/5, gdv(board, "y")/2])
        circle(d=dowel, $fn=60);

        translate([4*gdv(board, "x")/5, gdv(board, "y")/2])
        circle(d=dowel, $fn=60);
    }
}

module support(mirror = false)
{
    //long side
    linear_extrude(height = convert_in2mm(1))
    translate([0, -gdv(support, "y")])
    square(size=[gdv(support, "x"), gdv(support, "y")], center=false);

    //short side
    if(mirror)
    {
        #linear_extrude(height = convert_in2mm(1))
        translate([gdv(board, "x"), -gdv(support, "y")])
        square(size=[gdv(support2, "x"), gdv(support2, "y")], center=false);        
    }
    else
    {
        #linear_extrude(height = convert_in2mm(1))
        translate([-gdv(support2, "x"), -gdv(support, "y")])
        square(size=[gdv(support2, "x"), gdv(support2, "y")], center=false);               
    }

}
