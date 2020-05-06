/*

*/
use <vectorHelpers.scad>;

SquareLatticeTrellis();

module SquareLatticeTrellis
    (
        width = 200, 
        height = 400, 
        frameBoardDimension = [20, 40] , 
        latticeDimension = [5, 10],
        intervalCount = 4,
    )
    {
        intervalWidth = (width - frameBoardDimension.x)/ (intervalCount);
        // echo(intervalWidth = intervalWidth);
        //vertical
        for(i = [1 : 1 : intervalCount-1])
        {
            // echo(verticalWidth = i * intervalWidth)
            translate([ frameBoardDimension.x + i * intervalWidth, 0, frameBoardDimension.x/2])
            // color("AntiqueWhite")
            cube(size=ApendToV(latticeDimension, height), center=false);
        }
        //horizontal
        for(i = [1 : 1 : (height/intervalWidth -1)])
        {
            // echo(horizontalWidth = i * intervalWidth)
            translate([ frameBoardDimension.x/2, 0,  frameBoardDimension.x + i * intervalWidth])
            rotate([0, 90, 0])
            // color("AntiqueWhite")
            cube(size=ApendToV(latticeDimension, width), center=false);
        }
    }