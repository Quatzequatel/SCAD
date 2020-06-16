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

build();

module build(args) 
{
 
    move_to_cold_frame_to_left_of_entry(height = -getDictionaryValue(thermo_column_properties, "height"))
    thermo_column(true);

    move_to_cold_frame_to_right_of_entry(height = -getDictionaryValue(thermo_column_properties, "height"))
    thermo_column(true);
}

module thermo_column(helix = false)
{   
    if(helix)
    {
        points = helix
        (
            radius = 
                [
                    getDictionaryValue(thermo_column_properties, "radius"), 
                    getDictionaryValue(thermo_column_properties, "radius")
                ],
            levels = getDictionaryValue(thermo_column_properties, "turns"),
            level_dist = getDictionaryValue(thermo_column_properties, "height per turn"),
            vt_dir = "SPI_UP", 
            rt_dir = "CLK"            
        );

        hull_polyline3d(points, getDictionaryValue(thermo_column_properties, "pipe diameter"));        
    }
    else
    {
        linear_extrude(getDictionaryValue(thermo_column_properties, "height"))
        shell(-getDictionaryValue(thermo_column_properties, "pipe diameter"))
        circle
            (
                r=getDictionaryValue(thermo_column_properties, "radius")
            );
    }    
}