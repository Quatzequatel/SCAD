/*
    
*/

include <constants.scad>;

use <convert.scad>;
use <trigHelpers.scad>;
use <ObjectHelpers.scad>;
use <dictionary.scad>;

power_supply = 
[
    "60w power supply",
    ["x", convert_in2mm(5.66)],
    ["y", convert_in2mm(1.85)],
    ["z", convert_in2mm(1.33)],
    ["wall count",  4],
    ["floor layers", 12],
    ["color", "silver"]
];

wire_buffer = 0.2;

dc_wire =
[
    "DC wire details",
    ["wirelength", convert_in2mm(6)],
    ["rotate", [0, 90, 0]],
    ["top location", 16.6 ],
    ["diameter", 6.6 + wire_buffer],
    ["move", [gdv(power_supply, "x")/2, 0, 0]],
    ["color", "red"],
];

ac_wire =
[
    "AC wire details",
    ["wirelength", convert_in2mm(6)],
    ["rotate", [0, 90, 0]],
    ["top location", 16.6 ],
    ["diameter", 6.5 + wire_buffer],
    ["move", [-1.5*gdv(power_supply, "x"), 0, 0]],
    ["color", "black"],
];


power_supply_case = 
[
    "Bottom of 60w power supply enclosure",
    ["x", convert_in2mm(9)],
    ["y", 2 * gdv(power_supply, "y")],
    ["z", 2 * gdv(power_supply, "z")],
    ["wall count",  4],
    ["floor layers", 12],
    ["color", "WhiteSmoke"]
];

wall = WallThickness(gdv(power_supply_case, "wall count"));
spacer = 2;

power_supply_case_top = 
[
    "Top of 60w power supply enclosure",
    ["x", gdv(power_supply_case, "x") + wall + spacer],
    ["y",gdv(power_supply_case, "y") + wall + spacer],
    ["z", gdv(power_supply_case, "z")/2],
    ["wall count",  4],
    ["floor layers", 12],
    ["color", "Aqua"]
];

air_vents = 
[
    "details of air vents",
    ["diameter", 2],
    ["x", gdv(power_supply_case_top, "x") - 10],
    ["z", gdv(power_supply_case_top, "y") + 10 * wall],
    ["count", 29],
    ["rotate", [90, 0, 0]],
    ["move", [0, 0, 60]]
];

build();

module build() 
{
    draw_power_supply_enclosure(false);
}

module draw_power_supply_enclosure(printTop = true)
{
    difference()
    {
        union()
        {
            if(printTop)
            {
                echo("Save file as; Bottom_of_Power_Supply_Enclosure.stl");
                applyColor(power_supply_case)
                Box_bottom(power_supply_case); 
            }
            else
            {
                echo("Save file as; Top_of_Power_Supply_Enclosure.stl");
                draw_top(power_supply_case_top);
            }            
        }
      
        union()
        {
            applyColor(power_supply)
            translate([0,0,LayersToHeight(gdv(power_supply, "floor layers"))])
            draw_Box(power_supply);

            draw_wire(dc_wire);
            draw_wire(ac_wire);
            draw_air_vents(air_vents);
        }
    }
}

module draw_air_vents(args)
{
    count = gdv(args, "count");
    delta = gdv(args, "x")/count;
    start = -gdv(args, "x")/2;
    for (i=[1:count]) 
    {
        applyMove(args)
        translate([start + (i * delta), gdv(args, "z")/2, 0])
        applyRotate(args)
        linear_extrude(gdv(args, "z"))
        circle(d = gdv(args, "diameter"), $fn=100);
    }
    
}

module draw_wire(args) 
{
    translate([0, 0, gdv(args, "top location") - (gdv(args, "diameter")/2)])
    applyColor(args)
    applyMove(args)
    applyRotate(args)
    linear_extrude(gdv(args, "wirelength"))
    circle(d=gdv(args, "diameter"));
}

module draw_top(args) 
{
    properties_echo(args);
    spacer = 2;
    wall = WallThickness(gdv(args, "wall count"));
    floorheight = LayersToHeight(gdv(args, "floor layers"));
    x = gdv(args, "x") ;
    y = gdv(args, "y") ;
    z = gdv(args, "z");
    
    //move top 2 * z (which is power_supply_case.z) + floorheight of bottom + floorheight of top.
    translate([0, 0, 2 * gdv(args, "z") + 2 * floorheight])
    //at this point top of top is centered with z = 0;
    rotate([0, 180, 0])
    // color("AliceBlue", 0.3)
    applyColor(args)
    difference()
    {
        translate([-wall, -wall]) //move additional wall units
        moveToCenter(args)
        linear_extrude(height = z)
        //wall * 2, for each side of box.
        square([x + (2 * wall), y + (2 * wall)], center = false);


        translate([0,0,floorheight])
        moveToCenter(args)
        linear_extrude(height = z + 1)
        square([x, y], center = false);
    } 
}

module Box_bottom(args, clips = 1) 
{
    properties_echo(args);
    x = clips * gdv(args, "x");
    y = gdv(args, "y");
    z = gdv(args, "z");
    wall = WallThickness(gdv(args, "wall count"));
    floorheight = LayersToHeight(gdv(args, "floor layers"));

    moveToCenter(args)
    difference()
    {
        linear_extrude(height = z + floorheight)
        //wall * 2, for each side of box.
        square([x + 2*wall, y + 2*wall], center = false);

        translate([wall,wall,floorheight])
        linear_extrude(height = z + 1)
        square([x, y], center = false);
    }    
}

module draw_Box(args)
{
    x = gdv(args, "x");
    y = gdv(args, "y");
    z = gdv(args, "z");

        linear_extrude(height = z)
        square([x, y], center = true);    
}