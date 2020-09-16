/*
    
*/

include <constants.scad>;
include <GreenHouseProperties.scad>;

use <convert.scad>;
use <trigHelpers.scad>;
use <ObjectHelpers.scad>;
use <dictionary.scad>;
use <floor.scad>;
use <Roof.scad>;

build();

module build(args) 
{
    info();
    add_entry_roof();
}

module add_entry_roof()
{
    scale(size = 16, increment = convert_in2mm(12), fontsize = 72);

    // translate([HouseLength/2, HouseWidth/2,0])
    // rotate([0,0,90])    
    // add_floor();
    union()
    {
        add_beam();

        for (i=[0:4]) 
        {
            translate
            (
                [
                    -i * getDictionaryValue(RoofProperties, "spacing" ),
                    0,
                    0
                ]
            )
            add_entry_rafter(Entryway_Rafter);    
        }        
    }
}

module add_beam()
{
    
    translate
    (
        gdv(EntryBeamProperties, "location" )
    )
    rotate(gdv(EntryBeamProperties, "rotate"))
    color(gdv(EntryBeamProperties, "color" ), 0.5)
        linear_extrude(gdv(EntryBeamProperties, "depth" ))
        {
            square(
                size=
                [
                    gdv(EntryBeamProperties, "length" ) , 
                    gdv(EntryBeamProperties, "width" )
                ], 
                center=false);                     
        }
}

module add_entry_rafter(properties)
{
    translate(gdv(properties, "location"))
    color(gdv(properties, "color" ), 0.5) 
    union()
    {
        mirror([0,1,0])
        translate(gdv(properties, "pre-translate"))
        rotate(gdv(properties, "rotate"))
        translate([0, gdv(properties, "length")/2, -gdv(properties, "depth")])
        cut_rafter_properties(properties);

        translate(gdv(properties, "pre-translate"))
        rotate(gdv(properties, "rotate"))
        translate([0, gdv(properties, "length")/2, -gdv(properties, "depth")])
        cut_rafter_properties(properties);

        // translate([0, HouseLength/2 * -1,0])
        // rotate([90,0,90])
        // lable_angle(a = gdv(properties, "angle"), l = gdv(Angle_Lable, "length"), r = gdv(Angle_Lable, "radius"), size = gdv(Angle_Lable, "font size"));        
    }    
}

module info() {
    debugEcho("Entryway_Rafter",Entryway_Rafter, true);
}
