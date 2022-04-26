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
// drawSquarePegHolder();

// draw_Cleated_Back_Wall(Backwall);
// draw_Cleat_for_BackWall(Backwall);
// draw_Drill_Bit_Holder_Cleated();
// draw_box_for_staples();
// draw_box_for_JigSaw_Box();
// draw_peg_holder_for_staples();
draw_box_Ratchet_Set();
// scale();


module draw_box_Ratchet_Set() 
{
    echo();
    echo(FileName = "Ratchet_Set_Tray.stl");
    echo();
    tray = 
    ["tray", 
        ["x", convert_in2mm(7.5)],
        ["y", convert_in2mm(3)],
        ["z", convert_in2mm(0.75)],
        ["move", [0, 0, 0]],
        ["rotate", [0,0, 0]],
        ["color", "LightGrey"]
    ];

    cleat = 
    ["cleat properties", 
        ["x", gdv(tray, "x")],
        ["y", cleat_thickness],
        ["z", convert_in2mm(0.75)],
        ["parallelogram length", convert_in2mm(0.75)/sin(45) ],
        ["parallelogram thickness", cleat_thickness],
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
        ["y", cleat_thickness],
        ["z", convert_in2mm(2.5)],
        ["move", [0, 0, 0]],
        ["from edge", 0],
        ["rotate", [0,0, 0]],
        ["include cleat", false],
        ["cleat", cleat],
        ["color", "LightGrey"]
    ];

    hex_bit = 
    ["bit dimension",
        ["x", HexBitHoleDia],
        ["y", HexBitHoleDia],
        ["z", gdv(tray, "z")],
        ["fragments", 6],
        ["move", [0,0,LayersToHeight(8)]],
        ["rotate", [0,0, 0]],
        ["color", "LightBlue"]
    ];

    function Index(row, col, rows) =  row + (col * rows);  

    socketXajustment = 7.025;
    // socketX = convert_in2mm(1/2) - 1;
    minSocketDiameter = 23;

    sockets = [
        [minSocketDiameter, "3/8"],  
        [minSocketDiameter, "7/16"],  
        [minSocketDiameter, "1/2"],
        [minSocketDiameter, "9/16"],
        [convert_in2mm(11/16) + socketXajustment, "5/8"],
        [convert_in2mm(12/16) + socketXajustment, "11/16"],
        [convert_in2mm(13/16) + socketXajustment, "3/4"],
        [convert_in2mm(14/16) + socketXajustment, "13/16"],
        [convert_in2mm(15/16) + socketXajustment, "   7/8"], 
        [convert_in2mm(16/16) + socketXajustment, "    15/16"], 
        [convert_in2mm(1 + 1/16) + socketXajustment, "      1 inch"]
    ];

    columns =  1;
    rows = 6;

    xSpace = gdv(tray, "x") / (rows);
    ySpace = gdv(tray, "y") / (columns + 1);
    bottom_thickness = LayersToHeight(8);
    trayWidth = gdv(tray, "x");
    trayDepth = gdv(tray, "y");
    // ySpace = 19.05;
    // ySpace = trayDepth / (columns + 1);
    echo(trayWidth = trayWidth,  trayDepth = trayDepth)
    echo(rows = rows, columns = columns, xSpace = xSpace, ySpace = ySpace);

    // rotate([0,90,0])
    union()
    {
        translate([gdv(tray, "x"), gdv(tray, "y"), 0])
        rotate([0,0,180])
        translate([0, 0, -gdv(tray, "z")])
        difference()
        {
            union()
            {
                drawSquareShape(tray);
                // translate([0,gdv(tray, "y") - 2,0])
                // drawSquareShape(shortBackwall);
            }
            
            for (col = [0 : columns]) 
            {
                for(row = [0 : rows - 1])
                {
                    if( row + (col * rows) < len(sockets))
                    {
                    echo(x= row * xSpace, y = col * ySpace, row = row, col = col, drillBit = Index(row, col, rows) );
                        translate([ row * xSpace + xSpace/2 + (Index(row, col, rows) > 6 ? 3.5 : 0) * row, col * ySpace + ySpace/2, bottom_thickness + gdv(tray, "z")/2])
                        cylinder(d = sockets[ row + (col * rows)][0], h = gdv(tray, "z"), center=true, $fn=60);
                        
                        translate([ row * xSpace + xSpace/2.5 + (Index(row, col, rows) >= 6 ? -2 : 0) * row, col == 0 ? col * ySpace + 1 : (col * ySpace) - 3, gdv(tray, "z") - bottom_thickness ])
                        #linear_extrude(height = bottom_thickness)
                        text(text=sockets[ row + (col * rows)][1], size = 5);
                    }

                }
            }

            //hex bit slot
            translate([gdv(tray,"x") - 12.5, gdv(tray,"y") - 30, 0 ])
            drawCircleShape(hex_bit);
        }  
        translate([gdv(backwall,"x"), 0, (3 * gdv(backwall,"z")) - gdv(tray, "z")])
        rotate([0,90,0])
        draw_Cleated_Back_Wall(backwall);     
    }

}

module draw_box_for_JigSaw_Box()
{
    BladeBoxRows=10;
    BladeBoxColumns=9;
    BladeBoxX = 6.5 + 0.6; //printed is 5.92, difference = 0.58
    BladeBoxY = (1.23 * 3) + 0.65; //calulate = 3.69; printed 3.04, difference = 0.65
    BladeBoxSpacingWidth = BladeBoxY + 3;
    BladeBoxSpacingLength = BladeBoxX + 4;
    BladeBoxSpacing = 6.125; //convert_in2mm(0.25);

    screwDriverShaftDiameter = gdv( screwDriverShaft, "x");

    box = ["inner box",
        ["x", BladeBoxX],
        ["y", BladeBoxY],
        ["z", gdv(Tray, "z") ],
        ["move", [ (gdv(Tray, "x") - BladeBoxX)/2,  0, LayersToHeight(8)]],
        ["rotate", [0,0, 0]],
        ["color", "yellow"]
    ];

    shortBackwall = 
    ["short back wall", 
        ["x", gdv(Tray, "x")],
        ["y", cleat_thickness],
        ["z", convert_in2mm(1.5)],
        ["move", [0, 0, 0]],
        ["from edge", 0],
        ["rotate", [0,0, 0]],
        ["include cleat", false],
        ["cleat", cleat],
        ["color", "LightGrey"]
    ];    

    // translate([gdv(Tray, "x"), gdv(Tray, "y"), convert_in2mm(1.75)])
    // rotate([0,0,180])
    difference()
    {
        union()
        {
            drawSquareShape(Tray);
            translate([0,gdv(Tray, "y") - 2,0])
            drawSquareShape(shortBackwall);
        }

        translate([-55,-4,0])
        {
            for(col = [0 : BladeBoxColumns-1 ])
            {
                for (row =[1 : BladeBoxRows-1 ])
                {
                    echo(xyz = [col * BladeBoxSpacingLength, (row * BladeBoxSpacingWidth) , 0]);

                    translate([col * BladeBoxSpacingLength, (row * BladeBoxSpacingWidth) , 0])
                    drawSquareShape(box);            
                }
            }            
        }

        //hex tool holder.
        translate([gdv(Tray, "x") - 15, gdv(Tray, "y")-19, -1])
        linear_extrude(gdv(Tray, "z")+ 5)
        circle(d=screwDriverShaftDiameter, $fn = 90);

        //hex bit holder
        translate([gdv(Tray, "x") - 20, gdv(Tray, "y")-70, -1])
        drawCircleShape(Bit);

        //hex bit holder
        translate([gdv(Tray, "x") - 20, gdv(Tray, "y")-55, -1])
        drawCircleShape(Bit);
        
        //hex bit holder
        #translate([gdv(Tray, "x") - 20, gdv(Tray, "y")-40, -1])
        drawCircleShape(Bit);

        // translate([0, 3 * stapleBoxSpacing + 2 * gdv(box, "y"), 0])
        // drawSquareShape(box);    
        
        translate([0,gdv(Tray, "y") - 2, -convert_in2mm(0.75)])
        screw_hole_counter_sink(screwholes, shortBackwall);
    }
}

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
        ["y", cleat_thickness],
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
        ["y", cleat_thickness],
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
    rotate([0,90,180])
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



module drawSquarePegHolder()
{
    echo();
    echo(FileName = "drawSquarePegHolder.stl");
    echo();

    radius = gdv(DrillPeg,"x")/2;
    unit = 0.9;

    spacingA = 
        ["spacing", 
            ["0", [ 0, 0, 0 ]],
            ["1", [ convert_in2mm(unit), 0, 0 ]],
            ["2", [ convert_in2mm(2 * unit), 0, 0 ]],
            ["3", [ convert_in2mm(3 * unit), 0, 0 ]],
            ["4", [ convert_in2mm(4 * unit), 0, 0 ]],
        ];

    properties_echo(spacingA);
    
    difference()
    {
        union()
        {
            rotate([7,0,0])
            drawSquareShape(Backwall);
            
            translate(gdv(spacingA, "0"))
            drawSquareShape(DrillPeg);

            translate(gdv(spacingA, "1"))
            drawSquareShape(DrillPeg);
            
            translate(gdv(spacingA, "2"))
            drawSquareShape(DrillPeg);

            translate(gdv(spacingA, "3"))
            drawSquareShape(DrillPeg);

            translate(gdv(spacingA, "4"))
            drawSquareShape(DrillPeg);

            translate([gdv(Backwall, "x") - gdv(DrillPeg,"x") ,0,0])
            drawSquareShape(DrillPeg);        }

         //screw_hole_counter_sink(screwholes, Backwall);
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

    echo(FileName = "LargeHoleScrewDriverTray.stl");
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
        ["y", cleat_thickness],
        ["z", convert_in2mm(0.75)],
        ["parallelogram length", convert_in2mm(0.75)/sin(45) ],
        ["parallelogram thickness", cleat_thickness],
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
        ["y", cleat_thickness],
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
        ["x", convert_in2mm(1.25)],
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
        ["columns", 2],
        ["rows", 4],
        ["spacing", 0],
        //move is a final adjustment
        ["move", [gdv(shaft, "x")/8 + 3, 4, 0]],
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
            translate([gdv(backwall,"x"), 0, (3 * gdv(backwall,"z")) - gdv(tray, "z")])
            rotate([0,90,0])
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
