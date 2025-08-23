/*
    the intention of this file is to create a suction tool for a shop vac to go under the rubber barrier on the roof deck.
*/

include <constants.scad>;

use <convert.scad>;
use <trigHelpers.scad>;
use <ObjectHelpers.scad>;
use <dictionary.scad>;

build_this = ["build this", 
            ["drawBottom", 1], 
            ["drawNeck", 0], 
            ["drawTray", 0], 
            ["drawPegTray", 0],
            ["peg Tray", 0]
        ];

bottomRadius = convert_in2mm(3.75);
bottomHeight = convert_in2mm(0.5);
bottomTubeRadius = 4;
fn = 200;

build(build_this);

module build(what) {
    if (gdv(what, "drawBottom")) {
        drawBottom();
    }
    if (gdv(what, "drawNeck")) {
        drawNeck();
    }
    if (gdv(what, "drawTray")) {
        drawTray();
    }
    if (gdv(what, "drawPegTray")) {
        drawPegTray();
    }
    if (gdv(what, "peg Tray")) {
        pegTray();
    }
}

module drawBottom() {
    // translate([0, 0, 0]) 
    {
        // color(gdv(Tray, "color")) 
        echo(str("Drawing Bottom with radius=", bottomRadius, " height=", bottomHeight));
        echo();
        echo(K1C = "Max size of bottom is 8 inches in diameter.");
        echo(FileName = "Suction_Tool for ShopVac.stl");
        echo();
        difference()
        {
            union()
            {
                rotate([-90, 0, 0])
                {
                    translate([0, 0, convert_in2mm(0.4)])
                    cylinder(r1 = bottomRadius, r2 = bottomRadius-25, h=convert_in2mm(0.9), center=true, $fn=fn);
                }
            }

            union()
            {
                translate([0, convert_in2mm(0.3), -convert_in2mm(2.5)])
                rotate([5, 0, 0])
                cylinder(r1=convert_in2mm(0.37), r2 = convert_in2mm(0.34), h=convert_in2mm(7), center=true, $fn=fn);
                // rotate([90, 0, 0])
                for(i = [0 : 15 : 180]) 
                {
                    {
                        rotate([0, i, 0]) 
                        cylinder(r=bottomTubeRadius, h=bottomRadius * 2, center=true, $fn=fn);
                    }
                }                
            }

        }
    }
}

