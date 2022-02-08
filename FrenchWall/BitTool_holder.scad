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
// use <../libraries/vectorHelpers.scad>;


//un comment to show ruler in drawing.
// scale(size = 5, increment = convert_in2mm(1), fontsize = 8);
// screwDriverTray();
// completeBitTray();
// drawHammerHandle();
// drawPeggedHandle();
// drawDrillPeggedHandle();
// drawDrillPeggedHandleV2();
// drawTriSquareHolder();

// draw_Cleated_Back_Wall(Backwall);
// draw_Cleat_for_BackWall(Backwall);
// draw_Drill_Bit_Holder_Cleated();
// draw_box_for_staples();
draw_peg_holder_for_staples();
// scale();

/*
 create a tall back wall property that measure y = tray y + 1.25" + 1.5"
 => 0.5 + 1.25 + 1.5 == 3.25
  then this shoulds all work out.
*/
module draw_box_for_staples()
{
    stapleBoxLength = 108;
    stapleBoxWidth = 17;
    stapleBoxSpacing = convert_in2mm(0.25);

    box = ["inner box",
        ["x", stapleBoxLength],
        ["y", stapleBoxWidth],
        ["z", gdv(Tray, "z") ],
        ["move", [ (gdv(Tray, "x") - stapleBoxLength)/2,  0, LayersToHeight(8)]],
        ["rotate", [0,0, 0]],
        ["color", "yellow"]
    ];

    shortBackwall = 
    ["short back wall", 
        ["x", gdv(Tray, "x")],
        ["y", NozzleWidth * 8],
        ["z", convert_in2mm(1.5)],
        ["move", [0, 0, 0]],
        ["from edge", 0],
        ["rotate", [0,0, 0]],
        ["include cleat", false],
        ["cleat", cleat],
        ["color", "LightGrey"]
    ];    

    // translate([gdv(Tray, "x"), gdv(Tray, "y"), convert_in2mm(1.75)])
    rotate([0,0,180])
    difference()
    {
        union()
        {
            drawSquareShape(Tray);
            translate([0,gdv(Tray, "y") - 2,0])
            drawSquareShape(shortBackwall);
        }

        translate([0, stapleBoxSpacing, 0])
        drawSquareShape(box);

        translate([0, 2 * stapleBoxSpacing + gdv(box, "y"), 0])
        drawSquareShape(box);

        translate([0, 3 * stapleBoxSpacing + 2 * gdv(box, "y"), 0])
        drawSquareShape(box);    
        
        translate([0,gdv(Tray, "y") - 2, -convert_in2mm(0.75)])
        screw_hole_counter_sink(screwholes, shortBackwall);
    }
}

module draw_peg_holder_for_staples()
{
        shortBackwall = 
    ["short back wall", 
        ["x", gdv(Tray, "x")],
        ["y", NozzleWidth * 8],
        ["z", convert_in2mm(1.5)],
        ["move", [0, 0, 0]],
        ["from edge", 0],
        ["rotate", [0,0, 0]],
        ["include cleat", false],
        ["cleat", cleat],
        ["color", "LightGrey"]
    ];   

    //Peg holder
    rotate([0,0,180])
    difference()
    {
        union()
        {
            rotate([7,0,0])
            drawSquareShape(shortBackwall);
            // translate([-5,0,-6])
            // drawPegs(DrillPeg, HammerBackwall);
            // translate([gdv(DrillPeg, "from edge"),0,0])
            radius = gdv(DrillPeg,"x")/2;
            spacing = gdv(shortBackwall, "x")/3;
            
            //left peg
            translate([spacing - radius,0,0])
            drawCircleShape(DrillPeg);
            
            //right peg
            translate([gdv(shortBackwall, "x") - (radius + convert_in2mm(0.5)) ,0,0])
            drawCircleShape(DrillPeg);

            echo(distance = (gdv(shortBackwall, "x") - (radius + convert_in2mm(0.5))) - (spacing - radius) );
        }

        screw_hole_counter_sink(screwholes, shortBackwall);

        translate([0, 0, -gdv(shortBackwall, "z") + convert_in2mm(0.75)])
        screw_hole_counter_sink(screwholes, shortBackwall);
    } 
}

/*
    For use in models where cleat is part of object
*/
module draw_Cleated_Back_Wall(properties)
{
    // properties_echo(properties);
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

/*
    For stand alone printing.
*/
module draw_Cleat_for_BackWall( properties)
{
    //rotate for printing
    rotate([0, 90, 0])
    translate([gdv(properties, "x"), 0, 0])
    rotate([0, 0, 180])
    draw_Cleat_for_Back_Wall(properties);
}



module drawDrillPeggedHandleV2()
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
            spacing = gdv(Backwall, "x")/4;
            
            translate([spacing - radius,0,0])
            drawCircleShape(DrillPeg);
            
            translate([gdv(Backwall, "x") - spacing - radius,0,0])
            drawCircleShape(DrillPeg);
        }

         screw_hole_counter_sink(screwholes, Backwall);

        //  translate([0, 0, -gdv(Backwall, "z") + convert_in2mm(0.75)])
        //  screw_hole_counter_sink(screwholes, Backwall);
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
            drawSquareShape(Backwall);
            // translate([-5,0,-6])
            // drawPegs(DrillPeg, HammerBackwall);
            // translate([gdv(DrillPeg, "from edge"),0,0])
            radius = gdv(DrillPeg,"x")/2;
            spacing = (gdv(Backwall, "x") - (2*gdv(DrillPeg,"x")))/5;
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

            translate([gdv(Backwall, "x") - gdv(DrillPeg,"x") ,0,0])
            drawSquareShape(DrillPeg);        }

         screw_hole_counter_sink(screwholes, Backwall);
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

module draw_Drill_Bit_Holder_Cleated()
{
    drillBits = [
        [convert_in2mm(4/64) + 1, "1/16"],  
        [convert_in2mm(4/64) + 1, "1/16"],  
        [convert_in2mm(5/64) + 1, "5/64"],
        [convert_in2mm(5/64) + 1, "5/64"],
        [convert_in2mm(6/64) + 1, "3/32"],
        [convert_in2mm(6/64) + 1, "3/32"],
        [convert_in2mm(7/64) + 1, "7/64"],
        [convert_in2mm(7/64) + 1, "7/64"],
        [convert_in2mm(8/64) + 1, "1/8"], 
        [convert_in2mm(8/64) + 1, "1/8"], 
        [convert_in2mm(9/64) + 1, "9/64"],
        [convert_in2mm(9/64) + 1, "9/64"],
        [convert_in2mm(10/64) + 1,  "5/32"],
        [convert_in2mm(10/64) + 1,  "5/32"],
        [convert_in2mm(11/64) + 1,  "11/64"],
        [convert_in2mm(11/64) + 1,  "11/64"],
        [convert_in2mm(12/64) + 1,  "3/16"],
        [convert_in2mm(12/64) + 1,  "3/16"],
        [convert_in2mm(14/64) + 1,  "7/32"],
        [convert_in2mm(14/64) + 1,  "7/32"],
        [convert_in2mm(16/64) + 1,  "1/4"],
        [convert_in2mm(16/64) + 1,  "1/4"],
        [convert_in2mm(20/64) + 1,  "5/16"],
        [convert_in2mm(20/64) + 1,  "5/16"],
        [convert_in2mm(24/64) + 1,  "3/8"],
        [convert_in2mm(24/64) + 1,  "3/8"],
        [convert_in2mm(32/64) + 1,  "1/2"],
        [convert_in2mm(32/64) + 1,  "1/2"],

        // convert_in2mm(5/16) + 1, 
        // convert_in2mm(6/16) + 1, 
        // convert_in2mm(7/16) + 1, 
        // convert_in2mm(8/16) + 1, 
        // convert_in2mm(9/16) + 1, 
        // convert_in2mm(10/16) + 1, 
        // convert_in2mm(11/16) + 1, 
        // convert_in2mm(12/16) + 1, 
        // convert_in2mm(13/16) + 1, 
        // convert_in2mm(14/16) + 1, 
        // convert_in2mm(15/16) + 1, 
        // convert_in2mm(16/16) + 1, 
        ];
        
    properties_echo(Tray);

    trayWidth = gdv(Tray, "x");
    trayDepth = gdv(Tray, "y");
    bottom_thickness = LayersToHeight(4);
    rows = 7;
    columns = floor(len(drillBits)/rows) - 1 ;

    xSpace = gdv(Tray, "x") / (rows);
    ySpace = gdv(Tray, "y") / (columns + 1);
    // ySpace = 19.05;
    // ySpace = trayDepth / (columns + 1);
    echo(trayWidth = trayWidth,  trayDepth = trayDepth)
    echo(rows = rows, columns = columns, xSpace = xSpace, ySpace = ySpace);


    difference()
    {
        translate([gdv(Tray,"x"), gdv(Tray,"y"), 0])
        rotate([0,0,180])
        union()
        {
            drawSquareShape(Tray);
            // translate([0, gdv(Tray, "y"),0])
            
            draw_Cleated_Back_Wall(Backwall);            
        }
        
        for (col = [0 : columns]) 
        {
            for(row = [0 : rows - 1])
            {
                if( row + (col * rows) < len(drillBits))
                {
                    echo(x= row * xSpace, y = col * ySpace, row = row, col = col, drillBit = row + (col * rows) );
                    translate([ row * xSpace + xSpace/2 , col * ySpace + ySpace/2, bottom_thickness + gdv(Tray, "z")/2])
                    #cylinder(d = drillBits[ row + (col * rows)][0], h = gdv(Tray, "z"), center=true, $fn=60);
                    
                    translate([ row * xSpace + xSpace/4 , col == 0 ? col * ySpace + 2 : (col * ySpace) - 2, gdv(Tray, "z") - bottom_thickness ])
                    #linear_extrude(height = bottom_thickness)
                    text(text=drillBits[ row + (col * rows)][1], size = 3);
                }

            }
        }
        
    }
}

module completeBitTray()
{
    difference()
    {
        union()
        {
            drawSquareShape(Tray);
            // translate([0, gdv(Tray, "y"),0])
            draw_Cleated_Back_Wall(Backwall);            
        }
        
        drawArrayOfCircleShapes(tool_bit_array, Bit);
        // screw_hole_counter_sink(screwholes, Backwall);
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
