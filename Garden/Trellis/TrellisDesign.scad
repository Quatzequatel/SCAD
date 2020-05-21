
include <constants.scad>;
include <TrellisEnums.scad>;
use <convert.scad>;
use <TrellisFunctions.scad>;
use <polyline2d.scad>;
use <Frame.scad>;
use <SquareLatticeTrellis.scad>;
use <DiagonalTrellis.scad>;
use <WaveTrellis.scad>;
use <MazeLattice.scad>;
use <TrigHelpers.scad>;
use <convert.scad>;
use <.\\lattice.scad>;
use <..\\..\\..\\libraries\\SpiralShapes.scad>;
use <vectorHelpers.scad>;
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

// function getIncludeProperty(includes, enum) = includes[enum];
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
IntervalCount = [3,3];    
Includes = setIncludeProperty
    ([], 
        frame = true, 
        diamondStyleTrellis = false, 
        squareTrellis = true, 
        spiralTrellis = false, 
        waveTrellis = false,
        frameType = enumFrameTypeSquare,
        bubblesTrellis = false,
        mazeTrellis = false
    );
//specific trellis type properties
WaveProperties = ["wavetrellis", setWaveProperty(wave = [], width = 10, height = 50, length = 0, type = enumWaveTypeBoth)];
                            //[minframeRadius, maxframeRadius, enumCircleCount, enumCircleSeed]
BubblesTrellisProperties = ["bublestrellis", [convert_in2mm(1),175, 5, PI]];

//Frame type Properties
SquareProperties = 
[
    FrameDimension,         //[0] enumPropertyFrame [width (x), depth (y), height (z)]
    FrameBoardDimension,    //[1] enumPropertyFrameBoard [width (x), depth (y), length (z)] aka 2x4 x|84
    LatticeDimension,       //[2] enumPropertyLattice  [width (x), depth (y), length (z)] aka 1x2 x|24
    ScrewHoles,             //[3] enumPropertyScrewHoles [diameter, count], ex [woodScrewShankDiaN_8, 2]
    [IntervalCount],          //[4] enumPropertyInterval, int, howmany lattice to repeat.
    Includes,                //[5] enumPropertyInclude. See above setIncludeProperty()
    //[6] enumPropertyTrellisSpecific, this is a data bag. WaveProperty below:
    WaveProperties 
];

CircleProperties = 
[
    FrameDimension,         //[0] enumPropertyFrame [width (x), depth (y), height (z)]
    FrameBoardDimension,    //[1] enumPropertyFrameBoard [width (x), depth (y), length (z)] aka 2x4 x|84
    LatticeDimension,       //[2] enumPropertyLattice  [width (x), depth (y), length (z)] aka 1x2 x|24
    ScrewHoles,             //[3] enumPropertyScrewHoles [diameter, count], ex [woodScrewShankDiaN_8, 2]
    IntervalCount,          //[4] enumPropertyInterval, int, howmany lattice to repeat.
    Includes,               //[5] enumPropertyInclude.
    BubblesTrellisProperties //[6] enumPropertyTrellisSpecific, this is a data bag. Current example:
                                  //CirclesTrellisData=>[minframeRadius, maxframeRadius, enumCircleCount, enumCircleSeed]
];

HexProperties = 
[
    FrameDimension,         //[0] enumPropertyFrame [width (x), depth (y), height (z)]
    FrameBoardDimension,    //[1] enumPropertyFrameBoard [width (x), depth (y), length (z)] aka 2x4 x|84
    LatticeDimension,       //[2] enumPropertyLattice  [width (x), depth (y), length (z)] aka 1x2 x|24
    ScrewHoles,             //[3] enumPropertyScrewHoles [diameter, count], ex [woodScrewShankDiaN_8, 2]
    IntervalCount,          //[4] enumPropertyInterval, int, howmany lattice to repeat.
    Includes,               //[5] enumPropertyInclude.
    BubblesTrellisProperties //[6] enumPropertyTrellisSpecific, this is a data bag. Current example:
                                  //CirclesTrellisData=>[minframeRadius, maxframeRadius, enumCircleCount, enumCircleSeed]
];

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
        debugEcho("Build()", frameProperty);
        debugEcho("Include values", getIncludes(frameProperty));
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
                            x * (getFrameProperty(frameProperty).x + getFrameBoardDimension(frameProperty).x), 
                            y * (getFrameProperty(frameProperty).x + getFrameBoardDimension(frameProperty).x), 
                            0
                        ])
                    Square_Frame( frameProperty);               
                }
                
                if(getIncludeProperty(Includes, enumincludeFrameType) == enumFrameTypeCircle)
                {
                    echo(frameType = "enumFrameTypeCircle");
                    translate(
                        [
                            x * (getFrameProperty(frameProperty).x + getFrameBoardDimension(frameProperty).x), 
                            y * (getFrameProperty(frameProperty).x + getFrameBoardDimension(frameProperty).x), 
                            0
                        ])
                    Circles( frameProperty);               
                }

                if(getIncludeProperty(Includes, enumincludeFrameType) == enumFrameTypeHex)
                {
                    echo(frameType = "enumFrameTypeHex");
                    translate(
                        [
                            x * (getFrameProperty(frameProperty).x + getFrameBoardDimension(frameProperty).x), 
                            y * (getFrameProperty(frameProperty).x + getFrameBoardDimension(frameProperty).x), 
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
    difference()
    {    
        union()
        {
            if(getIncludesPropertyValue( frameProperties, enumincludeFrame))
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
            if(getIncludesPropertyValue( frameProperties, enumincludeDiamondStyleTrellis))
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
            if(getIncludesPropertyValue( frameProperties, enumincludeSquareLatticeTrellis))
            {
                translate([- frameProperties[enumPropertyFrame].x/2,- frameProperties[enumPropertyFrame].y/2, 0])
                SquareLatticeTrellis
                (
                    frameDimension = [width, height], 
                    frameBoardDimension = frameProperties[enumPropertyFrameBoard] , 
                    latticeDimension = latticeDimension,
                    intervalCount = intervalCount
                );
            }
            if(getIncludesPropertyValue( frameProperties, enumincludeArchimedianSpiral))
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
            if(getIncludesPropertyValue( frameProperties, enumincludeHorizontalWaveTrellis))
            {
                WaveTrellis
                (
                    frameProperties = frameProperties,
                    waveDimensions = WaveProperties
                );
            }        
        }

        if(getIncludesPropertyValue( frameProperties, enumincludeBubbles))
        {
            BubblesTrellis
            (
                minframeRadius = hypotenuse(frameProperties[enumPropertyFrame].x, frameProperties[enumPropertyFrame].y)/10,
                maxframeRadius = hypotenuse(frameProperties[enumPropertyFrame].x, frameProperties[enumPropertyFrame].y),
                latticeDimension = latticeDimension,
                count = intervalCount,
                seed = Seed
            );
        }

        if(getIncludesPropertyValue( frameProperties, enumincludeMaze))
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
            if(getIncludesPropertyValue( frameProperties, enumincludeFrame))
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
            if(getIncludesPropertyValue( frameProperties, enumincludeDiamondStyleTrellis))
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
            if(getIncludesPropertyValue( frameProperties, enumincludeSquareLatticeTrellis))
            {
                translate([- frameProperties[enumPropertyFrame].x/2,- frameProperties[enumPropertyFrame].y/2, 0])
                SquareLatticeTrellis
                (
                    frameDimension = [width, height], 
                    frameBoardDimension = frameBoardDimension , 
                    latticeDimension = latticeDimension,
                    intervalCount = intervalCount
                );

            }
            if(getIncludesPropertyValue( frameProperties, enumincludeArchimedianSpiral))
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
            if(getIncludesPropertyValue( frameProperties, enumincludeHorizontalWaveTrellis))
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

            if(getIncludesPropertyValue( frameProperties, enumincludeBubbles))
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

            if(getIncludesPropertyValue( frameProperties, enumincludeMaze))
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

module Square_Frame(frameProperties) 
{
    difference()
    {
        // rotate([90,0,0])
        union()
        {
            if(getIncludes(frameProperties)[enumincludeFrame])
            {    
                echo(Panel = "Square_Frame : enumincludeFrame");
                SquareFrame
                (
                    frameProperties = frameProperties
                );
            }

            if(getIncludes(frameProperties)[enumincludeDiamondStyleTrellis])
            {
                echo(Panel = "Square_Frame : enumincludeDiamondStyleTrellis");
                translate([-frameProperties[enumPropertyFrame].x/2, -frameProperties[enumPropertyFrame].y/2,0])
                // rotate([90,0,0])
                DiagonalLattice
                (
                    frameDimension = frameProperties[enumPropertyFrame], 
                    frameBoardDimension = frameBoardDimension , 
                    latticeDimension = latticeDimension,
                    intervalCount = intervalCount
                );
            }

            // if(getIncludes( frameProperties, enumincludeSquareLatticeTrellis))
            // debugEcho(lable = "Include:SquareLatticeTrellis", args = getIncludes(frameProperties)[enumincludeSquareLatticeTrellis]);
            if(getIncludes(frameProperties)[enumincludeSquareLatticeTrellis])
            {    
                debugEcho("Panel: Square_Frame", "enumincludeSquareLatticeTrellis");
                translate([- frameProperties[enumPropertyFrame].x/2,- frameProperties[enumPropertyFrame].y/2, 0])
                SquareLatticeTrellis
                (
                    frameProperties
                );
            }

            if(getIncludesPropertyValue( frameProperties, enumincludeFrame) && getIncludesPropertyValue( frameProperties, enumincludeArchimedianSpiral))
            {
                debugEcho("Panel: Square_Frame", "enumincludeArchimedianSpiral");
                difference()
                {
                    translate([ 0, 0, latticeDimension.y])
                    if(getIncludesPropertyValue( frameProperties, enumincludeArchimedianSpiral))
                    {
                        ArchimedianSpiralTrellis
                        (
                            frameProperties              
                        );
                    }            
                }
            }

            if(getIncludesPropertyValue( frameProperties, enumincludeHorizontalWaveTrellis))
            {
                debugEcho("Panel: Square_Frame", "enumincludeHorizontalWaveTrellis");
                WaveTrellis
                (
                    frameProperties = frameProperties
                );
            }

            if(getIncludesPropertyValue( frameProperties, enumincludeBubbles))
            {
                debugEcho("Panel: Square_Frame", "enumincludeBubbles");
                BubblesTrellis
                (
                    frameProperties = frameProperties
                );
            }

            if(getIncludesPropertyValue( frameProperties, enumincludeMaze))
            {
                debugEcho("Panel: Square_Frame", "enumincludeMaze");
                MazeLattice
                (
                    frameProperties = frameProperties
                );
            }            
        }

        SquareFrameCutter(frameProperties = frameProperties);
    }
}



module ArchimedianSpiralTrellis
(
        frameProperties
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

