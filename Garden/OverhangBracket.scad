/*
 U-Bracket to connect to roof fascia.
 square tube to connect to latticeStrip.
 TODO: improve variable names.
*/
$fn=100;
NozzleWidth = 1.0;
LayerHeight = 0.24;
InitialLayerHeight = 0.4;
mmPerInch = 25.4;
wallCount = 2;

iThickness = 28;
iDepth = 35;
wallDepth = WallThickness(wallCount);

function InchTomm(inches = 1) = inches * mmPerInch;
function height2layers(mm = 1) = mm/LayerHeight;
function layers2Height(layers) = InitialLayerHeight + ((layers - 1) * LayerHeight);
function BaseHeight() = layers2Height(6);
function WallThickness(count) = count * NozzleWidth;

aInnerDimension = [iThickness, iDepth + 4 * wallDepth, iThickness];
aOuterDimension = [iThickness + (2 * wallDepth), iDepth + (2 * wallDepth), iDepth];

aOuterTubeDimension = [iThickness, iDepth, iThickness];
aInnerTubeDimension = vAddToAxis(vAdd(aOuterTubeDimension, - 2 * wallDepth), 1, 10);

Build();

module Build(args) 
{
    // echo(halfDiff(aOuterDimension[0], aOuterTubeDimension[2]));
    U_Connect(vInner = aInnerDimension, vOuter = aOuterDimension, length =  iThickness);
    translate([-halfDiff(iThickness, iThickness + (2 * wallDepth)), halfDiff(aOuterDimension[2], aOuterTubeDimension[2]) + 2 ,aOuterDimension[2]-wallDepth])
    translate([aOuterTubeDimension[0]/2, aOuterTubeDimension[2]/2, aOuterTubeDimension[1]/2])
    rotate([90,0,0])
    mTube(vOuter = aOuterTubeDimension, vInner = aInnerTubeDimension,  radius = 2, center = true);

}

module U_Connect(vInner = aInnerDimension, vOuter = aOuterDimension, length =  iThickness, radius = 3)
{
    translate([radius,radius,radius])
    difference()
    {
        mCube(dimensions = vOuter, radius = radius, center = false);
        translate([wallDepth, - wallDepth, -radius]) 
        mCube(dimensions = vInner, radius = radius, center = false);
    }
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

function diff(i, j) = i - j;
function halfDiff(i, j) = diff(i, j) / 2;
function vHalfDiff(v1, v2) = 
[
    for (i = [ 0 : len(v1) - 1 ] ) halfDiff( v1[i], v2[i]) 
];

//append a z value to an [x,y] vector.
function AddZ(v, zValue) = 
[
    for(i = [0 : len(v)]) (i == len(v) ? zValue : v[i])
];

//add value to every element of v.
function vAdd(v, value) = 
[
    for(i = [0 : (len(v) -1) ])
        v[i] + value
];

function vHalf(v) = 
[
    for(i = [0 : len(v) - 1])
        v[i]/2
];

function vAddToAxis(v, axis, value) =
[
    for(i = [0 : len(v)-1]) (i == axis ? v[i] + value : v[i])
];
