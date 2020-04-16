include <SpiralShapes.scad>;
$fn=100;
Build();

module Build(args) 
{
    Saucer();
}

module Saucer()
{
        ripple = 90;
        rippleCount = 9;
        range = ripple * rippleCount;
        amplitude = 100;
        width = 10;
        length = 100;

        lipThickness = 2;
        lipHeight = 30;
        points1 = SinWavePoints(range = range, stepSize = 1, amplitude=amplitude);
        // echo(points1);

        union()
        {
            //color("y")
            #rotate_extrude(angle = 360, convexity = 10)
            translate([length,(lipThickness / 2),0]) 
            hull()
            { 
                translate([0, lipHeight, 0]) circle(r = lipThickness / 2); 
                circle(r = lipThickness / 2);
            }

            rotate_extrude(angle = 360, convexity = 10)
            scale([(1/range * (length/2)), (1/range * (length/2)), 0])
            translate([valueOfX(points1,0), (cos(PI/2)*amplitude), 0])

            polygon(points = concat(points1, [[range, amplitude + width],[-range, amplitude + width]]));

            // echo(value = (1/range * (length/2))*(amplitude + width));
            translate([ 0, 0,13])
            ArchimedeanDoubleSpiral(height=1, width=2, range = 1000, scale = 0.1, a = 0, b = 0.99);
        }
}


function SinWavePoints(range, stepSize, amplitude=100, width = 0) = 
    [
        for (x=stepSize > 0 ? [-range:stepSize:range] : [range:stepSize:-range]) 
            [x,  width + sin(x)*amplitude ]
    ];

    
function valueOfX(points, index) = points[index][0];
function valueOfY(points, index) = points[index][1];