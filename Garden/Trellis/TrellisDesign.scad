/*
    Create panels for Trellis
*/

//standard
$fn = 100;
NozzleWidth = 1.0;
LayerHeight = 0.24;
InitialLayerHeight = 0.4;
mmPerInch = 25.4;
mmPerFoot = 304.8;

//LatticeStrip
LS_Length = convertFeet2mm(4);

//screwholes
ScrewHoleRadius = 2;
ScrewHoleCount = 2;

//enum
enumThickness = 0;
enumDepth = 1;

enumScrewRadius = 0;
enumScrewCount = 1;

function getDepth(board) = board[enumDepth];
function getThickness(board) = board[enumThickness];

function convertFeet2mm(feet) = feet * mmPerFoot;
function convertInches2mm(inches) = inches * mmPerInch;
function WallThickness(count) = count * NozzleWidth;

function height2layers(mm = 1) = mm/LayerHeight;
function layers2Height(layers) = InitialLayerHeight + ((layers - 1) * LayerHeight);

includeFrame = true;
includeDiamondStyleTrellis = false;
includeSquareLatticeTrellis = true;
Panels = [1 : 1];

Build();


module Build()
{
    //[0,1] = [enumThickness, enumDepth]
    frameBoardDimension = [WallThickness(count = 4), convertInches2mm(0.5)] ; 
    latticeDimension = [WallThickness(2), layers2Height(8)];
    width = convertInches2mm(12) - getThickness(frameBoardDimension);
    height = convertInches2mm(12)  - getThickness(frameBoardDimension);// + 2*getThickness(frameBoardDimension); 
    intervalCount = 4;
    angle = 45;

    xDimension = Panels[0];
    yDimension = Panels[1];

    for(x = [0 : xDimension-1])
    {
        for(y = [0 : yDimension-1])
        {
            translate([x * (width + getThickness(frameBoardDimension)), y * (height + getThickness(frameBoardDimension)), 0])
            Panel(
                frameBoardDimension = frameBoardDimension ,
                latticeDimension = latticeDimension,
                width = width,
                height = height,
                intervalCount = intervalCount,
                angle = angle       
            );
        }
    }

}

module Panel
(
        frameBoardDimension = [0,0] ,
        latticeDimension = [0,0],
        width = 0,
        height = 0,
        intervalCount = 8,
        angle = 45
) 
{
        //[0,1] = [enumThickness, enumDepth]
        // frameBoardDimension = [WallThickness(count = 4), convertInches2mm(1)] ; 
        // latticeDimension = [convertInches2mm(0.07), convertInches2mm(0.07)];
        // width = convertInches2mm(12) - getThickness(frameBoardDimension);
        // height = convertInches2mm(12)  - getThickness(frameBoardDimension);// + 2*getThickness(frameBoardDimension); 
        // intervalCount = 8;
        // angle = 45;

    rotate([90,0,0])
    union()
    {
        if(includeFrame)
        {    
            Frame
            (
                width = width, 
                height = height, 
                frameBoardDimension = frameBoardDimension,
                screwHoles = [3, 3]
            );
        }

        if(includeDiamondStyleTrellis)
        {
            DiamondStyleTrellis
            (
                width = width, 
                height = height, 
                frameBoardDimension = frameBoardDimension , 
                latticeDimension = latticeDimension,
                intervalCount = intervalCount,
                angle = angle
            );
        }

        if(includeSquareLatticeTrellis)
        {    
            SquareLatticeTrellis
            (
                width = width, 
                height = height, 
                frameBoardDimension = frameBoardDimension , 
                latticeDimension = latticeDimension,
                intervalCount = intervalCount
            );
        }
    }

}

module Frame
    (
        width = convertFeet2mm(4), 
        height = convertFeet2mm(8), 
        frameBoardDimension = [convertInches2mm(1), convertInches2mm(1)],
        screwHoles = [ScrewHoleRadius, ScrewHoleCount]
    )
{
    difference()
    {
        union()
        {    
            //Top
            translate([ getThickness(frameBoardDimension), 0, height + getThickness(frameBoardDimension) ])
            rotate([0, 90, 0])
            color("DeepSkyBlue") cube(AddZ(frameBoardDimension, width));
            //Bottom
            translate([ 0, 0, getThickness(frameBoardDimension) ])
            rotate([0, 90, 0])
            color("DeepSkyBlue") cube(AddZ(frameBoardDimension, width));
            //Left
            translate([ 0, 0, getThickness(frameBoardDimension) ])
            rotate([0, 0, 0])
            color("Lime") cube(AddZ(frameBoardDimension, height));    
            //Right
            translate([ width, 0, 0 ])
            rotate([0, 0, 0])
            color("Lime") cube(AddZ(frameBoardDimension, height));
        }   

        if (len(screwHoles) != undef) 
        {
            incrementHoz = height / (screwHoles[enumScrewCount] + 1);
            // echo(getActualHeight = getActualHeight(), enumScrewCount  = screwHoles[enumScrewCount], increment = increment);
            for(i = [1 : screwHoles[enumScrewCount]])
            {
                translate([getActualWidth()/2, getDepth(frameBoardDimension)/2, i * incrementHoz])
                rotate([0,90,0])
                cylinder(r=screwHoles[enumScrewRadius], h= getActualWidth() + getDepth(frameBoardDimension), center=true);
            }

            incrementVert = width / (screwHoles[enumScrewCount] + 1);
            // echo(getActualHeight = getActualHeight(), enumScrewCount  = screwHoles[enumScrewCount], increment = increment);
            for(i = [1 : screwHoles[enumScrewCount]])
            {
                translate([i * incrementVert, getDepth(frameBoardDimension)/2, getActualWidth()/2, ])
                rotate([0,0,90])
                cylinder(r=screwHoles[enumScrewRadius], h= getActualWidth() + getDepth(frameBoardDimension), center=true);
            }
        }        
    }

    function getActualWidth() = width + getThickness(frameBoardDimension);
    function getActualHeight() = height + getThickness(frameBoardDimension);

}

module SquareLatticeTrellis
    (
        width = convertFeet2mm(4), 
        height = convertFeet2mm(8), 
        frameBoardDimension = [convertInches2mm(1), convertInches2mm(1)] , 
        latticeDimension = [convertInches2mm(0.5), convertInches2mm(0.5)],
        intervalCount = 4,
    )
    {
        intervalWidth = (width - getThickness(frameBoardDimension))/ (intervalCount);
        echo(intervalWidth = intervalWidth);
        //vertical
        for(i = [1 : intervalCount-1])
        {
            echo(verticalWidth = i * intervalWidth)
            translate([ getThickness(frameBoardDimension) + i * intervalWidth, 0, getThickness(frameBoardDimension)/2])
            color("AntiqueWhite")cube(size=AddZ(latticeDimension, height), center=false);
        }
        //horizontal
        for(i = [1 : (height/intervalWidth -1)])
        {
            echo(horizontalWidth = i * intervalWidth)
            translate([ getThickness(frameBoardDimension)/2, 0,  getThickness(frameBoardDimension) + i * intervalWidth])
            rotate([0, 90, 0])
            color("AntiqueWhite")cube(size=AddZ(latticeDimension, width), center=false);
        }
    }

module DiamondStyleTrellis
    (
        width = convertFeet2mm(4), 
        height = convertFeet2mm(4), 
        frameBoardDimension = [convertInches2mm(1), convertInches2mm(1)] , 
        latticeDimension = [convertInches2mm(0.5), convertInches2mm(0.5)],
        intervalCount = 4,
        angle = 45
    )
{
    echo(width = width, height = height, frameBoardDimension = frameBoardDimension, latticeDimension = latticeDimension);
    // adjustedHeight = height - 2*getThickness(frameBoardDimension);
    adjustedWidth = width - getThickness(frameBoardDimension);
    // intervalWidthH = adjustedWidth/ (intervalCount);
    // intervalWidthV = adjustedHeight/intervalWidthH;

    //bottom
    for(i = [0: (intervalCount - 1)])
    {
        translate(translateBottom(adjWidth = adjustedWidth, latticeThickness = getDepth(latticeDimension), frameThickness = getThickness(frameBoardDimension), i = i))
        rotate([0, angle, 0])
        {
            color("red")cube(size=AddZ(latticeDimension, latticeLength(width = width, count = intervalCount, angle = angle,  i = i)), center=false);
        }
    }

    //top
    for(i = [1: (intervalCount - 1)])
    {
        translate(translateTop(adjWidth = adjustedWidth, latticeThickness = getDepth(latticeDimension), frameThickness = getThickness(frameBoardDimension), i = i))
        rotate([180, -angle, 0])
        {
            color("yellow")cube(size=AddZ(latticeDimension, latticeLength(width = width, count = intervalCount, angle = angle,  i = i)), center=false);
        }
    }

    heightIntervals = latticeHeightCount(height, width, intervalCount) ;
    //left
    for(i = [1: heightIntervals])
    {
        translate(translateLeft( adjWidth = adjustedWidth, latticeThickness = getDepth(latticeDimension), frameThickness = getThickness(frameBoardDimension), i = i))
        rotate([0, angle, 0])
        {
        color("red")cube(size=AddZ(latticeDimension, latticeLength2(height = height, width = width, count = intervalCount, angle = angle,  i = i)), center=false);
        }
    }    
    
    //Right    
    for(i = [heightIntervals : -1 : 0])
    {
        translate(translateRight( adjWidth = adjustedWidth, latticeThickness = getDepth(latticeDimension), frameThickness = getThickness(frameBoardDimension), i = i))
        rotate([180, -angle, 0])
        {
            color("yellow")cube(size=AddZ(latticeDimension, latticeLength2(height = height, width = width, count = intervalCount, angle = angle,  i = i)), center=false);
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

function latticeLength(width, count, angle,  i) = (1/cos(angle) * IntervalWidth(width, count, i));
function IntervalWidth(width, count, i) = width - (width/count * i);
function hypotenuse(width, angle) = sqrt(pow(cos(angle) * width, 2) + (pow(sin(angle) * width,2)));

function latticeLength2(height, width, count, angle,  i) = 
    (1/cos(angle) * (height - (width/ count) * i)) < (1/cos(angle) * width) 
    ? 
        (1/cos(angle) * (height - (width / count) * i)) 
    : 
        (1/cos(angle) * width);
// function latticeMoveX(width, count, i) = (width/ count * i);
function latticeMoveZ(width, count, i) = latticeIntervalWidth(width, count) * i;
function latticeIntervalWidth(frameThickness, intervalCount ) = frameThickness/intervalCount;
function latticeHeightCount(frameHeight, frameThickness, intervalCount) = frameHeight /latticeIntervalWidth(frameThickness, intervalCount );

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

//vector functions
//append a z value to an [x,y] vector.
function AddZ(v, zValue) = 
[
    for(i = [0 : len(v)]) (i == len(v) ? zValue : v[i])
];