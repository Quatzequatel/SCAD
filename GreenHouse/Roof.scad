/*
    
*/

include <constants.scad>;
include <GreenHouseProperties.scad>;

use <convert.scad>;
use <trigHelpers.scad>;
use <ObjectHelpers.scad>;
use <dictionary.scad>;

use <morphology.scad>;

build();

module build(args) 
{
    main_roof();
}

module main_roof()
{

    roofValues = getDictionary(v = RoofProperties, key = "roof properties");
    studValues = getDictionary(v = StudProperties, key = "StudProperties");

    roofangle = getDictionaryValue(RoofProperties, "angle" );
    echo(RoofProperties = RoofProperties);
    echo(roofangle = roofangle);
    echo(rafter_length_ft = convert_mm2ft(getDictionaryValue(RoofProperties, "rafter length" )));
    echo(roof_height_ft = convert_mm2ft(getDictionaryValue(RoofProperties, "height" )));
    echo(roof_width_ft = convert_mm2ft(getDictionaryValue(RoofProperties, "width" )));
    echo(poly_sheet_count = convert_mm2ft(getDictionaryValue(RoofProperties, "length" ))/4);

    %translate([ 0, 0, -convert_ft2mm(ft = 4)])
    linear_extrude(convert_ft2mm(ft = 4))
    translate([-getDictionaryValue(HouseDimensions, "width")/2,0,0])
    square([getDictionaryValue(HouseDimensions, "width"), getDictionaryValue(HouseDimensions, "length")]);

    cylinder(r=10, h=getDictionaryValue(RoofProperties, "height" ), center=false);

    for (i=[0:6]) 
    {
        translate
        (
            [
                0,
                i * getDictionaryValue(RoofProperties, "spacing" ),
                0
            ]
        )
        union()
        {
            rafter_left(offset = 25);
            rafter_right(offset = 25);            
        }       
    }
    //last one
    translate
    (
        [
            0,
            getDictionaryValue(RoofProperties, "length" ) - getDictionaryValue(RafterProperties, "thickness" ),
            0
        ]
    )
    union()
    {
        rafter_left(offset = 25);
        rafter_right(offset = 25);             
    }    
    center_beam();
 }

module center_beam()
{
    translate
    (
        [
            -getDictionaryValue(RafterProperties, "thickness" )/2,
            0,
            getDictionaryValue(RoofProperties, "height" )        
        ]
    )
        linear_extrude(getDictionaryValue(RafterProperties, "depth" ))
        {
            square(
                size=
                [
                    getDictionaryValue(RafterProperties, "thickness" ) , 
                    getDictionaryValue(RoofProperties, "length" )
                ], 
                center=false);                     
        }
}

module rafter_left(offset = 25)
{
    // echo(offset = offset);
    //
    translate(
        [
            -getDictionaryValue(RoofProperties, "width" ) 
            - getDictionaryValue(RoofProperties, "overhang depth" )
            + getDictionaryValue(RafterProperties, "thickness" ) + offset
            ,0, 
            - getDictionaryValue(RoofProperties, "overhang height" ) + offset
        ]
        ) 
    //rotate in place
    rotate([0, -getDictionaryValue(RoofProperties, "angle" ), 0]) 
    {
        //rafter with end cuts
        difference()
        {
            //create rafter
            linear_extrude(getDictionaryValue(RafterProperties, "depth" ))
            {
                square(
                    size=
                    [
                        getDictionaryValue(RoofProperties, "rafter length" ) , 
                        getDictionaryValue(RafterProperties, "thickness" )
                    ], 
                    center=false);                     
            }
            
            //cut right end to angle
            translate(
                [
                    getDictionaryValue(RoofProperties, "rafter length" ) - 
                        sideBaA
                            (
                                side_a =  getDictionaryValue(RafterProperties, "depth" ), 
                                aA =  getDictionaryValue(RoofProperties, "angle" )
                            ), 
                    -1, 
                    0
                ])
            angle_cut_rightside
                (
                    angle = getDictionaryValue(RoofProperties, "angle" ), 
                    sideA = getDictionaryValue(RafterProperties, "depth" ),
                    doMirror = false
                );

            //cut left end to angle
            translate(
                [
                    - sideBaA
                        (
                            side_a =  getDictionaryValue(RafterProperties, "depth" ), 
                            aA =  getDictionaryValue(RoofProperties, "angle" )
                        ), 
                    -1, 
                    0
                ])
                
            angle_cut_lefttside
            (
                angle = getDictionaryValue(RoofProperties, "angle" ), 
                sideA = getDictionaryValue(RafterProperties, "depth" ),
                doMirror = false
            );                    
        }
    
    }        
}

module rafter_right(offset=25)
{
    // echo(offset = offset);
        mirror([1, 0, 0]) 
        // translate(
        //     [
        //         -getDictionaryValue(RoofProperties, "width" ) - getDictionaryValue(RoofProperties, "overhang depth" ), 
        //         0, 
        //         - getDictionaryValue(RoofProperties, "overhang height" )
        //     ]
        //     ) 
    translate(
        [
            -getDictionaryValue(RoofProperties, "width" ) 
            - getDictionaryValue(RoofProperties, "overhang depth" )
            + getDictionaryValue(RafterProperties, "thickness" ) + offset
            ,0, 
            - getDictionaryValue(RoofProperties, "overhang height" ) + offset
        ]
        ) 
    rotate([0, -getDictionaryValue(RoofProperties, "angle" ), 0]) 
    {
        difference()
        {
            linear_extrude(getDictionaryValue(RafterProperties, "depth" ))
            {
                square(
                    size=
                    [
                        getDictionaryValue(RoofProperties, "rafter length" ) , 
                        getDictionaryValue(RafterProperties, "thickness" )
                    ], 
                    center=false);                     
            }

            translate(
                [
                    getDictionaryValue(RoofProperties, "rafter length" ) - sideBaA(side_a =  getDictionaryValue(RafterProperties, "depth" ), aA =  getDictionaryValue(RoofProperties, "angle" )), 
                    0, 
                    0
                ])
            angle_cut_rightside
                (
                    angle = getDictionaryValue(RoofProperties, "angle" ), 
                    sideA = getDictionaryValue(RafterProperties, "depth" ),
                    doMirror = false
                );

            translate(
                [
                    - sideBaA(side_a =  getDictionaryValue(RafterProperties, "depth" ), aA =  getDictionaryValue(RoofProperties, "angle" )), 
                    0, 
                    0
                ])
                
            angle_cut_lefttside
            (
                angle = getDictionaryValue(RoofProperties, "angle" ), 
                sideA = getDictionaryValue(RafterProperties, "depth" ),
                doMirror = false
            );                    
        }
    
    }
}

module angle_cut_rightside(angle, sideA, doMirror = false) 
{
    thickness = getDictionaryValue(RafterProperties, "thickness") + 2;
    translate([sideBaA(side_a =  sideA, aA =  angle), thickness, 0])
    mirror([1, 0, 0]) 
    
    do_cut(angle = angle, sideA = sideA);

    module do_cut(angle , sideA)
    {
        rotate([90,0,0])
        linear_extrude(thickness)
        polygon(points=getTrianglePoints(sideA = sideA, angleA = angle));        
    }
}

module angle_cut_lefttside(angle, sideA, doMirror = false) 
{
    thickness = getDictionaryValue(RafterProperties, "thickness") + 2;
    translate([sideBaA(side_a =  sideA, aA =  angle), thickness, 0])
    // mirror([1, 0, 0]) 
    
    do_cut(angle = angle, sideA = sideA);

    module do_cut(angle , sideA)
    {
        rotate([90,0,0])
        linear_extrude(thickness)
        polygon(points=getTrianglePoints(sideA = sideA, angleA = angle));        
    }
}


function getTrianglePoints(sideA, angleA) = 
[
    [0,0], 
    [0, sideA], 
    [sideBaA(side_a =  sideA, aA =  angleA) , 0]    
];