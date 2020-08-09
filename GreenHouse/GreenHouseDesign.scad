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

use <box_extrude.scad>;

// ISDEBUGEMODE = false;


//Note: moved definitions to GreenHouseProperties.scad

Build();

module Build(args) 
{
    echo("Base Dimensions:");
    echo(Length = convert_mm2ft(mm = getDictionaryValue(HouseDimensions, "length")));
    echo(Width = convert_mm2ft(mm = getDictionaryValue(HouseDimensions, "width")));
    echo(Height = convert_mm2ft(mm = getDictionaryValue(HouseDimensions, "wall height") + getDictionaryValue(RoofProperties, "height")));
    echo(RoofAngle = RoofAngle);
    echo(RoofHeight = convert_mm2ft(mm = getDictionaryValue(RoofProperties, "height")));
    echo(RoofWidth = convert_mm2ft(mm = getDictionaryValue(RoofProperties, "width")));
    echo(WallHeight = convert_mm2ft(mm = getDictionaryValue(HouseDimensions, "wall height")));
    echo(RoofLength = convert_mm2ft(mm = getDictionaryValue(RoofProperties, "length")));
    echo(EntryRoofDimensions_inches = convertV_mm2Inch(mm = EntryRoofDimensions));
    echo(EntryRoofAngle = EntryRoofDimensions[3]);
    // echo(sin45 = sin(45));

    simpleView(showentry = true, showRoof = true, showwalls = false);


    HouseFrame2();

}

module HouseFrame2()
{
    isFinished = true;
    //back wall
    translate([0, 0, 0])
    rotate([90, 0, 90]) 
    {
        color("aqua")
        Wall(
            wallOD = [getDictionaryValue(HouseDimensions, "width"), getDictionaryValue(HouseDimensions, "width"), getDictionaryValue(HouseDimensions, "wall height")], 
            board = Board2x4, //vSetValue(Board2x4, 2, convert_in2mm(72)-Board2x4.x), 
            spacing = StudSpacing,
            finished = isFinished
        );        
        // drawFrame([0,0,0], getDictionaryValue(HouseDimensions, "wall height"), getDictionaryValue(HouseDimensions, "width"), Board2x4);
    }

    //right side wall
    translate([Board2x4.y, getDictionaryValue(HouseDimensions, "width"), 0])
    rotate([90, 0, 0]) 
    {
        color("red")
        Wall(
            wallOD = [getDictionaryValue(HouseDimensions, "width") - Board2x4.y, getDictionaryValue(HouseDimensions, "width"), getDictionaryValue(HouseDimensions, "wall height")], 
            board = Board2x4, //vSetValue(Board2x4, 2, convert_in2mm(72)-Board2x4.x), 
            spacing = StudSpacing,
            finished = isFinished
        );        
    }
    
    //left side wall
    translate([Board2x4.y, Board2x4.y, 0])
    rotate([90, 0, 0]) 
    {
        color("red")
        Wall(
            wallOD = [getDictionaryValue(HouseDimensions, "width") - Board2x4.y, getDictionaryValue(HouseDimensions, "width"), getDictionaryValue(HouseDimensions, "wall height")], 
            board = Board2x4, //vSetValue(Board2x4, 2, convert_in2mm(72)-Board2x4.x), 
            spacing = StudSpacing,
            finished = isFinished
        );        
    }

    //front wall  left side
    translate([getDictionaryValue(HouseDimensions, "width"), 0, 0])
    rotate([90, 0, 90]) 
    {
        color("blue")
        Wall(
            wallOD = [getDictionaryValue(HouseDimensions, "width")/2 - getDictionaryValue(EntryDimensions, "width")/2, getDictionaryValue(HouseDimensions, "width"), getDictionaryValue(HouseDimensions, "wall height")], 
            board = Board2x4, //vSetValue(Board2x4, 2, convert_in2mm(72)-Board2x4.x), 
            spacing = StudSpacing,
            finished = isFinished
        );        
    }

    //front wall  right side
    translate([getDictionaryValue(HouseDimensions, "width"), getDictionaryValue(HouseDimensions, "width") - (getDictionaryValue(HouseDimensions, "width")/2 - getDictionaryValue(EntryDimensions, "width")/2), 0])
    rotate([90, 0, 90]) 
    {
        color("blue")
        Wall(
            wallOD = [getDictionaryValue(HouseDimensions, "width")/2 - getDictionaryValue(EntryDimensions, "width")/2, getDictionaryValue(HouseDimensions, "width"), getDictionaryValue(HouseDimensions, "wall height")], 
            board = Board2x4, //vSetValue(Board2x4, 2, convert_in2mm(72)-Board2x4.x), 
            spacing = StudSpacing,
            finished = isFinished
        );        
    }
}

module EntryFrame2()
{
    isFinished = true;
    //left side wall
    translate
    (
        [
            getDictionaryValue(HouseDimensions, "width") + Board2x4.y, 
            getDictionaryValue(HouseDimensions, "width") - (getDictionaryValue(HouseDimensions, "width")/2 - getDictionaryValue(EntryDimensions, "width")/2) + Board2x4.y, 
            0
        ]
    )
    rotate([90, 0, 0]) 
    {
        color("yellow")
        Wall(
            wallOD = [getDictionaryValue(EntryDimensions, "width") - Board2x4.y, EntryDimensions.y, getDictionaryValue(EntryDimensions, "height")], 
            board = Board2x4, //vSetValue(Board2x4, 2, convert_in2mm(72)-Board2x4.x), 
            spacing = StudSpacing,
            finished = isFinished
        );        
    }

    //right side wall
    translate
    (
        [
            getDictionaryValue(HouseDimensions, "width") + Board2x4.y, 
            (getDictionaryValue(HouseDimensions, "width")/2 - getDictionaryValue(EntryDimensions, "width")/2), 
            0
        ]
    )
    rotate([90, 0, 0]) 
    {
        color("yellow")
        Wall(
            wallOD = [getDictionaryValue(EntryDimensions, "width") - Board2x4.y, EntryDimensions.y, getDictionaryValue(EntryDimensions, "height")], 
            board = Board2x4, //vSetValue(Board2x4, 2, convert_in2mm(72)-Board2x4.x), 
            spacing = StudSpacing,
            finished = isFinished
        );        
    }

    //Doorway
    translate
    (
        [
            getDictionaryValue(HouseDimensions, "width") + getDictionaryValue(EntryDimensions, "width") - Board2x4.y, 
            (getDictionaryValue(HouseDimensions, "width")/2 - getDictionaryValue(EntryDimensions, "width")/2), 
            0
        ]
    )
    rotate([90, 0, 90]) 
    {
        color("yellow")
        Wall(
            wallOD = [getDictionaryValue(EntryDimensions, "width"), EntryDimensions.y, getDictionaryValue(EntryDimensions, "height")], 
            board = Board2x4, //vSetValue(Board2x4, 2, convert_in2mm(72)-Board2x4.x), 
            spacing = StudSpacing,
            includeStuds = false,
            finished = isFinished
        );        
    }    
}

module RoofFrame2()
{
     
     debugEcho("RoofFrame2([0]=RoofProperties, [1]=Board2x4, [2]=StudSpacing)",[RoofProperties, Board2x4, StudSpacing], true);
    //back
    translate([0, 0, getDictionaryValue(HouseDimensions, "wall height") + Board2x4.y])
    rotate([90, 0, 90]) 
    Roof
    (
        roofOD = RoofProperties, //[x,y,z,angle]
        board = Board2x4, //vSetValue(Board2x4, 2, convert_in2mm(72)-Board2x4.x), 
        spacing = StudSpacing,
        includeHeader = false,
        includeStuds = true,
        finished = false
    );

    //front
    mirror([1,0,0])
    translate([-(getDictionaryValue(HouseDimensions, "width") + Board2x4.y), 0, getDictionaryValue(HouseDimensions, "wall height") + Board2x4.y])
    //  translate([getDictionaryValue(HouseDimensions, "width") + Board2x4.y, getDictionaryValue(HouseDimensions, "width"), getDictionaryValue(HouseDimensions, "wall height") + Board2x4.y])
    rotate([90, 0, 90]) 
    Roof
    (
        roofOD = RoofProperties, //[x,y,z,angle]
        board = Board2x4, //vSetValue(Board2x4, 2, convert_in2mm(72)-Board2x4.x), 
        spacing = StudSpacing,
        includeHeader = false,
        includeStuds = true,
        finished = true
    );
}

module EntryRoofFrame2()
{
    echo(EntryRoofFrame2 = 1, EntryRoofDimensions=EntryRoofDimensions);
    //left
    // translate([0, 0, getDictionaryValue(HouseDimensions, "wall height") + Board2x4.y])
    // rotate([90, 0, 90]) 
    translate
    (
        [
            getDictionaryValue(HouseDimensions, "width") + Board2x4.y, 
            getDictionaryValue(HouseDimensions, "width") - (getDictionaryValue(HouseDimensions, "width")/2 - getDictionaryValue(EntryDimensions, "width")/2) + Board2x4.y, 
            getDictionaryValue(HouseDimensions, "wall height") + Board2x4.y
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
            getDictionaryValue(HouseDimensions, "width") + Board2x4.y, 
            (getDictionaryValue(HouseDimensions, "width")/2 - getDictionaryValue(EntryDimensions, "width")/2) - Board2x4.y , 
            getDictionaryValue(HouseDimensions, "wall height") + Board2x4.y
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

module simpleView(showentry = true, showRoof = true, showwalls = true)
{
    {
        sidePoints = housePoints(houseDi = HouseDimensions, roofDi = RoofProperties, p0 = [0,0]);

        echo(sidePoints = sidePoints);
        echo(sidePoints_inches = convertVPts_mm2Inch(sidePoints));

        translate([0,getDictionaryValue(HouseDimensions, "width"),0])
        rotate([90,0,0])
        %linear_extrude(height = getDictionaryValue(HouseDimensions, "width"))
        polygon(points=sidePoints);

    }
    if(showentry)
    {
            entryPoints = housePoints(houseDi = EntryDimensions, roofDi = EntryRoofDimensions, p0 = [0,0]);
            echo(entryPoints = entryPoints);
            echo(EntryDimensions = EntryDimensions, EntryRoofDimensions = EntryRoofDimensions);

            translate(
                [
                    getDictionaryValue(HouseDimensions, "width") 
                        - (getDictionaryValue(EntryRoofDimensions, "length") 
                        - getDictionaryValue(EntryDimensions, "width")), 
                    getDictionaryValue(HouseDimensions, "wall height")/2 
                        - getDictionaryValue(EntryDimensions, "width")/2,
                    0
                ]
            )
            rotate([90,0,90])
            difference()
            {
                linear_extrude(height = getDictionaryValue(EntryRoofDimensions, "length"))
                polygon(points=entryPoints);

                union()
                {
                    linear_extrude(height = getDictionaryValue(EntryRoofDimensions, "length")/2)
                    square([getDictionaryValue(EntryDimensions, "width") + 1,getDictionaryValue(EntryDimensions, "height") + 1], center = false);
                    tripoints = [
                        [0,getDictionaryValue(EntryDimensions, "height")],
                        [getDictionaryValue(EntryRoofDimensions, "length")/2,getDictionaryValue(EntryDimensions, "height")],
                        [0, getDictionaryValue(EntryRoofDimensions, "length")/2 ]
                        ];
                        echo(tripoints=tripoints);
                        echo(tripoints=convertVPts_mm2Inch(tripoints));
                    // translate([0,getDictionaryValue(EntryDimensions, "height"),0])
                    // !#rotate([0,-90,90])
                    // translate([0,-getDictionaryValue(EntryDimensions, "height"),0])
                    // linear_extrude(height = getDictionaryValue(EntryDimensions, "width"))
                    // polygon(points=tripoints);
                }
            }


            //left garden box
            translate([getDictionaryValue(HouseDimensions, "width"), 0, 0])
            // linear_extrude(height = getDictionaryValue(EntryRoofDimensions, "length"))
            color("white") box_extrude(height = convert_ft2mm(2), shell_thickness = convert_in2mm(in = 2)) 
            square([getDictionaryValue(EntryDimensions, "width"),(getDictionaryValue(HouseDimensions, "wall height") - getDictionaryValue(EntryDimensions, "width"))/2], center = false);

            //right garden box
            translate([getDictionaryValue(HouseDimensions, "width"), getDictionaryValue(HouseDimensions, "wall height") - (getDictionaryValue(HouseDimensions, "wall height") - getDictionaryValue(EntryDimensions, "width"))/2 , 0])
            // linear_extrude(height = getDictionaryValue(EntryRoofDimensions, "length"))
            color("white") box_extrude(height = convert_ft2mm(2), shell_thickness = convert_in2mm(in = 2)) 
            square([getDictionaryValue(EntryDimensions, "width"),(getDictionaryValue(HouseDimensions, "wall height") - getDictionaryValue(EntryDimensions, "width"))/2], center = false);
    }

}

// module EntryRoofFrame2()
// {

// }

function housePoints(houseDi, roofDi, p0) = 
[
    p0,                             //p0
    [getDictionaryValue(houseDi, "length"), p0.y],           //p1
    [getDictionaryValue(houseDi, "length"), getDictionaryValue(houseDi, "wall height")],   //p2
    [getDictionaryValue(houseDi, "length")/2, getDictionaryValue(houseDi, "peak height")],   //p3 
    [p0.x, getDictionaryValue(houseDi, "wall height")]           //p4
];


function half(v) = 
[
   for(i = [0 : len(v)-1]) (v[i]/2) 
];


