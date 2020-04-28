
//standard
mmPerInch = 25.4;
mmPerFoot = 304.8;

//LatticeStrip
LS_Length = convertFeet2mm(4);



Build();
function convertFeet2mm(feet) = feet * mmPerFoot;
function convertInches2mm(inches) = inches * mmPerInch;

module Build(args) 
{
        width = convertFeet2mm(4);
        height = convertFeet2mm(8); 
        frameBoardDimension = [convertInches2mm(1), convertInches2mm(1)] ; 
        latticeDimension = [convertInches2mm(0.5), convertInches2mm(0.5)];
        intervalCount = 4;
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
        intervalWidth = width/ (intervalCount);
        //horizontal
        for(i = [0 : intervalCount-1])
        {
            // echo(intervalWidth = i * intervalWidth)
            translate([ i * intervalWidth, 0, 0])
            cube(size=AddZ(latticeDimension, height), center=false);
        }
        //vertical
        for(i = [0 : height/intervalWidth])
        {
            echo(intervalWidth = i * intervalWidth)
            translate([ 0, 0, i * intervalWidth])
            #cube(size=AddZ(latticeDimension, height), center=false);
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
    intervalWidth = width/ (intervalCount);

    //bottom
    for(i = [0: (intervalCount - 1)])
    {
        translate([ latticeMoveX(width = width, count = intervalCount, i = i), 0, latticeDimension[1] * cos(angle)])
        rotate([0, angle, 0])
        {
        // echo(AddZ(latticeDimension, latticeLength(width = width, count = intervalCount, angle = angle,  i = i)));
            cube(size=AddZ(latticeDimension, latticeLength(width = width, count = intervalCount, angle = angle,  i = i)), center=false);
        }
    }

    //top
    for(i = [1: (intervalCount - 1)])
    {
        translate([ latticeMoveX(width = width, count = intervalCount, i = i), latticeDimension[1], height-(latticeDimension[1] * cos(angle))])
        rotate([180, -angle, 0])
        {
            cube(size=AddZ(latticeDimension, latticeLength(width = width, count = intervalCount, angle = angle,  i = i)), center=false);
        }
    }

    // if(height == width)
    {    //left
        for(i = [1: latticeHeightCount(height, width, intervalCount)])
        {
            translate([ 0, 0, latticeMoveZ(width = width, count = intervalCount, i = i)])
            rotate([0, angle, 0])
            {
            cube(size=AddZ(latticeDimension, latticeLength2(height = height, width = width, count = intervalCount, angle = angle,  i = i)), center=false);
            }
        }    
        
        //Right
        heightIntervals = latticeHeightCount(height, width, intervalCount) ;
        for(i = [heightIntervals : -1 : 0])
        {
            translate([ 0, latticeDimension[1], (height) - latticeMoveZ(width = width, count = intervalCount, i = i)])
            rotate([180, -angle, 0])
            {
            cube(size=AddZ(latticeDimension, latticeLength2(height = height, width = width, count = intervalCount, angle = angle,  i = i)), center=false);
            }
        }  
    }
}

function latticeLength(width, count, angle,  i) = (1/cos(angle) * (width - (width/ count) * i));

function latticeLength2(height, width, count, angle,  i) = 
    (1/cos(angle) * (height - (width/ count) * i)) < (1/cos(angle) * width) 
    ? 
        (1/cos(angle) * (height - (width / count) * i)) 
    : 
        (1/cos(angle) * width);
function latticeMoveX(width, count, i) = (width/ count * i);
function latticeMoveZ(width, count, i) = latticeIntervalWidth(width, count) * i;
function latticeIntervalWidth(frameWidth, intervalCount ) = frameWidth/intervalCount;
function latticeHeightCount(frameHeight, frameWidth, intervalCount) = frameHeight /latticeIntervalWidth(frameWidth, intervalCount );

module Frame
    (
        width = convertFeet2mm(4), 
        height = convertFeet2mm(8), 
        frameBoardDimension = [convertInches2mm(1), convertInches2mm(1)]
    )
{
    //Top
    translate([ 0, 0, height ])
    rotate([0, 90, 0])
    cube(AddZ(frameBoardDimension, width));
    //Bottom
    translate([ 0, 0, frameBoardDimension[0] ])
    rotate([0, 90, 0])
    cube(AddZ(frameBoardDimension, width));
    //Left
    // translate([ 0, 0, frameBoardDimension[0] ])
    rotate([0, 0, 0])
    cube(AddZ(frameBoardDimension, height));    
    //Right
    translate([ width, 0, 0 ])
    rotate([0, 0, 0])
    cube(AddZ(frameBoardDimension, height));   
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