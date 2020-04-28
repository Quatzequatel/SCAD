
//standard
mmPerInch = 25.4;
mmPerFoot = 304.8;

//LatticeStrip
LS_Length = convertFeet2mm(4);

//enum
enumThickness = 0;
enumDepth = 1;

function getDepth(board) = board[enumDepth];
function getThickness(board) = board[enumThickness];


Build();
function convertFeet2mm(feet) = feet * mmPerFoot;
function convertInches2mm(inches) = inches * mmPerInch;

module Build(args) 
{
                            //[0,1] = [enumThickness, enumDepth]
        frameBoardDimension = [convertInches2mm(0.196), convertInches2mm(1)] ; 
        latticeDimension = [convertInches2mm(0.07), convertInches2mm(0.07)];
        width = convertInches2mm(12);
        height = convertInches2mm(12);// + 2*getThickness(frameBoardDimension); 
        intervalCount = 8;
        angle = 45;
    Frame
    (
        width = width, 
        height = height, 
        frameBoardDimension = frameBoardDimension 
    );

    DiamondStyleTrellis
    (
        width = width, 
        height = height, 
        frameBoardDimension = frameBoardDimension , 
        latticeDimension = latticeDimension,
        intervalCount = intervalCount,
        angle = angle
    );

    SquareLatticeTrellis
    (
        width = width, 
        height = height, 
        frameBoardDimension = frameBoardDimension , 
        latticeDimension = latticeDimension,
        intervalCount = intervalCount
    );
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
            color("SlateGray")cube(size=AddZ(latticeDimension, width), center=false);
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
        // translate([ getThickness(frameBoardDimension)/2 + latticeMoveX(width = width, count = intervalCount, i = i), 0, getThickness(frameBoardDimension)/2 + getThickness(latticeDimension) * cos(angle)])
        translate(translateBottom(adjWidth = adjustedWidth, latticeThickness = getThickness(latticeDimension), frameThickness = getThickness(frameBoardDimension), i = i))
        rotate([0, angle, 0])
        {
        // echo(AddZ(latticeDimension, latticeLength(width = width, count = intervalCount, angle = angle,  i = i)));
            color("yellow")cube(size=AddZ(latticeDimension, latticeLength(width = width, count = intervalCount, angle = angle,  i = i)), center=false);
            // color("yellow")cube(size=AddZ(latticeDimension, hypotenuse(IntervalWidth(width = adjustedWidth, count = intervalCount, i = i), angle)), center=false);
        }
    }

    //top
    for(i = [1: (intervalCount - 1)])
    {
        // translate([ latticeMoveX(width = width, count = intervalCount, i = i), getThickness(latticeDimension), height-(getThickness(latticeDimension) + cos(angle) * getThickness(latticeDimension))])
        translate(translateTop(adjWidth = adjustedWidth, latticeThickness = getThickness(latticeDimension), frameThickness = getThickness(frameBoardDimension), i = i))
        rotate([180, -angle, 0])
        {
            color("blue")cube(size=AddZ(latticeDimension, latticeLength(width = width, count = intervalCount, angle = angle,  i = i)), center=false);
        }
    }

    heightIntervals = latticeHeightCount(height, width, intervalCount) ;
    //left
    for(i = [1: heightIntervals])
    {
        /*translate(
            [
                 getThickness(frameBoardDimension)/2, 
                 0, 
                 latticeMoveZ(width = width, count = intervalCount, i = i) + getThickness(frameBoardDimension)/2
            ])*/
        translate(translateLeft( adjWidth = adjustedWidth, latticeThickness = getThickness(latticeDimension), frameThickness = getThickness(frameBoardDimension), i = i))
        rotate([0, angle, 0])
        {
        color("red")cube(size=AddZ(latticeDimension, latticeLength2(height = height, width = width, count = intervalCount, angle = angle,  i = i)), center=false);
        }
    }    
    
    //Right    
    for(i = [heightIntervals : -1 : 0])
    {
        /* translate([ 
            0, 
            getThickness(latticeDimension), 
            (height) - (latticeMoveZ(width = width, count = intervalCount, i = i) + (cos(angle) * getThickness(latticeDimension)))
            ])
        */
        translate(translateRight( adjWidth = adjustedWidth, latticeThickness = getThickness(latticeDimension), frameThickness = getThickness(frameBoardDimension), i = i))
        rotate([180, -angle, 0])
        {
            color("aqua")cube(size=AddZ(latticeDimension, latticeLength2(height = height, width = width, count = intervalCount, angle = angle,  i = i)), center=false);
        }
    }  
    
    function translateTop(adjWidth, latticeThickness, frameThickness, i) = 
    [
        ((adjWidth/intervalCount * i) + frameThickness/2), 
        0, 
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
    // [
    //      getThickness(frameBoardDimension)/2, 
    //      0, 
    //      latticeMoveZ(width = width, count = intervalCount, i = i) + getThickness(frameBoardDimension)/2
    // ]
    function translateLeft(adjWidth, latticeThickness, frameThickness, i) = 
    [
        frameThickness/2, 
        0, 
        height-(frameThickness/2 + latticeThickness * cos(angle))
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

module Frame
    (
        width = convertFeet2mm(4), 
        height = convertFeet2mm(8), 
        frameBoardDimension = [convertInches2mm(1), convertInches2mm(1)]
    )
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