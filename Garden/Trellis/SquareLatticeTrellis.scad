/*

*/
use <vectorHelpers.scad>;
use <shapesByPoints.scad>;

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
        intervalWidth = width/ intervalCount;
        echo(intervalWidth = intervalWidth);
        //vertical
        for(i = [1 : 1 : intervalCount-1])
        {
            echo(verticalWidth = i * intervalWidth, latticeDimension = latticeDimension);

            let
            ( 
                p1 = [ i * intervalWidth, 0, 0], 
                p2 = [ i * intervalWidth, height, 0]
            )
            {
                echo(type = "vsrt", p1 = p1, p2 = p2);
                point_square(psqSize = latticeDimension, p1 = p1, p2 = p2, zRes = latticeDimension.y);                
            }

        }
        //horizontal
        verticalWidth = height / intervalCount;
        echo(verticalWidth = intervalWidth, latticeDimension = latticeDimension);
        echo();
        for(i = [0 : 1 :  intervalCount - 1])
        {
            let
            ( 
                p1 = [ 0,verticalWidth + i * verticalWidth, 0], 
                p2 = [ width, verticalWidth + i * verticalWidth, 0]
            )
            {
                echo(type = "horz", i = i, verticalWidth = verticalWidth, p1 = p1, p2 = p2);
                point_square(psqSize = vSwitch(latticeDimension, 0, 1), p1 = p1, p2 = p2, zRes = latticeDimension.y);                
            }
        }
    }