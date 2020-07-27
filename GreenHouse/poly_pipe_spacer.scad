/*
    
*/
$fn=200;
include <constants.scad>;

use <convert.scad>;
use <trigHelpers.scad>;
use <ObjectHelpers.scad>;
use <dictionary.scad>;

use <morphology.scad>;

debugEcho("poly pipe properties", polypipe_properties, true);
build();
polypipe_properties = 
[
    "poly pipe properties",
    ["width", convert_in2mm(1.75)],
    ["pipe diameter", convert_in2mm(7/8)],
    ["wall thickness", 4 * NozzleWidth],
    ["height", convert_in2mm(0.5)],
    ["screw hole", true],
    ["screw hole diameter", woodScrewShankDiaN_4]
];

module build(args) 
{
    poly_pipe_spacer();
    // rotate([90,0,0])
    // poly_pipe_180_end();
    // poly_pipe_clip();
}

module poly_pipe_180_end()
{
    rotate_extrude(angle = 180)    
    {
        translate([getDictionaryValue(polypipe_properties, "width")/2,0,0])
        rotate([0, 0, 90]) 
        poly_pipe_clip();
        translate([0,-9,0])
            square(
            size=
            [
                getDictionaryValue(polypipe_properties, "width")/1.65 - getDictionaryValue(polypipe_properties, "pipe diameter"), 
                getDictionaryValue(polypipe_properties, "wall thickness")
            ], center=false);        
    }

}

module poly_pipe_clip()
{
    x1 = getDictionaryValue(polypipe_properties, "pipe diameter");
    difference()
    {
        shell(d = getDictionaryValue(polypipe_properties, "wall thickness"))
        {
            circle(d = x1);        
        }    

        translate([-5,0,0])
        square([x1,x1]);
    }
    
}

module poly_pipe_spacer()
{
    difference()
    {
        linear_extrude(getDictionaryValue(polypipe_properties, "height"))
        difference()
        {
            poly_pipe_spacer_2D();        

            translate(
                [
                    - getDictionaryValue(polypipe_properties, "pipe diameter")/4,
                    + getDictionaryValue(polypipe_properties, "wall thickness")/2,
                    0
                ]
            )
            polygon
            (
                points =
                isosceles_triangle
                (
                    s = getDictionaryValue(polypipe_properties, "width") 
                        + getDictionaryValue(polypipe_properties, "pipe diameter")/2
                )
            );
            
        }    

        translate([getDictionaryValue(polypipe_properties, "width")/2 ,0,getDictionaryValue(polypipe_properties, "height")/2])
        rotate([90,0,0])
        cylinder(r=getDictionaryValue(polypipe_properties, "screw hole diameter"), h=10, center=true);   
    }
    
}

module poly_pipe_spacer_2D()
{
    shell(d = getDictionaryValue(polypipe_properties, "wall thickness"))
    {
        circle(d = getDictionaryValue(polypipe_properties, "pipe diameter"));        
    }

    translate([getDictionaryValue(polypipe_properties, "width"),0,0])
    shell(d = getDictionaryValue(polypipe_properties, "wall thickness"))
    {
        circle(d = getDictionaryValue(polypipe_properties, "pipe diameter"));        
    }

    translate(
        [
            getDictionaryValue(polypipe_properties, "pipe diameter")/2,
            - getDictionaryValue(polypipe_properties, "wall thickness")/2,
            0
        ]
        )
    square(
        size=
        [
            getDictionaryValue(polypipe_properties, "width") - getDictionaryValue(polypipe_properties, "pipe diameter"), 
            getDictionaryValue(polypipe_properties, "wall thickness")
        ], center=false);

}