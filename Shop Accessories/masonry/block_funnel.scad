/*
    
*/
$fn=100;
include <constants.scad>;

use <convert.scad>;
use <trigHelpers.scad>;
use <ObjectHelpers.scad>;
use <dictionary.scad>;
use <morphology.scad>;
use <ellipse_extrude.scad>;

fvs = 
[
    "funnel values",
    ["inside diameter", convert_in2mm(4.5)],
    ["pail bottom diameter", convert_in2mm(9.25)],
    ["wall thickness", 4 * NozzleWidth],
    ["tool thickness", LayersToHeight(10)],
    ["funnel height", convert_in2mm(2)],
    ["color", "yellow"]
];

build();

module build(args) 
{
    properties_echo(fvs);
    scale(size = 12, increment = convert_in2mm(1), fontsize = 6);
    block_funnel(fvs);
}

module block_funnel(values)
{
    multipler = 3;
    union()
    {
        difference()
        {
            color(gdv(values, "color"), 0.5)
            linear_extrude(gdv(values, "tool thickness"))        
            circle(d = gdv(values, "pail bottom diameter"));
            
            linear_extrude(gdv(values, "tool thickness") + 1)        
            circle(d = gdv(values, "inside diameter"));
        }        


        difference()
        {
            ellipse_extrude(multipler * gdv(values, "funnel height") + 2)
            shell(gdv(values, "wall thickness"))
            circle(d = gdv(values, "inside diameter"));      

            translate([0,0, gdv(values, "funnel height") + 2])
            translate([0,0, multipler * gdv(values, "funnel height")/2])
            cube
            (
                size=
                [
                    gdv(values, "inside diameter") + gdv(values, "wall thickness") + 10, 
                    gdv(values, "inside diameter") + gdv(values, "wall thickness") + 10, 
                    multipler * gdv(values, "funnel height") + 2
                ], 
                center=true
            );      
        }

    }


}
