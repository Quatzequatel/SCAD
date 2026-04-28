// ============================================================================
// Coasters.scad - Customizable coaster holder and individual coaster parts
// ============================================================================
// Generates a cylindrical holder for stacking circular coasters and optional
// individual coaster components (insert, brim, bottom).
// All geometry is centered at origin (0, 0, 0) for easy positioning in assemblies.
// ============================================================================

include <constants.scad>;
include <../FrenchWall/ToolHolders_Library.scad>;
use <../House/Carpet_corner.scad>;
use <../FrenchWall/ToolHolders_Modules_Library.scad>;

use <convert.scad>;
use <trigHelpers.scad>;
use <ObjectHelpers.scad>;
use <dictionary.scad>;

// ============================================================================
// GLOBAL PARAMETERS
// ============================================================================
// Coaster dimensions (in mm)
    diameter = 89;                       // Coaster diameter: 3.7 inches = 89 mm
    insert_thickness = 2;                // Thickness of decorative insert layer
    brim_height = 2.5;                   // Height of outer wall ring (brim)
    brim_thickness = 2.5;                // Radial thickness of outer wall
    bottom_thickness = LayerHeight * 12; // Thickness of base (12 layers)

// ============================================================================
// BUILD ORCHESTRATION
// ============================================================================
// Uncomment one of the lines below to render a specific part:
// build(args = "Complete Coaster");
// build(args = "Coaster Brim and Bottom");
// build(args = "Coaster Insert");
// build(args = "Coaster Holder");

// Build selector module - routes execution to requested component
// Parameters:
//   args - string indicating which part to render
module build(args) 
{
    if( args != undef)
    {
        if (args == "Coaster Holder") 
        {
            echo();
            echo(FileName = str("Coasters Holder.stl"));
            echo();
            draw_coasters_holder(diameter, insert_thickness, brim_thickness, brim_height, bottom_thickness);            
        }

        if(args == "Coaster Insert") 
        {
            echo();
            echo(FileName = str("Coaster Insert.stl"));
            echo();
            draw_coaster_insert(diameter, insert_thickness);            
        }

        if(args == "Coaster Brim and Bottom") 
        {
            echo();
            echo(FileName = str("Coaster Brim and Bottom.stl"));
            echo();
            draw_coaster_brim_and_bottom(diameter, insert_thickness, brim_thickness, brim_height, bottom_thickness);            
        }

        if(args == "Complete Coaster") 
        {
            echo();
            echo(FileName = str("Complete Coaster.stl"));
            echo();
            draw_complete_coaster(diameter, insert_thickness, brim_thickness, brim_height, bottom_thickness);
        }
    }
}


// ============================================================================
// MAIN COASTER HOLDER MODULE
// ============================================================================
// Creates cylindrical holder for stacking coasters vertically
// Parameters:
//   diameter - coaster diameter
//   insert_thickness - thickness of insert layer
//   brim_thickness - radial thickness of coaster wall
//   brim_height - vertical height of coaster wall
//   bottom_thickness - thickness of coaster base
//   coaster_count - number of coasters to stack (default: 16)
// Returns: Cylindrical holder with internal slots and finger access holes
module draw_coasters_holder(diameter, insert_thickness, brim_thickness, brim_height, bottom_thickness, cosaster_count = 16) 
{
    // ========================================================================
    // HOLDER GEOMETRY CALCULATIONS
    // ========================================================================
    holder_wall_thickness = 6;                                    // Outer wall thickness (mm)
    space_between_coasters_and_holder = 2;                        // Radial clearance for coaster removal
    wobble_room = 0.5;                                            // Vertical clearance per coaster layer
    
    // Total holder height calculation:
    // (coasters * height_per_coaster) + base + top clearance
    holder_height = bottom_thickness + (brim_height + wobble_room) * cosaster_count + 2;
    
    // Diameter calculations for circular geometry:
    // Outer diameter = coaster diameter + 2*(brim_thickness + holder_wall_thickness)
    diaOuter = diameter + (brim_thickness * 2) + holder_wall_thickness;
    
    // Inner diameter = coaster diameter + 2*(brim_thickness + clearance)
    diaInner = diameter + (brim_thickness * 2) + space_between_coasters_and_holder;

    // Debug output to console
    echo(str("holder_height = ", holder_height));
    echo(str("diaOuter = ", diaOuter)); 
    echo(str("diaInner = ", diaInner));
    echo(str("diameter = ", diameter));

    // ========================================================================
    // GEOMETRY: MAIN HOLDER STRUCTURE (centered at origin 0, 0, 0)
    // ========================================================================
    difference()
    {
        union()
        {
            // Cylindrical holder walls - outer ring from base to top
            color("SaddleBrown")
            linear_extrude(height=holder_height)
            difference() 
            {
                // Outer circular boundary
                circle(d=diaOuter, $fn=100);

                // Inner cutout (cavity where coasters rest)
                circle(d=diaInner, $fn=100);
            }        

            // Stack of coaster brims and bottoms - serves as the base/example
            // Positioned at origin for alignment with holder geometry
            translate([0, 0, 0])
            draw_coaster_brim_and_bottom(diaInner-2, insert_thickness, brim_thickness, brim_height, bottom_thickness);     
        }
       
        // ====================================================================
        // CUTOUTS: Finger slots for ergonomic coaster removal
        // ====================================================================
        // Creates oval-shaped access holes on opposite walls
        
        // Top wall finger slot - allows thumb access from above
        translate([0, diaOuter/2, bottom_thickness])
        rotate([0, 0, 90])
        draw_finger_slot(holder_height, finger_diameter=15, thickness=10);

        // Bottom wall finger slot - allows finger access from below
        translate([0, -diaOuter/2, bottom_thickness])
        rotate([0, 0, 90])
        draw_finger_slot(holder_height, finger_diameter=15, thickness=10);
    }

}

// ============================================================================
// FINGER SLOT MODULE
// ============================================================================
// Creates an elongated oval slot for ergonomic access to coasters
// Parameters:
//   holder_height - total height of holder (width of slot opening)
//   finger_diameter - diameter of rounded ends of slot
//   thickness - thickness of wall that slot cuts through (default: 10mm)
// Returns: Subtractable geometry for difference() operations
module draw_finger_slot(holder_height, finger_diameter, thickness = 10) 
{
    // Creates slot by extruding a rounded-rectangle (hull of two circles)
    translate([thickness/2, 0, 0])
    rotate([0, -90, 0])
    linear_extrude(height=thickness)
    hull() 
    {
        // Top rounded end
        translate([finger_diameter/2, 0, 0])
        circle(d=finger_diameter, $fn=100);
        
        // Bottom rounded end - offset by holder height
        translate([(2 * holder_height) - (finger_diameter * 2), 0, 0])
        circle(d=finger_diameter, $fn=100);        
    }

}

// ============================================================================
// COMPOSITE COASTER MODULES
// ============================================================================

// Creates the brim (wall) and bottom (base) of a coaster
// Used in holder as example/alignment piece
// Parameters: dimensions for both brim and bottom components
module draw_coaster_brim_and_bottom(diameter, insert_thickness, brim_thickness, brim_height, bottom_thickness) 
{
    // Outer decorative ring
    draw_coaster_brim(diameter, brim_thickness, brim_height);

    // Bottom support structure
    draw_coaster_bottom(diameter, bottom_thickness);
}

// Creates a complete coaster assembly (all three parts)
// Parameters: dimensions for all coaster components
module draw_complete_coaster(diameter, insert_thickness, brim_thickness, brim_height, bottom_thickness) 
{
    // Decorative insert with hexagonal lattice pattern
    draw_coaster_insert(diameter, insert_thickness);

    // Outer wall ring
    draw_coaster_brim(diameter, brim_thickness, brim_height);

    // Base platform
    draw_coaster_bottom(diameter, bottom_thickness);
}

// ============================================================================
// INDIVIDUAL COASTER COMPONENT MODULES
// ============================================================================

// Creates the decorative insert with hexagonal lattice cutout
// Parameters:
//   diameter - overall diameter of insert
//   insert_thickness - vertical thickness
// Returns: Circular disk with hexagonal hole pattern
module draw_coaster_insert(diameter, insert_thickness) 
{
    linear_extrude(height=insert_thickness)    
    difference() 
    {        
        // Solid circular base
        circle(d=diameter);
        
        // Hexagonal lattice pattern cutout (for decoration/grip)
        translate([-diameter/2, -diameter/2])
        hex_lattice(sizeX = diameter, sizeY = diameter, hex_flat_d=5, gap=0.4, border=0);
    } 
}


// Creates the outer wall ring of a coaster
// Parameters:
//   diameter - inner diameter (where insert sits)
//   brim_thickness - radial wall thickness
//   brim_height - vertical wall height
// Returns: Hollow cylindrical ring with chamfered top edge
module draw_coaster_brim(diameter, brim_thickness, brim_height) 
{
    linear_extrude(height=brim_height)
    difference() 
    {
        // Outer circle (diameter + 2*thickness)
        diaOuter = diameter + brim_thickness * 2;
        circle(d=diaOuter, $fn=100);

        // Inner circle (hollow cavity)
        circle(d=diameter, $fn=100);
    }
    
    // Chamfer (45° bevel) on top edge for smooth appearance and print strength
    translate([0, 0, brim_height])
    draw_chamfer([[0,0], [brim_thickness, 0], [brim_thickness, insert_thickness]], diameter);
}

// Creates the base/platform of a coaster
// Parameters:
//   diameter - diameter of base
//   bottom_thickness - vertical height of base
// Returns: Solid disk with chamfered bottom edge
module draw_coaster_bottom(diameter, bottom_thickness) 
{
    // Solid circular base (extends downward)
    translate([0, 0, -bottom_thickness])
    linear_extrude(height=bottom_thickness)
    circle(d=diameter, $fn=100);

    // Chamfer (45° bevel) on bottom edge for smooth appearance and print strength
    translate([0, 0, -bottom_thickness - 0.0])
    draw_chamfer([[0,0], [brim_thickness, bottom_thickness ], [0, bottom_thickness ]], (diameter - brim_thickness/2) + 0.7);
}

// ============================================================================
// UTILITY MODULES
// ============================================================================

// Creates a 45° chamfered edge using rotate_extrude
// Parameters:
//   triangle - array of [x,y] points defining cross-section profile
//   diameter - diameter at which to revolve the profile
// Returns: 3D chamfer via revolutionary extrusion
module draw_chamfer(triangle, diameter) 
{
    echo(str("triangle = ", triangle));
    echo(str("diameter = ", diameter));
    
    // Revolve the triangle profile around the coaster axis to create chamfer
    rotate_extrude($fn=200) 
        translate([diameter/2, 0, 0])
        polygon(points=triangle);
}