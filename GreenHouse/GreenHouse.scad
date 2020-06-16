/*
    
*/

include <constants.scad>;
include <GreenHouseProperties.scad>;

use <convert.scad>;
use <trigHelpers.scad>;
use <ObjectHelpers.scad>;
use <dictionary.scad>;

use <transformations.scad>;
use <Foundation.scad>;
use <GeoThermal.scad>;

build();

module build(args) 
{
    greenhouse();
}

module greenhouse()
{
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

    move_to_cold_frame_to_left_of_entry(height = -getDictionaryValue(thermo_column_properties, "height"))
    thermo_column(true);

    move_to_cold_frame_to_right_of_entry(height = -getDictionaryValue(thermo_column_properties, "height"))
    thermo_column(true);        
}