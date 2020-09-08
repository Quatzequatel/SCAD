/*
    Library of useful converters.
    note put any constants in constants.scad
*/
include <constants.scad>;

// mmPerInch = 25.4;
// cmPerInch = mmPerInch/10;
// inchesInFoot = 12;
// FeetInInch = 1/inchesInFoot;
//imperial <-> meteric
function convert_ft2in(ft) = ft * inchesInFoot;
function convert_in2ft(in) = in * FeetInInch;
function convert_in2mm(in) = in * mmPerInch;
function convert_ft2mm(ft) = convert_ft2in(ft) * mmPerInch;
// function convert_ft2in(ft) = ft*12;
function convert_mm2in(mm) = convert_cm2Inch(mm);
function convert_mm2Inch(mm) = mm/mmPerInch;
function convertV_mm2Inch(mm) = 
    [
        for(i = [0 : 1 : len(mm)-1]) convert_mm2Inch(mm[i])
    ];

function convert_mm2ft(mm) = convert_in2ft(in = convert_mm2Inch(mm));
function convert_feet2feet(ft) = ft;
function convert_in2in(in) = in;

function convertV_mm2Feet(mm) =
    [
        for(i = [0 : 1 : len(mm)-1]) convert_in2ft(in = convert_mm2Inch(mm[i]))
    ];

function convertVPts_mm2Feet(mm) =
[
    for(i = [0 : 1 : len(mm) - 1]) convertV_mm2Feet(mm = convertV_mm2Feet(mm[i]))
];

function convertVPts_mm2Inch(mm) =
[
    for(i = [0 : 1 : len(mm) - 1]) convertV_mm2Inch(mm = mm[i])
];

function convert_cm2Inch(cm) = convert_mm2Inch(cm) * 10;

function testPass(note, value1, value2) = echo(note = note, input = value1, return = value2) [value1, value2];


Test();

module Test() 
{
    assert(testPass("convert_ft2in", 1, convert_ft2in(1))[1] == inchesInFoot);
    assert(testPass("convert_in2ft", inchesInFoot, convert_in2ft(inchesInFoot))[1] == 1);
    assert(testPass("convert_in2mm", 1, convert_in2mm(1))[1] == mmPerInch);
    // assert(testPass("convert_in2mm", 11.71875, convert_in2mm(11.71875))[1] ==  297.656);
    assert(testPass("convert_mm2Inch", mmPerInch, convert_mm2Inch(mmPerInch))[1] == 1);
    assert(testPass("convert_cm2Inch", cmPerInch, convert_cm2Inch(cmPerInch))[1] == 1);
    assert(testPass("convert_ft2mm", 1, convert_ft2mm(1))[1] == inchesInFoot * mmPerInch);
    // assert(testPass("convert_mm2Feet", mmPerInch * inchesInFoot, convert_mm2Feet(mm = mmPerInch * inchesInFoot))[1] == 1);
}

