include <constants.scad>;

use <convert.scad>;
use <trigHelpers.scad>;
use <ObjectHelpers.scad>;
use <dictionary.scad>;

use <Carpet_corner.scad>;

build(args = []);

module build(args) 
{
    echo(args=args);
    sizeX = 200;
    sizeY = 100;
    if(args == ["top"])
    {
        linear_extrude(height=2)
        hex_lattice_square(sizeX = sizeX, sizeY = sizeY, hex_flat_d=5, gap=1, border=10);
        draw_walls(sizeX = sizeX, sizeY = sizeY, wall_thickness = 2.4);
    }
    else
    {
        //top tray
        difference() 
        {
            linear_extrude(height=2)
            hex_lattice_square(sizeX = sizeX, sizeY = sizeY, hex_flat_d=5, gap=1, border=10);
            translate([0.2,0,-1])
            draw_walls(sizeX = sizeX, sizeY = sizeY, wall_thickness = 2.6);
        }
    }

    //draw_walls(sizeX = sizeX, sizeY = sizeY, wall_thickness = 2.4);

}

module draw_walls(sizeX = 200, sizeY = 100, wall_thickness=2.4)
{
    sizeX = sizeX;
    sizeY = sizeY;
    wallY = 90;
    left_edge = 5;
    bottom_edge = 2;
    bandAid1 = 40;
    bandAid2 = 36;
    Nexcare1 = [46,95];
    SteriStrip1 = [80,95];
    ba1 = [40,95];
    ba2 = [36,95];
    wall_thickness = wall_thickness;
    height = 10;

    // Preview
    translate([left_edge, left_edge])
    Organizer_walls(sizeX = bandAid1, sizeY = wallY, wall_thickness=2.5, height=10);
    
    translate([ left_edge + wall_thickness + bandAid1, left_edge])
    Organizer_walls(sizeX = bandAid2, sizeY = wallY, wall_thickness=2.5, height=10);

    translate([ left_edge + wall_thickness + bandAid1 + wall_thickness + bandAid2, left_edge])
    Organizer_walls(sizeX = Nexcare1.x, sizeY = wallY, wall_thickness=2.5, height=10);

    // // color("Lightblue", 0.5)
    // translate([left_edge + wall_thickness,bottom_edge])
    // square(ba1, center=false);
    
    // // color("Lightblue", 0.5)
    // translate([ left_edge + wall_thickness + bandAid1 + wall_thickness, bottom_edge])
    // square(ba2, center=false);

    // // color("LightSeaGreen", 0.5)
    // translate([ left_edge + 
    //             wall_thickness + 
    //             bandAid1 + 
    //             wall_thickness + 
    //             bandAid2 + 
    //             wall_thickness, bottom_edge])
    // square(Nexcare1, center=false);    

    // // color("DarkOrange", 0.5)
    // translate([ left_edge + 
    //             wall_thickness + 
    //             bandAid1 + 
    //             wall_thickness + 
    //             bandAid2 + 
    //             wall_thickness + 
    //             Nexcare1.x +
    //             wall_thickness, bottom_edge])
    // square(SteriStrip1, center=false);    

    linear_extrude(height=height)
    translate([sizeX - wall_thickness - left_edge, left_edge])
    square([wall_thickness, wallY], center=false);
}

module Organizer_walls(sizeX = 200, sizeY = 100, wall_thickness=2.5, height=10)
{
    echo("Organizer_walls: sizeX=", sizeX, " sizeY=", sizeY, " wall_thickness=", wall_thickness, " height=", height);
    // Walls for travel organizer box
    linear_extrude(height=height)
    union() 
    {
        square([wall_thickness, sizeY], center=false);
        
        translate([sizeX + wall_thickness, 0])
        square([wall_thickness, sizeY], center=false);
    }
}