/*
    Single Peg Cleat Components
*/

include <constants.scad>;
include <../FrenchWall/ToolHolders_Library.scad>;
use <../FrenchWall/ToolHolders_Modules_Library.scad>;
use <../FrenchWall/BitTool_holder.scad>;
use <../FrenchWall/SinglePegCleatProperties.scad>;

use <convert.scad>;
use <trigHelpers.scad>;
use <ObjectHelpers.scad>;
use <dictionary.scad>;

trayX = convert_in2mm(2/8);
trayY = convert_in2mm(2/8);
trayZ = convert_in2mm(0.75);
cleat_thickness = convert_in2mm(1/8);
cleat_angle = 135;

// draw_single_peg_cleat_hook(pegLengthInches = 4, pegRadiusInches = 3/8);
// draw_peg_bracket(bracketInseamInches = 2);
// draw_Assorted_peg_brackets([1.5, 2, 2.5, 3]) ;

draw_Assorted_single_peg_cleats([[0,0], [2, 3/8], [2, 3/8], [3, 3/8], [3, 3/8]]);

module draw_Assorted_peg_brackets(args) 
{
    echo();
    echo(FileName = str("Assorted_peg_brackets.stl"));
    echo();

     draw_peg_bracket(bracketInseamInches = args[0]);
     translate([30, 0, 0])
     draw_peg_bracket(bracketInseamInches = args[1]);
     translate([60, 0, 0])
     draw_peg_bracket(bracketInseamInches = args[2]);
     translate([90, 0, 0])
     draw_peg_bracket(bracketInseamInches = args[3]);
    // body...
}

module draw_Assorted_single_peg_cleats(args) 
{
    echo(args=args);
    echo(FileName = str("Assorted_single_peg_cleats.stl"));
    echo();

    // translate([-10, 10, 0])
    // draw_single_peg_cleat_hook(pegLengthInches = args[0][0], pegRadiusInches = args[0][1])
     
     translate([30, -30, 0])
     draw_single_peg_cleat_hook(pegLengthInches = args[1][0], pegRadiusInches = args[1][1]);
     
     translate([60, -60, 0])
     draw_single_peg_cleat_hook(pegLengthInches = args[2][0], pegRadiusInches = args[2][1]);

     translate([90, -90, 0])
     draw_single_peg_cleat_hook(pegLengthInches = args[3][0], pegRadiusInches = args[3][1]);

     translate([120, -120, 0])
     draw_single_peg_cleat_hook(pegLengthInches = args[4][0], pegRadiusInches = args[4][1]);
    
}

// module draw_Cleated_Back_Wall(properties)
module draw_single_peg_cleat_hook(pegLengthInches = 1, pegRadiusInches = 3/8)
{
    pegProperties = Peg();
    trayProperties = Tray();
    backwallProperties = Backwall();

    echo();
    echo(FileName = str(pegLengthInches, "_in_single_peg_cleat.stl"));
    echo();

    pegRadius = convert_in2mm(pegRadiusInches);

    pegAdjust = PegAdjusted(
        description = str(pegLengthInches, "in_single_peg"),
        X = pegRadius, 
        Y = pegRadius, 
        Z = convert_in2mm(pegLengthInches), //gdv(pegProperties, "z"), 
        fragments = gdv(pegProperties, "fragments"), 
        move = gdv(pegProperties, "move"), 
        from_edge = gdv(pegProperties, "from edge"), 
        rotate = gdv(pegProperties, "rotate"), 
        color = gdv(pegProperties, "color")
    );

    trayAdjust = TrayAdjusted(
        X = gdv(trayProperties, "x"), 
        Y = convert_in2mm(3/8),//gdv(trayProperties, "y"), 
        Z = gdv(trayProperties, "z"), 
        move = gdv(trayProperties, "move"), 
        rotate = gdv(trayProperties, "rotate"), 
        color = gdv(trayProperties, "color")
    );

    cleat = gdv(backwallProperties, "cleat");
    cleatAdjust = CleatAdjusted(
        description = "Adjusted Cleat",
        X = gdv(cleat, "x"), 
        Y = gdv(cleat, "y"), 
        Z = gdv(cleat, "z"), 
        parallelogram_length = gdv(cleat, "parallelogram length"), 
        parallelogram_thickness = gdv(cleat, "parallelogram thickness"), 
        angle = gdv(cleat, "angle"), 
        extrude_height = gdv(pegAdjust, "x"), 
        move = gdv(cleat, "move"), 
        from_edge = gdv(cleat, "from edge"), 
        rotate = gdv(cleat, "rotate"), 
        color = gdv(cleat, "color")
    );

    backwallAdjust = BackwallAdjusted(
        filename = "backwallAdjust.stl",
        X = gdv(pegAdjust, "x"), 
        Y = gdv(backwallProperties, "y"), 
        Z = gdv(backwallProperties, "z"), 
        move = gdv(backwallProperties, "move"), 
        from_edge = gdv(backwallProperties, "from edge"), 
        rotate = gdv(backwallProperties, "rotate"), 
        include_cleat = gdv(backwallProperties, "include cleat"), 
        cleat = cleatAdjust, 
        color = gdv(backwallProperties, "color")
    );

    // properties_echo(pegAdjust);

    // properties_echo(cleat);
    // properties_echo(cleatAdjust);    
    // properties_echo(backwallProperties);
    // properties_echo(backwallAdjust);

    applyColor(pegAdjust, 0.5)
    applyRotate(pegAdjust)
    applyExtrude(pegAdjust)
    moveToOrigin(pegAdjust)
    drawCircleShape2(pegAdjust);


    translate([ gdv(trayAdjust, "x"), -3, gdv(pegAdjust, "x")])
    rotate([180, 180, -5 ])
    draw_Cleated_Back_Wall(backwallAdjust);   
}

module draw_peg_bracket(bracketInseamInches = 2) 
{
    echo();
    echo(FileName = str(bracketInseamInches, "_in_peg_bracket.stl"));
    echo();

    thickness = 2;
    numbRadius = 0.5;
    cleatX = 6.5;
    cleatY = 10;
    height = 15;
    length = convert_in2mm(bracketInseamInches); //1.9685 inches

    echo( length = length);

    bracket_Properties1 = PropertiesAdjusted
        (
            description = "Peg Bracket", 
            X = cleatX, 
            Y = cleatY, 
            Z= 20, 
            move=[0,0,0], 
            rotate=[0,0,0], 
            color="LightPink"
        );    

    bracket_Properties2 = PropertiesAdjusted
        (
            description = "Peg Bracket", 
            X = gdv(bracket_Properties1, "x"), 
            Y = gdv(bracket_Properties1, "y"), 
            Z= 20, 
            move=[0,length,0], 
            rotate=[0,0,0], 
            color="LightPink"
        );

    bracket_Properties3 = PropertiesAdjusted
        (
            description = "Peg Bracket", 
            X = gdv(bracket_Properties1, "x")+ thickness, 
            Y = length + gdv(bracket_Properties1, "y") + 2 * thickness, 
            Z = height, 
            move=[-0, -(thickness), 1], 
            rotate=[0,0,0], 
            color="LightGrey"
        );

    // properties_echo(bracket_Properties1);
    // properties_echo(bracket_Properties3);

    difference()
    {
        drawSquareShape(bracket_Properties3);
        union()
        {
            #drawSquareShape(bracket_Properties1);
            #drawSquareShape(bracket_Properties2);
        }
    }

    Y1 = 0;
    Y2 = gdv(bracket_Properties1, "y");
    Y3 = gdv(bracket_Properties2, "move")[1];
    Y4 = Y3 + gdv(bracket_Properties2, "y");

    translate([0, Y1, height/2 + 1])
    cylinder(r=numbRadius, h=height, center=true, $fn=50);

    translate([0, Y2, height/2 + 1])
    cylinder(r=numbRadius, h=height, center=true, $fn=50);

    // echo(str("Variable = ", [Y1, Y2, Y3, Y4]));

    translate([0, Y3, height/2 + 1])
    cylinder(r=numbRadius, h=height, center=true, $fn=50);

    translate([0, Y4, height/2 + 1])
    cylinder(r=numbRadius, h=height, center=true, $fn=50);

}