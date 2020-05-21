
include <constants.scad>;
include <TrellisEnums.scad>;
use <vectorHelpers.scad>;
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
// LatticeDimension = setDimension([], depth =WallThickness(count = 2), thickness = layers2Height(8)); 
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
        bubblesTrellis = true,
        mazeTrellis = false
    );

//specific trellis type properties
LatticeProperties = 
[
    "lattice properties",
    [
        ["width", WallThickness(count = 20)],
        ["depth", layers2Height(8)],
        ["height", 0]
    ]
];

TrellisFeatures = 
[
    "trellisfeatures",
    [
        ["hasFrame", true],
        ["diamondstyletrellis", false],
        ["squaretrellis", true],
        ["spiraltrellis", false],
        ["wavetrellis", false],
        ["bubblestrellis", false],
        ["mazetrellis", false],
        ["debug", true]
    ]
];

FrameDimensionProperties = 
    [
        "framedimensionproperties",
        [
            ["frame type", enumFrameTypeSquare],
            ["frame dimension", FrameDimension],
            ["frameboard dimension", FrameBoardDimension],
            ["screw holes", [ScrewHole_OD, 1]],
            ["debug", false]
        ]
    ];
WaveProperties = 
    [
        "wavetrellis", 
        [
            ["width", 10], 
            ["height" , 50], 
            ["length" , 0], 
            LatticeProperties,
            ["type", enumWaveTypeBoth]
        ]
    ];

BubblesTrellisProperties = 
    [
        "bublestrellis", 
        [
            ["minRadius", convert_in2mm(1)],
            ["maxRadius", 175],
            ["circleCount", 18],
            ["Seed", PI],
            LatticeProperties,
            ["debug", true]
        ]
    ];
SquareTrellisProperties = 
    [
        "squaretrellisproperties", 
        [
            ["rows", 3],
            ["columns", 2],
            ["hoz width", 100],
            ["vert width", 75],
            LatticeProperties,
            ["debug", true]
        ]
    ];

//Frame type Properties
SquareProperties = 
[
    // FrameDimension,         //[0] enumPropertyFrame [width (x), depth (y), height (z)]
    // FrameBoardDimension,    //[1] enumPropertyFrameBoard [width (x), depth (y), length (z)] aka 2x4 x|84
    // LatticeDimension,       //[2] enumPropertyLattice  [width (x), depth (y), length (z)] aka 1x2 x|24
    // ScrewHoles,             //[3] enumPropertyScrewHoles [diameter, count], ex [woodScrewShankDiaN_8, 2]
    // [IntervalCount],          //[4] enumPropertyInterval, int, howmany lattice to repeat.
    // Includes,                //[5] enumPropertyInclude. See above setIncludeProperty()
    //[6] enumPropertyTrellisSpecific, this is a data bag. WaveProperty below:
    FrameDimensionProperties,
    // LatticeProperties,
    TrellisFeatures,
    WaveProperties,
    BubblesTrellisProperties,
    SquareTrellisProperties
];

CircleProperties = 
[
    // FrameDimension,         //[0] enumPropertyFrame [width (x), depth (y), height (z)]
    // FrameBoardDimension,    //[1] enumPropertyFrameBoard [width (x), depth (y), length (z)] aka 2x4 x|84
    // LatticeDimension,       //[2] enumPropertyLattice  [width (x), depth (y), length (z)] aka 1x2 x|24
    // ScrewHoles,             //[3] enumPropertyScrewHoles [diameter, count], ex [woodScrewShankDiaN_8, 2]
    // IntervalCount,          //[4] enumPropertyInterval, int, howmany lattice to repeat.
    // Includes,               //[5] enumPropertyInclude.
    BubblesTrellisProperties //[6] enumPropertyTrellisSpecific, this is a data bag. Current example:
                                  //CirclesTrellisData=>[minframeRadius, maxframeRadius, enumCircleCount, enumCircleSeed]
];

HexProperties = 
[
    // FrameDimension,         //[0] enumPropertyFrame [width (x), depth (y), height (z)]
    // FrameBoardDimension,    //[1] enumPropertyFrameBoard [width (x), depth (y), length (z)] aka 2x4 x|84
    // LatticeDimension,       //[2] enumPropertyLattice  [width (x), depth (y), length (z)] aka 1x2 x|24
    // ScrewHoles,             //[3] enumPropertyScrewHoles [diameter, count], ex [woodScrewShankDiaN_8, 2]
    // IntervalCount,          //[4] enumPropertyInterval, int, howmany lattice to repeat.
    // Includes,               //[5] enumPropertyInclude.
    BubblesTrellisProperties //[6] enumPropertyTrellisSpecific, this is a data bag. Current example:
                                  //CirclesTrellisData=>[minframeRadius, maxframeRadius, enumCircleCount, enumCircleSeed]
];

Build(frameProperty = SquareProperties);

module Build(frameProperty)
{
    let
    (
        frameDictionary = getKeyValue(frameProperty, "framedimensionproperties"),
        frameSize = getKeyValue(getKeyValue(frameProperty, "framedimensionproperties"), "frame dimension"),
        frameBoard = getKeyValue(getKeyValue(frameProperty, "framedimensionproperties"), "frameboard dimension"),
        screwHoles = getKeyValue(getKeyValue(frameProperty, "framedimensionproperties"), "screw holes"),
        debugmode = getKeyValue(getKeyValue(frameProperty, "framedimensionproperties"), "debug")
    )
    {
        debugEcho("Build()", frameProperty, debugmode);
        debugEcho("Include values", getIncludes(frameProperty), debugmode);

        debugEcho("frameDictionary", getKeyValue(frameProperty, "framedimensionproperties"), debugmode);
        debugEcho("debug", getKeyValue(getKeyValue(frameProperty, "framedimensionproperties"), "debug"), debugmode);
        debugEcho("frameboard dimension", getKeyValue(getKeyValue(frameProperty, "framedimensionproperties"), "frameboard dimension"), debugmode);

        xDimension = Panels[0];
        yDimension = Panels[1];

        for(x = [0 : 1 : xDimension-1])
        {
            for(y = [0 : 1 : yDimension-1])
            {
                if(getKeyValue(frameDictionary, "frame type") == enumFrameTypeSquare)
                {
                    echo(frameType = "enumFrameTypeSquare");
                    translate(
                        [
                            x * (frameSize.x + frameBoard.x), 
                            y * (frameSize.x + frameBoard.x), 
                            0
                        ])
                    Square_Frame( frameProperty);               
                }
                
                if(getIncludeProperty(Includes, enumincludeFrameType) == enumFrameTypeCircle)
                {
                    echo(frameType = "enumFrameTypeCircle");
                    translate(
                        [
                            x * (frameSize.x + frameBoard.x), 
                            y * (frameSize.x + frameBoard.x), 
                            0
                        ])
                    Circles( frameProperty);               
                }

                if(getIncludeProperty(Includes, enumincludeFrameType) == enumFrameTypeHex)
                {
                    echo(frameType = "enumFrameTypeHex");
                    translate(
                        [
                            x * (frameSize.x + frameBoard.x), 
                            y * (frameSize.x + frameBoard.x), 
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
    let
    (
        frameDictionary = getKeyValue(frameProperties, "framedimensionproperties"),
        frameSize = getKeyValue(getKeyValue(frameProperties, "framedimensionproperties"), "frame dimension"),
        frameBoard = getKeyValue(getKeyValue(frameProperties, "framedimensionproperties"), "frameboard dimension"),
        screwHoles = getKeyValue(getKeyValue(frameProperties, "framedimensionproperties"), "screw holes"),
        featuresDictionary = getKeyValue(getKeyValue(frameProperties, "framedimensionproperties"), "trellisfeatures"),
        debugmode = getKeyValue(getKeyValue(frameProperties, "framedimensionproperties"), "debug")

    )
    {
        difference()
        {    
            union()
            {
                // getKeyValue(featuresDictionary, "hasFrame")
                if(getKeyValue(featuresDictionary, "hasFrame"))
                {
                    echo(frameBoardDimension=frameProperties[enumPropertyFrameBoard]);

                    translate([0,0, frameProperties[enumPropertyFrameBoard].y/2])
                    CircleFrame
                    (
                        frameProperties
                    );
                }
                if(getKeyValue(featuresDictionary, "diamondstyletrellis"))
                {
                    // echo(DiagonalLattice = 1);
                    translate([-frameRadius, -frameRadius, 0])
                    // rotate([90,0,0])
                    DiagonalLattice2
                    (
                    frameProperties
                    );
                }
                if(getKeyValue(featuresDictionary, "squaretrellis"))
                {
                    translate([- frameSize.x/2,- frameSize.y/2, 0])
                    SquareLatticeTrellis
                    (
                        frameProperties
                    );
                }
                if(getKeyValue(featuresDictionary, "spiraltrellis"))
                {
                    translate([0, 0, getThickness(latticeDimension)])
                    // rotate([90,0,0])
                        ArchimedianSpiralTrellis
                        (
                            frameProperties             
                        );
                }
                if(getKeyValue(featuresDictionary, "wavetrellis"))
                {
                    WaveTrellis
                    (
                        frameProperties
                    );
                }        
                if(getKeyValue(featuresDictionary, "bubblestrellis"))
                {
                    BubblesTrellis
                    (
                    frameProperties
                    );
                }
                if(getKeyValue(featuresDictionary, "mazetrellis"))
                {
                    MazeLattice
                    (
                    frameProperties
                    );
                }            
            }

            CircleFrameCutter
            (
                frameProperties
            );       
        }
    }   
}

module HexFrames
(
    frameProperties
)
{
    let
    (
        frameDictionary = getKeyValue(frameProperties, "framedimensionproperties"),
        frameSize = getKeyValue(getKeyValue(frameProperties, "framedimensionproperties"), "frame dimension"),
        frameBoard = getKeyValue(getKeyValue(frameProperties, "framedimensionproperties"), "frameboard dimension"),
        screwHoles = getKeyValue(getKeyValue(frameProperties, "framedimensionproperties"), "screw holes"),
        featuresDictionary = getKeyValue(getKeyValue(frameProperties, "framedimensionproperties"), "trellisfeatures"),
        debugmode = getKeyValue(getKeyValue(frameProperties, "framedimensionproperties"), "debug")

    )
    {
        debugEcho("HexFrames()", [frameRadius,frameBoardDimension,latticeDimension,intervalCount,includes,screwHoles]);

        difference()
        {    
            union()
            {
                if(getKeyValue(featuresDictionary, "hasFrame"))
                {
                    echo(frameBoardDimension=frameBoardDimension);

                    translate([0,0, frameBoardDimension.y/2])
                    HexFrame
                    (
                        frameProperties
                    );
                }
                if(getKeyValue(featuresDictionary, "diamondstyletrellis"))
                {
                    // echo(DiagonalLattice = 1);
                    translate([-frameRadius, -frameRadius, 0])
                    // rotate([90,0,0])
                    DiagonalLattice2
                    (
                    frameProperties
                    );
                }
                if(getKeyValue(featuresDictionary, "squaretrellis"))
                {
                    translate([- frameSize.x/2,- frameSize.y/2, 0])
                    SquareLatticeTrellis
                    (
                        frameProperties
                    );

                }
                if(getKeyValue(featuresDictionary, "spiraltrellis"))
                {
                    translate([0, 0, getThickness(latticeDimension)])
                    // rotate([90,0,0])
                        ArchimedianSpiralTrellis
                        (
                            frameProperties              
                        );
                }
                if(getKeyValue(featuresDictionary, "wavetrellis"))
                {
                    WaveTrellis
                    (
                        frameProperties
                    );
                }   

                if(getKeyValue(featuresDictionary, "bubblestrellis"))
                {
                    BubblesTrellis
                    (
                        frameProperties
                    );
                }

                if(getKeyValue(featuresDictionary, "mazetrellis"))
                {
                    MazeLattice
                    (
                        frameProperties
                    );
                }            
            }

            HexFrameCutter
            (
                frameProperties
            ) ;       
        }
    } 
}

module Square_Frame(frameProperties) 
{
    let
    (
        frameDictionary = getKeyValue(frameProperties, "framedimensionproperties"),
        frameSize = getKeyValue(getKeyValue(frameProperties, "framedimensionproperties"), "frame dimension"),
        frameBoard = getKeyValue(getKeyValue(frameProperties, "framedimensionproperties"), "frameboard dimension"),
        screwHoles = getKeyValue(getKeyValue(frameProperties, "framedimensionproperties"), "screw holes"),
        featuresDictionary = getKeyValue(frameProperties, "trellisfeatures"),
        debugmode = getKeyValue(getKeyValue(frameProperties, "framedimensionproperties"), "debug")
    )
    {
        debugEcho("Square_Frame.let.frameDictionary", frameDictionary, debugmode);
        debugEcho("Square_Frame.let.frameSize", frameSize, debugmode);
        debugEcho("Square_Frame.let.frameBoard", frameBoard, debugmode);
        debugEcho("Square_Frame.let.screwHoles", screwHoles, debugmode);
        debugEcho("Square_Frame.let.featuresDictionary", featuresDictionary, debugmode);
        echo(featuresDictionary = featuresDictionary);

        difference()
        {
            // rotate([90,0,0])
            union()
            {
                if(getKeyValue(featuresDictionary, "hasFrame"))
                {    
                    echo(Panel = "Square_Frame : enumincludeFrame");
                    SquareFrame
                    (
                        frameProperties = frameProperties
                    );
                }

                if(getKeyValue(featuresDictionary, "diamondstyletrellis"))
                {
                    echo(Panel = "Square_Frame : enumincludeDiamondStyleTrellis");
                    translate([-frameSize.x/2, -frameSize.y/2,0])
                    // rotate([90,0,0])
                    DiagonalLattice
                    (
                        frameProperties
                    );
                }

                // if(getIncludes( frameProperties, enumincludeSquareLatticeTrellis))
                // debugEcho(lable = "Include:SquareLatticeTrellis", args = getIncludes(frameProperties)[enumincludeSquareLatticeTrellis]);
                if(getKeyValue(featuresDictionary, "squaretrellis"))
                {    
                    debugEcho("Panel: Square_Frame", "enumincludeSquareLatticeTrellis");
                    translate([- frameSize.x/2,- frameSize.y/2, 0])
                    SquareLatticeTrellis
                    (
                        frameProperties
                    );
                }

                if(getKeyValue(featuresDictionary, "spiraltrellis"))
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

                if(getKeyValue(featuresDictionary, "wavetrellis"))
                {
                    debugEcho("Panel: Square_Frame", "enumincludeHorizontalWaveTrellis");
                    WaveTrellis
                    (
                        frameProperties = frameProperties
                    );
                }

                if(getKeyValue(featuresDictionary, "bubblestrellis"))
                {
                    debugEcho("Panel: Square_Frame", "enumincludeBubbles");
                    DrawBubbles
                    (
                        frameProperties = frameProperties
                    );
                }

                if(getKeyValue(featuresDictionary, "mazetrellis"))
                {
                    debugEcho("Panel: Square_Frame", "enumincludeMaze");
                    // MazeLattice
                    // (
                    //     frameProperties = frameProperties
                    // );
                }            
            }

            SquareFrameCutter(frameProperties = frameProperties);
        }
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

