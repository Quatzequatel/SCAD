/*
functions for trellis
*/

include <TrellisEnums.scad>;
include <constants.scad>;
use <vectorHelpers.scad>;

function getFrameProperty(fp) = fp[enumPropertyFrame];
function getFrameBoardDimension(fp) =  fp[enumPropertyFrameBoard];
function getLatticeSize(ld) = //echo(ld)
[
     getKeyValue(getKeyValue(ld, "lattice properties"), "width"),
     getKeyValue(getKeyValue(ld, "lattice properties"), "depth")
    //  getKeyValue(getKeyValue(ld, "lattice properties"), "height")
];

function getScrewHoles(fp) =  fp[enumPropertyScrewHoles];
function getIntervalCount(fp) =  isVector(fp[enumPropertyInterval]) ? fp[enumPropertyInterval][0] : fp[enumPropertyInterval];
function vgetIntervalCount(fp) =  
    isVector(fp[enumPropertyInterval]) ? 
    fp[enumPropertyInterval] 
    : assert(false, "getIntervalCount is not an array.")
    ;

function getIncludes(fp) =  fp[enumPropertyInclude];
function getIncludesPropertyValue(fp, enum) = getIncludes(fp)[enum];
function getTrellisProperty(key, frameProperties) = getKeyValue(frameProperties, key);

// function getKeyValue(v, key, i = 0, result) = //echo(v=v, key=key, i=i, result=result)
// ( i < len(v) ? 
//     getKeyValue
//     (
//         v = v,
//         key = key,
//         i = i + 1,
//         result = v[i][0] == key 
//             ? v[i] : result
//     ) : result[1] //[0] returns ket, [1] returns value and nothing returns booth
// );


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

function getActualWidth(frame, board) = frame.x + board.x;
function getActualHeight(frame, board) = frame.y + board.x;

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

function testPass(note, value1, value2) = echo(note = note, input = value1, return = value2) [value1, value2];


Test();

module Test() 
{
    echo(LayerHeight = LayerHeight);
    // assert(testPass("hypotenuse(width, angle)", [3,4], hypotenuse(width, angle)[1] == inchesInFoot);
    assert(testPass("height2layers(4 * LayerHeight)", 4 * LayerHeight , height2layers(4 * LayerHeight))[1] == 4);
    // assert(testPass("convert_in2mm", 1, convert_in2mm(1))[1] == mmPerInch);
    // assert(testPass("convert_mm2Inch", mmPerInch, convert_mm2Inch(mmPerInch))[1] == 1);
    // assert(testPass("convert_cm2Inch", cmPerInch, convert_cm2Inch(cmPerInch))[1] == 1);
    // assert(testPass("convert_ft2mm", 1, convert_ft2mm(1))[1] == inchesInFoot * mmPerInch);
    // assert(testPass("convert_mm2Feet", mmPerInch * inchesInFoot, convert_mm2Feet(mm = mmPerInch * inchesInFoot))[1] == 1);
}