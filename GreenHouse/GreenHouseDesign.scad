/*
    this is the design for the greenhouse.
    preliminary constraints:
        max 200 ft^2
        max height is 12 ft.
    Dimensions are therefore
        width = 16 ft.
        depth = 12 ft.
        wall height = 6.8038 ft or 81.64617 in
        roof height with 60 degree angle = 5.196 ft or 62.35383 in
*/
// include <TrellisEnums.scad>;
include <constants.scad>;
include <GreenHouseProperties.scad>;
// use <shapesByPoints.scad>;
use <convert.scad>;
use <ObjectHelpers.scad>;
use <trigHelpers.scad>;
use <Construction.scad>;
use <dictionary.scad>;
use <roof.scad>;
use <entry_roof.scad>;
use <floor.scad>;
use <geoThermal.scad>;
use <doorway.scad>;

use <box_extrude.scad>;

// ISDEBUGEMODE = false;


//Note: moved definitions to GreenHouseProperties.scad

Build();

module info()
{
    echo("Base Dimensions:");
    echo(Length = convert_mm2ft(mm = gdv(HouseDimensions, "length")));
    echo(Width = convert_mm2ft(mm = gdv(HouseDimensions, "width")));
    echo(Height = convert_mm2ft(mm = gdv(HouseDimensions, "wall height") + gdv(RoofProperties, "height")));
    echo(RoofAngle = RoofAngle);
    echo(RoofHeight = convert_mm2ft(mm = gdv(RoofProperties, "height")));
    echo(RoofWidth = convert_mm2ft(mm = gdv(RoofProperties, "width")));
    echo(WallHeight = convert_mm2ft(mm = gdv(HouseDimensions, "wall height")));
    echo(RoofLength = convert_mm2ft(mm = gdv(RoofProperties, "length")));
    echo(EntryRoofDimensions_inches = convertV_mm2Inch(mm = EntryRoofDimensions));
    echo(EntryRoofAngle = EntryRoofDimensions[3]);    
    properties_echo(Polycarbonate_sheet);

    GreenHouseProperties_Info();
}

module Build(args) 
{
    // debug_callstack();
    // info();
    scale(size = 16, increment = convert_in2mm(12), fontsize = 72);

    // simpleView(showentry = true, showRoof = true, showwalls = true);
    standardColor = "AliceBlue";

    color(standardColor)
    add_roof();

    color(standardColor)
    foundation_plates();

    color(standardColor)
    translate([0, 0, 2 * Board2x4.x])
    HouseFrame2();

    translate([HouseLength/2, HouseWidth/2,0])
    rotate([0,0,90])
    add_floor();  
    // add_geo_thermal();

    // add_polycarbonate_sheet();

    translate([HouseLength + EntryLength , HouseWidth/2 - EntryWidth/2,0])
    rotate([0,0,90])
    add_doorway();

    // GreenHouseProperties_Info();

}

module add_roof()
{
    translate([HouseLength/2, HouseWidth/2,0])
    rotate([0,0,90])
    union()
    {
        translate([0, 0, 2 * Board2x4.x])
        main_roof();  //in use <roof.scad>;
    }
    
    translate([0, 0, 2 * Board2x4.x])
    add_entry_roof(); //in use <roof.scad>;
}

module HouseFrame2()
{
    debug_callstack();

    isFinished = true;
    //back wall
    add_wall(West_Wall);
    add_wall(North_Wall);
    add_wall(South_Wall);
    // add_glazing_to_wall(South_Wall);

    add_wall(East_Wall1);
    add_wall(East_Wall2);

    add_wall(North_Entry_Wall);
    add_wall(South_Entry_Wall);

}

module foundation_plates() 
{
    debug_callstack();
    add_foundation_plate(South_Entry_Wall);
    add_foundation_plate(North_Entry_Wall);
    add_foundation_plate(East_Wall1);
    add_foundation_plate(East_Wall2);
    add_foundation_plate(South_Wall);
    add_foundation_plate(North_Wall);
    add_foundation_plate(West_Wall);
}

module add_roof_plate()
{

}

module add_glazing_to_wall(properties)
{
     debug_callstack();
     echo(
         panel_count = round(ceil(gdv(properties, "wall dimension").x / gdv(Polycarbonate_sheet, "width"))),
         width = gdv(Polycarbonate_sheet, "width"),
         spacing = gdv(Polycarbonate_sheet, "spacing")
         );

    for (i=[0: round(floor(gdv(properties, "wall dimension").x / gdv(Polycarbonate_sheet, "width")))]) 
    {
        translate
        (
            [
                panel_x
                (
                    i = i, 
                    panel_width = gdv(Polycarbonate_sheet, "width"), 
                    spacing = gdv(Polycarbonate_sheet, "spacing")
                ), 
                0, 
                0
            ]
        )
        {
            // translate([gdv(Polycarbonate_sheet, "spacing"), 0 ,0])
            add_polycarbonate_sheet();            
        }
    }
    
}

function panel_x(i, panel_width, spacing) = (i * panel_width) + (i * spacing);

module add_polycarbonate_sheet()
{
    color(gdv(Polycarbonate_sheet, "color"), gdv(Polycarbonate_sheet, "alpha value"))
    linear_extrude(height = gdv(Polycarbonate_sheet, "height"))
    // translate(gdv(Polycarbonate_sheet, "location"))
     // put left bottom corner of sheet at [0, 0, 0,]
     
    // translate([gdv(Polycarbonate_sheet, "width")/2, 0, 0])   
    translate([Board2x4.y, 0, 100])
    translate([1219.2/2, 0, 0])
    square(size=[gdv(Polycarbonate_sheet, "width"), gdv(Polycarbonate_sheet, "thickness")], center=true);
}


module add_wall(properties)
{
    echo(properties = properties);
    echo(Width_in = convertV_mm2Inch(properties[4]));
    debug_callstack();
    color(gdv(properties, "color"), 0.5)
    translate(gdv(properties, "location"))
    rotate(gdv(properties, "rotate"))
    {
        Wall
        (
            wallOD = gdv(properties, "wall dimension"),
            board = Board2x4,
            spacing = StudSpacing,
            finished = true
        );
    }
}

module add_foundation_plate(properties)
{
    echo(Wall = properties.x);
    color(gdv(properties, "foundation plate color"), 0.5)
    translate(gdv(properties, "foundation location"))
    rotate(gdv(properties, "foundation rotate"))
    {
        Plate
        (
            wallOD = gdv(properties, "plate dimension"),
            board = gdv(properties, "foundation board"),
            isOverlap = !gdv(properties, "start plate flush"), 
            isEnd = gdv(properties, "foundation isEnd")
        );

        translate([0, 0, gdv(properties, "foundation board").x])
        Plate
        (
            wallOD = gdv(properties, "plate dimension"),
            board =  gdv(properties, "foundation board"),
            isOverlap = gdv(properties, "start plate flush"),
            isEnd = gdv(properties, "foundation isEnd")
        );
    }    
}

module simpleView(showentry = true, showRoof = true, showwalls = true)
{
    {
        sidePoints = housePoints(houseDi = HouseDimensions, roofDi = RoofProperties, p0 = [0,0]);

        echo(sidePoints = sidePoints);
        echo(sidePoints_inches = convertVPts_mm2Inch(sidePoints));

        translate([gdv(HouseDimensions, "length")/2,gdv(HouseDimensions, "width")/2,0])
        // rotate([90,0,0])
        %linear_extrude(height = gdv(HouseDimensions, "wall height"))
        square(size=[gdv(HouseDimensions, "length"), gdv(HouseDimensions, "width")], center=true);
        // polygon(points=sidePoints);

    }
    if(showentry)
    {
            entryPoints = housePoints(houseDi = EntryDimensions, roofDi = EntryRoofDimensions, p0 = [0,0]);
            echo(entryPoints = entryPoints);
            echo(EntryDimensions = EntryDimensions, EntryRoofDimensions = EntryRoofDimensions);

            translate(
                [
                    gdv(HouseDimensions, "width") 
                        - (gdv(EntryRoofDimensions, "length") 
                        - gdv(EntryDimensions, "width")), 
                    gdv(HouseDimensions, "wall height")/2 
                        - gdv(EntryDimensions, "width")/2,
                    0
                ]
            )
            rotate([90,0,90])
            difference()
            {
                linear_extrude(height = gdv(EntryRoofDimensions, "length"))
                polygon(points=entryPoints);

                union()
                {
                    linear_extrude(height = gdv(EntryRoofDimensions, "length")/2)
                    square([gdv(EntryDimensions, "width") + 1,gdv(EntryDimensions, "height") + 1], center = false);
                    tripoints = [
                        [0,gdv(EntryDimensions, "height")],
                        [gdv(EntryRoofDimensions, "length")/2,gdv(EntryDimensions, "height")],
                        [0, gdv(EntryRoofDimensions, "length")/2 ]
                        ];
                        echo(tripoints=tripoints);
                        echo(tripoints=convertVPts_mm2Inch(tripoints));
                    // translate([0,gdv(EntryDimensions, "height"),0])
                    // !#rotate([0,-90,90])
                    // translate([0,-gdv(EntryDimensions, "height"),0])
                    // linear_extrude(height = gdv(EntryDimensions, "width"))
                    // polygon(points=tripoints);
                }
            }


            //left garden box
            translate([gdv(HouseDimensions, "width"), 0, 0])
            // linear_extrude(height = gdv(EntryRoofDimensions, "length"))
            color("white") box_extrude(height = convert_ft2mm(2), shell_thickness = convert_in2mm(in = 2)) 
            square([gdv(EntryDimensions, "width"),(gdv(HouseDimensions, "wall height") - gdv(EntryDimensions, "width"))/2], center = false);

            //right garden box
            translate([gdv(HouseDimensions, "width"), gdv(HouseDimensions, "wall height") - (gdv(HouseDimensions, "wall height") - gdv(EntryDimensions, "width"))/2 , 0])
            // linear_extrude(height = gdv(EntryRoofDimensions, "length"))
            color("white") box_extrude(height = convert_ft2mm(2), shell_thickness = convert_in2mm(in = 2)) 
            square([gdv(EntryDimensions, "width"),(gdv(HouseDimensions, "wall height") - gdv(EntryDimensions, "width"))/2], center = false);
    }

}

function housePoints(houseDi, roofDi, p0) = 
[
    p0,                             //p0
    [gdv(houseDi, "width"), p0.y],           //p1
    [gdv(houseDi, "width"), gdv(houseDi, "wall height")],   //p2
    [gdv(houseDi, "width")/2, gdv(houseDi, "peak height")],   //p3 
    [p0.x, gdv(houseDi, "wall height")]           //p4
];


function half(v) = 
[
   for(i = [0 : len(v)-1]) (v[i]/2) 
];


