/*
    
*/

include <constants.scad>;
include <GreenHouseProperties.scad>;

use <convert.scad>;
use <trigHelpers.scad>;
use <ObjectHelpers.scad>;
use <dictionary.scad>;

use <morphology.scad>;

use <floor.scad>;

show_labels = false;

build();

module build(args) 
{
    // main_roof();
    // Info();
    add_rafter(Rafter_Main);  
}

module main_roof()
{
    echo();
    echo("*** Roof.scad::main_roof()");
    echo();

    roofValues = getDictionary(v = RoofProperties, key = "roof properties");
    studValues = getDictionary(v = StudProperties, key = "StudProperties");

    // %translate([ 0, 0, -convert_ft2mm(ft = 4)])
    // linear_extrude(convert_ft2mm(ft = 4))
    // translate([-getDictionaryValue(HouseDimensions, "width")/2,0,0])
    // square([getDictionaryValue(HouseDimensions, "width"), getDictionaryValue(HouseDimensions, "length")]);
    add_floor();

    translate([0,0, HouseWallHeight])
    union()
    {
        translate([0,0,gdv(RoofProperties, "height" )/2])
        cylinder(r=10, h=getDictionaryValue(RoofProperties, "height" )/2, center=false);

        truss_count = floor(gdv(RoofProperties, "truss count")+1)/2;

        echo(truss_count = truss_count * 2, trussLength_in_ft = convert_mm2ft(gdv(Rafter_Main, "length")));

        for (i=[truss_count * -1 : 1 : truss_count]) 
        {
            if(i == -6 )
            {
                translate
                (
                    [
                        i * getDictionaryValue(RoofProperties, "spacing" ) + convert_in2mm(4.25),
                        0,
                        0
                    ]
                )
                add_rafter(Rafter_Main); 

                translate
                (
                    [
                        i * getDictionaryValue(RoofProperties, "spacing" ) + convert_in2mm(1.75),
                        0,
                        0
                    ]
                )              
                add_rafter_beam(Rafter_EndCap);                
            }
            else if( i == 6)
            {
                translate
                (
                    [
                        i * getDictionaryValue(RoofProperties, "spacing" ) - convert_in2mm(4.25),
                        0,
                        0
                    ]
                )
                add_rafter(Rafter_Main);        

                translate
                (
                    [
                        i * getDictionaryValue(RoofProperties, "spacing" ) - convert_in2mm(1.75),
                        0,
                        0
                    ]
                )              
                add_rafter_beam(Rafter_EndCap);
            }
            else
            {
                // echo(True_i = i);
                translate
                (
                    [
                        i * getDictionaryValue(RoofProperties, "spacing" ),
                        0,
                        0
                    ]
                )
                add_rafter(Rafter_Main);                  
            }     
        }

        // add_rafter(Rafter_Main);       
        center_beam();
    }

 }

module center_beam()
{
    rotate([0, 0, 90]) 
    translate
    (
        gdv(CenterBeamProperties, "location" )
    )
    
    color(gdv(CenterBeamProperties, "color" ), 0.5)
        linear_extrude(gdv(CenterBeamProperties, "depth" ))
        {
            square(
                size=
                [
                    gdv(CenterBeamProperties, "width" ) , 
                    gdv(CenterBeamProperties, "length" )
                ], 
                center=false);                     
        }
}

function getTrianglePoints(sideA, angleA) = 
[
    [0,0], 
    [0, sideA], 
    [sideBaA(side_a =  sideA, aA =  angleA) , 0]    
];

module Info()
{
    echo();
    echo("*** Roof.scad::Info()");
    echo();

    roofangle = getDictionaryValue(RoofProperties, "angle" );
    echo(RoofProperties = RoofProperties);
    echo(roofangle = roofangle);
    echo(rafter_length_ft = convert_mm2ft(getDictionaryValue(RoofProperties, "rafter length" )));
    echo(roof_height_ft = convert_mm2ft(getDictionaryValue(RoofProperties, "height" )));
    echo(roof_width_ft = convert_mm2ft(getDictionaryValue(RoofProperties, "width" )));
    echo(poly_sheet_count = convert_mm2ft(getDictionaryValue(RoofProperties, "length" ))/4);
    echo(Rafter_North = Rafter_North);

    // debugEcho("House Dimensions", HouseDimensions, true);
    // echo();
    // debugEcho("Entry Dimensions", EntryDimensions, true);
    // echo();
    // debugEcho("EntryColdFrame", EntryColdFrame, true);
    // echo();
    // debugEcho("house_foundation_properties", house_foundation_properties, true);
    // echo();
    // debugEcho("footing_properties", footing_properties, true);
    // echo();
    // debugEcho("crushed_rock_properties", crushed_rock_properties, true);
    // echo();
    // debugEcho("Roof", RoofDimensions[1], true);
    echo();
    debugEcho("Entry Roof", EntryRoofDimensions, true);
    echo();
    debugEcho("Roof Properties", RoofProperties, true);
    debugEcho("height", convert_mm2Inch(getDictionaryValue(RoofProperties, "height")), true);
    // debugEcho("height", convert_mm2Inch(getDictionaryValue(RoofProperties, "height")), true);
    debugEcho("rafter length", convert_mm2Inch(getDictionaryValue(RoofProperties, "rafter length")), true);

    echo(RoofWidth = convert_mm2Inch(RoofWidth));
    echo(RoofHeight = convert_mm2Inch(RoofHeight));
    echo(RoofLength = convert_mm2Inch(RoofLength));
    echo();
    echo(RoofWidth = convert_mm2ft(RoofWidth));
    echo(RoofHeight = convert_mm2ft(RoofHeight));
    echo(RoofLength = convert_mm2ft(RoofLength));
    echo();
    echo(getTrianglePoints = getTrianglePoints(6, 42));
}



//// functions

module add_rafter(properties)
{
    // echo();
    // debugEcho(properties[0], properties, true);
    // echo();

    add_rafter_beam(properties);
    
    // add_brace(Brace_One);
    // add_brace(Brace_Two);

}

module add_rafter_beam(properties)
{
    color(gdv(properties, "color" ), 0.5) 
    union()
    {
        mirror([0,1,0])
        translate(gdv(properties, "location"))
        rotate(gdv(properties, "rotate"))
        cut_rafter_properties(properties);

        translate(gdv(properties, "location"))
        rotate(gdv(properties, "rotate"))
        cut_rafter_properties(properties);

        translate([0, HouseLength/2 * -1,0])
        rotate([90,0,90])
        lable_angle(a = gdv(properties, "angle"), l = gdv(Angle_Lable, "length"), r = gdv(Angle_Lable, "radius"), size = gdv(Angle_Lable, "font size"));        
    }
}

module cut_rafter_properties(properties)
{
    translate([0,0, gdv(properties, "depth")])
    rotate([270, 0, 90]) 
    cut_rafter
    (
        angle = gdv(properties, "angle"),
        width = gdv(properties, "width"),
        depth = gdv(properties, "depth"),
        length = gdv(properties, "length")
    );
}

module cut_rafter(angle, width, depth, length)
{
    points = hypotenuse_cut(angle, depth, length);

    linear_extrude(height = width,  center = true)
    polygon(points=points);
    
}

function side_b(angle, depth) = //echo([angle, depth]) 
depth/tan(angle);

// function trap_top(angle, depth, length) = length -  side_b(angle, depth);
function hypotenuse_cut(angle, depth, length) = 
    [
        [-length/2,0], 
        [side_b(angle, depth) - length/2, depth], 
        [length/2 - side_b(90 - angle, depth), depth], 
        [length/2, 0]
    ];

module add_brace(properties)
{
    color(gdv(properties, "color" ), 0.5) 
    union()
    {
        translate([gdv(properties, "width") - convert_in2mm(in = 0.75)/2, 0, 0])
        translate(gdv(properties, "location"))
        rotate(gdv(properties, "rotate"))
        cut_brace_board_properties(properties);        

        translate([0, HouseLength/2 * -1,0])
        rotate([90,0,90])
        lable_angle(a = gdv(properties, "angle"), l = gdv(properties, "lable length"), r = gdv(Angle_Lable, "radius"), size = gdv(Angle_Lable, "font size"));        

        translate([-gdv(properties, "width") + convert_in2mm(in = 0.75)/2 ,0,0])
        mirror([0,1,0])
        // color(gdv(properties, "color" ), 0.5) 
        translate(gdv(properties, "location"))
        rotate(gdv(properties, "rotate"))
        cut_brace_board_properties(properties);           
    }
}

module cut_brace_board_properties(properties)
{
    translate([0,0, gdv(properties, "depth")])
    rotate([270, 0, 90]) 
    brace_board_cut
    (
        angle = gdv(properties, "angle"),
        angle2 = gdv(properties, "angle2"),
        width = gdv(properties, "width"),
        depth = gdv(properties, "depth"),
        length = gdv(properties, "length")
    );
}

module brace_board_cut(angle, angle2, width, depth, length)
{
    points = brace_board_points(angle, angle2, depth, length);

    // echo(points = points);

    linear_extrude(height = width,  center = true)
    polygon(points=points);
    
}

function brace_board_points(angle, angle2, depth, length) = //echo([angle, angle2, depth, length])
    [
        [-length/2,0], 
        [side_b(angle, depth) - length/2, depth], 
        [length/2 - side_b(angle2, depth), depth], 
        [length/2, 0]
    ];


module lable_angle(a = 30, l = 40, r = 1, size = 9, color = "blue") 
{
    if(show_labels)
    {
        color(color, 0.5) 
        union()
        {
            rotate_extrude(angle = a, $fn=100)
            translate([l, 0])
            circle(r = r, $fn=100);

            square([l,1]);

            rotate([0,0,a])
            square([l,1]);

            rotate([0,0,a/2])
            translate([l/3, -l/size])
            text(text = str(a, "°"), size = size);
        }        
    }


}    
