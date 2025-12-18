
include <constants.scad>;
include <../FrenchWall/ToolHolders_Library.scad>;
use <../FrenchWall/ToolHolders_Modules_Library.scad>;

use <convert.scad>;
use <trigHelpers.scad>;
use <ObjectHelpers.scad>;
use <dictionary.scad>;

// Hex-filled 200x200 mm square with 10 mm across-flats hexagons
// Adjust hex_flat_d if you mean 10 mm across-points (use 11.547 mm instead)

/*
    create modeule for hex filled lattice pattern within a square cutout
    parameters:
        size - size of square (default 200 mm)
        hex_flat_d - distance across flats of hexagons (default 10 mm)
        gap - gap between hexagons (default 2 mm)
        border - border thickness around square (default 10 mm)
*/

build(args = []);

module build(args) {
    
    // Preview
    linear_extrude(height=2)
    hex_lattice_square(sizeX = 200, sizeY = 100, hex_flat_d=5, gap=1, border=10);
}

// Hex-filled lattice pattern inside a square cutout
// Parameters:
//   size       - size of square (default 200 mm)
//   hex_flat_d - distance across flats of hexagons (default 10 mm)
//   gap        - gap between hexagons (default 2 mm)
//   border     - border thickness around square (default 10 mm)


// Hex-filled 200x200 mm square with 10 mm across-flats hexagons
// Adjust hex_flat_d if you mean 10 mm across-points (use 11.547 mm instead)

module hex_lattice_square(sizeX = 200, sizeY = 100, hex_flat_d=10, gap=1, border=6) {


    difference() {
        
        // Inner cutout region (where hex lattice goes)
        translate([border, border])
            square([sizeX - 2*border, sizeY - 2*border], center=false);

        // Hex lattice pattern clipped to inner cutout
        translate([border, border])
        hex_lattice(sizeX = sizeX, sizeY = sizeY, hex_flat_d=hex_flat_d, gap=gap, border=border); 
    }

    difference() 
    {
        // Outer square 
        square([sizeX, sizeY], center=false);
        // Inner cutout region (where hex lattice goes)
        translate([border, border])
            square([sizeX - 2*border, sizeY - 2*border], center=false);   
    }
}

module hex_lattice(sizeX = 200, sizeY = 100, hex_flat_d=10, gap=2, border=10) {
    R  = hex_flat_d / sqrt(3);
    dx = 1.8 * R + gap;         // horizontal spacing with gap
    dy = sqrt(3) * R + gap/2;     // vertical spacing with gap
    echo("R=", R, " dx=", dx, " dy=", dy);
    echo(sizeX = sizeX, sizeY = sizeY, hex_flat_d=hex_flat_d, gap=gap, border= border);

        intersection() {
            square([sizeX - 2*border, sizeY - 2*border], center=false);

            union() {
                rows = ceil((sizeY - 2*border)/dy) + 2;
                cols = ceil((sizeX - 2*border)/dx) + 2;

                for (row = [-1 : rows]) {
                    y = row * dy;
                    x_offset = (row % 2 == 0) ? 0 : dx/2;

                    for (col = [-1 : cols]) {
                        x = col * dx + x_offset;
                        translate([x, y]) hexagon_flat(hex_flat_d);
                    }
                }
            }
        }
}

module hexagon_flat(hex_flat_d=10) {
    R = hex_flat_d / sqrt(3);   // circumradius for across-flats
    rotate(30) circle(r=R, $fn=6);
}
