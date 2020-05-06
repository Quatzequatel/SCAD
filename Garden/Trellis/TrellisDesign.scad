
include <constants.scad>;
use <TrellisFunctions.scad>;
use <polyline2d.scad>;
use <SquareLatticeTrellis.scad>;
use <WaveTrellis.scad>;
use <..\\..\\..\\libraries\\SpiralShapes.scad>
/*
    Create panels for Trellis
    note to self:
        dimensions are [width, height, length] 
        [width, depth, length]
        [x, y, z]
        [thumb, index finger, middle finger]
        paper is 8.5 x 11
        board is 2 x 4
        screen is 1024 x 768
*/

//standard
$fn = 60;

//LatticeStrip
LS_Length = convertFeet2mm(4);

//screwholes
ScrewHole_OD = 2;
ScrewHoleCount = 2;

//enum
enumThickness = 0;
enumDepth = 1;

enumScrew_OD = 0;
enumScrewCount = 1;

enumWaveWidth = 0;
enumWaveHeight = 1;
enumWaveLength = 2;
enumWaveType = 3;

enumWaveTypeCos = 0;
enumWaveTypeSin = 1;

enumFrameTypeSquare = 0;
enumFrameTypeCircle = 1;


enumincludeFrame = 0;
enumincludeDiamondStyleTrellis = 1;
enumincludeSquareLatticeTrellis = 2;
enumincludeArchimedianSpiral = 3;
enumincludeHorizontalWaveTrellis = 4;
enumincludeFrameType = 5;

function getIncludeProperty(includes, enum) = includes[enum];
function setIncludeProperty(includes, frame, diamondStyleTrellis, squareTrellis, spiralTrellis, waveTrellis, frameType) =
[
    frame == undef ? includes[enumincludeFrame] : frame, 
    diamondStyleTrellis == undef ? includes[enumincludeDiamondStyleTrellis] : diamondStyleTrellis, 
    squareTrellis == undef ? includes[enumincludeSquareLatticeTrellis] : squareTrellis, 
    spiralTrellis == undef ? includes[enumincludeArchimedianSpiral] : spiralTrellis,
    waveTrellis == undef ? includes[enumincludeHorizontalWaveTrellis] : waveTrellis,
    frameType == undef ? includes[enumincludeFrameType] : frameType,
];


Includes = setIncludeProperty
    ([], 
        frame = true, 
        diamondStyleTrellis = false, 
        squareTrellis = true, 
        spiralTrellis = false, 
        waveTrellis = true,
        frameType = enumFrameTypeSquare
    );
WaveProperties = setWaveProperty(wave = [], width = 10, height = 38, length = 0, type = enumWaveTypeCos);

Panels = [1,1];

Build();
// Circles();

// Frame();

module Build()
{
    //[0,1] = [enumThickness, enumDepth]
    frameBoardDimension = setDimension([], depth =WallThickness(count = 4), thickness = convertInches2mm(0.5)); 
    latticeDimension = setDimension([], depth =WallThickness(count = 2), thickness = layers2Height(8)); 
    width = convertInches2mm(12) - getThickness(frameBoardDimension);
    height = convertInches2mm(12)  - getThickness(frameBoardDimension);// + 2*getThickness(frameBoardDimension); 
    intervalCount = 3;
    includes = Includes;
    screwHoles = [ScrewHole_OD, ScrewHoleCount];
    echo(frameBoardDimension=frameBoardDimension, latticeDimension=latticeDimension);

    xDimension = Panels[0];
    yDimension = Panels[1];

    for(x = [0 : 1 : xDimension-1])
    {
        for(y = [0 : 1 : yDimension-1])
        {
            if(getIncludeProperty(includes, enumincludeFrameType) == enumFrameTypeSquare)
            {
                echo(frameType = "enumFrameTypeSquare");
                translate([x * (width + getThickness(frameBoardDimension)), y * (height + getThickness(frameBoardDimension)), 0])
                Panel( frameWidth = width, frameHeight = height);               
            }
            
            if(getIncludeProperty(includes, enumincludeFrameType) == enumFrameTypeCircle)
            {
                echo(frameType = "enumFrameTypeCircle");
                translate([x * (width + getThickness(frameBoardDimension)), y * (height + getThickness(frameBoardDimension)), 0])
                Circles( radius = width/2);               
            }

        }
    }

}

module Circles
(
    radius
)
{
    frameRadius = radius;
    frameBoardDimension = setDimension([], depth =WallThickness(count = 4), thickness = convertInches2mm(0.5)); 
    latticeDimension = setDimension([], depth =WallThickness(count = 2), thickness = layers2Height(8)); 
    width = radius * 2;
    height = radius * 2;
    intervalCount = 3;
    includes = Includes;
    screwHoles = [ScrewHole_OD, ScrewHoleCount];

    difference()
    {    
        union()
        {
            if(getIncludeProperty(includes, enumincludeFrame))
            {
                echo(frameBoardDimension=frameBoardDimension);

                translate([0,0, frameBoardDimension.y/2])
                CircleFrame
                (
                    frameRadius = frameRadius,
                    frameBoardDimension = frameBoardDimension,
                    screwHoles = [ScrewHole_OD, ScrewHoleCount]
                );
            }
            if(getIncludeProperty(includes, enumincludeDiamondStyleTrellis))
            {
                translate([-frameRadius, frameRadius, 0])
                rotate([90,0,0])
                DiamondStyleTrellis
                (
                    width = width, 
                    height = height, 
                    frameBoardDimension = frameBoardDimension , 
                    latticeDimension = latticeDimension,
                    intervalCount = intervalCount
                );
            }
            if(getIncludeProperty(includes, enumincludeSquareLatticeTrellis))
            {
                translate([- width/2,- height/2, 0])
                SquareLatticeTrellis
                (
                    width = width, 
                    height = height, 
                    frameBoardDimension = frameBoardDimension , 
                    latticeDimension = latticeDimension,
                    intervalCount = intervalCount
                );

            }
            if(getIncludeProperty(includes, enumincludeArchimedianSpiral))
            {
                translate([0, 0, getThickness(latticeDimension)])
                // rotate([90,0,0])
                    ArchimedianSpiralTrellis
                    (
                        width = width, 
                        height = height, 
                        frameBoardDimension = frameBoardDimension , 
                        latticeDimension = latticeDimension              
                    );
            }
            if(getIncludeProperty(includes, enumincludeHorizontalWaveTrellis))
            {
                WaveTrellis
                (
                    frameDimension = [width, height],
                    frameBoardDimension = frameBoardDimension , 
                    latticeDimension = latticeDimension,
                    waveDimensions = WaveProperties,
                    intervalCount = intervalCount
                );
            }        

        }

        CircleFrameCutter
        (
                    frameRadius = frameRadius,
                    frameBoardDimension = [convertInches2mm(6), convertInches2mm(0.5)]
        ) ;       
    }
}

module Panel(frameWidth, frameHeight) 
{
    frameBoardDimension = setDimension([], depth =WallThickness(count = 4), thickness = convertInches2mm(0.5)); 
    latticeDimension = setDimension([], depth =WallThickness(count = 2), thickness = layers2Height(8)); 
    width = frameWidth;
    height = frameHeight;
    intervalCount = 3;
    includes = Includes;
    screwHoles = [ScrewHole_OD, ScrewHoleCount];
    difference()
    {
        // rotate([90,0,0])
        union()
        {
            if(getIncludeProperty(includes, enumincludeFrame))
            {    
                echo(Panel = "Frame");
                Frame
                (
                    width = width, 
                    height = height, 
                    frameBoardDimension = frameBoardDimension,
                    screwHoles = [3, 3]
                );
            }

            if(getIncludeProperty(includes, enumincludeDiamondStyleTrellis))
            {
                DiamondStyleTrellis
                (
                    width = width, 
                    height = height, 
                    frameBoardDimension = frameBoardDimension , 
                    latticeDimension = latticeDimension,
                    intervalCount = intervalCount
                );
            }

            if(getIncludeProperty(includes, enumincludeSquareLatticeTrellis))
            {    
                translate([- width/2,- height/2, 0])
                SquareLatticeTrellis
                (
                    width = width, 
                    height = height, 
                    frameBoardDimension = frameBoardDimension , 
                    latticeDimension = latticeDimension,
                    intervalCount = intervalCount
                );
            }

            if(getIncludeProperty(includes, enumincludeFrame) && getIncludeProperty(includes, enumincludeArchimedianSpiral))
            {
                difference()
                {
                    translate([ 0, 0, latticeDimension.y])
                    if(getIncludeProperty(includes, enumincludeArchimedianSpiral))
                    {
                        ArchimedianSpiralTrellis
                        (
                            width = width, 
                            height = height, 
                            frameBoardDimension = frameBoardDimension , 
                            latticeDimension = latticeDimension              
                        );
                    }            
                }
            }

            if(getIncludeProperty(includes, enumincludeHorizontalWaveTrellis))
            {
                WaveTrellis
                (
                    frameDimension = [width, height],
                    frameBoardDimension = frameBoardDimension , 
                    latticeDimension = latticeDimension,
                    waveDimensions = WaveProperties,
                    intervalCount = intervalCount
                );
            }
        }

        FrameCutter(frameWidth = width, frameHeight = height, frameBoardDimension = frameBoardDimension);
    }
}

module FrameCutter(frameWidth, frameHeight, frameBoardDimension)
{
    echo(FrameCutter="FrameCutter", frameWidth=frameWidth, frameHeight=frameHeight, frameBoardDimension=frameBoardDimension);
    offset =  NozzleWidth/4; //values needs to be less than nozzel width
    translate([0, 0, -getThickness(frameBoardDimension)])
    linear_extrude(height= 3 * frameBoardDimension.y)
    {
        difference()
        {
            square(size = [2 * frameWidth, 2 * frameHeight], center = true);
            square(size = [frameWidth + offset, frameHeight  +offset], center = true);
        }
    }
}

module Frame
    (
        width = convertFeet2mm(1), 
        height = convertFeet2mm(2), 
        frameBoardDimension = [convertInches2mm(1), convertInches2mm(1)],
        screwHoles = [ScrewHole_OD, ScrewHoleCount]
    )
{
    difference()
    {
        union()
        {    
            // Box
            linear_extrude(height = frameBoardDimension.y)
            difference()
            {
                square(size=[width, height], center=true);
                square(size=[width - frameBoardDimension.x, height - frameBoardDimension.x], center=true);
            }
        }   

        if (len(screwHoles) != undef) 
        {
            incrementHoz = height / (screwHoles[enumScrewCount] + 1);
            echo(width = width, height  = height, screwHoles = screwHoles);
            echo(getActualHeight = getActualHeight(), ScrewCount  = screwHoles[enumScrewCount], incrementHoz = incrementHoz);
            for(i = [1 : screwHoles[enumScrewCount]])
            {
                //note: p[x=>length]
                point_hole
                    (
                        diameter = screwHoles[enumScrew_OD], 
                        p1 = [ - getActualWidth()/2, (i * incrementHoz - height/2), frameBoardDimension.y/2], 
                        p2 = [   getActualWidth()/2, (i * incrementHoz - height/2), frameBoardDimension.y/2]
                    );
            }

            incrementVert = width / (screwHoles[enumScrewCount] + 1);
            echo(getActualHeight = getActualHeight(), ScrewCount  = screwHoles[enumScrewCount], incrementVert = incrementVert);
            for(i = [1 : screwHoles[enumScrewCount]])
            {
                //note: p[y=>length]
                point_hole
                    (
                        diameter = screwHoles[enumScrew_OD], 
                        p1 = [(i * incrementVert - width/2), - getActualHeight()/2, frameBoardDimension.y/2], 
                        p2 = [(i * incrementVert - width/2),   getActualHeight()/2, frameBoardDimension.y/2]
                    );                
            }
        }        
    }

    function getActualWidth() = width + frameBoardDimension.x;
    function getActualHeight() = height + frameBoardDimension.x;

}

module point_hole(diameter, p1, p2)
{
    echo(p1 = p1, p2 = p2);
    
    hull()
    {
        translate(p1) sphere(d = diameter);
        translate(p2) sphere(d = diameter);
    } 
}


module CircleFrame
    (
        frameRadius = 300,
        frameBoardDimension = [convertInches2mm(1), convertInches2mm(2)],
        screwHoles = [ScrewHole_OD, ScrewHoleCount]
    )
    {
        difference()
        {
            union()
            {
                rotate_extrude(angle = 360)
                {
                    translate([frameRadius,0,0])
                    {
                        // echo(size = [frameBoardDimension.x, frameBoardDimension.y]);
                        square(size = frameBoardDimension, center = true);
                    }                     
                }
           
            }     
     
            if (len(screwHoles) != undef)
            {
                echo(screwHoles = screwHoles[enumScrewCount])
                for(i = [1 : 2])
                {
                    rotate([90,0, i * 360/(screwHoles[enumScrewCount]*2)])
                    cylinder(d=screwHoles[enumScrew_OD], h= 2 * (frameRadius + frameBoardDimension.x), center=true);
                }
            }
        }

    }

module CircleFrameCutter
    (
        frameRadius = 300,
        frameBoardDimension = [convertInches2mm(1), convertInches2mm(2)]
    )
{
    union()
    {
        translate([0,0,-frameBoardDimension.y/6])
        rotate_extrude(angle = 360)
        {
            translate([frameRadius + frameBoardDimension.y/6,0,0])
            {
                // echo(size = frameBoardDimension);
                square(size = frameBoardDimension, center = false);
            }                     
        }
    
    }     
}    

module ArchimedianSpiralTrellis
(
        width = 0,
        height = 0,
        frameBoardDimension = [0,0] , 
        latticeDimension = [0,0], 
        intervalCount = 4
)
{
    union()
    {
        translate([0, 0 , -latticeDimension.y])
        {
            ArchimedeanDoubleSpiral
                (
                    height=latticeDimension.x, 
                    width=latticeDimension.y, 
                    range = 2000, 
                    scale = 0.1, 
                    a = 0, 
                    b = 1); 

            cylinder(h = latticeDimension.x, r = latticeDimension.y);
        }

    }

}

module DiamondStyleTrellis
    (
        width = convertFeet2mm(4), 
        height = convertFeet2mm(4), 
        frameBoardDimension = [convertInches2mm(1), convertInches2mm(1)] , 
        latticeDimension = [convertInches2mm(0.5), convertInches2mm(0.5)],
        intervalCount = 4
    )
{
    angle = 45;
    adjustedWidth = width - getThickness(frameBoardDimension);

    //bottom
    for(i = [0: (intervalCount - 1)])
    {
        translate(translateBottom(adjWidth = adjustedWidth, latticeThickness = getDepth(latticeDimension), frameThickness = getThickness(frameBoardDimension), i = i))
        rotate([0, angle, 0])
        {
            // color("red")
            cube(size=AddZ(latticeDimension, latticeLength(width = width, count = intervalCount, angle = angle,  i = i)), center=false);
        }
    }

    //top
    for(i = [1: 1 : (intervalCount - 1)])
    {
        translate(translateTop(adjWidth = adjustedWidth, latticeThickness = getDepth(latticeDimension), frameThickness = getThickness(frameBoardDimension), i = i))
        rotate([180, -angle, 0])
        {
            // color("yellow")
            cube(size=AddZ(latticeDimension, latticeLength(width = width, count = intervalCount, angle = angle,  i = i)), center=false);
        }
    }

    heightIntervals = latticeHeightCount(height, width, intervalCount) ;
    //left
    for(i = [1: heightIntervals])
    {
        translate(translateLeft( adjWidth = adjustedWidth, latticeThickness = getDepth(latticeDimension), frameThickness = getThickness(frameBoardDimension), i = i))
        rotate([0, angle, 0])
        {
        // color("red")
        cube(size=AddZ(latticeDimension, latticeLength2(height = height, width = width, count = intervalCount, angle = angle,  i = i)), center=false);
        }
    }    
    
    //Right    
    for(i = [heightIntervals : -1 : 0])
    {
        translate(translateRight( adjWidth = adjustedWidth, latticeThickness = getDepth(latticeDimension), frameThickness = getThickness(frameBoardDimension), i = i))
        rotate([180, -angle, 0])
        {
            // color("yellow")
            cube(size=AddZ(latticeDimension, latticeLength2(height = height, width = width, count = intervalCount, angle = angle,  i = i)), center=false);
        }
    }  
    
    function translateTop(adjWidth, latticeThickness, frameThickness, i) = 
    [
        ((adjWidth/intervalCount * i) + frameThickness/2), 
        latticeThickness, 
        height//-(frameThickness/2 + latticeThickness * cos(angle))
    ];

    function translateBottom(adjWidth, latticeThickness, frameThickness, i) = 
    [
        (adjWidth/intervalCount * i + frameThickness/2), 
        0, 
        (frameThickness/2 + latticeThickness * cos(angle))
    ];

    function translateRight(adjWidth, latticeThickness, frameThickness, i) = 
    [
        frameThickness/2, 
        latticeThickness, 
        height - adjWidth/intervalCount * i + (cos(angle) * latticeThickness)
    ];

    function translateLeft(adjWidth, latticeThickness, frameThickness, i) = 
    [
        frameThickness/2, 
        0, 
        (width/intervalCount * i) + frameThickness/2
    ];
}

// function latticeLength(width, count, angle,  i) = (1/cos(angle) * IntervalWidth(width, count, i));
// function IntervalWidth(width, count, i) = width - (width/count * i);
// function hypotenuse(width, angle) = sqrt(pow(cos(angle) * width, 2) + (pow(sin(angle) * width,2)));

// function latticeLength2(height, width, count, angle,  i) = 
//     (1/cos(angle) * (height - (width/ count) * i)) < (1/cos(angle) * width) 
//     ? 
//         (1/cos(angle) * (height - (width / count) * i)) 
//     : 
//         (1/cos(angle) * width);
// // function latticeMoveX(width, count, i) = (width/ count * i);
// function latticeMoveZ(width, count, i) = latticeIntervalWidth(width, count) * i;
// function latticeIntervalWidth(frameThickness, intervalCount ) = frameThickness/intervalCount;
// function latticeHeightCount(frameHeight, frameThickness, intervalCount) = frameHeight /latticeIntervalWidth(frameThickness, intervalCount );

module mTube(vOuter, vInner,  radius = 1, center = true)
{
    if(center)
    {
        centerTube();
    }
    else
    {
        NotCenterTube();
    }

    module centerTube()
    {
        difference()
        {
            mCube(dimensions=vOuter, radius = radius, center=center);
            mCube(dimensions=vInner, radius = radius, center=center);
        }
    }

    module NotCenterTube()
    {
        translate([radius,radius,radius])
        difference()
        {
            %mCube(dimensions=vOuter, radius = radius, center=center);
            translate(vHalfDiff(vOuter, vInner))
            mCube(dimensions=vInner, radius = radius, center=center);
        }
    }
}

module mCube(dimensions=[5,5,5], radius = 1, center = true)
{
    // echo(dimensions = dimensions, radius = radius, vAdd = vAdd(dimensions, - 2 *radius))
    minkowski()
    {
        cube(size = vAdd(dimensions, -2 * radius), center=center);
        sphere(r=radius);
    }
}
