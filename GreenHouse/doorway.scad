/*
    
*/

include <constants.scad>;
include <GreenHouseProperties.scad>;
// use <shapesByPoints.scad>;
use <convert.scad>;
use <ObjectHelpers.scad>;
use <trigHelpers.scad>;
use <Construction.scad>;
use <dictionary.scad>;
use <entry_roof.scad>;


build();

module build(args) 
{
    add_doorway();
}


//Drawing methods

module add_doorway()
{
    add_sill(DoorSill);
    add_door(Door);    
}

module add_sill(properties)
{
    echo(properties = properties);
    echo(Width_in = convertV_mm2Inch(properties[4]));
    debug_callstack();
    color(gdv(properties, "color"), 0.5)
    translate(gdv(properties, "location"))
    rotate(gdv(properties, "rotate"))
    {
        difference()
        {
            linear_extrude(gdv(properties, "depth (z)"))
            square([gdv(properties, "width (x)"), gdv(properties, "length (y)")], center = false); 

            translate(gdv(properties, "wall cutout 1 location") )
            linear_extrude(gdv(properties, "depth (z)") + 2)
            square([gdv(properties, "wall cutout (x)"), gdv(properties, "wall cutout (y)")], center = false);        

            translate(gdv(properties, "wall cutout 2 location"))
            linear_extrude(gdv(properties, "depth (z)") + 2)
            square([gdv(properties, "wall cutout (x)"), gdv(properties, "wall cutout (y)")], center = false);              
        }

    }
}

module add_door(properties)
{
    echo(properties = properties);
    
    debug_callstack();
    
    translate(gdv(properties, "location 2"))
    make_door(properties);

    translate(gdv(properties, "location"))
    make_door(properties);    

}

module make_door(properties)
{
    color(gdv(properties, "color"), 0.5)
    rotate(gdv(properties, "rotate"))
    {
        difference()
        {
            linear_extrude(gdv(properties, "depth (z)"))
            square([gdv(properties, "width (x)"), gdv(properties, "length (y)")], center = false);  

            //cutout for panel
            translate(gdv(properties, "insert location"))  
            linear_extrude(gdv(properties, "depth (z)" + 2))
            square([gdv(properties, "insert x"), gdv(properties, "insert y")], center = false);                      
        }
    }
}


//Properties

DoorSill = 
[
    "door way sill",
    ["width (x)", EntryWidth],    
    ["length (y)", convert_in2mm(10)],  
    ["depth (z)", convert_in2mm(1.75)],
    ["wall cutout (x)", convert_in2mm(8)],
    ["wall cutout (y)", convert_in2mm(8)],  
    ["wall cutout 1 location", [0, convert_in2mm(10) - convert_in2mm(8), -1]],  
    ["wall cutout 2 location", [EntryWidth - convert_in2mm(8), convert_in2mm(10) - convert_in2mm(8), -1]],  
    ["location", [0, convert_in2mm(8) - convert_in2mm(10), 0]],
    ["rotate", [0, 0, 0]],
    ["color", "SaddleBrown"],        
];

Door = 
[
    "door properties",
    ["width (x)", EntryWidth/2],    
    ["length (y)", convert_in2mm(7*12)],  
    ["depth (z)", convert_in2mm(1.75)],
    ["location", [0, 0, convert_in2mm(1.75)]],
    ["location 2", [EntryWidth/2 + convert_in2mm(1/8), 0, convert_in2mm(1.75)]],
    ["rotate", [90, 0, 0]],
    ["color", "aqua"], 
    ["insert x", EntryWidth/2 - convert_in2mm(2 * 3.5)], 
    ["insert y", convert_in2mm(7*12) - convert_in2mm(2 * 3.5)],
    ["insert z", 10],
    ["insert location", [convert_in2mm(3.5), convert_in2mm(3.5), -1]]
];