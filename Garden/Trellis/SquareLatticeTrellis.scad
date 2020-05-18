/*

*/
use <vectorHelpers.scad>;
use <shapesByPoints.scad>;

SquareLatticeTrellis();

module SquareLatticeTrellis
    (
        frameDimension = [200 , 200],
        frameBoardDimension = [20, 40] , 
        latticeDimension = [5, 10],
        intervalCount = 4,
    )
    {
        intervalWidth = frameDimension.x/ intervalCount+1;
        echo(intervalWidth = intervalWidth);
        //vertical
        for(i = [1 : 1 : intervalCount - 1])
        {
            echo(verticalWidth = i * intervalWidth, latticeDimension = latticeDimension);

            let
            ( 
                p1 = [ i * intervalWidth, 0, 0], 
                p2 = [ i * intervalWidth, frameDimension.y, 0]
            )
            {
                echo(type = "vsrt", p1 = p1, p2 = p2);
                point_square(size = latticeDimension, p1 = p1, p2 = p2, height = latticeDimension.y);                
            }

        }
        //horizontal
        verticalWidth = frameDimension.y / intervalCount+1;
        echo(verticalWidth = intervalWidth, latticeDimension = latticeDimension);
        echo();
        for(i = [0 : 1 :  intervalCount - 2])
        {
            let
            ( 
                p1 = [ 0,verticalWidth + i * verticalWidth, 0], 
                p2 = [ frameDimension.x, verticalWidth + i * verticalWidth, 0]
            )
            {
                echo(type = "horz", i = i, verticalWidth = verticalWidth, p1 = p1, p2 = p2);
                // color("blue")
                point_square(size = vSwitch(latticeDimension, 0, 1), p1 = p1, p2 = p2, height = latticeDimension.y);                
            }
        }
    }