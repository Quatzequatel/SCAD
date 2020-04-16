/*
*
*/
$fn=100;
build("plotParabola");

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


