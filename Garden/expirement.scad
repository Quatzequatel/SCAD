/*
*
*/
$fn=100;
build("ArchimedeanSpiral");

// function

module build(args) 
{
    if(args == "plotSine")
    {
        linear_extrude(height=100)
        {
            // plotSine(range = 360, stepSize = -1, angle = 10/180);   
            plotSine(range = 360, stepSize = 1, angle = 10/180, width = 5);   
        } 
    }
    
    if(args == "plotParabola")
    {
        color("red")  linear_extrude(height=10)polygon(points= ParabolaPoints(10,100,1));
        color("blue")  linear_extrude(height=20)polygon(points= ParabolaPoints(4,60,2));
        color("yellow")  linear_extrude(height=30)polygon(points= ParabolaPoints(1,30,0.5));
        // color("blue") plotParabola(4,60,2);
        // color("yellow") plotParabola(1,30,0.5);
    }

    if(args =="")
    {
        // linear_extrude(height=100)
        // polygon(points=concat(
        //     SinWavePoints(range = 360, stepSize = 1, width = 0), 
        //     SinWavePoints(range = 360, stepSize = -1, width = 30)
        //     ));

        points1 = SinWavePoints(range = 360, stepSize = 1);
        points3 = Add2Yvector(SinWavePoints(range = 360, stepSize = -1), 10);
        // echo(points2=points2);
        polygon(points = concat(points1, points3));

        // color("red") plot( SinWavePoints(range = 360, stepSize = 1, width = 0));
        // color("blue") plot( SinWavePoints(range = 360, stepSize = -1, width = 30));
    }

    if(args == "vectorSample")
    {
        vectorSample();
    }

    if(args == "ArchimedeanSpiral")
    {
        union()
        {
            ArchimedeanSpiral(height=10, width=4, range = 1000, scale = 0.1, a = -10, b = -1);
            // translate([-1.06,-0.01,0])
            // ArchimedeanSpiral(height=5, width=2, range = 1000, scale = 0.1, a = -10, b = 1);           
            // translate([0, 0, 5])  
            // cylinder(r=3, h=10, center=true, $fn=360);
        }
    }

}

module ArchimedeanSpiral(height, width, range = 900, scale = 0.25, a = 5, b = 1)
{
    points1 = ArchimedeanSpiral(a = a, b = b, width = 0, range = range, ascending = true);
    points2 = ArchimedeanSpiral(a = a, b = b, width = width/scale, range = range, ascending = false);

    difference()
    {
        linear_extrude(height = height)
        {
            scale([scale,scale,0])
            polygon(points = concat(points1, points2));
        }
        
        // translate([b > 0 ? -2 : 0, b > 0 ? -1.9 : -0.1, -1]) 
        // linear_extrude(height = height+2)
        // square([2,2]);
    }
}

module plot(points)
{
    // hull()
    for(i = points)
    {
        // echo(i = i, x = i[0], y=i[1]);
        // echo(points);
        //hull()
        translate([i[0], i[1], 0]) 
        {
            circle(r=5);
        }
    }
}

function ArchimedeanSpiral(a = 1, b = -2, width = 0, range = 900, ascending = true) =
[
    for(rad = ascending ? [0 : PI/8 : range] : [range : -PI/8 : 0])
    [(cos(rad) * (a + b * rad) + (width != 0 ? cos(rad) * width : 0)), (sin(rad) * (a + b * rad) + (width != 0 ? sin(rad) * width : 0 ))]
];

function parabola(f, x) = (1/(4*f)) * (x*x); 

function Add2Yvector(v, y) = 
[
    for(i = [0 : len(v)-1]) 
        [v[i][0], v[i][1] + y]
];

function Add2XYvector(v, value) = 
[
    for(i = [0 : len(v)-1]) 
        [foobarX(v[i][0], v[i][1], value), foobarY(v[i][0], v[i][1], value)]
];

function foobarX(x,y, value) = cos(tan(y/x > 100000 ? 90 : y/x)) * value;
function foobarY(x,y, value) = sin(tan(y/x > 100000 ? 90 : y/x)) * value;


function ParabolaPoints(f, wide, steps=1) =
    [
        for (x=[-wide/2 : steps : wide/2]) 
            [x, parabola(f, x)]
    ];

function SinWavePoints(range, stepSize, amplitude=100) = 
    [
        for (x=stepSize > 0 ? [-range:stepSize:range] : [range:stepSize:-range]) 
            [x, sin(x)*amplitude ]
    ];


