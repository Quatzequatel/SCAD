/*
    
*/

include <constants.scad>;
include <GreenHouseProperties.scad>;

use <construction2.scad>;
use <convert.scad>;
// use <trigHelpers.scad>;
// use <ObjectHelpers.scad>;
use <dictionary.scad>;

houseDimensions = 
[
    "house dimensions",
        ["x", HouseWidth],    
        ["y", HouseLength],  
        ["z", HouseWallHeight],  
        ["peak height", HouseWallHeight + Height(x= HouseWidth/2, angle = RoofAngle)], 
        ["angle", RoofAngle ],
        ["wall thickness", convert_in2mm(4)],  
];

entryDimensions = 
[
    "entry dimensions",
        ["x", EntryWidth],    
        ["y", EntryLength],  
        ["z", gdv(houseDimensions, "z")],
        ["move", [HouseWidth/2 - EntryWidth/2, -EntryLength, 0]],
        ["rotate", [ 0, 90, 0] ],
        ["color", "LightSlateGray"],        
        ["wall thickness", convert_in2mm(4)],  
        ["foundation height", convert_in2mm(4)],          
];

block_width = convert_in2mm(8);
block_length = convert_in2mm(16);
block_height = convert_in2mm(8);

block = 
[ "cinder block",
    ["x", block_width],
    ["y", block_length],
    ["z", block_height],
    ["move", [ HouseWidth - block_width, 0, 0]],
    ["rotate", [ 0, 0, 0] ],
    ["spacer", convert_in2mm(0.75)],
    ["color", "LightSlateGray"]
]; 

Y_block = 
[ "cinder block",
    ["x", block_length],
    ["y", block_width],
    ["z", block_height],
    ["move", [ HouseWidth - block_width, 0, 0]],
    ["rotate", [ 0, 0, 0] ],
    ["spacer", convert_in2mm(0.75)],
    ["color", "LightSlateGray"]
];

half_block = 
[ "cinder block",
    ["x", block_width],
    ["y", block_length/2],
    ["z", block_height],
    ["move", [ HouseWidth - block_width, 0, 0]],
    ["rotate", [ 0, 0, 0] ],
    ["spacer", convert_in2mm(0.75)],
    ["color", "LightSlateGray"]
];

block_bed_width = 2 * block_length + gdv(block, "spacer");

locations = 
[
    "locations",
    ["northeast corner", [ HouseWidth - block_width, 0, 0]],
    ["northeast bed", [ HouseWidth + block_bed_width - block_width, 0, 0]]
];

build();

module build(args) 
{
    drawGreenHouseFoundation();
    drawNorthBlockWall();
    draw_block_bed();
    add_potting_station();

}

module add_potting_station()
{
        potting_station = 
        [ "potting station",
            ["x", block_bed_width],
            ["y", convert_in2mm(48)],
            ["z", convert_in2mm(36-16)],
            ["move", [ HouseWidth, HouseLength/2 - convert_in2mm(48)/2, convert_in2mm(16)]],
            ["rotate", [ 0, 0, 0] ],
            ["color", "LightGreen"]
        ];

        potting_station_bottom = 
        [ "potting station",
            ["x", block_bed_width],
            ["y", convert_in2mm(24)],
            ["z", convert_in2mm(16)],
            ["move", [ HouseWidth, HouseLength/2 - convert_in2mm(24)/2, convert_in2mm(0)]],
            ["rotate", [ 0, 0, 90] ],
            ["color", "LightSlateGray"]
        ];

        applyColor(potting_station)
        // // applyRotate(potting_station)
        applyMove(potting_station)
        // translate([ HouseWidth, 0, 0])
        applyExtrude(potting_station_bottom)
        moveToOrigin(potting_station)
        drawSquare(potting_station);

        applyColor(potting_station_bottom)
        applyMove(potting_station_bottom)
        // applyRotate(potting_station_bottom)
        moveToOrigin(potting_station_bottom)
        applyExtrude(potting_station_bottom)
        drawSquare(potting_station_bottom);
}

module draw_block_bed()
{
    for (i = [0:4])
    {
        translate([block_bed_width, -block_bed_width, 0])
        drawBlockWall(block, i);        
    }

    for (i = [7:11])
    {
        translate([block_bed_width, -block_bed_width, 0])
        drawBlockWall(block, i);        
    }


}

module drawNorthBlockWall()
{
    for (i=[0:7]) 
    {
        // moveZBlock(block, 1)
       drawBlockWall(block, i);
    }

    drawHalfBlockWall(half_block, 1);
    for (i=[0:6]) 
    {
        moveZBlock(block, 1)
        applyHalfYMove(block)
       drawBlockWall(block, i);
    }

    translate([ 0, -block_width, 0])
    moveYBlock(block, 8)
    drawHalfBlockWall(half_block,  1);

    for (i=[0:7]) 
    {
        moveZBlock(block, 2)
        // applyHalfYMove(block)
       drawBlockWall(block, i);
    }
}

module drawGreenHouseFoundation()
{
    // applyColor(entryDimensions)
    applyMove(entryDimensions)
    moveToOrigin(entryDimensions)
    // applyExtrude(entryDimensions)
    drawSquare(entryDimensions);

    moveToOrigin(houseDimensions)
    drawSquare(houseDimensions);
}

module drawBlockWall(properties, index)
{
    applyColor(properties, 1.0)
    moveYproperties(properties, index)    
    applyMove(properties)
    moveToOrigin(properties)
    applyExtrude(properties)
    drawSquare(properties);
}

module drawHalfBlockWall(properties, zRow)
{
    applyColor(properties, 1.0)
    moveZBlock(properties, zRow)    

    applyMove(properties)
    moveToOrigin(properties)
    applyExtrude(properties)
    drawSquare(properties);
}

module applyHalfXMove(properties)
{
    translate([gdv(properties, "x")/2, 0, 0]) children();
}

module applyHalfYMove(properties)
{
    translate([ 0, gdv(properties, "y")/2, 0]) children();
}

module moveYBlock(properties, count)
{
    translate([ 0, count * (gdv(properties, "y") + gdv(properties, "spacer")), 0]) children();
}

module moveZBlock(properties, count)
{
    translate([ 0 , 0, count * (gdv(properties, "z") + gdv(properties, "spacer"))]) children();
}
