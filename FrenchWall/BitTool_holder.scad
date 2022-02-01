/*
    1. bit holder tray for french wall
    2. Back with holes to attach to cleat board.
*/

include <constants.scad>;
include <ToolHolders_Library.scad>;

use <convert.scad>;
use <trigHelpers.scad>;
use <ObjectHelpers.scad>;
use <dictionary.scad>;


//un comment to show ruler in drawing.
// scale(size = 5, increment = convert_in2mm(1), fontsize = 8);
screwDriverTray();
// completeBitTray();
// drawHammerHandle();
// drawPeggedHandle();
// drawDrillPeggedHandle();
// drawTriSquareHolder();

// draw_Cleated_Back_Wall();
// scale();

module draw_Cleated_Back_Wall(backwall)
{
    //now wall and cleat is at [0,0]
    //move to positive 0 x-axis.
    translate([gdv(backwall,"x"),0,0])
    //rotate so cleat is external and wall is located at 0 y-axis
    rotate([0,0,180])
    union()
    {
        //draw wall
        drawSquareShape(backwall);    
        //draw cleat
        translate([0, gdv(backwall,"y"), gdv(backwall,"z")])
        draw_parallelogram(gdv(backwall, "cleat"));
    }
}

module drawDrillPeggedHandle()
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
            spacing = gdv(backwall, "x")/3;
            
            translate([spacing - radius,0,0])
            drawCircleShape(DrillPeg);
            
            translate([2*spacing - radius,0,0])
            drawCircleShape(DrillPeg);
        }

         screw_hole_counter_sink(screwholes, backwall);
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
        ["cleat length", convert_in2mm(0.75) ],
        ["cleat thickness", NozzleWidth * 8],
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
            // drawSquareShape(backwall);      
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

/*
    draws a parallelogram
*/
module draw_parallelogram(properties)
{
    /* visual
    
       D----------C
    A----------B

    height distance between lines AB and CD
    angle is angle of AB and AD
    baselength is where point D intersects line AB.
    */
    // properties_echo(properties);
    length = gdv(properties, "cleat length");
    height = gdv(properties, "cleat thickness");
    angle = gdv(cleat, "angle");    
    base_length = height/tan(angle);
    hypoten = sqrt(pow(height, 2) + pow(base_length, 2));

    A = [ 0, 0 ];
    B = [ length, 0 ];
    C = [ length + base_length, height];
    D = [ base_length, height];

    points = [A, B, C, D];
    echo(points = points);
    color(gdv(properties, "color"), 0.5)

    translate([0, 0, -hypoten])
    rotate([angle - 90, 0, 0])
    rotate([0,90,0])
    linear_extrude(height = gdv(properties, "extrude height"), center=false)
    polygon(points=points); 
}

module draw_trapizoid(cleat_properties)
{
    /*
    A is point origin point [0,0]
    B is point length of bottom from origin [length, 0]
    x is length of triangle side at the bottom of trapizoid. Where
    2x + length of top = length of bottom
    C is point of top [x, h]
    D is last point [length - x, h]
    points visually:
                C   D
              A       B
    */
    properties_echo(cleat_properties);
    inverted_trapizoid = gdv(cleat_properties, "inverted trapizoid");
    length = gdv(cleat_properties, "bottom length");
    height = gdv(cleat_properties, "height");
    angle = gdv(cleat, "angle");    
    base_length = height/tan(angle);

    points = trapizoid_points(length, height, base_length, inverted_trapizoid);

    echo(points = points);

    color(gdv(cleat_properties, "color"), 0.5)

    rotate([0, 90, 0])
    rotate([0, 0, angle])
    translate([0, -height,0])
    linear_extrude(height = gdv(cleat_properties, "extrude height"), center=false)
    polygon(points=points);    
}

//parameters are
function trapizoid_points(length, height, base_length, inverted = false) = 
    inverted==false ? 
        //[A, B, D, C]
        [ [ 0, 0 ], [ length, 0 ], [ length - base_length, height ], [ base_length, height ]  ] : 
        //for inverted [A, B, C, D]
        [ [ base_length, 0 ], [ length - base_length, 0 ], [ length, height ], [ 0, height ] ];


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
