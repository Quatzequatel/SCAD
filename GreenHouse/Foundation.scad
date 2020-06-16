/*
    
*/

include <constants.scad>;

use <convert.scad>;
use <trigHelpers.scad>;
use <ObjectHelpers.scad>;
use <dictionary.scad>;
use <vectorHelpers.scad>;

use <morphology.scad>;
use <helix.scad>;
use <hull_polyline3d.scad>;
use <shape_square.scad>;
use <shape_circle.scad>;
use <path_extrude.scad>;

include <GreenHouseProperties.scad>;
use <transformations.scad>;
$fn = 16;

foundation
    (
        drainage = true, 
        conduit = true, 
        gravel = true, 
        footings = false, 
        foundation = true, 
        cold_frame = false, 
        insulation = false, 
        info = true
    );

module foundation(drainage = true, conduit = true, foundation = true, footings = true, gravel = true, cold_frame = true, insulation = true, info = false)
{
    if(drainage)
    {
        drainage();
    }
    
    if(conduit)
    {
        conduit(color = "red", properties = electric_conduit);
        conduit(color = "blue", properties = water_conduit);
    }

    if(gravel)
    {
        // greenhouse_gravel_layer
        greenhouse_foundation
            (
                color = "DimGray", 
                additionalWidth = getDictionaryValue(crushed_rock_properties, "width"), 
                properties = crushed_rock_properties
            );
    }    

    
    if(foundation)
    {
        // greenhouse_footings
        greenhouse_foundation
            (
                color = "DarkGray", 
                additionalWidth = getDictionaryValue(footing_properties, "width"), 
                properties = footing_properties
            );
    }
    
    if(footings)
    {
        // foundation
        greenhouse_foundation
            (
                color = "SlateGray", 
                additionalWidth = 0, 
                properties = house_foundation_properties
            );
    }

    
    if(cold_frame)
    {
        move_to_cold_frame_to_left_of_entry(height = -getDictionaryValue(EntryColdFrame, "foundation height"))
        entry_cold_frame();

        move_to_cold_frame_to_right_of_entry(height = -getDictionaryValue(EntryColdFrame, "foundation height"))
        entry_cold_frame();

        move_to_cold_frame_to_left_of_house(height = -getDictionaryValue(EntryColdFrame, "foundation height"))
        south_cold_frame();
    }

    if(insulation)
    {
        move_to_center_of_foundation(-getDictionaryValue(insulation_properties, "height"))
        foundation_insulation();
    }

    if(frostline)
    {
        move_to_center_of_foundation(-getDictionaryValue(foundationProperties, "frost line"))
        Frost_line();
    }

    if(info)
    {
        Info();
    }
}

module conduit(color = "red", properties = undef)
{
    color(color)
    translate(getDictionaryValue(properties, "location"))
    rotate([0,90,0])
    cylinder
    (
        r = getDictionaryValue(properties, "radius"), 
        h = getDictionaryValue(properties, "length"), 
        center=true
    );
}

module drainage()
{
    outer_foundation_size = 
    [
        getDictionaryValue(HouseDimensions, "width") + getDictionaryValue(drainage_properties, "distance from wall"),
        getDictionaryValue(HouseDimensions, "length") + getDictionaryValue(drainage_properties, "distance from wall")
    ];
    path_points = shape_square(size = outer_foundation_size, corner_r = getDictionaryValue(drainage_properties, "corner_r"));
    shape_pts = shape_circle(radius = getDictionaryValue(drainage_properties, "radius"));
    // echo(path_points=path_points);

    color("white")
    translate([ 0, 0, getDictionaryValue(crushed_rock_properties, "start")])
    path_extrude(shape_pts, ApendToV(path_points, path_points[0]));
}

module greenhouse_foundation(color = "red", additionalWidth = 0, properties = undef)
{
    translate([ 0, 0, getDictionaryValue(properties, "start")])

    color(color)
    linear_extrude(getDictionaryValue(properties, "height"))
    shell( - getDictionaryValue(properties, "width")/2)
    union()
    {
        square
        (
            [
                getDictionaryValue(HouseDimensions, "width") + additionalWidth/2, 
                getDictionaryValue(HouseDimensions, "length") + additionalWidth/2
            ], 
            center = true
        );
        entry_foundation(width = additionalWidth/2);
    }
}

module entry_foundation(width = 0)
{
    move_to_entry_base(height = 0)
    square
    (
        [
            getDictionaryValue(EntryDimensions, "width") + width, 
            getDictionaryValue(EntryDimensions, "length") + width
        ], 
        center = true
    );    
}

module entry_cold_frame()
{       
    linear_extrude(getDictionaryValue(EntryColdFrame, "foundation height"))
    shell(-getDictionaryValue(EntryColdFrame, "wall thickness"))
    square([getDictionaryValue(EntryColdFrame, "width"), getDictionaryValue(EntryColdFrame, "length")], center = true);    
}

module south_cold_frame()
{   
    linear_extrude(getDictionaryValue(SouthColdFrame, "foundation height"))
    shell(- getDictionaryValue(SouthColdFrame, "wall thickness"))    
    square([getDictionaryValue(SouthColdFrame, "width"), getDictionaryValue(SouthColdFrame, "length")], center = true);    
}

module foundation_insulation()
{
    color("pink")
    linear_extrude(getDictionaryValue(insulation_properties, "height"))
    shell(-getDictionaryValue(insulation_properties, "width"))    
    square([getDictionaryValue(foundationProperties, "width"), getDictionaryValue(foundationProperties, "length")], center = true);    
}

module Frost_line()
{
    color("LightSteelBlue")
    square([getDictionaryValue(foundationProperties, "width") + 1000, getDictionaryValue(foundationProperties, "length") + 1000], center = true);    
}

module Info()
{
    debugEcho("House Dimensions", HouseDimensions, true);
    echo();
    debugEcho("Entry Dimensions", EntryDimensions, true);
    echo();
    debugEcho("EntryColdFrame", EntryColdFrame, true);
    echo();
    debugEcho("house_foundation_properties", house_foundation_properties, true);
    echo();
    debugEcho("footing_properties", footing_properties, true);
    echo();
    debugEcho("crushed_rock_properties", crushed_rock_properties, true);
    echo();
    // debugEcho("Roof", RoofDimensions[1], true);
    echo();
    debugEcho("Entry Roof", EntryRoofDimensions[1], true);
    echo();
    debugEcho("Roof Properties", RoofProperties[1], true);
}