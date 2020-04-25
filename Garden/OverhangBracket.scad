/*
U-Bracket
*/
$fn=24;
NozzleWidth = 1.0;
LayerHeight = 0.24;
InitialLayerHeight = 0.4;
mmPerInch = 25.4;
wallCount = 2;

iThickness = 28;
iDepth = 45;
wallDepth = WallThickness(wallCount);

function InchTomm(inches = 1) = inches * mmPerInch;
function height2layers(mm = 1) = mm/LayerHeight;
function layers2Height(layers) = InitialLayerHeight + ((layers - 1) * LayerHeight);
function BaseHeight() = layers2Height(6);
function WallThickness(count) = count * NozzleWidth;

aInnerDimension = [iThickness, 2*iDepth, iThickness];
aOuterDimension = [iThickness + (2 * wallDepth), iDepth + (2 * wallDepth), iDepth];

Build();

module Build(args) 
{
    U_Bracket(vInner = aInnerDimension, vOuter = aOuterDimension, length =  iThickness);
}

module U_Bracket(vInner = aInnerDimension, vOuter = aOuterDimension, length =  iThickness)
{
    // linear_extrude(height = length + 2 * wallDepth)
    {
        echo(vInner = AddZ(vInner, length), vOuter = AddZ(vOuter, length));
        difference()
        {
            %minkowski() 
            {
                cube(vOuter, center=false);
                sphere(r=1);
            }
            
            translate([wallDepth, 2*wallDepth + 1, 0]) 
            #cube(vInner, center=false);
        }
    }

    // translate([0, 0, wallDepth]) 
    // rotate([90, 0, 0]) 
    // squareTube(vInner = [iThickness, iThickness], vOuter = [iThickness + 2 * wallDepth, iThickness + 2 * wallDepth], length = iDepth);

}

module squareTube(vInner = [iThickness, iThickness], vOuter = [iThickness + 2 * wallDepth, iThickness + 2 * wallDepth], length = iDepth)
{
    linear_extrude(height = length)
    difference()
    {
        square(size=vOuter, center=false);
        translate([wallDepth, wallDepth, 0]) 
        square(size=vInner, center=false);
    }
}

function diff(i, j) = i - j;
function halfDiff(i, j) = diff(i, j) / 2;
function vHalfDiff(v1, v2) = 
[
    for (i=[0:len(v1-1)]) [halfDiff(v1[i], v2[i])]    
];
function AddZ(v, zValue) = 
[
    for(i = [0 : len(v)-1]) [v[i][0], v[i][1], zValue]
];
