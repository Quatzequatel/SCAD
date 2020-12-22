/*
    
*/

include <constants.scad>;
include <arc.scad>;

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

build();

module build(args) 
{
 
    move_to_cold_frame_to_left_of_entry(height = -getDictionaryValue(thermo_column_properties, "height"))
    build_multi_helix_column();

    move_to_cold_frame_to_right_of_entry(height = -getDictionaryValue(thermo_column_properties, "height"))
    build_multi_helix_column();
}

module add_geo_thermal() 
{
    move_to_cold_frame_to_left_of_entry(height = -getDictionaryValue(thermo_column_properties, "height"))
    build_multi_helix_column();

    move_to_cold_frame_to_right_of_entry(height = -getDictionaryValue(thermo_column_properties, "height"))
    build_multi_helix_column();
}

module build_multi_helix_column()
{
    color("blue",0.5) thermo_column(false, "radius-01");
    color("CornflowerBlue",0.5) thermo_column(true, "radius-02", "SPI_UP", "CLK");
    connect_pipe_1_to_2();
    color("Pink",0.5) thermo_column(true, "radius-03", "SPI_DOWN", "CLK");
    connect_pipe_2_to_3();
    color("Crimson",0.5) thermo_column(true, "radius-04", "SPI_UP", "CLK");
    connect_pipe_3_to_4();    
}

module thermo_column(helix = false, radius_label, direction, rotation)
{   
    if(helix)
    {
        points = helix
        (
            radius = 
                [
                    getDictionaryValue(thermo_column_properties, radius_label), 
                    getDictionaryValue(thermo_column_properties, radius_label)
                ],
            levels = getDictionaryValue(thermo_column_properties, "turns"),
            level_dist = getDictionaryValue(thermo_column_properties, "height per turn"),
            vt_dir = direction, 
            rt_dir = rotation            
        );

        hull_polyline3d(points, getDictionaryValue(thermo_column_properties, "pipe diameter"));        
    }
    else
    {
        linear_extrude(getDictionaryValue(thermo_column_properties, "height"))
        // shell(-getDictionaryValue(thermo_column_properties, "pipe diameter"))
        circle
            (
                r=getDictionaryValue(thermo_column_properties, radius_label)
            );
    }    
}

module connect_pipe_1_to_2()
{
    rotate([0,90,0])
            color("SteelBlue",0.5)
            linear_extrude(getDictionaryValue(thermo_column_properties, "radius-02"))
            circle (
                r=getDictionaryValue(thermo_column_properties, "pipe diameter")/2
            );
}

module connect_pipe_2_to_3()
{
    translate(
        [
            70, 
            0, 
            gdv(thermo_column_properties, "height")
        ]) 
    // rotate([0,90,0])
            color("MediumOrchid",0.5)
            linear_extrude(gdv(thermo_column_properties, "pipe diameter"))
            // circle (
            //     r = gdv(thermo_column_properties, "pipe diameter")/2
            // );
            arc(
                radius = (gdv(thermo_column_properties, "radius-02") + gdv(thermo_column_properties, "radius-03"))/2, 
                angle = [0, 180], 
                width = gdv(thermo_column_properties, "pipe diameter")
                );
}

module connect_pipe_3_to_4()
{
    translate(
        [
            100, 
            0, 
            0
        ]) 
    // rotate([0,90,0])
            color("MediumVioletRed",0.5)
            linear_extrude(gdv(thermo_column_properties, "pipe diameter"))
            // circle (
            //     r = gdv(thermo_column_properties, "pipe diameter")/2
            // );
            arc(
                radius = (gdv(thermo_column_properties, "radius-03") + gdv(thermo_column_properties, "radius-04"))/2, 
                angle = [0, 180], 
                width = gdv(thermo_column_properties, "pipe diameter")
                );
}