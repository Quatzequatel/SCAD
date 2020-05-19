
include <constants.scad>;
include <TrellisEnums.scad>;
use <TrellisFunctions.scad>;
use <polyline2d.scad>;
use <Frame.scad>;
use <SquareLatticeTrellis.scad>;
use <DiagonalTrellis.scad>;
use <WaveTrellis.scad>;
use <MazeLattice.scad>;
use <TrigHelpers.scad>;
use <.\\lattice.scad>;
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
enumFrameTypeHex = 2;


enumincludeFrame = 0;
enumincludeDiamondStyleTrellis = 1;
enumincludeSquareLatticeTrellis = 2;
enumincludeArchimedianSpiral = 3;
enumincludeHorizontalWaveTrellis = 4;
enumincludeFrameType = 5;
enumincludeBubbles = 6;
enumincludeMaze = 6;

function getIncludeProperty(includes, enum) = includes[enum];
function setIncludeProperty
    (
        includes, 
        frame, 
        diamondStyleTrellis, 
        squareTrellis, 
        spiralTrellis, 
        waveTrellis, 
        frameType, 
        bubblesTrellis,
        mazeTrellis
    ) =
[
    frame == undef ? includes[enumincludeFrame] : frame, 
    diamondStyleTrellis == undef ? includes[enumincludeDiamondStyleTrellis] : diamondStyleTrellis, 
    squareTrellis == undef ? includes[enumincludeSquareLatticeTrellis] : squareTrellis, 
    spiralTrellis == undef ? includes[enumincludeArchimedianSpiral] : spiralTrellis,
    waveTrellis == undef ? includes[enumincludeHorizontalWaveTrellis] : waveTrellis,
    frameType == undef ? includes[enumincludeFrameType] : frameType,
    bubblesTrellis == undef ? includes[enumincludeBubbles] : bubblesTrellis,
    mazeTrellis == undef ? includes[enumincludeMaze] : mazeTrellis,
];

Panels = [1,1];
Seed = 7;


//Global Properties
FrameBoardDimension = [WallThickness(count = 4), convertInches2mm(0.5)]; 
FrameDimension = [convertInches2mm(12) - FrameBoardDimension.y, convertInches2mm(12) - FrameBoardDimension.y];
LatticeDimension = setDimension([], depth =WallThickness(count = 2), thickness = layers2Height(8)); 
ScrewHoles = [ScrewHole_OD, ScrewHoleCount];
IntervalCount =2;    
Includes = setIncludeProperty
    ([], 
        frame = true, 
        diamondStyleTrellis = false, 
        squareTrellis = true, 
        spiralTrellis = false, 
        waveTrellis = false,
        frameType = enumFrameTypeSquare,
        bubblesTrellis = true,
        mazeTrellis = false
    );

//Frame type Properties
SquareProperties = 
[
    FrameDimension,         //[0] enumPropertyFrame
    FrameBoardDimension,    //[1] enumPropertyFrameBoard
    LatticeDimension,       //[2] enumPropertyLattice
    ScrewHoles,             //[3] enumPropertyScrewHoles
    IntervalCount,          //[4] enumPropertyInterval
    Includes                //[5] enumPropertyInclude.
];

CircleProperties = 
[
    FrameDimension,         //[0] enumPropertyFrame
    FrameBoardDimension,    //[1] enumPropertyFrameBoard
    LatticeDimension,       //[2] enumPropertyLattice
    ScrewHoles,             //[3] enumPropertyScrewHoles
    IntervalCount,          //[4] enumPropertyInterval
    Includes                //[5] enumPropertyInclude.
];

HexProperties = 
[
    FrameDimension,         //[0] enumPropertyFrame
    FrameBoardDimension,    //[1] enumPropertyFrameBoard
    LatticeDimension,       //[2] enumPropertyLattice
    ScrewHoles,             //[3] enumPropertyScrewHoles
    IntervalCount,          //[4] enumPropertyInterval
    Includes                //[5] enumPropertyInclude.
];


//specific trellis type properties
WaveProperties = setWaveProperty(wave = [], width = 10, height = 50, length = 0, type = enumWaveTypeBoth);


Build();
// Circles();

// Frame();

module Build()
{
    let
    (
        frameProperty = getIncludeProperty(Includes, enumincludeFrameType) == enumFrameTypeSquare ?
            SquareProperties :
            getIncludeProperty(Includes, enumincludeFrameType) == enumFrameTypeCircle ?
            CircleProperties :
            HexProperties
    )
    {
        xDimension = Panels[0];
        yDimension = Panels[1];

        for(x = [0 : 1 : xDimension-1])
        {
            for(y = [0 : 1 : yDimension-1])
            {
                if(getIncludeProperty(Includes, enumincludeFrameType) == enumFrameTypeSquare)
                {
                    echo(frameType = "enumFrameTypeSquare");
                    translate(
                        [
                            x * (frameProperty[enumPropertyFrame].x + frameProperty[enumPropertyFrameBoard].x), 
                            y * (frameProperty[enumPropertyFrame].x + frameProperty[enumPropertyFrameBoard].x), 
                            0
                        ])
                    Square_Frame( frameProperty);               
                }
                
                if(getIncludeProperty(Includes, enumincludeFrameType) == enumFrameTypeCircle)
                {
                    echo(frameType = "enumFrameTypeCircle");
                    translate(
                        [
                            x * (frameProperty[enumPropertyFrame].x + frameProperty[enumPropertyFrameBoard].x), 
                            y * (frameProperty[enumPropertyFrame].x + frameProperty[enumPropertyFrameBoard].x), 
                            0
                        ])
                    Circles( frameProperty);               
                }

                if(getIncludeProperty(Includes, enumincludeFrameType) == enumFrameTypeHex)
                {
                    echo(frameType = "enumFrameTypeHex");
                    translate(
                        [
                            x * (frameProperty[enumPropertyFrame].x + frameProperty[enumPropertyFrameBoard].x), 
                            y * (frameProperty[enumPropertyFrame].x + frameProperty[enumPropertyFrameBoard].x), 
                            0
                        ])
                    HexFrames( frameProperty);               
                }

            }
        }        
    }



}

module Circles
(
    frameProperties
)
{
    // frameRadius = circleProperties[enumPropertyFrame].x;
    // frameBoardDimension = circleProperties[enumPropertyFrameBoard]; 
    // latticeDimension = circleProperties[enumPropertyLattice]; 
    // intervalCount = circleProperties[enumPropertyInterval];
    // includes = circleProperties[enumPropertyInclude]; 
    // screwHoles = circleProperties[enumPropertyScrewHoles];  

    difference()
    {    
        union()
        {
            if(getIncludeProperty(includes, enumincludeFrame))
            {
                echo(frameBoardDimension=frameProperties[enumPropertyFrameBoard]);

                translate([0,0, frameProperties[enumPropertyFrameBoard].y/2])
                CircleFrame
                (
                    frameRadius = frameRadius,
                    frameBoardDimension = frameProperties[enumPropertyFrameBoard],
                    screwHoles = [ScrewHole_OD, ScrewHoleCount]
                );
            }
            if(getIncludeProperty(includes, enumincludeDiamondStyleTrellis))
            {
                // echo(DiagonalLattice = 1);
                translate([-frameRadius, -frameRadius, 0])
                // rotate([90,0,0])
                DiagonalLattice2
                (
                   frameDimension = [width, height],  
                    frameBoardDimension = frameProperties[enumPropertyFrameBoard] , 
                    latticeDimension = latticeDimension,
                    intervalCount = intervalCount
                );
            }
            if(getIncludeProperty(includes, enumincludeSquareLatticeTrellis))
            {
                translate([- frameDimension.x/2,- frameDimension.y/2, 0])
                SquareLatticeTrellis
                (
                    frameDimension = [width, height], 
                    frameBoardDimension = frameProperties[enumPropertyFrameBoard] , 
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
                        frameBoardDimension = frameProperties[enumPropertyFrameBoard] , 
                        latticeDimension = latticeDimension              
                    );
            }
            if(getIncludeProperty(includes, enumincludeHorizontalWaveTrellis))
            {
                WaveTrellis
                (
                    frameProperties = frameProperties,
                    waveDimensions = WaveProperties
                );
            }        

        }

        if(getIncludeProperty(includes, enumincludeBubbles))
        {
            BubblesTrellis
            (
                minframeRadius = hypotenuse(frameDimension.x, frameDimension.y)/10,
                maxframeRadius = hypotenuse(frameDimension.x, frameDimension.y),
                latticeDimension = latticeDimension,
                count = intervalCount,
                seed = Seed
            );
        }

        if(getIncludeProperty(includes, enumincludeMaze))
        {
            MazeLattice
            (
                frameType = enumFrameTypeCircle,
                frameDimension = [width, height],
                frameBoardDimension = FrameBoardDimension,
                latticeDimension = LatticeDimension,
                screwHoles = ScrewHoles,
                showFrame = false
            );
        }

        CircleFrameCutter
        (
                    frameRadius = frameRadius,
                    frameBoardDimension = frameProperties[enumPropertyFrameBoard]
        ) ;       
    }
}

module HexFrames
(
    hexProperties
)
{
    frameRadius = hexProperties[enumPropertyFrame].x;
    frameBoardDimension = hexProperties[enumPropertyFrameBoard]; 
    latticeDimension = hexProperties[enumPropertyLattice]; 
    intervalCount = hexProperties[enumPropertyInterval];
    includes = hexProperties[enumPropertyInclude]; 
    screwHoles = hexProperties[enumPropertyScrewHoles];  

    difference()
    {    
        union()
        {
            if(getIncludeProperty(includes, enumincludeFrame))
            {
                echo(frameBoardDimension=frameBoardDimension);

                translate([0,0, frameBoardDimension.y/2])
                HexFrame
                (
                    frameRadius = frameRadius,
                    frameBoardDimension = frameBoardDimension,
                    screwHoles = [ScrewHole_OD, ScrewHoleCount]
                );
            }
            if(getIncludeProperty(includes, enumincludeDiamondStyleTrellis))
            {
                // echo(DiagonalLattice = 1);
                translate([-frameRadius, -frameRadius, 0])
                // rotate([90,0,0])
                DiagonalLattice2
                (
                   frameDimension = [width, height],  
                    frameBoardDimension = frameBoardDimension , 
                    latticeDimension = latticeDimension,
                    intervalCount = intervalCount
                );
            }
            if(getIncludeProperty(includes, enumincludeSquareLatticeTrellis))
            {
                translate([- frameDimension.x/2,- frameDimension.y/2, 0])
                SquareLatticeTrellis
                (
                    frameDimension = [width, height], 
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

            if(getIncludeProperty(includes, enumincludeBubbles))
            {
                BubblesTrellis
                (
                    minframeRadius = frameRadius/10,
                    maxframeRadius = frameRadius,
                    latticeDimension = latticeDimension,
                    count = intervalCount,
                    seed = Seed
                );
            }

            if(getIncludeProperty(includes, enumincludeMaze))
            {
                MazeLattice
                (
                    frameType = enumFrameTypeHex,
                    frameDimension = [width, height],
                    frameBoardDimension = FrameBoardDimension,
                    latticeDimension = LatticeDimension,
                    screwHoles = ScrewHoles,
                    showFrame = false
                );
            }            
        }

        HexFrameCutter
        (
                    frameRadius = frameRadius,
                    frameBoardDimension = FrameBoardDimension
        ) ;       
    }
}


module Square_Frame(squareProperties) 
{
    frameDimension = squareProperties[enumPropertyFrame]; 
    frameBoardDimension = squareProperties[enumPropertyFrameBoard]; 
    latticeDimension = squareProperties[enumPropertyLattice]; 
    // width = frameWidth;
    // height = frameHeight;
    screwHoles = squareProperties[enumPropertyScrewHoles];     
    intervalCount = squareProperties[enumPropertyInterval];
    includes = squareProperties[enumPropertyInclude]; 

    difference()
    {
        // rotate([90,0,0])
        union()
        {
            if(getIncludeProperty(includes, enumincludeFrame))
            {    
                echo(Panel = "SquareFrame");
                SquareFrame
                (
                    frameDimension = frameDimension,
                    frameBoardDimension = frameBoardDimension,
                    screwHoles = [4, 3]
                );
            }

            if(getIncludeProperty(includes, enumincludeDiamondStyleTrellis))
            {
                translate([-frameDimension.x/2, -frameDimension.y/2,0])
                // rotate([90,0,0])
                DiagonalLattice
                (
                    frameDimension = frameDimension, 
                    frameBoardDimension = frameBoardDimension , 
                    latticeDimension = latticeDimension,
                    intervalCount = intervalCount
                );
            }

            if(getIncludeProperty(includes, enumincludeSquareLatticeTrellis))
            {    
                translate([- frameDimension.x/2,- frameDimension.y/2, 0])
                SquareLatticeTrellis
                (
                    frameDimension = frameDimension, 
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

            if(getIncludeProperty(includes, enumincludeBubbles))
            {
                BubblesTrellis
                (
                    minframeRadius = hypotenuse(squareProperties[enumPropertyFrame].x, squareProperties[enumPropertyFrame].y)/10,
                    maxframeRadius = hypotenuse(squareProperties[enumPropertyFrame].x, squareProperties[enumPropertyFrame].y),
                    latticeDimension = latticeDimension,
                    count = intervalCount * 4,
                    seed = Seed
                );
            }

            if(getIncludeProperty(includes, enumincludeMaze))
            {
                MazeLattice
                (
                    frameType = enumFrameTypeSquare,
                    frameDimension = [width, height],
                    frameBoardDimension = frameBoardDimension,
                    latticeDimension = latticeDimension,
                    screwHoles = screwHoles,
                    showFrame = false
                );
            }            
        }

        SquareFrameCutter(frameDimension = [width, height], frameBoardDimension = frameBoardDimension);
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

