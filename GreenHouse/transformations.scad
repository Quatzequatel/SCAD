/*
    modules to move objects to key location.
*/

include <constants.scad>;
include <GreenHouseProperties.scad>;

use <convert.scad>;
use <trigHelpers.scad>;
use <ObjectHelpers.scad>;
use <dictionary.scad>;

// move from [0,0,0] to center of entry.
module move_to_entry_base(height = 0)
{
    // color("PeachPuff")
    translate(
        [ 
            0, 
            getDictionaryValue(HouseDimensions, "length")/2 + getDictionaryValue(EntryDimensions, "length")/2, 
            height
        ]
        )
        children();    
}

module move_to_cold_frame_to_right_of_entry(height = 0)
{
    // color("darkKhaki")
    translate(
        [ 
            -1 * (getDictionaryValue(EntryDimensions, "width")/2 + getDictionaryValue(EntryColdFrame, "width")/2),
            getDictionaryValue(HouseDimensions, "length")/2 + getDictionaryValue(EntryColdFrame, "length")/2, 
            height
        ]
        )
        children();    
}

module move_to_cold_frame_to_left_of_entry(height = 0)
{
    // % color("Khaki")
    translate(
        [ 
            getDictionaryValue(EntryDimensions, "width")/2 + getDictionaryValue(EntryColdFrame, "width")/2,
            getDictionaryValue(HouseDimensions, "length")/2 + getDictionaryValue(EntryColdFrame, "length")/2, 
            height
        ]
        ) 
        children();    
}

module move_to_cold_frame_to_left_of_house(height = 0)
{
    // % color("Khaki")
    translate(
        [ 
            getDictionaryValue(HouseDimensions, "width")/2 + getDictionaryValue(SouthColdFrame, "width")/2,
            -1 * getDictionaryValue(HouseDimensions, "length")/2 + getDictionaryValue(SouthColdFrame, "length")/2 , 
            height
        ]
        ) 
        children();    
}

module move_to_center_of_foundation(height = 0)
{
    translate(
        [
            getDictionaryValue(SouthColdFrame, "width")/2,
            getDictionaryValue(EntryColdFrame, "length")/2,
            height
        ]
    )    
    children();
}