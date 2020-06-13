/*
    
*/

include <constants.scad>;

use <convert.scad>;
use <trigHelpers.scad>;
use <ObjectHelpers.scad>;
use <dictionary.scad>;

use <morphology.scad>;
use <helix.scad>;
use <hull_polyline3d.scad>;

include <GreenHouseProperties.scad>;
$fn = 16;

build();

module build(args) 
{
    Info();
    GH_base();
    // entry_base();
    Cold_Frame_1();
    Cold_Frame_2();
    Cold_Frame_3();
    foundation_insulation();
    translate_to_cold_frame_1(height = -getDictionaryValue(geothermalProperties, "height"))
    geo_thermal_1(true);

    translate_to_cold_frame_2(height = -getDictionaryValue(geothermalProperties, "height"))
    geo_thermal_1(true);

    // Frost_line();
}

module GH_base()
{
    %translate([ 0, 0, -getDictionaryValue(HouseDimensions, "foundation height")])
    linear_extrude(getDictionaryValue(HouseDimensions, "foundation height"))
    shell(- getDictionaryValue(HouseDimensions, "wall thickness"))
    union()
    {
        square([getDictionaryValue(HouseDimensions, "width"), getDictionaryValue(HouseDimensions, "length")], center = true);
        entry_base();
    }
}

module entry_base()
{
    translate_to_entry_base(height = -getDictionaryValue(EntryDimensions, "foundation height"))
    // linear_extrude(getDictionaryValue(EntryDimensions, "foundation height"))
    // shell(- getDictionaryValue(EntryDimensions, "wall thickness"))
    square([getDictionaryValue(EntryDimensions, "width"), getDictionaryValue(EntryDimensions, "length")], center = true);    
}

module translate_to_entry_base(height = 0)
{
    color("PeachPuff")
    translate(
        [ 
            0, 
            getDictionaryValue(HouseDimensions, "length")/2 + getDictionaryValue(EntryDimensions, "length")/2, 
            height
        ]
        )
        children();    
}

module Cold_Frame_1()
{    
    translate_to_cold_frame_1(height = -getDictionaryValue(ColdFrame1, "foundation height"))
    linear_extrude(getDictionaryValue(ColdFrame1, "foundation height"))
    shell(-getDictionaryValue(ColdFrame1, "wall thickness"))
    square([getDictionaryValue(ColdFrame1, "width"), getDictionaryValue(ColdFrame1, "length")], center = true);    
}

module geo_thermal_1(helix = false)
{   
    if(helix)
    {
        points = helix
        (
            radius = 
                [
                    getDictionaryValue(geothermalProperties, "radius"), 
                    getDictionaryValue(geothermalProperties, "radius")
                ],
            levels = getDictionaryValue(geothermalProperties, "turns"),
            level_dist = getDictionaryValue(geothermalProperties, "height per turn"),
            vt_dir = "SPI_UP", 
            rt_dir = "CLK"            
        );

        hull_polyline3d(points, getDictionaryValue(geothermalProperties, "pipe diameter"));        
    }
    else
    {
        linear_extrude(getDictionaryValue(geothermalProperties, "height"))
        shell(-getDictionaryValue(geothermalProperties, "pipe diameter"))
        circle
            (
                r=getDictionaryValue(geothermalProperties, "radius")
            );
    }    
}

module Cold_Frame_2()
{

    // % color("darkKhaki")
    // translate(
    //     [ 
    //         -1 * (getDictionaryValue(EntryDimensions, "width")/2 + getDictionaryValue(ColdFrame1, "width")/2),
    //         getDictionaryValue(HouseDimensions, "length")/2 + getDictionaryValue(ColdFrame1, "length")/2, 
    //         -getDictionaryValue(ColdFrame1, "foundation height")
    //     ]
    //     )        
    translate_to_cold_frame_2(height = -getDictionaryValue(ColdFrame1, "foundation height"))
    linear_extrude(getDictionaryValue(ColdFrame1, "foundation height"))
    shell(- getDictionaryValue(ColdFrame1, "wall thickness"))    
    square([getDictionaryValue(ColdFrame1, "width"), getDictionaryValue(ColdFrame1, "length")], center = true);    
}

module translate_to_cold_frame_2(height = 0)
{
    color("darkKhaki")
    translate(
        [ 
            -1 * (getDictionaryValue(EntryDimensions, "width")/2 + getDictionaryValue(ColdFrame1, "width")/2),
            getDictionaryValue(HouseDimensions, "length")/2 + getDictionaryValue(ColdFrame1, "length")/2, 
            height
        ]
        )
        children();    
}

module geo_thermal_2(helix = false)
{
    % color("Khaki")
    translate(
        [ 
            getDictionaryValue(EntryDimensions, "width")/2 + getDictionaryValue(ColdFrame1, "width")/2,
            getDictionaryValue(HouseDimensions, "length")/2 + getDictionaryValue(ColdFrame1, "length")/2, 
            -getDictionaryValue(geothermalProperties, "height")
        ]
        )      
    if(helix)
    {
        points = helix
        (
            radius = 
                [
                    getDictionaryValue(geothermalProperties, "radius"), 
                    getDictionaryValue(geothermalProperties, "radius")
                ],
            levels = getDictionaryValue(geothermalProperties, "turns"),
            level_dist = getDictionaryValue(geothermalProperties, "height per turn"),
            vt_dir = "SPI_UP", 
            rt_dir = "CLK"            
        );

        hull_polyline3d(points, getDictionaryValue(geothermalProperties, "pipe diameter"));        
    }
    else
    {
        linear_extrude(getDictionaryValue(geothermalProperties, "height"))
        shell(-getDictionaryValue(geothermalProperties, "pipe diameter"))
        circle
            (
                r=getDictionaryValue(geothermalProperties, "radius")
            );
    }    
}

module Cold_Frame_3()
{

    % color("darkKhaki")
    translate(
        [ 
            getDictionaryValue(HouseDimensions, "width")/2 + getDictionaryValue(ColdFrame3, "width")/2,
            -1 * getDictionaryValue(HouseDimensions, "length")/2 + getDictionaryValue(ColdFrame3, "length")/2 , 
            -getDictionaryValue(ColdFrame3, "foundation height")
        ]
        )        
    linear_extrude(getDictionaryValue(ColdFrame3, "foundation height"))
    shell(- getDictionaryValue(ColdFrame3, "wall thickness"))    
    square([getDictionaryValue(ColdFrame3, "width"), getDictionaryValue(ColdFrame3, "length")], center = true);    
}
module foundation_insulation()
{
    translate(
        [
            getDictionaryValue(ColdFrame3, "width")/2,
            getDictionaryValue(ColdFrame1, "length")/2,
            -getDictionaryValue(foundationProperties, "insulation height")
        ]
    )
    color("pink")
    linear_extrude(getDictionaryValue(foundationProperties, "insulation height"))
    shell(getDictionaryValue(foundationProperties, "insulation thickness"))    
    square([getDictionaryValue(foundationProperties, "width"), getDictionaryValue(foundationProperties, "length")], center = true);    
}

module Frost_line()
{
    translate(
        [
            getDictionaryValue(ColdFrame3, "width")/2,
            getDictionaryValue(ColdFrame1, "length")/2,
            -getDictionaryValue(foundationProperties, "frost line")
        ]
    )
    color("LightSteelBlue")
    square([getDictionaryValue(foundationProperties, "width") + 1000, getDictionaryValue(foundationProperties, "length") + 1000], center = true);    
}

module translate_to_cold_frame_1(height = 0)
{
    % color("Khaki")
    translate(
        [ 
            getDictionaryValue(EntryDimensions, "width")/2 + getDictionaryValue(ColdFrame1, "width")/2,
            getDictionaryValue(HouseDimensions, "length")/2 + getDictionaryValue(ColdFrame1, "length")/2, 
            height
        ]
        ) 
        children();    
}

module Info()
{
    debugEcho("Entry Dimensions", EntryDimensions, true);
    echo();
    debugEcho("Cold Frame 1", ColdFrame1, true);
    echo();
    debugEcho("House Dimensions", HouseDimensions, true);
    echo();
    // debugEcho("Roof", RoofDimensions[1], true);
    echo();
    debugEcho("Entry Roof", EntryRoofDimensions[1], true);
    echo();
    debugEcho("Roof Properties", RoofProperties[1], true);
}