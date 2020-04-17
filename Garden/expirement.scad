/*
*
*/
use <..\\libraries\\dotSCAD\\src\\hull_polyline2d.scad>;
// use <..\\libraries\\SpiralShapes.scad>;
$fn=20;
build("");

// function

module build(args) 
{
  
    if(args == "plotParabola")
    {
        color("red")  linear_extrude(height=10)polygon(points= ParabolaPoints(10,100,1));
        color("blue")  linear_extrude(height=20)polygon(points= ParabolaPoints(4,60,2));
        color("yellow")  linear_extrude(height=30)polygon(points= ParabolaPoints(1,30,0.5));
        // color("blue") plotParabola(4,60,2);
        // color("yellow") plotParabola(1,30,0.5);
    }

    function valueOfX(points, index) = points[index][0];
    function valueOfY(points, index) = points[index][1];

    if(args == "vectorSample")
    {
        vectorSample();
    }

    if(args == "")
    {
        scale([0.25,0.25,0.25,])
        hull_polyline2d(
            points = ArchimedeanSpiral(a = 0, b = -0.25, range = 1800, width = 0, ascending = true), 
            width = 20
        );
    }

}


module plot(points)
{
    for(i = points)
    {
        translate([i[0], i[1], 0]) 
        {
            circle(r=1, $fn=6);
        }
    }
}


function parabola(f, x) = (1/(4*f)) * (x*x); 

function Add2Yvector(v, y) = 
[
    for(i = [0 : len(v)-1]) 
        [v[i][0], v[i][1] + y]
];

function Add2Xvector(v, x) = 
[
    for(i = [0 : len(v)-1]) 
        [v[i][0] + x, v[i][1]]
];

function Add2XYvector(v, value) = 
[
    for(i = [0 : len(v)-1]) 
        [foobarX(v[i][0], v[i][1], value), foobarY(v[i][0], v[i][1], value)]
];

function ParabolaPoints(f, wide, steps=1) =
    [
        for (x=[-wide/2 : steps : wide/2]) 
            [x, parabola(f, x)]
    ];

function SinWavePoints(range, stepSize, amplitude=100, width = 0) = 
    [
        for (x=stepSize > 0 ? [-range:stepSize:range] : [range:stepSize:-range]) 
            [x,  width + sin(x)*amplitude ]
    ];

function ArchimedeanSpiral(a = 1, b = -2, range = 900, width = 0, ascending = true) = 
[
    for(rad = ascending ? [0 : PI/2 : range] : [range : -PI/2 : 0])
    [
        (cos(rad) * (a + b * rad) + (width != 0 ? cos(rad) * width : 0) * (b > 0 ? 1 : -1)) ,
        (sin(rad) * (a + b * rad) + (width !=0  ? sin(rad) * width : 0) * (b > 0 ? 1 : -1))
    ]
];
