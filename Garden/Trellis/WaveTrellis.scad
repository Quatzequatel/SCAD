/*

*/
include <TrellisEnums.scad>;
use <vectorHelpers.scad>;
use <shapesByPoints.scad>;
use <polyline2d.scad>;
use <WaveShapes.scad>;

WaveTrellis();

module WaveTrellis
    (
        frameDimension = [200, 400],
        frameBoardDimension = [4, 12.7] , 
        latticeDimension = [2, 2.08],
        waveDimensions = [10, 38, 0, enumWaveTypeCos],
        intervalCount = 4
    )
{
    intervalSize = frameDimension.y/ intervalCount;
    echo(intervalSize = intervalSize);
    //vertical
    translate([ - frameDimension.x/2, - frameDimension.y/2, 0])
    {
        for(i = [1 : 1 : (frameDimension.y/intervalSize -1)])
        {
            translate([ 0, frameBoardDimension.y + i * intervalSize, 0])
            render() {
                polyline
                    (
                        [waveDimensions.x, waveDimensions.y, frameDimension.x, waveDimensions[enumWaveType]],
                        latticeDimension = latticeDimension
                    );                     
            }
        }            
    }
}

//
// wave = [width, height, length, type]
//
module polyline(wave = [0,0,0,0], latticeDimension = [2,2])
{
    echo(wave = wave);
    if(enumWaveTypeCos == wave[enumWaveType])
    {
        linear_extrude(latticeDimension.x)
        polyline2d
            (
                points = polyCosWave
                            (
                                width = wave.x, 
                                height = wave.y,
                                length = wave.z
                            ), 
                width =  latticeDimension.y
            );
    }
    else 
    {
        linear_extrude(latticeDimension.x)
        polyline2d
            (
                points = polySinWave
                            (
                                width = wave.x, 
                                height = wave.y,
                                length = wave.z
                            ), 
                width = latticeDimension.y
            );        
    }
}