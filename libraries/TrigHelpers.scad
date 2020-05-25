/*
    library of useful Trigonometry functions.
*/
include <constants.scad>;

//length of hypotenuse for right angled triangle.
function hypotenuse(a, b) = //echo(hypotenuse = 1, a = a, b = b) 
    sqrt((a * a) + (b * b));
//point 2 given point 1 and angle assuming in a right angle triangle.
function p2(p1, angle) = [p1.x * cos(angle), p1.y * sin(angle)];

function Distance(p1, p2) = //echo(Distance = 1, p1 = p1,p2 = p2) 
    hypotenuse((p1.x - p2.x), (p1.y - p2.y));

function sqr(i) = //echo(sqr = 1, i=i) 
    i * i;

function midpoint(p1, p2) = //echo( midpoint="input", p1 = p1, p2 = p2)
    let( foo = ISDEBUGEMODE ? fargsEcho("midpoint([0]=p1, [1]=p2)", [p1, p2]) : 0)
    let(result = [(p1.x + p2.x)/2, (p1.y + p2.y)/2, (p1.z + p2.z)/2]) 
    let( foo = ISDEBUGEMODE ? fargsEcho("midpoint()=> [0]=x, [1]=y, [2]=z", result) : 0)
    result;


function directionPoint(p = [0,0,0], angle = 10, length = 10) = 
let( foo = ISDEBUGEMODE ? fargsEcho("directionPoint([0]=p, [1]=angle , [2]=length)", [p, angle, length]) : 0)
let
    (
        result = pointOnCircle(origin=p, angle=angle, radius=length)
    )
    let( foo = ISDEBUGEMODE ? fargsEcho("directionPoint()=> [0]=x, [1]=y, [2]=z", result) : 0)
    
    result;

function pointOnCircle(origin, angle, radius) =
let
(
    result = 
    [
        origin.x + radius * cos(angle),
        origin.y + radius * sin(angle),
        origin.z          
    ]
)
result;

function AddPoints(p1, p2) = [p1.x + p2.x, p2.y + p2.y, 0];

function Add2X(p, value) = [p.x + value, p.y, p.z];
function Add2Y(p, value) = [p.x, p.y + value, p.z];
function Add2Z(p, value) = [p.x, p.y, p.z + value];

function testPass(note, value1, value2) = echo(note = note, input = value1, return = value2) [value1, value2];

function Height(x, angle) = tan(angle) * x;

function Angle(x, y) = asin(x / hypotenuse(x,y));

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
    x = directionPoint();
}