/*
    Library of useful converters.
*/

mmPerInch = 25.4;
cmPerInch = mmPerInch/10;
inchesInFoot = 12;
FeetInInch = 1/inchesInFoot;
//imperial <-> meteric
function convert_ft2in(feet) = feet * inchesInFoot;
function convert_in2ft(in) = in * FeetInInch;
function convert_in2mm(in) = in * mmPerInch;
function convert_ft2mm(feet) = convert_ft2in(feet) * mmPerInch;
// function convert_ft2in(feet) = feet*12;
function convert_mm2Inch(mm) = mm/mmPerInch;
function convert_mm2Feet(mm) = convert_in2ft(in = convert_mm2Inch(mm));
function convert_cm2Inch(cm) = convert_mm2Inch(cm) * 10;

function testPass(note, value1, value2) = echo(note = note, input = value1, return = value2) [value1, value2];


Test();

module Test() 
{
    assert(testPass("convert_ft2in", 1, convert_ft2in(1))[1] == inchesInFoot);
    assert(testPass("convert_in2ft", inchesInFoot, convert_in2ft(inchesInFoot))[1] == 1);
    assert(testPass("convert_in2mm", 1, convert_in2mm(1))[1] == mmPerInch);
    assert(testPass("convert_mm2Inch", mmPerInch, convert_mm2Inch(mmPerInch))[1] == 1);
    assert(testPass("convert_cm2Inch", cmPerInch, convert_cm2Inch(cmPerInch))[1] == 1);
    assert(testPass("convert_ft2mm", 1, convert_ft2mm(1))[1] == inchesInFoot * mmPerInch);
    assert(testPass("convert_mm2Feet", mmPerInch * inchesInFoot, convert_mm2Feet(mmPerInch * inchesInFoot))[1] == mmPerInch * inchesInFoot);
}

