/*
    library of useful Trigonometry functions.
*/

//length of hypotenuse for right angled triangle.
function hypotenuse(a, b) = echo(hypotenuse = 1, a = a, b = b) 
    sqrt((a * a) + (b * b));
//point 2 given point 1 and angle assuming in a right angle triangle.
function p2(p1, angle) = [p1.x * cos(angle), p1.y * sin(angle)];

function Distance(p1, p2) = echo(Distance = 1, p1 = p1,p2 = p2) 
    hypotenuse((p1.x - p2.x), (p1.y - p2.y));

function sqr(i) = echo(sqr = 1, i=i) 
    i * i;

function AddPoints(p1, p2) = [p1.x + p2.x, p2.y + p2.y, 0];

function testPass(note, value1, value2) = echo(note = note, input = value1, return = value2) [value1, value2];

Test();

module Test() 
{
    assert(testPass("Distance([[0,0],[3,4]])", [[0,0],[3,4]], Distance([0,0],[3,4]))[1] == 5);
    // assert(testPass("convert_in2ft", inchesInFoot, convert_in2ft(inchesInFoot))[1] == 1);
    // assert(testPass("convert_in2mm", 1, convert_in2mm(1))[1] == mmPerInch);
    // assert(testPass("convert_mm2Inch", mmPerInch, convert_mm2Inch(mmPerInch))[1] == 1);
    // assert(testPass("convert_cm2Inch", cmPerInch, convert_cm2Inch(cmPerInch))[1] == 1);
    // assert(testPass("convert_ft2mm", 1, convert_ft2mm(1))[1] == inchesInFoot * mmPerInch);
    // assert(testPass("convert_mm2Feet", mmPerInch * inchesInFoot, convert_mm2Feet(mm = mmPerInch * inchesInFoot))[1] == 1);
}