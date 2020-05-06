/*
functions for trellis
*/

include <TrellisEnums.scad>;
include <constants.scad>;
use <vectorHelpers.scad>;


function getDepth(board) = board.x;
function getThickness(board) = board.y;
function setDimension(board, depth, thickness) = 
[
    depth == undef ? board.x : depth, 
    thickness == undef ? board.y : thickness     
];

function getVectorValue(vector, enum) = vector[enum];
function setVectorValue(vector, enum, value) = 
[
    for(i = [0: 1 : len(v)-1])  i == enum ? value : v[i]
];

function getWaveProperty(wave, enum) = wave[enum];
function setWaveProperty(wave, width, height, length, type) =
[
    width == undef ? wave[enumWaveWidth] : width, 
    height == undef ? wave[enumWaveHeight] : height, 
    length == undef ? wave[enumWaveLength] : length, 
    type == undef ? wave[enumWaveType] : type
];

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

function convertFeet2mm(feet) = feet * mmPerFoot;
function convertInches2mm(inches) = inches * mmPerInch;
function WallThickness(count) = count * NozzleWidth;

function height2layers(mm = 1) = mm/LayerHeight;
function layers2Height(layers) = InitialLayerHeight + ((layers - 1) * LayerHeight);

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

//vector functions
//append a z value to an [x,y] vector.
function AddZ(v, zValue) = 
[
    for(i = [0 : len(v)]) (i == len(v) ? zValue : v[i])
];