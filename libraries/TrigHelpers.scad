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
    let( do_echo = ISDEBUGEMODE ? fargsEcho("midpoint([0]=p1, [1]=p2)", [p1, p2]) : 0)
    let(result = [(p1.x + p2.x)/2, (p1.y + p2.y)/2, (p1.z + p2.z)/2]) 
    let( do_echo = ISDEBUGEMODE ? fargsEcho("midpoint()=> [0]=x, [1]=y, [2]=z", result) : 0)
    result;


function directionPoint(p = [0,0,0], angle = 10, length = 10) = 
let( do_echo = ISDEBUGEMODE ? fargsEcho("directionPoint([0]=p, [1]=angle , [2]=length)", [p, angle, length]) : 0)
let
    (
        result = pointOnCircle(origin=p, angle=angle, radius=length)
    )
    let( do_echo = ISDEBUGEMODE ? fargsEcho("directionPoint()=> [0]=x, [1]=y, [2]=z", result) : 0)
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

function AddPoints(p1, p2) = [p1.x + p2.x, p2.y + p2.y, p1.z + p2.z];

function Add2X(p, value) = [p.x + value, p.y, p.z];
function Add2Y(p, value) = [p.x, p.y + value, p.z];
function Add2Z(p, value) = [p.x, p.y, p.z + value];

function testPass(note, value1, value2) = echo(note = note, input = value1, return = value2) [value1, value2];

function Height(x, angle) = lengthOpposite(side_a = x, angleA = angle > 45 ? angle : AngleOpposite(angle) );
/*
How to identify the sides and angles of a Right triangle use in the below functions.
all of the following functions are derived from the basic right triangle where:
    when a = 3, b = 4, c = 5, A = 36.87, B = 53.13, C = 90
    side a =  b * sin(A)/sin(C) also adjacent; or the shortest leg of the triangle
    side b =  a * sin(B)/sin(C) also opposite; or the longest leg of the triangle
    side c = (a^2 + b^2)^0.5 & == b*sin(C)/sin(B); the hypotenuse
    angle A == angle C - angle B 
    angle B == angle C - angle B 
    angle C = 90
    area = a*b*sin(C)/2
*/
//sideB is the longer leg (ex: 3) and angleA is the smaller (ex: 36.87) of the two
function sideA(side_b, aA)=
let
(
    result = side_b /tan(aA)
)
result;

//sideB is the longer leg (ex: 3) and angleB is the larger (ex: 53.13) of the two
function sideA(side_b, aB)=
let
(
    result = side_b /tan(aB)
)
result;

/*
  sideB is the longer leg (ex: 4) and angleA is the smaller (ex: 36.87) of the two
*/
function sideB(side_a, aA)=
let
(
    result = side_a /tan(aA)
)
result;

function sideC(side_a, aA)=
let
(
    result = side_a /sin(aA)
)
result;

function angleA(side_a, side_b)=
let
(
    result = atan(side_a /side_b)
)
result;

function angleB(side_a, side_b)=
let
(
    result = atan(side_b/side_a)
)
result;

/*
  side_b is the shorter leg (ex: 3) and angleA is the larger (ex: 53.13) of the two
*/
function lengthOpposite(side_a, angleA) = 
let( do_echo = ISDEBUGEMODE ? fargsEcho("lengthOpposite([0]=side_b, [1]=angleA )", [side_b, angleA]) : 0)
let( angle = max(angleA, AngleOpposite(angleA)))
let
    (
        result = sideB(side_a, angle) 
    )
    let( do_echo = ISDEBUGEMODE ? fargsEcho("lengthOpposite(result= )", [result]) : 0)
    result;

// simple function to return the opposite angle of the input value.
// result is always positive.
function AngleOpposite(angle) = 
    assert(angle > 0, "angle must be positive value > 0 and < 90")
    assert(angle < 90, "angle must be less than 90")
    let
    (

        result = 90 - angle
    )
    result;    


Test();

/*

*/


module Test() 
{
    assert(testPass("Distance([[0,0],[3,4]])", [[0,0],[3,4]], Distance([0,0],[3,4]))[1] == 5);
    // assert(testPass("convert_in2ft", inchesInFoot, convert_in2ft(inchesInFoot))[1] == 1);
    // assert(testPass("convert_in2mm", 1, convert_in2mm(1))[1] == mmPerInch);
    // assert(testPass("convert_mm2Inch", mmPerInch, convert_mm2Inch(mmPerInch))[1] == 1);
    // assert(testPass("convert_cm2Inch", cmPerInch, convert_cm2Inch(cmPerInch))[1] == 1);
    // assert(testPass("convert_ft2mm", 1, convert_ft2mm(1))[1] == inchesInFoot * mmPerInch);
    // assert(testPass("convert_mm2Feet", mmPerInch * inchesInFoot, convert_mm2Feet(mm = mmPerInch * inchesInFoot))[1] == 1);
    // let(result = lengthOpposite(3, 53.13))
    // {
    //     assert(testPass("lengthOpposite(3, 53.13)", [3, 53.13], lengthOpposite(3, 53.13))[1] == result);
    //     // assert(3.9 < result && result < 4);
    // }
    // assert(testPass("lengthAdjacent([3657.6, 42)", [3657.6, 42], Height(x=3657.6 , angle=45 ))[1] == 1);
    assert(testPass("lengthOpposite(side_a = 6, angleA = 42 )", [6,42], sideB(side_a=6, aA=42 ))[1] < 6.67);
    assert(testPass("sideC(side_a = 6, aA = 42 )", [6,42], sideC(side_a=6, aA=42 ))[1] <  8.97);
    assert(testPass("angleA(side_a = 6, side_b = 6.6638)", [6,42], angleA(side_a = 6, side_b = 6.6638 ))[1] <  42.1);
    assert(testPass("angleB(side_a = 6, side_b = 6.6638 )", [6,42], angleB(side_a = 6, side_b = 6.6638 ))[1] < 48.1);

    
    x = directionPoint();


}