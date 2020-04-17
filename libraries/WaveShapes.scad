include <SpiralShapes.scad>;
$fn=40;
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
        plateThickness = 2;
        length = 100;
        a_scale = (1/range * (length/2));
        scalePlateThickness = plateThickness * 1/a_scale;

        lipThickness = 2;
        lipHeight = 30;
        points1 = SinWavePoints(range = range, stepSize = 1, amplitude=amplitude);
        // echo(a_scale = a_scale, scalePlateThickness=scalePlateThickness);
        plateTop = a_scale * (2 * amplitude + scalePlateThickness);

        union()
        {
            rotate_extrude(angle = 360, convexity = 10)
            union()
            {
                translate([-length,(lipThickness / 2),0]) 
                hull()
                {
                    translate([-2.3, lipHeight, 0]) circle(r = lipThickness / 2); 
                    circle(r = lipThickness / 2);                
                }

                scale([a_scale, a_scale, 0])
                translate([valueOfX(points1,0), (cos(PI/2)*amplitude), 0])

                polygon(points = concat(points1, [[range, amplitude + scalePlateThickness],[-range, amplitude + scalePlateThickness]]));
            }

            translate([ 0, 0, plateTop])
            WaveStar(spokes = 16, spokeWidth = 2, spokeLength = 101, spokeAmplitude = 100);
        }
}

module WaveStar(spokes = 7, spokeWidth = 2, spokeLength = 100, spokeAmplitude = 200)
{
    angle = 360/spokes;
    for(n = [1 : spokes])
    {
        rotate([0, 0, n * angle])
        {
            Wave(width = spokeWidth, length = spokeLength, amplitude = spokeAmplitude);
        }
    }
}

module Wave(width = 10, length = 100, amplitude = 200)
{
    ripple = 90;
    rippleCount = 1;
    range = ripple * rippleCount;
    waveWidth = width;
    amplitude = amplitude;
    waveScale = waveWidth * (1/range);
    waveLength = length;

    points1 = CosWavePoints(range = range, stepSize = 1, amplitude = amplitude);

    rotate([90,0,0])
    linear_extrude(height = waveLength )
    scale([waveScale, waveScale, 0])
    polygon(points = points1);

}

function SinWavePoints(range, stepSize, amplitude=100, width = 0) = 
    [
        for (x=stepSize > 0 ? [-range:stepSize:range] : [range:stepSize:-range]) 
            [x,  width + sin(x)*amplitude ]
    ];

function CosWavePoints(range, stepSize, amplitude=100, width = 0) = 
    [
        for (x=stepSize > 0 ? [-range:stepSize:range] : [range:stepSize:-range]) 
            [x,  width + cos(x)*amplitude ]
    ];
    
function valueOfX(points, index) = points[index][0];
function valueOfY(points, index) = points[index][1];