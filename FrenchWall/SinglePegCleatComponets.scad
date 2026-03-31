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
draw_peg_bracket(length, thickness, BackwallAdjusted(
        "Cleat_for_wall.stl",
        trayX,
        cleat_thickness,
        convert_in2mm(2.5),
        [0, 0, 0],
        0,
        [0,0, 0],
        false,
        cleat,
        "LightGrey"
    ));

// module draw_Cleated_Back_Wall(properties)
module draw_single_peg_cleat_hook()
{
    echo();
    echo(FileName = "single_peg_cleat_hook.stl");
    echo();

    // peg = Peg();
    peg = PegAdjusted(
        convert_in2mm(3/8), 
        convert_in2mm(3/8), 
        convert_in2mm(2), 
        60, 
        [0,gdv(HammerBackwall, "move").y,convert_in2mm(3/8)/2], 
        (gdv(HammerTray, "x")-convert_in2mm(1))/2, 
        [90,0, 0], 
        "LightBlue"
    );

    // tray = TrayAdjusted(
    //     convert_in2mm(2/8),
    //     convert_in2mm(2/8),
    //     convert_in2mm(0.75),
    //     [0, 0, 0],
    //     [0,0, 0],
    //     "LightGrey"
    // );

    // cleat = CleatAdjusted(
    //     gdv(tray, "x"),
    //     cleat_thickness,
    //     convert_in2mm(0.75),
    //     convert_in2mm(0.75)/sin(45),
    //     cleat_thickness,
    //     135,
    //     gdv(tray, "x"),
    //     [0, 0, 0],
    //     0,
    //     [0, 0, 0],
    //     "LightGrey"
    // );

    backwall = BackwallAdjusted(
        "Cleat_for_wall.stl",
        gdv(tray, "x"),
        cleat_thickness,
        convert_in2mm(2.5),
        [0, 0, 0],
        0,
        [0,0, 0],
        false,
        cleat,
        "LightGrey"
    );

    applyColor(peg, 0.5)
    applyRotate(peg)
    applyExtrude(peg)
    moveToOrigin(peg)
    drawCircleShape2(peg);

    // applyColor(tray, 0.5)
    // moveToOrigin(tray)
    // drawSquareShape2(tray);

    translate([ gdv(tray, "x"), -3, gdv(tray, "x")])
    rotate([180, 180, -5 ])
    draw_Cleated_Back_Wall(backwall);   
}

module draw_peg_bracket(length, thickness, backwall) 
{
    tray = TrayAdjusted(
        convert_in2mm(2/8),
        convert_in2mm(2/8),
        convert_in2mm(0.75),
        [0, 0, 0],
        [0, 0, 0],
        "LightGrey"
    );

    cleat = CleatAdjusted(
        gdv(tray, "x"),
        cleat_thickness,
        convert_in2mm(0.75),
        convert_in2mm(0.75)/sin(45),
        cleat_thickness,
        135,
        gdv(tray, "x"),
        [0, 0, 0],
        0,
        [0, 0, 0],
        "LightGrey"
    );

    draw_peg_bracket(10, 5, 
        BackwallAdjusted(
            "Cleat_for_wall.stl",
            gdv(tray, "x"),
            cleat_thickness,
            convert_in2mm(2.5),
            [0, 0, 0],
            0,
            [0,0, 0],
            false,
            cleat,
            "LightGrey"
        )
    );

    drawSquareShape(backwall);
    translate([0, length, 0]) 
    drawSquareShape(backwall);
}