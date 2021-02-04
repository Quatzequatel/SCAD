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

module move_to_center_of_house(height = 0)
{
    translate(
        [
            getDictionaryValue(HouseDimensions, "length")/2,
            getDictionaryValue(HouseDimensions, "width")/2,
            height
        ]
    )    
    children();
}

module move_to_south_east_corner(height = 0, length = 0, width = 0, inset = convert_ft2mm(1))
{
    translate(
        [
            getDictionaryValue(HouseDimensions, "length") - length/2 - inset,
            length/2 + inset ,
            height            
        ]
    )
    children();
}

module move_to_south_west_corner(height = 0, length = 0, width = 0, inset = convert_ft2mm(1))
{
    translate(
        [
            length/2 + inset,
            length/2 + inset ,
            height            
        ]
    )
    children();
}

module move_to_north_west_corner(height = 0, length = 0, width = 0, inset = convert_ft2mm(1))
{
    translate(
        [
            length/2 + inset,
            getDictionaryValue(HouseDimensions, "width") - length/2 - inset ,
            height            
        ]
    )
    children();
}

module move_to_north_east_corner(height = 0, length = 0, width = 0, inset = convert_ft2mm(1))
{
    translate(
        [
            getDictionaryValue(HouseDimensions, "length") - length/2 - inset,
            getDictionaryValue(HouseDimensions, "width") - length/2 - inset ,
            height            
        ]
    )
    children();
}

module move_to_center_east(height = 0, length = 0, width = 0, inset = convert_ft2mm(1))
{
    translate(
        [
            length/2 + inset,
            getDictionaryValue(HouseDimensions, "width")/2,
            height            
        ]
    )
    children();
}

module move_to_center_west(height = 0, length = 0, width = 0, inset = convert_ft2mm(1))
{
    translate(
        [
            getDictionaryValue(HouseDimensions, "length") - length/2 - inset,
            getDictionaryValue(HouseDimensions, "width")/2  ,
            height            
        ]
    )
    children();
}

module move_to_center_entry(height = 0, length = 0, width = 0, inset = convert_ft2mm(1))
{
    translate(
        [
            getDictionaryValue(HouseDimensions, "length") + length/2- inset/2,
            getDictionaryValue(HouseDimensions, "width")/2,
            height            
        ]
    )
    children();
}

module move_to_fence_line(fence_properties = undef)
{
    // echo(easement = getDictionaryValue(fence_properties, "easement"));
    translate(
        [
            0,
            getDictionaryValue(fence_properties, "easement"),
            0
        ]
    )    
    children();
}