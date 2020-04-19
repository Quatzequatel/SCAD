
$fn=100;
Build();

module Build(args) 
{
    Spiral();
}

module Spiral()
{
    ArchimedeanDoubleSpiral(height=5, width=4, range = 1000, scale = 0.1, a = 0, b = 1); 
}

module ArchimedeanSpiral(height, width, range = 900, scale = 0.25, a = 0, b = 1)
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
    }
}

module ArchimedeanDoubleSpiral(height, width, range = 900, scale = 0.25, a = 0, b = 1)
{
    points1 = ArchimedeanSpiral(a = a, b = b, width = 0, range = range, ascending = true);
    points2 = ArchimedeanSpiral(a = a, b = b, width = width/scale, range = range, ascending = false);

    points3 = ArchimedeanSpiral(a = -a, b = -b, width = 0, range = range, ascending = true);
    points4 = ArchimedeanSpiral(a = -a, b = -b, width = width/scale, range = range, ascending = false);

    linear_extrude(height = height)
    union()
    {
        scale([scale,scale,0])
        {
            translate([ -(width/scale)/2, 0, 0])
            polygon(points = concat(points1, points2));
            translate([ (width/scale)/2, 0, 0])
            polygon(points = concat(points3, points4));
        }        
    }
}

module ArchimedeanSpiralDebug(height, width, range = 900, scale = 0.25, a = 0, b = 1)
{
    points1 = ArchimedeanSpiral(a = a, b = b, width = 0, range = range, ascending = true);
    points2 = ArchimedeanSpiral(a = a, b = b, width = width/scale, range = range, ascending = false);

    plot(points1);
    #plot(points2);
}

//this is generally used to visualize points.
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

/*
    a = distance from center
    b => controls distance between spirals
*/
function ArchimedeanSpiral(a = 1, b = -2, range = 900, width = 0, ascending = true) = 
[
    for(rad = ascending ? [0 : PI/8 : range] : [range : -PI/8 : 0])
    [
        fArchimedeanSpiralX(rad, a, b, width) ,
        fArchimedeanSpiralY(rad, a, b, width)
    ]
];

function fArchimedeanSpiralX(rad, a, b, width) = (cos(rad) * (a + b * rad) + 
                                                    (width != 0 ? 
                                                        cos(rad) * width : 0) * (b > 0 ? 1 : -1));
function fArchimedeanSpiralY(rad, a, b, width) = (sin(rad) * (a + b * rad) + 
                                                    (width !=0  ? 
                                                        sin(rad) * width : 0) * (b > 0 ? 1 : -1));