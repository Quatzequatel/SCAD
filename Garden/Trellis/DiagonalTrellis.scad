/*

*/
use <vectorHelpers.scad>;
use <TrigHelpers.scad>;
use <shapesByPoints.scad>;
use <Frame.scad>;
use <SquareLatticeTrellis.scad>;

// translate([400/2, 400/2, 0])
// {
//    SquareFrame
// (
//     frameDimension = [400,  400],
//     frameBoardDimension = [4, 12.7],
//     screwHoles = [5, 3]
// );
// }

DiagonalLattice(); 
// DiagonalLattice2(); 
// DiagonalLatticeOld();

module DiagonalLattice
    (
        frameDimension = [ 400,  400],
        frameBoardDimension = [4, 12.7] , 
        latticeDimension = [2, 2.08],
        intervalCount = 3
    )
{
    echo(DiagonalLattice = 1, frameDimension = frameDimension, frameBoardDimension = frameBoardDimension, latticeDimension = latticeDimension, intervalCount = intervalCount );
    
    translate([frameDimension.x/2, frameDimension.y/2,0])
    rotate([0,0,45])
    translate([-hypotenuse(frameDimension.x, frameDimension.y)/2, -hypotenuse(frameDimension.x, frameDimension.y)/2,0])
    SquareLatticeTrellis
    (
        frameDimension = [hypotenuse(frameDimension.x, frameDimension.y), hypotenuse(frameDimension.x, frameDimension.y)], //[400, 400], 
        frameBoardDimension = frameBoardDimension , 
        latticeDimension = latticeDimension,
        intervalCount = intervalCount
    );
}

module DiagonalLatticeOld
    (
        frameDimension = [ 400,  400],
        frameBoardDimension = [4, 12.7] , 
        latticeDimension = [2, 2.08],
        intervalCount = 3
    )
{
    angle = 45;
    adjustedWidth = frameDimension.x; // - frameBoardDimension.x;

    rotate([-90,0,0])
    translate([- frameBoardDimension.x - 2,0, - frameBoardDimension.x])
    union()
    {
        //bottom
        for(i = [0: (intervalCount - 1)])
        {
            translate(translateBottom(adjWidth = adjustedWidth, latticeThickness = latticeDimension.x, frameThickness = frameBoardDimension.y, i = i))
            rotate([0, angle, 0])
            {
                // color("red")
                cube(size=ApendToV(latticeDimension, latticeLength(width = frameDimension.x, count = intervalCount, angle = angle,  i = i)), center=false);
            }
        }

        //top
        for(i = [1: 1 : (intervalCount - 1)])
        {
            translate(translateTop(adjWidth = adjustedWidth, latticeThickness = latticeDimension.x, frameThickness = frameBoardDimension.y, i = i))
            rotate([180, -angle, 0])
            {
                // color("yellow")
                cube(size=ApendToV(latticeDimension, latticeLength(width = frameDimension.x, count = intervalCount, angle = angle,  i = i)), center=false);
            }
        }

        heightIntervals = latticeHeightCount(frameDimension.y, frameDimension.x, intervalCount) ;
        //left
        for(i = [1: heightIntervals])
        {
            translate(translateLeft( adjWidth = adjustedWidth, latticeThickness = latticeDimension.x, frameThickness = frameBoardDimension.y, i = i))
            rotate([0, angle, 0])
            {
            // color("red")
            cube(size=ApendToV(latticeDimension, latticeLength2(height = frameDimension.y, width = frameDimension.x, count = intervalCount, angle = angle,  i = i)), center=false);
            }
        }    
        
        //Right    
        for(i = [heightIntervals : -1 : 0])
        {
            translate(translateRight( adjWidth = adjustedWidth, latticeThickness = latticeDimension.x, frameThickness = frameBoardDimension.y, i = i))
            rotate([180, -angle, 0])
            {
                // color("yellow")
                cube(size=ApendToV(latticeDimension, latticeLength2(height = frameDimension.y, width = frameDimension.x, count = intervalCount, angle = angle,  i = i)), center=false);
            }
        }         
    }
 
    
    function translateTop(adjWidth, latticeThickness, frameThickness, i) = 
    [
        ((adjWidth/intervalCount * i) + frameThickness/2), 
        latticeThickness, 
        frameDimension.y//-(frameThickness/2 + latticeThickness * cos(angle))
    ];

    function translateBottom(adjWidth, latticeThickness, frameThickness, i) = 
    [
        (adjWidth/intervalCount * i + frameThickness/2), 
        0, 
        (frameThickness/2 + latticeThickness * cos(angle))
    ];

    function translateRight(adjWidth, latticeThickness, frameThickness, i) = 
    [
        frameThickness/2, 
        latticeThickness, 
        frameDimension.y - adjWidth/intervalCount * i + (cos(angle) * latticeThickness)
    ];

    function translateLeft(adjWidth, latticeThickness, frameThickness, i) = 
    [
        frameThickness/2, 
        0, 
        (frameDimension.x/intervalCount * i) + frameThickness/2
    ];  
    
    function latticeHeightCount(frameHeight, frameThickness, intervalCount) = frameHeight /latticeIntervalWidth(frameThickness, intervalCount );
    function latticeLength(width, count, angle,  i) = (1/cos(angle) * IntervalWidth(width, count, i));
    function IntervalWidth(width, count, i) = frameDimension.x - (width/count * i);
    function latticeIntervalWidth(frameThickness, intervalCount ) = frameThickness/intervalCount;
    function latticeLength2(height, width, count, angle,  i) = 
        (1/cos(angle) * (height - (width/ count) * i)) < (1/cos(angle) * width) 
        ? 
            (1/cos(angle) * (height - (width / count) * i)) 
        : 
            (1/cos(angle) * width);
    function latticeMoveX(width, count, i) = (width/ count * i);
}

module DiagonalLattice2
(
    frameDimension = [ 400,  400],
    frameBoardDimension = [4, 12.7] , 
    latticeDimension = [2, 2.08],
    intervalCount = 3
)
{
    angle = 45;
    adjustedWidth = frameDimension.x/intervalCount;
    adjustedHeight = frameDimension.y/intervalCount;
    p0 = [0,0];
    pw = [frameDimension.x/intervalCount, frameDimension.y/intervalCount];
    px = [frameDimension.x, frameDimension.y];

    for (i=[ 0: 1 : intervalCount-1]) 
    {
        let
        ( 

                p1 = i == 0 ? [p0.x, p0.y, 0] : [px.x - (i * pw.x), p0.y, 0], 
                // p2 = [frameDimension.x/2,  frameDimension.y/2 - (i * adjustedHeight) , 0],
                p2 = [ px.x, i ==0 ? px.y : px.y - (i * pw.y), 0],
                // p3 = [(frameDimension.x - (i * adjustedWidth)), 0, 0],
                // p4 = [ 0, frameDimension.y - (i * adjustedHeight), 0]                
                p3 = i == 0 ? [p1.x, p2.y, 0] : [p1.x, px.y, 0],
                p4 = i == 0 ? [px.x, p0.y, 0] : [p0.x, p2.y, 0]
        )
        {
            echo(i = i, p1 = p1, p2 = p2, p3 = p3, p4 = p4);
            if( i == 0)
            {
            // color("pink") 
            point_square(size = latticeDimension, p1 = p1, p2 = p2, zRes = latticeDimension.y);       
            // color("aqua") 
            point_square(size = latticeDimension, p1 = p4, p2 = p3, zRes = latticeDimension.y);            

            }
            else
            {
                // color("red") 
                point_square(size = latticeDimension, p1 = p1, p2 = p2, zRes = latticeDimension.y);                
                // color("blue") 
                point_square(size = latticeDimension, p1 = p2, p2 = p3, zRes = latticeDimension.y);   
                // color("yellow") 
                point_square(size = latticeDimension, p1 = p3, p2 = p4, zRes = latticeDimension.y);                        
                // color("green") 
                point_square(size = latticeDimension, p1 = p4, p2 = p1, zRes = latticeDimension.y); 
            }
        }
    }
}

    // function hypotenuse(a, b) = sqrt((a * a) + (b * b));
    function p2(p1, angle) = [p1.x * cos(angle), p1.y * sin(angle)];