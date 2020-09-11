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
}

module Build(args) 
{

    // echo(sin45 = sin(45));
    info();
    scale(size = 16, increment = convert_in2mm(12), fontsize = 72);

    // simpleView(showentry = true, showRoof = false, showwalls = true);

    translate([HouseLength/2, HouseWidth/2,0])
    rotate([0,0,90])
    union()
    {
        main_roof();
        add_floor();        
    }
    
    add_entry_roof();

    HouseFrame2();

}

module HouseFrame2()
{
    isFinished = true;
    //back wall
    add_wall(West_Wall);
    add_wall(North_Wall);
    add_wall(South_Wall);
    add_wall(East_Wall1);
    add_wall(East_Wall2);

    add_wall(North_Entry_Wall);
    add_wall(South_Entry_Wall);

}

module EntryFrame2()
{
    isFinished = true;
    //left side wall
    translate
    (
        [
            gdv(HouseDimensions, "width") + Board2x4.y, 
            gdv(HouseDimensions, "width") - (gdv(HouseDimensions, "width")/2 - gdv(EntryDimensions, "width")/2) + Board2x4.y, 
            0
        ]
    )
    rotate([90, 0, 0]) 
    {
        color("yellow")
        Wall(
            wallOD = [gdv(EntryDimensions, "width") - Board2x4.y, EntryDimensions.y, gdv(EntryDimensions, "height")], 
            board = Board2x4, //vSetValue(Board2x4, 2, convert_in2mm(72)-Board2x4.x), 
            spacing = StudSpacing,
            finished = isFinished
        );        
    }

    //right side wall
    translate
    (
        [
            gdv(HouseDimensions, "width") + Board2x4.y, 
            (gdv(HouseDimensions, "width")/2 - gdv(EntryDimensions, "width")/2), 
            0
        ]
    )
    rotate([90, 0, 0]) 
    {
        color("yellow")
        Wall(
            wallOD = [gdv(EntryDimensions, "width") - Board2x4.y, EntryDimensions.y, gdv(EntryDimensions, "height")], 
            board = Board2x4, //vSetValue(Board2x4, 2, convert_in2mm(72)-Board2x4.x), 
            spacing = StudSpacing,
            finished = isFinished
        );        
    }

    //Doorway
    translate
    (
        [
            gdv(HouseDimensions, "width") + gdv(EntryDimensions, "width") - Board2x4.y, 
            (gdv(HouseDimensions, "width")/2 - gdv(EntryDimensions, "width")/2), 
            0
        ]
    )
    rotate([90, 0, 90]) 
    {
        color("yellow")
        Wall(
            wallOD = [gdv(EntryDimensions, "width"), EntryDimensions.y, gdv(EntryDimensions, "height")], 
            board = Board2x4, //vSetValue(Board2x4, 2, convert_in2mm(72)-Board2x4.x), 
            spacing = StudSpacing,
            includeStuds = false,
            finished = isFinished
        );        
    }    
}

module EntryRoofFrame2()
{
    echo(EntryRoofFrame2 = 1, EntryRoofDimensions=EntryRoofDimensions);
    //left
    // translate([0, 0, gdv(HouseDimensions, "wall height") + Board2x4.y])
    // rotate([90, 0, 90]) 
    translate
    (
        [
            gdv(HouseDimensions, "width") + Board2x4.y, 
            gdv(HouseDimensions, "width") - (gdv(HouseDimensions, "width")/2 - gdv(EntryDimensions, "width")/2) + Board2x4.y, 
            gdv(HouseDimensions, "wall height") + Board2x4.y
        ]
    )
    rotate([90, 0, 0])    
    Roof
    (
        roofOD = EntryRoofDimensions, //[x,y,z,angle]
        board = Board2x4, //vSetValue(Board2x4, 2, convert_in2mm(72)-Board2x4.x), 
        spacing = StudSpacing,
        includeHeader = true,
        includeStuds = true,
        finished = true
    );

    translate
    (
        [
            gdv(HouseDimensions, "width") + Board2x4.y, 
            (gdv(HouseDimensions, "width")/2 - gdv(EntryDimensions, "width")/2) - Board2x4.y , 
            gdv(HouseDimensions, "wall height") + Board2x4.y
        ]
    )
    mirror([0,1,0])
    rotate([90, 0, 0])    
    Roof
    (
        roofOD = EntryRoofDimensions, //[x,y,z,angle]
        board = Board2x4, //vSetValue(Board2x4, 2, convert_in2mm(72)-Board2x4.x), 
        spacing = StudSpacing,
        includeHeader = true,
        includeStuds = true,
        finished = true
    );
}

module add_wall(properties)
{
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

// module EntryRoofFrame2()
// {

// }

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


