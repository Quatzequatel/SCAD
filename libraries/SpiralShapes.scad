use <vectorHelpers.scad>
use <shapesbypoints.scad>
use <polyline2d.scad>;
use <archimedean_spiral.scad>;

$fn=100;
Build();

module Build(args) 
{
    heartTop();
}

module heartTop()
{


    points_angles = archimedean_spiral(
        arm_distance = 10,
        init_angle = 30,
        point_distance = 1,
        num_of_points = 100 
    ); 

    points = [for(pa = points_angles) pa[0]];

    polyline2d(points, width = 2);
}



module Spiral()
{
    height=10; 
    width=10; 
    range =  457.102; 
    convolutions = 2;
    // range =  convolutions * 2 * PI /ArchimedeanSpiralIncrement(true); 
    echo( convolutions = convolutions, range = range);
    scale = 0.1; 
    a = 10; 
    b = 5;
    

    points1 = ArchimedeanSpiral(a = a, b = b, width = 0, range = range, , ascending = true);
    points2 = ArchimedeanSpiral(a = a, b = b, width = height, range = range, , ascending = false);

    pmx =  vMultiply(getMaxValue(points1, 1), scale); //[-270.296, 2297.7];
    p1 = [pmx.x - 45.7, pmx.y + height/2]; //vMultiply(pmx, scale);
    p2 = [0, p1.y];
    p3 = [p1.x * -1, p1.y];

    echo(p1 = p1, p2 = p2, p3 = p3, pmx = pmx);

    // echo(points2 = points2);


    // echo(points0 = points2[0]);
    // idx = len(points1)-1;
    // lastpoints = vAdd(vMultiply(getMaxValue(points1, 1), scale), -height);
    // echo(lastpoints = lastpoints);
    // // #plot([lastpoints[0]]);
    // // plot([vMultiply(getMaxValue(points2, 1), scale)]);
    #plot([[-28.6281, 229.774]]);

    // lastRad = getLastRadianY(a = a, b = b, width = 0, endvalue = getMaxValue(points1, 1).y, ascending = true);
    // echo(lastRad = lastRad);

    translate([105, 0, 0]) 
    ArchimedeanSpiral(height=height, width=height, range = range, scale = scale, a = a, b = b); 
    translate([-105, 0, height]) 
    rotate([0, 180, 0])
    ArchimedeanSpiral(height=height, width=height, range = range, scale = scale, a = a, b = b); 

// translate([0, 0, 10]) 
    point_square(size = [width, height], p1 = p1, p2 = p2, height = height);
    point_square(size = [width, height], p1 = p3, p2 = p2, height = height);

}


function getLastRadianY(a = 1, b = -2, width = 0, endvalue = 0, rad=0, ascending = true) = //echo(rad = rad)
    (
        endvalue > fArchimedeanSpiralY(rad, a, b, width) 
        ? 
        getLastRadianY
        ( 
            a = a, b = b, width = width, endvalue = endvalue, rad = rad + PI/8 
        )  
        // 20
        : 
        rad
    );


module ArchimedeanSpiral(height, width, range = 900, scale = 0.25, a = 0, b = 1, startvalue = 0)
{
    points1 = ArchimedeanSpiral(a = a, b = b, width = 0, range = range, startvalue = startvalue, ascending = true);
    points2 = ArchimedeanSpiral(a = a, b = b, width = width/scale, range = range, startvalue = startvalue, ascending = false);

    idx = len(points2)-1;
    lastpoints = [points1[idx], points2[1]];
    echo(f_lastpoints = lastpoints);

    difference()
    {
        linear_extrude(height = height)
        {
            scale([scale,scale,0])
            polygon(points = concat(points1, points2));
        }
    }
}

module ArchimedeanDoubleSpiral(height, width, range = 900, scale = 0.25, a = 0, b = 1, startvalue = 0)
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

module ArchimedeanSpiralDebug(height, width, range = 900, scale = 0.25, a = 0, b = 1, startvalue = 0)
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
            linear_extrude(height = 20)
            circle(r=0.1, $fn=6);
        }
    }
}

/*
    a = distance from center
    b => controls distance between spirals
*/
function ArchimedeanSpiral(a = 1, b = -2, range = 900, width = 0, startvalue = 0, ascending = true) = 
[
    for(rad = ascending ? [startvalue : ArchimedeanSpiralIncrement(ascending) : range] : [range : ArchimedeanSpiralIncrement(ascending) : startvalue])
    [
        fArchimedeanSpiralX(rad, a, b, width) ,
        fArchimedeanSpiralY(rad, a, b, width)
    ]
];

function ArchimedeanSpiralIncrement(ascending) = ascending ? PI/8 : -PI/8;



function fArchimedeanSpiralX(rad, a, b, width) = //echo(fArchimedeanSpiralX=1, rad=rad, a=a, b=b, width=width, y = fArchimedeanSpiralY(rad, a, b, width)) 
    (cos(rad) * (a + b * rad) + 
                                                    (width != 0 ? 
                                                        cos(rad) * width : 0) * (b > 0 ? 1 : -1));
function fArchimedeanSpiralY(rad, a, b, width) = //echo(fArchimedeanSpiralY=1, rad=rad, a=a, b=b, width=width) 
    (sin(rad) * (a + b * rad) + 
        (
            width !=0  
            ? 
                sin(rad) * width 
            : 
                0
            ) 
        * (b > 0 ? 1 : -1)
    );