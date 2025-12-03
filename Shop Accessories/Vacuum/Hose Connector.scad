include <constants.scad>;
include <../FrenchWall/ToolHolders_Library.scad>;
use <../FrenchWall/ToolHolders_Modules_Library.scad>;

use <convert.scad>;
use <trigHelpers.scad>;
use <ObjectHelpers.scad>;
use <dictionary.scad>;

/*
Module: Hose Connector
Description: A connector for vacuum hoses, designed to fit standard sizes.
Author: Steven Mitchell
Creation Date: 2024-06-15
License: MIT License

*/

    tray = 
    ["tray", 
        ["x", convert_in2mm(3/8)],
        ["y", convert_in2mm(3/8)],
        ["z", convert_in2mm(0.75)],
        ["move", [0, 0, 0]],
        ["rotate", [0,0, 0]],
        ["color", "LightGrey"]
    ];
    $fn = 128;

build(args = []);

module build(args) {
    // Hose_Connector(
    //     IDia = gdv(args, "IDia", 40),
    //     connector_length = gdv(args, "connector_length", 100),
    //     wall_thickness = gdv(args, "wall_thickness", 3),
    //     flange_diameter = gdv(args, "flange_diameter", 60),
    //     flange_thickness = gdv(args, "flange_thickness", 5)
    // );
    Hose_Connector();
}

module Hose_Connector(IDia = 58, ODia = 0, connector_length=40, wall_thickness=4.5, flange_width=6, flange_thickness=2.5) 
{
    echo(str("Hose Connector: IDia=", IDia, " ODia=", ODia, " Length=", connector_length, " Wall Thk=", wall_thickness, " Flange W=", flange_width, " Flange Thk=", flange_thickness));
    echo(FileName = "Shop Vac Connector");
    // Main hose connector body
    difference() {
        union() 
        {
            // Outer cylinder 
            cylinder(h=connector_length, d= ODia > IDia ? ODia : IDia + 2*wall_thickness, center=false);
            // // Main cylinder
            // cylinder(h=connector_length, d=IDia, center=false);
            // Flange
            translate([0, 0, connector_length - flange_thickness])
                cylinder(h=flange_thickness, d=IDia + 2*flange_width, center=false);

            // translate([0, 0, connector_length - flange_thickness])
                cylinder(h=flange_thickness, d=IDia + 2*flange_width, center=false);                
        }
        // Inner cylinder (hollow part)
        translate([0, 0, -1])
            cylinder(h=connector_length+2, d=IDia, center=false);
    }
    
    // Flange at one end
    // translate([0, 0, connector_length - flange_thickness])
    //     cylinder(h=flange_thickness, d=IDia + flange_width, center=false);
}
