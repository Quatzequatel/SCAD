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

// draw_single_peg_cleat_hook();
draw_peg_bracket(Tray());

// module draw_Cleated_Back_Wall(properties)
module draw_single_peg_cleat_hook(pegProperties = Peg(), trayProperties = Tray(), backwallProperties = Backwall())
{
    echo();
    echo(FileName = "single_peg_cleat_hook.stl");
    echo();


    applyColor(pegProperties, 0.5)
    applyRotate(pegProperties)
    applyExtrude(pegProperties)
    moveToOrigin(pegProperties)
    drawCircleShape2(pegProperties);

    // applyColor(tray, 0.5)
    // moveToOrigin(tray)
    // drawSquareShape2(tray);

    translate([ gdv(trayProperties, "x"), -3, gdv(trayProperties, "x")])
    rotate([180, 180, -5 ])
    draw_Cleated_Back_Wall(backwallProperties);   
}

module draw_peg_bracket(trayProperties) 
{
    echo();
    echo(FileName = "draw_peg_bracket.stl");
    echo();

    thickness = 2;
    length = 50;

    bracket_Properties1 = PropertiesAdjusted
        (
            description = "Peg Bracket", 
            X = gdv(trayProperties, "x"), 
            Y =gdv(trayProperties, "y"), 
            Z= 10, 
            move=[0,0,0], 
            rotate=[0,0,0], 
            color="LightGrey"
        );    

    bracket_Properties2 = PropertiesAdjusted
        (
            description = "Peg Bracket", 
            X = gdv(bracket_Properties1, "x"), 
            Y =gdv(bracket_Properties1, "y"), 
            Z= 10, 
            move=[0,50,0], 
            rotate=[0,0,0], 
            color="LightGrey"
        );

    bracket_Properties3 = PropertiesAdjusted
    (
        description = "Peg Bracket", 
        X = gdv(bracket_Properties1, "x")+ thickness, 
        Y = length + gdv(bracket_Properties1, "y") + 2 * thickness, 
        Z = 5, 
        move=[1, -thickness,1], 
        rotate=[0,0,0], 
        color="LightGrey"
    );

    difference()
    {
        drawSquareShape(bracket_Properties3);
        union()
        {
            drawSquareShape(bracket_Properties1);
            drawSquareShape(bracket_Properties2);
        }
    }
}