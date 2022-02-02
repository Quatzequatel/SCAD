/*
    1. bit holder tray for french wall
    2. Back with holes to attach to cleat board.
*/

include <constants.scad>;
include <../FrenchWall/ToolHolders_Library.scad>;
use <../FrenchWall/ToolHolders_Modules_Library.scad>;

use <convert.scad>;
use <trigHelpers.scad>;
use <ObjectHelpers.scad>;
use <dictionary.scad>;


//un comment to show ruler in drawing.
// scale(size = 5, increment = convert_in2mm(1), fontsize = 8);
// screwDriverTray();
// completeBitTray();
// drawHammerHandle();
// drawPeggedHandle();
drawDrillPeggedHandle();
// drawTriSquareHolder();

// draw_Cleated_Back_Wall();
// scale();

module draw_Cleated_Back_Wall(properties)
{
    properties_echo(properties);
    //now wall and cleat is at [0,0]
    //move to positive 0 x-axis.
    translate([gdv(properties,"x"),0,0])
    //rotate so cleat is external and wall is located at 0 y-axis
    rotate([0,0,180])
    union()
    {
        //draw wall
        drawSquareShape(properties);    
        //draw cleat
        translate([0, gdv(properties,"y"), gdv(properties,"z")])
        draw_parallelogram(gdv(properties, "cleat"));
    }
}

module drawDrillPeggedHandle()
{
    
    difference()
    {
        union()
        {
            rotate([7,0,0])
            drawSquareShape(Backwall);
            // translate([-5,0,-6])
            // drawPegs(DrillPeg, HammerBackwall);
            // translate([gdv(DrillPeg, "from edge"),0,0])
            radius = gdv(DrillPeg,"x")/2;
            spacing = gdv(Backwall, "x")/3;
            
            translate([spacing - radius,0,0])
            drawCircleShape(DrillPeg);
            
            translate([2*spacing - radius,0,0])
            drawCircleShape(DrillPeg);
        }

         screw_hole_counter_sink(screwholes, Backwall);

        translate([0, 0, -gdv(Backwall, "z") + convert_in2mm(0.75)])
         screw_hole_counter_sink(screwholes, Backwall);
    }
              
}

module drawTriSquareHolder()
{
    
    difference()
    {
        union()
        {
            rotate([7,0,0])
            drawSquareShape(backwall);
            // translate([-5,0,-6])
            // drawPegs(DrillPeg, HammerBackwall);
            // translate([gdv(DrillPeg, "from edge"),0,0])
            radius = gdv(DrillPeg,"x")/2;
            spacing = (gdv(backwall, "x") - (2*gdv(DrillPeg,"x")))/5;
            start = gdv(DrillPeg,"x");

            echo(start = start, radius = radius, spacing = spacing);
            
            drawSquareShape(DrillPeg);

            translate([start + spacing - radius,0,0])
            drawSquareShape(DrillPeg);
            
            translate([start + 2*spacing - radius,0,0])
            drawSquareShape(DrillPeg);

            translate([start + 3*spacing - radius,0,0])
            drawSquareShape(DrillPeg);

            translate([start + 4*spacing - radius,0,0])
            drawSquareShape(DrillPeg);

            translate([gdv(backwall, "x") - gdv(DrillPeg,"x") ,0,0])
            drawSquareShape(DrillPeg);        }

         screw_hole_counter_sink(screwholes, backwall);
    }
              
}

module drawPeggedHandle()
{
    
    difference()
    {
        union()
        {
            drawSquareShape(HammerBackwall);
            translate([gdv(Peg, "from edge"),0,0])
            drawCircleShape(Peg);
            
            translate([-gdv(Peg, "from edge"),0,0])
            drawCircleShape(Peg);
        }

        screw_hole_counter_sink(screwholes, HammerBackwall);
    }
              
}

module completeBitTray()
{
    difference()
    {
        union()
        {
            drawSquareShape(tray);
            translate([0, gdv(tray, "y"),0])
            draw_Cleated_Back_Wall();            
        }
        
        drawArrayOfCircleShapes(tool_bit_array, bit);
        // screw_hole_counter_sink(screwholes, backwall);
    }
}

module screwDriverTray()
{
    tray = 
    ["tray", 
        ["x", convert_in2mm(7)],
        ["y", convert_in2mm(3)],
        ["z", convert_in2mm(0.5)],
        ["move", [0, 0, 0]],
        ["rotate", [0,0, 0]],
        ["color", "LightGrey"]
    ];
    cleat = 
    ["cleat properties", 
        ["x", gdv(tray, "x")],
        ["y", NozzleWidth * 8],
        ["z", convert_in2mm(0.75)],
        ["parallelogram length", convert_in2mm(0.75) ],
        ["parallelogram thickness", NozzleWidth * 8],
        ["angle", 135],
        ["extrude height", gdv(tray, "x")],
        ["move", [0, 0, 0]],
        ["from edge", 0],
        ["rotate", [0, 0, 0]],
        ["color", "LightGrey"]
    ];

    backwall = 
    ["backwall", 
        ["x", gdv(tray, "x")],
        ["y", NozzleWidth * 8],
        ["z", convert_in2mm(2.5)],
        ["move", [0, 0, 0]],
        ["from edge", 0],
        ["rotate", [0,0, 0]],
        ["include cleat", false],
        ["cleat", cleat],
        ["color", "LightGrey"]
    ];


    shaft = 
    ["bit dimension",
        ["x", convert_in2mm(0.75)],
        ["y", convert_in2mm(1)],
        ["z", gdv(tray, "z") * 1.25],
        ["fragments", 60],
        ["move", [0,0,LayersToHeight(-2)]],
        ["rotate", [0,0, 0]],
        ["color", "lightYellow"]
    ];

    shaft_array = 
    ["tool_bit_array",
        ["x", gdv(tray, "x")],
        ["y", gdv(tray, "y")],
        ["z", gdv(tray, "z")],
        ["columns", 3],
        ["rows", 7],
        ["spacing", 0],
        //move is a final adjustment
        ["move", [gdv(shaft, "x")/6, 0, 0]],
        ["rotate", [0,0, 0]],
        ["color", "yellow"]
    ];

    //rotate for printing
    rotate([0,90,0])
    difference()
    {
        union()
        {
            drawSquareShape(tray);
            draw_Cleated_Back_Wall(backwall);      
        }

        drawArrayOfCircleShapes(shaft_array, shaft);
        screw_hole_counter_sink(screwholes, backwall);

    }
}

module screw_hole_counter_sink(properties, backwall)
{
    // properties_echo(properties);
    // properties_echo(backwall);

    count = gdv(properties, "count");
    spacing = gdv(backwall, "x") / (count + 1);

    for(item = [0: count])
    {
        translate([item * spacing + spacing/2, 0, 0])
        drawCircleShape(properties);
    }
}

module drawPegs(properties, backwall)
{
    properties_echo(properties);
    properties_echo(backwall);

    count = gdv(properties, "count");
    spacing = gdv(backwall, "x") / (count + 1);

    for(item = [0: count])
    {
        translate([item * spacing + spacing/2, 0, 0])
        drawCircleShape(properties);
    }
}


module drawPegs2(pegs, wall)
{
    properties_echo(pegs);
    properties_echo(wall);

    count = gdv(pegs, "count");
    spacing = gdv(wall, "x") / (1 + count) - gdv(pegs, "x")/2;

    for(item = [0: count-1])
    {
        echo(spacing = (item * spacing) + spacing);
        translate([(item * spacing) + spacing, 0, 0])
        
            color(gdv(pegs, "color"), 0.5)
            // translate(gdv(pegs, "move"))
            rotate(gdv(pegs, "rotate"))
            translate([gdv(pegs, "x")/2, gdv(pegs, "y")/2])
            linear_extrude(gdv(pegs, "z"))
            circle(d=gdv(pegs, "x"), $fn = gdv(pegs, "fragments"));
    }
}

module drawHammerHandle()
{
    difference()
    {
        union()
        {
            drawSquareShape(HammerTray);
            drawSquareShape(HammerBackwall);            
        }        

        translate([0,-5,0])
        union()
        {
            drawCircleShape(HammerHead);
            hull() 
            {
                translate([0,-(gdv(HammerHead, "y")*2),0])
                drawCircleShape(HammerShaft);    
                drawCircleShape(HammerShaft);    
            }            
        }      
        translate([gdv(HammerBackwall, "from edge"),-10,-10])
        drawCircleShape(screwhole);
        translate([-gdv(HammerBackwall, "from edge"),-10,-10])
        drawCircleShape(screwhole);

        translate([29,-14,0])
        difference()
        {
            drawSquareShape(HammerShapperTray); 
            hull()
            {
                drawCircleShape(HammerShaper);
                translate([0,20,0])
                drawCircleShape(HammerShaper);
            }
            
        }      

        translate([-29,-14,0])
        difference()
        {
            drawSquareShape(HammerShapperTray); 
            hull()
            {
                drawCircleShape(HammerShaper);
                translate([0,20,0])
                drawCircleShape(HammerShaper);
            }
            
        }  
    }

}
