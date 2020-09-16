/*
    
*/

include <constants.scad>;
include <GreenHouseProperties.scad>;

use <convert.scad>;
use <trigHelpers.scad>;
use <ObjectHelpers.scad>;
use <dictionary.scad>;
use <construction.scad>;

build();

module build(args) 
{
    add_floor();
    add_block_layer_to_eastwest_wall(west_wall, block_EW);
    add_block_layer_to_eastwest_wall(east_wall_1, block_EW);
    add_block_layer_to_eastwest_wall(east_wall_2, block_EW);
    add_block_layer_to_eastwest_wall(east_wall_3, block_EW);
    add_block_layer_to_north_wall(north_wall, block_NS);
    add_block_layer_to_north_wall(south_wall, block_NS);

}

module add_floor() 
{
    %color("brown", 0.5) 
    translate([-HouseWidth/2, -HouseLength/2])
    square([HouseWidth, HouseLength]);

    %color("brown", 0.5) 
    translate([0, -1 * (HouseLength/2 + EntryLength/2 )])
    square([EntryWidth, EntryLength], center = true);
}

module add_block_layer_to_eastwest_wall(wall_properties, block)
{
    for (i=[0:gdv(wall_properties, "count")]) 
    {
        color(gdv(block, "color"))
        move_to_eastwest_wall_location(wall_properties, block, i) 
        rotate_object(block) 
        instanciate3D(block, false);         
    } 
}

module add_block_layer_to_north_wall(wall, block)
{
    for (i=[0:gdv(wall, "count")]) 
    {
        color(gdv(block, "color"))
        move_to_north_wall_location(wall, block, i) 
        rotate_object(block) 
        instanciate3D(block, false);         
    } 
}

module move_to_start(p)
{
    translate(gdv(p, "start location")) 
    children();
}

module move_to_eastwest_wall_location(wall, block, id)
{
    start = gdv(wall, "start location");
    ploc = 
    [
        start.x + id * gdv(block, "length") + id * gdv(wall, "mortar gap"), 
        start.y,
        0
    ];

    // echo(ploc = ploc);

    translate(ploc)
    children();
}

module move_to_north_wall_location(wall, block, id)
{
    start = gdv(wall, "start location");
    ploc = 
        [
            start.x, 
            start.y 
                - gdv(wall, "mortar gap")
                - id * gdv(block, "length") 
                - id * gdv(wall, "mortar gap"), 
            0
        ];

    translate(ploc)
    children();
}

block_width = convert_in2mm(8);
block_length = convert_in2mm(15.5);
block_height = convert_in2mm(8);
mortar_gap = convert_in2mm(0.5);

east_wall_1 = 
[
    "east wall 1",
    ["count", 3],
    ["start location", [-HouseWidth/2 + block_length/2, -HouseLength/2 + block_width/2]],
    ["end location", [HouseWidth/2, HouseLength/2]],
    ["mortar gap", mortar_gap],
    ["rotate", [0,0, 0]],
    ["color", "LightGrey"]
];

east_wall_2 = 
[
    "east wall 2",
    ["count", 3],
    ["start location", [EntryWidth/2 + block_length/2, -HouseLength/2 + block_width/2]],
    ["end location", [HouseWidth/2, HouseLength/2]],
    ["mortar gap", mortar_gap],
    ["rotate", [0,0, 0]],
    ["color", "LightGrey"]
];

east_wall_3 = 
[
    "east wall 3",
    ["count", 3],
    ["start location", [-HouseWidth/2 + block_length/2, -HouseLength/2 + block_width/2]],
    ["end location", [HouseWidth/2, HouseLength/2]],
    ["mortar gap", mortar_gap],
    ["rotate", [0,0, 0]],
    ["color", "LightGrey"]
];

west_wall = 
[
    "west wall",
    ["count", 11],
    ["start location", [-HouseWidth/2 + block_length/2, HouseLength/2 - block_width/2]],
    ["end location", [HouseWidth/2, HouseLength/2]],
    ["mortar gap", mortar_gap],
    ["rotate", [0,0, 0]],
    ["color", "LightGrey"]
];

north_wall = 
[
    "north wall",
    ["count", 6],
    ["start location", 
        [
            HouseWidth/2 - block_width/2, 
            HouseLength/2 - block_length - convert_in2mm(0.25)
        ]
    ],
    ["end location", [HouseWidth/2, HouseLength/2]],
    ["mortar gap", mortar_gap],
    ["rotate", [0,0, 90]],
    ["color", "LightGrey"]
];

south_wall = 
[
    "south wall",
    ["count", 6],
    ["start location", 
        [
            -1 * HouseWidth/2 + block_width/2, 
            HouseLength/2 - block_length - convert_in2mm(0.25)
        ]
    ],
    ["end location", [HouseWidth/2, HouseLength/2]],
    ["mortar gap", mortar_gap],
    ["rotate", [0,0, 90]],
    ["color", "LightGrey"]
];

block_EW = 
[
    "block east-west",
    ["length" , block_length],
    ["depth" , block_width],
    ["height", block_height],
    ["move", [0, HouseLength/2 - block_width/2, 0]],
    ["rotate", [0,0, 0]],
    ["color", "LightGrey"]
];

block_NS = 
[
    "block north-south",
    ["length", block_length],
    ["depth" , block_width],
    ["height", block_height],
    ["move", [- HouseWidth/2 + block_width/2, 0, 0]],
    ["rotate", [0,0, 90]],
    ["color", "yellow"]
];