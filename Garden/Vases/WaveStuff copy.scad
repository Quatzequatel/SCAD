

$fn=360;
Radius = 40;
function f1X(i) = cos(360*i/18) * Radius;
function f1Y(i) = sin(360*i/18) * Radius;

function f2X(i,j) = f1X(i) + cos(180*i/18) * Radius/40;
function f2Y(i,j) = f1Y(i) + sin(180*i/18) * Radius/40;

function DegreeSteps(resolution) = 360/resolution;
function StepCount(resolution) = 360/DegreeSteps(resolution);

function PointX(radius, degree) = cos(degree) * radius;
function PointY(radius, degree) = sin(degree) * radius;
function circlePoints(radius, resolution, index) = [PointX(radius, DegreeSteps(resolution) * index), PointY(radius, DegreeSteps(resolution) * index), 0];

Build();
module Build(args) 
{
    // linear_extrude(height = 100, twist = 120, scale=3)
    union()
    {
    foo4(100,15, PointY(100,15));
    circle(100);
    }
    // foo2();
        
}

module foo()
{
 for (i = [0:9]) {
  echo(360*i/6, sin(360*i/6)*80, cos(360*i/6)*80);
   translate([sin(360*i/6)*80, cos(360*i/6)*80, 0 ])
    cylinder(h = 200, r=10);
 }
}

module foo2()
{
     for(i=[0:10])
     {
         for(j=[0:10])
         {
            // echo(f1X=f1X(i),f1Y=f1Y(i));
            translate([f2X(i,j),f2Y(i,j),0])
            // translate([i*10,0,0])
            cylinder(r=2,h=sin(i*10)*50+60);
         }

     }
}

module foo3()
{
     for (i = [0:5]) {
  echo(360*i/6, tan(360*i/6)*80);
   translate([tan(360*i/6)*80, 0, 0 ])
    cylinder(h = 200, r=10);
 }
}

module foo4(radius, resolution, r2)
{
    echo(radius=radius, resolution=resolution);
    for(i = [0: StepCount(resolution)])
    {
        translate(circlePoints(radius, resolution, i))
        circle(r2);
        // echo(i=i, circlePoints=circlePoints(radius, resolution, i));
    }
}