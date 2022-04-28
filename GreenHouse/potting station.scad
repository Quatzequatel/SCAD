/*
    
*/

include <constants.scad>;
include <GreenHouseProperties.scad>;

use <construction2.scad>;
use <convert.scad>;
// use <trigHelpers.scad>;
// use <ObjectHelpers.scad>;
use <dictionary.scad>;

//dictionaries

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

Y_block = 
[ "cinder block",
    ["x", block_width],
    ["y", block_length],
    ["z", block_height],
    ["move", [ HouseWidth - block_width, 0, 0]],
    ["rotate", [ 0, 0, 0] ],
    ["spacer", convert_in2mm(0.75)],
    ["color", "LightSlateGray"]
]; 

X_block = 
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

block_bed_width = 2 * block_length + gdv(Y_block, "spacer");


potting_station = 
[ "potting station",
    ["x", block_bed_width],
    ["y", convert_in2mm(48)],
    // ["z", convert_in2mm(36-16)],
    ["z", convert_in2mm(2)],
    ["move", [ HouseWidth, HouseLength/2 - convert_in2mm(48)/2, convert_in2mm(36)]],
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
    ["color", "Sienna"]
];

misting_station = 
[ "misting station",
    ["x", convert_in2mm(24)],
    ["y", convert_in2mm(42.75)],
    ["z", convert_in2mm(36)],
    ["move", [ HouseWidth + convert_in2mm(0.5), convert_in2mm(91.5), 0,]],
    ["rotate", [ 0, 0, 0] ],
    ["color", "AliceBlue"]
];

locations = 
[
    "locations",
    ["northeast corner", [ HouseWidth - block_width, 0, 0]],
    ["northeast bed", [ HouseWidth + block_bed_width - block_length - block_width -  gdv(Y_block, "spacer"), -block_bed_width, 0]],
    ["northwest bed", [ HouseWidth + block_bed_width - block_length - block_width -  gdv(Y_block, "spacer"), HouseLength + block_bed_width - block_width, 0]],
    [
        "west of potting station", 
        [ 
            HouseWidth + block_bed_width  - block_length, 
            HouseLength/2 + convert_in2mm(12), 
            block_width
        ]
    ]
];

build();

module build(args) 
{
    // drawGreenHouseFoundation();
    // drawNorthBlockWall();
    // draw_block_bed();
    add_potting_station();
    // add_misting_station();
}

module add_misting_station()
{
    //draw potting_station        
    applyColor(misting_station, 1)
    // // applyRotate(potting_station)
    applyMove(misting_station)
    // translate([ HouseWidth, 0, 0])
    applyExtrude(misting_station)
    moveToOrigin(misting_station)
    drawSquare(misting_station);
}

module add_potting_station()
{
    //draw potting_station        
    applyColor(potting_station)
    // applyMove(potting_station)
    
    applyExtrude(potting_station)
    moveToOrigin(potting_station)
    drawSquare(potting_station);

    //draw potting_station_bottom
    applyColor(potting_station_bottom)
    applyMove(potting_station_bottom)
    moveToOrigin(potting_station_bottom)
    applyExtrude(potting_station_bottom)
    drawSquare(potting_station_bottom);

    draw_blocks_around_potting_station_bottom();    
}

module draw_blocks_around_potting_station_bottom()
{
    // block west of potting station tier 1
    translate([0, 0, -block_width])
    moveTo(locations, "west of potting station")
    union()
    {
        for (i = [0:-1:-1])
        {
            draw_X_BlockWall(X_block, i);    
        }
    }        

    // block west of potting station tier 2
    // translate([0, 0, -block_width])
    moveTo(locations, "west of potting station")
    union()
    {
        for (i = [0:-1:-1])
        {
            draw_X_BlockWall(X_block, i);    
        }
    } 

    translate([0, -gdv(potting_station_bottom, "y") - block_width, 0])
    union()
    {
        // block west of potting station tier 1
        translate([0, 0, -block_width])
        moveTo(locations, "west of potting station")
        union()
        {
            for (i = [0:-1:-1])
            {
                draw_X_BlockWall(X_block, i);    
            }
        }        

        // block west of potting station tier 2
        // translate([0, 0, -block_width])
        moveTo(locations, "west of potting station")
        union()
        {
            for (i = [0:-1:-1])
            {
                draw_X_BlockWall(X_block, i);    
            }
        }        
    }
}

module draw_block_bed()
{
    //northeast side tier 1
    translate([block_bed_width, -block_bed_width, 0])
    for (i = [0:4])
    {
        draw_Y_BlockWall(Y_block, i);        
    }

    //northeast side tier 2
    translate([block_bed_width, -block_bed_width + block_width + convert_in2mm(0.5), block_width + convert_in2mm(0.1)])
    for (i = [0:3])
    {
        draw_Y_BlockWall(Y_block, i);        
    }    

    //northwest side tier 1
    translate([block_bed_width, -block_bed_width, 0])
    for (i = [7:11])
    {
        draw_Y_BlockWall(Y_block, i);        
    }

    //northwest side tier 2
    translate([block_bed_width, -block_bed_width + convert_in2mm(3.5), block_width])
    for (i = [7:10])
    {
        draw_Y_BlockWall(Y_block, i);        
    }

    //north east side tier 1
    moveTo(locations, "northeast bed")
    union()
    {
        for (i = [0:-1:-4])
        {
            draw_X_BlockWall(X_block, i);    
        }
    }    

    //north east side tier 2
    translate([block_width + convert_in2mm(0.5), 0, block_width])
    moveTo(locations, "northeast bed")
    union()
    {
        for (i = [0:-1:-4])
        {
            draw_X_BlockWall(X_block, i);    
        }
    }     
    
    //west side tier 1
    moveTo(locations, "northwest bed")
    union()
    {
        for (i = [0:-1:-14])
        {
            draw_X_BlockWall(X_block, i);    
        }
    }

    //west side tier 2
    translate([block_width + convert_in2mm(0.5), 0, block_width])
    moveTo(locations, "northwest bed")
    union()
    {
        for (i = [0:-1:-14])
        {
            draw_X_BlockWall(X_block, i);    
        }
    }    
}



module drawNorthBlockWall()
{
    //first tier
    for (i=[0:7]) 
    {
       draw_Y_BlockWall(Y_block, i);
    }

    //second tier start with half block
    drawHalfBlockWall(half_block, 1);
    //add slight adjustment to tier
    translate([ 0, convert_in2mm(0.75), 0])
    union()
    {
        for (i=[0:6]) 
        {
            moveZBlock(Y_block, 1)
            applyHalfYMove(Y_block)
        draw_Y_BlockWall(Y_block, i);
        }
    }

    //last half block
    translate([ 0, -block_width, 0])
    moveYBlock(Y_block, 8)
    drawHalfBlockWall(half_block,  1);

    //third tier
    for (i=[0:7]) 
    {
        moveZBlock(Y_block, 2)
        // applyHalfYMove(Y_block)
       draw_Y_BlockWall(Y_block, i);
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

module draw_Y_BlockWall(properties, index)
{
    applyColor(properties, 1.0)
    moveYBlock(properties, index)    
    applyMove(properties)
    moveToOrigin(properties)
    applyExtrude(properties)
    drawSquare(properties);
}

module draw_X_BlockWall(properties, index)
{
    applyColor(properties, 1.0)
    moveXBlock(properties, index)    
    // applyMove(properties)
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

module moveXBlock(properties, count)
{
    translate([ count * (gdv(properties, "x") + gdv(properties, "spacer")), 0, 0]) children();
}

module moveZBlock(properties, count)
{
    translate([ 0 , 0, count * (gdv(properties, "z") + gdv(properties, "spacer"))]) children();
}
