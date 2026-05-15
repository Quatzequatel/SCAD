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
use <../libraries/kvpairs.scad>;
// use <../libraries/vectorHelpers.scad>;


//un comment to show ruler in drawing.
// scale(size = 5, increment = convert_in2mm(1), fontsize = 8);
// screwDriverTray(true);
// completeBitTray();
// drawHammerHandle();
// drawPeggedHandle();
//drawDrillPeggedHandle();
// drawDrillPeggedHandleV2();
// drawSquarePegHolder();

   //echo(); echo(fileName = kv_get(Backwall, "filename")); echo(); draw_Cleated_Back_Wall(Backwall);
// draw_Cleat_for_BackWall(Backwall);
// draw_Drill_Bit_Holder_Cleated();
// draw_box_for_staples();
// draw_box_for_JigSaw_Box();
// draw_peg_holder_for_staples();
// draw_box_Ratchet_Set();
draw_single_peg_cleat_hook();
// scale();

module draw_single_peg_cleat_hook()
{

    echo(FileName = "single_peg_cleat_hook.stl");

    peg = 
    ["Peg dimension",
        ["x", convert_in2mm(3/8)],
        ["y", convert_in2mm(3/8)],
        ["z", convert_in2mm(2)],
        ["fragments", 60],
        ["move", [0,kv_get(HammerBackwall, "move")[1],convert_in2mm(3/8)/2]],
        ["from edge", (kv_get(HammerTray, "x")-convert_in2mm(1))/2],
        ["rotate", [90,0, 0]],
        ["color", "LightBlue"]
    ];

    tray = 
    ["tray", 
        ["x", convert_in2mm(2/8)],
        ["y", convert_in2mm(2/8)],
        ["z", convert_in2mm(0.75)],
        ["move", [0, 0, 0]],
        ["rotate", [0,0, 0]],
        ["color", "LightGrey"]
    ];

    cleat = 
    ["cleat properties", 
        ["x", kv_get(tray, "x")],
        ["y", cleat_thickness],
        ["z", convert_in2mm(0.75)],
        ["parallelogram length", convert_in2mm(0.75)/sin(45) ],
        ["parallelogram thickness", cleat_thickness],
        ["angle", 135],
        ["extrude height", kv_get(tray, "x")],
        ["move", [0, 0, 0]],
        ["from edge", 0],
        ["rotate", [0, 0, 0]],
        ["color", "LightGrey"]
    ];

    backwall = 
    ["backwall", 
        ["filename", "Cleat_for_wall.stl"],
        ["x", kv_get(tray, "x")],
        ["y", cleat_thickness],
        ["z", convert_in2mm(2.5)],
        ["move", [0, 0, 0]],
        ["from edge", 0],
        ["rotate", [0,0, 0]],
        ["include cleat", false],
        ["cleat", cleat],
        ["color", "LightGrey"]
    ];

    applyColor(peg, 0.5)
    applyRotate(peg)
    applyExtrude(peg)
    moveToOrigin(peg)
    drawCircleShape2(peg);

    // applyColor(tray, 0.5)
    // moveToOrigin(tray)
    // drawSquareShape2(tray);

    translate([ kv_get(tray, "x"), -3, kv_get(tray, "x")])
    rotate([180, 180, -5 ])
    draw_Cleated_Back_Wall(backwall);   
}


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
        ["x", kv_get(tray, "x")],
        ["y", cleat_thickness],
        ["z", convert_in2mm(0.75)],
        ["parallelogram length", convert_in2mm(0.75)/sin(45) ],
        ["parallelogram thickness", cleat_thickness],
        ["angle", 135],
        ["extrude height", kv_get(tray, "x")],
        ["move", [0, 0, 0]],
        ["from edge", 0],
        ["rotate", [0, 0, 0]],
        ["color", "LightGrey"]
    ];

    backwall = 
    ["backwall", 
        ["x", kv_get(tray, "x")],
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
        ["z", kv_get(tray, "z")],
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

    xSpace = kv_get(tray, "x") / (rows);
    ySpace = kv_get(tray, "y") / (columns + 1);
    bottom_thickness = LayersToHeight(8);
    trayWidth = kv_get(tray, "x");
    trayDepth = kv_get(tray, "y");
    // ySpace = 19.05;
    // ySpace = trayDepth / (columns + 1);
    // echo(trayWidth = trayWidth,  trayDepth = trayDepth)
    // echo(rows = rows, columns = columns, xSpace = xSpace, ySpace = ySpace);

    // rotate([0,90,0])
    union()
    {
        translate([kv_get(tray, "x"), kv_get(tray, "y"), 0])
        rotate([0,0,180])
        translate([0, 0, -kv_get(tray, "z")])
        difference()
        {
            union()
            {
                drawSquareShape(tray);
                // translate([0,kv_get(tray, "y") - 2,0])
                // drawSquareShape(shortBackwall);
            }
            
            for (col = [0 : columns]) 
            {
                for(row = [0 : rows - 1])
                {
                    if( row + (col * rows) < len(sockets))
                    {
                    // echo(x= row * xSpace, y = col * ySpace, row = row, col = col, drillBit = Index(row, col, rows) );
                        translate([ row * xSpace + xSpace/2 + (Index(row, col, rows) > 6 ? 3.5 : 0) * row, col * ySpace + ySpace/2, bottom_thickness + kv_get(tray, "z")/2])
                        cylinder(d = sockets[ row + (col * rows)][0], h = kv_get(tray, "z"), center=true, $fn=60);
                        
                        translate([ row * xSpace + xSpace/2.5 + (Index(row, col, rows) >= 6 ? -2 : 0) * row, col == 0 ? col * ySpace + 1 : (col * ySpace) - 3, kv_get(tray, "z") - bottom_thickness ])
                        #linear_extrude(height = bottom_thickness)
                        text(text=sockets[ row + (col * rows)][1], size = 5);
                    }

                }
            }

            //hex bit slot
            translate([kv_get(tray,"x") - 12.5, kv_get(tray,"y") - 30, 0 ])
            drawCircleShape(hex_bit);
        }  
        translate([kv_get(backwall,"x"), 0, (3 * kv_get(backwall,"z")) - kv_get(tray, "z")])
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

    screwDriverShaftDiameter = kv_get( screwDriverShaft, "x");

    box = ["inner box",
        ["x", BladeBoxX],
        ["y", BladeBoxY],
        ["z", kv_get(Tray, "z") ],
        ["move", [ (kv_get(Tray, "x") - BladeBoxX)/2,  0, LayersToHeight(8)]],
        ["rotate", [0,0, 0]],
        ["color", "yellow"]
    ];

    shortBackwall = 
    ["short back wall", 
        ["x", kv_get(Tray, "x")],
        ["y", cleat_thickness],
        ["z", convert_in2mm(1.5)],
        ["move", [0, 0, 0]],
        ["from edge", 0],
        ["rotate", [0,0, 0]],
        ["include cleat", false],
        ["cleat", cleat],
        ["color", "LightGrey"]
    ];    

    // translate([kv_get(Tray, "x"), kv_get(Tray, "y"), convert_in2mm(1.75)])
    // rotate([0,0,180])
    difference()
    {
        union()
        {
            drawSquareShape(Tray);
            translate([0,kv_get(Tray, "y") - 2,0])
            drawSquareShape(shortBackwall);
        }

        translate([-55,-4,0])
        {
            for(col = [0 : BladeBoxColumns-1 ])
            {
                for (row =[1 : BladeBoxRows-1 ])
                {
                    // echo(xyz = [col * BladeBoxSpacingLength, (row * BladeBoxSpacingWidth) , 0]);

                    translate([col * BladeBoxSpacingLength, (row * BladeBoxSpacingWidth) , 0])
                    drawSquareShape(box);            
                }
            }            
        }

        //hex tool holder.
        translate([kv_get(Tray, "x") - 15, kv_get(Tray, "y")-19, -1])
        linear_extrude(kv_get(Tray, "z")+ 5)
        circle(d=screwDriverShaftDiameter, $fn = 90);

        //hex bit holder
        translate([kv_get(Tray, "x") - 20, kv_get(Tray, "y")-70, -1])
        drawCircleShape(Bit);

        //hex bit holder
        translate([kv_get(Tray, "x") - 20, kv_get(Tray, "y")-55, -1])
        drawCircleShape(Bit);
        
        //hex bit holder
        #translate([kv_get(Tray, "x") - 20, kv_get(Tray, "y")-40, -1])
        drawCircleShape(Bit);

        // translate([0, 3 * stapleBoxSpacing + 2 * kv_get(box, "y"), 0])
        // drawSquareShape(box);    
        
        translate([0,kv_get(Tray, "y") - 2, -convert_in2mm(0.75)])
        screw_hole_counter_sink(includeScrewholes, shortBackwall);
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
        ["z", kv_get(Tray, "z") ],
        ["move", [ (kv_get(Tray, "x") - stapleBoxLength)/2,  0, LayersToHeight(8)]],
        ["rotate", [0,0, 0]],
        ["color", "yellow"]
    ];

    shortBackwall = 
    ["short back wall", 
        ["x", kv_get(Tray, "x")],,
        ["y", cleat_thickness],
        ["z", convert_in2mm(1.5)],
        ["move", [0, 0, 0]],
        ["from edge", 0],
        ["rotate", [0,0, 0]],
        ["include cleat", false],
        ["cleat", cleat],
        ["color", "LightGrey"]
    ];    

    // translate([kv_get(Tray, "x"), kv_get(Tray, "y"), convert_in2mm(1.75)])
    rotate([0,0,180])
    difference()
    {
        union()
        {
            drawSquareShape(Tray);
            translate([0,kv_get(Tray, "y") - 2,0])
            drawSquareShape(shortBackwall);
        }

        translate([0, stapleBoxSpacing, 0])
        drawSquareShape(box);

        translate([0, 2 * stapleBoxSpacing + kv_get(box, "y"), 0])
        drawSquareShape(box);

        translate([0, 3 * stapleBoxSpacing + 2 * kv_get(box, "y"), 0])
        drawSquareShape(box);    
        
        translate([0,kv_get(Tray, "y") - 2, -convert_in2mm(0.75)])
        screw_hole_counter_sink(includeScrewholes, shortBackwall);
    }
}

module draw_peg_holder_for_staples()
{
        shortBackwall = 
    ["short back wall", 
        ["x", kv_get(Tray, "x")],
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
            // translate([kv_get(DrillPeg, "from edge"),0,0])
            radius = kv_get(DrillPeg,"x")/2;
            spacing = kv_get(shortBackwall, "x")/3;
            
            //left peg
            translate([spacing - radius,0,0])
            drawCircleShape(DrillPeg);
            
            //right peg
            translate([kv_get(shortBackwall, "x") - (radius + convert_in2mm(0.5)) ,0,0])
            drawCircleShape(DrillPeg);

            echo(distance = (kv_get(shortBackwall, "x") - (radius + convert_in2mm(0.5))) - (spacing - radius) );
        }

        screw_hole_counter_sink(includeScrewholes, shortBackwall);

        translate([0, 0, -kv_get(shortBackwall, "z") + convert_in2mm(0.75)])
        screw_hole_counter_sink(includeScrewholes, shortBackwall);
    } 
}

/*
    For use in models where cleat is part of object
*/
module draw_Cleated_Back_Wall(properties)
{
    // echo(kv_get(properties, "filename"));
    // properties_echo(properties);
    //now wall and cleat is at [0,0]
    //move to positive 0 x-axis.
    translate([kv_get(properties,"x"),0,0])
    //rotate so cleat is external and wall is located at 0 y-axis
    rotate([0,90,180])
    union()
    {
        //draw wall
        drawSquareShape(properties);    
        //draw cleat
        translate([0, kv_get(properties,"y"), kv_get(properties,"z")])
        draw_parallelogram(kv_get(properties, "cleat"));
    }
}

/*
    For stand alone printing.
*/
module draw_Cleat_for_BackWall( properties)
{
    //rotate for printing
    rotate([0, 90, 0])
    translate([kv_get(properties, "x"), 0, 0])
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
            // translate([kv_get(DrillPeg, "from edge"),0,0])
            radius = kv_get(DrillPeg,"x")/2;
            spacing = kv_get(Backwall, "x")/4;
            
            translate([spacing - radius,0,0])
            drawCircleShape(DrillPeg);
            
            translate([kv_get(Backwall, "x") - spacing - radius,0,0])
            drawCircleShape(DrillPeg);
        }

         screw_hole_counter_sink(includeScrewholes, Backwall);

        //  translate([0, 0, -kv_get(Backwall, "z") + convert_in2mm(0.75)])
        //  screw_hole_counter_sink(includeScrewholes, Backwall);
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
            // translate([kv_get(DrillPeg, "from edge"),0,0])
            radius = kv_get(DrillPeg,"x")/2;
            spacing = kv_get(Backwall, "x")/3;
            
            translate([spacing - radius,0,0])
            drawCircleShape(DrillPeg);
            
            translate([2*spacing - radius,0,0])
            drawCircleShape(DrillPeg);
        }

         screw_hole_counter_sink(includeScrewholes, Backwall);

        translate([0, 0, -kv_get(Backwall, "z") + convert_in2mm(0.75)])
         screw_hole_counter_sink(includeScrewholes, Backwall);
    }              
}



module drawSquarePegHolder()
{
    echo();
    echo(FileName = "drawSquarePegHolder.stl");
    echo();

    shortBackwall = 
    ["short back wall", 
        ["x", kv_get(Tray, "x")],
        ["y", cleat_thickness],
        ["z", convert_in2mm(1.5)],
        ["move", [0, 0, 0]],
        ["from edge", 0],
        ["rotate", [0,0, 0]],
        ["include cleat", false],
        ["cleat", cleat],
        ["color", "LightGrey"]
    ];    

    radius = kv_get(DrillPeg,"x")/2;
    unit = 0.9;

    spacingA = 
        ["spacing", 
            ["0", [ 0, 0, 0 ]],
            ["1", [ convert_in2mm(unit)+2, 0, 0 ]],
            ["2", [ convert_in2mm(2 * unit) , 0, 0 ]],
            ["3", [ convert_in2mm(3 * unit) + 2, 0, 0 ]],
            ["4", [ convert_in2mm(4 * unit), 0, 0 ]],
        ];

    // properties_echo(spacingA);
    
    difference()
    {
        union()
        {
            rotate([7,0,0])
            drawSquareShape(shortBackwall);
            
            translate(kv_get(spacingA, "0"))
            drawSquareShape(DrillPeg);

            translate(kv_get(spacingA, "1"))
            drawSquareShape(DrillPeg);
            
            translate(kv_get(spacingA, "2"))
            drawSquareShape(DrillPeg);

            translate(kv_get(spacingA, "3"))
            drawSquareShape(DrillPeg);

            translate(kv_get(spacingA, "4"))
            drawSquareShape(DrillPeg);

            translate([kv_get(shortBackwall, "x") - kv_get(DrillPeg,"x") ,0,0])
            drawSquareShape(DrillPeg); 
        }

        translate([convert_in2mm(0.65), 0, -45])
        drawCircleShape(includeScrewholes);

        translate([kv_get(Tray, "x")/2, 0, -45])
        drawCircleShape(includeScrewholes);

        translate([kv_get(shortBackwall, "x") - kv_get(DrillPeg,"x") - 7, 0, -45])
        drawCircleShape(includeScrewholes);

        // translate([0,0, -35])
        // screw_hole_counter_sink(includeScrewholes, shortBackwall);
    }
              
}

module drawPeggedHandle()
{
    
    difference()
    {
        union()
        {
            drawSquareShape(HammerBackwall);
            translate([kv_get(Peg, "from edge"),0,0])
            drawCircleShape(Peg);
            
            translate([-kv_get(Peg, "from edge"),0,0])
            drawCircleShape(Peg);
        }

        screw_hole_counter_sink(includeScrewholes, HammerBackwall);
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

    trayWidth = kv_get(Tray, "x");
    trayDepth = kv_get(Tray, "y");
    bottom_thickness = LayersToHeight(4);
    rows = 7;
    columns = floor(len(drillBits)/rows) - 1 ;

    xSpace = kv_get(Tray, "x") / (rows);
    ySpace = kv_get(Tray, "y") / (columns + 1);
    // ySpace = 19.05;
    // ySpace = trayDepth / (columns + 1);
    // echo(trayWidth = trayWidth,  trayDepth = trayDepth)
    // echo(rows = rows, columns = columns, xSpace = xSpace, ySpace = ySpace);


    difference()
    {
        translate([kv_get(Tray,"x"), kv_get(Tray,"y"), 0])
        rotate([0,0,180])
        union()
        {
            drawSquareShape(Tray);
            // translate([0, kv_get(Tray, "y"),0])
            
            draw_Cleated_Back_Wall(Backwall);            
        }
        
        for (col = [0 : columns]) 
        {
            for(row = [0 : rows - 1])
            {
                if( row + (col * rows) < len(drillBits))
                {
                    echo(x= row * xSpace, y = col * ySpace, row = row, col = col, drillBit = row + (col * rows) );
                    translate([ row * xSpace + xSpace/2 , col * ySpace + ySpace/2, bottom_thickness + kv_get(Tray, "z")/2])
                    #cylinder(d = drillBits[ row + (col * rows)][0], h = kv_get(Tray, "z"), center=true, $fn=60);
                    
                    translate([ row * xSpace + xSpace/4 , col == 0 ? col * ySpace + 2 : (col * ySpace) - 2, kv_get(Tray, "z") - bottom_thickness ])
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
            // translate([0, kv_get(Tray, "y"),0])
            draw_Cleated_Back_Wall(Backwall);            
        }
        
        drawArrayOfCircleShapes(tool_bit_array, Bit);
        // screw_hole_counter_sink(includeScrewholes, Backwall);
    }
}

module screwDriverTray(includeScrewholes = true)
{
    echo();
    echo(FileName = "LargeHoleScrewDriverTray.stl");
    echo();
    echo( tray = tray );

    tray = 
    ["tray", 
        ["x", convert_in2mm(4)],
        ["y", convert_in2mm(3)],
        ["z", convert_in2mm(0.5)],
        ["move", [0, 0, 0]],
        ["rotate", [0,0, 0]],
        ["color", "LightGrey"]
    ];

    tray_x = kv_get(tray, "x");
    tray_y = kv_get(tray, "y");   
    tray_z = kv_get(tray, "z");

    cleat = 
    ["cleat properties", 
        ["x", tray_x],
        ["y", cleat_thickness],
        ["z", convert_in2mm(0.75)],
        ["parallelogram length", convert_in2mm(0.75)/sin(45) ],
        ["parallelogram thickness", cleat_thickness],
        ["angle", 135],
        ["extrude height", tray_x],
        ["move", [0, 0, 0]],
        ["from edge", 0],
        ["rotate", [0, 0, 0]],
        ["color", "LightGrey"]
    ];

    backwall = 
    ["backwall", 
        ["x", tray_x],
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
        ["x", convert_in2mm(0.75)],
        ["y", convert_in2mm(1)],
        ["z", tray_z * 1.25],
        ["fragments", 60],
        ["move", [0,0,LayersToHeight(-2)]],
        ["rotate", [0,0, 0]],
        ["color", "lightYellow"]
    ];

    shaft_array = 
    ["tool_bit_array",
        ["x", tray_x],
        ["y", tray_y],
        ["z", tray_z],
        ["columns", 3],
        ["rows", 4],
        ["spacing", 1],
        //move is a final adjustment
        ["move", [tray_x/12, 4, 0]],
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
            translate([kv_get(backwall,"x"), 0, (2 * kv_get(backwall,"z")) - 2 *kv_get(tray, "z")])
            rotate([0,90,0])
            draw_Cleated_Back_Wall(backwall);      
        }

        if(includeScrewholes == true)
        {
            // drawArrayOfCircleShapes2(shaft_array, shaft);
            linear_extrude(height = kv_get(tray, "z") * 1.25)
            #drawArrayOfCircleShapes2(rows=kv_get(shaft_array, "rows"), columns=kv_get(shaft_array, "columns"), 
                width=kv_get(shaft_array, "x"), height=kv_get(shaft_array, "y"), spacing=kv_get(shaft_array, "spacing"));
            //screw_hole_counter_sink(shaft, backwall);
        }
    }
}

module screw_hole_counter_sink(properties, backwall)
{
    // properties_echo(properties);
    // properties_echo(backwall);

    // count = kv_get(properties, "count");
    count = 0;
    spacing = kv_get(backwall, "x") / (count + 1);

    for(item = [0: count])
    {
        translate([item * spacing + spacing/2, 0, 0])
        #drawCircleShape(properties);
    }
}

module drawPegs(properties, backwall)
{
    // properties_echo(properties);
    // properties_echo(backwall);

    count = kv_get(properties, "count");
    spacing = kv_get(backwall, "x") / (count + 1);

    for(item = [0: count])
    {
        translate([item * spacing + spacing/2, 0, 0])
        drawCircleShape(properties);
    }
}


module drawPegs2(pegs, wall)
{
    // properties_echo(pegs);
    // properties_echo(wall);

    count = kv_get(pegs, "count");
    spacing = kv_get(wall, "x") / (1 + count) - kv_get(pegs, "x")/2;

    for(item = [0: count-1])
    {
        // echo(spacing = (item * spacing) + spacing);
        translate([(item * spacing) + spacing, 0, 0])
        
            color(kv_get(pegs, "color"), 0.5)
            // translate(kv_get(pegs, "move"))
            rotate(kv_get(pegs, "rotate"))
            translate([kv_get(pegs, "x")/2, kv_get(pegs, "y")/2])
            linear_extrude(kv_get(pegs, "z"))
            circle(d=kv_get(pegs, "x"), $fn = kv_get(pegs, "fragments"));
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
                translate([0,-(kv_get(HammerHead, "y")*2),0])
                drawCircleShape(HammerShaft);    
                drawCircleShape(HammerShaft);    
            }            
        }      
        translate([kv_get(HammerBackwall, "from edge"),-10,-10])
        // drawCircleShape(screwhole);
        translate([-kv_get(HammerBackwall, "from edge"),-10,-10])
        // drawCircleShape(screwhole);

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
