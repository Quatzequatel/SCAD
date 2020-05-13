/*

*/
include <TrellisEnums.scad>;
use <vectorHelpers.scad>;
use <shapesByPoints.scad>;
use <polyline2d.scad>;
use <WaveShapes.scad>;

WaveTrellis();

/*
    frameDimension = Dimension of frame,
    frameBoardDimension = Dimension of board used in frame , 
    latticeDimension = Dimension of lattice within frame,
    waveDimensions = Dimensions of wave [period, amplitude, length, enumWaveType[cos, sine, alternating]],
    intervalCount = 4
*/
module WaveTrellis
    (
        frameDimension = [200, 200],
        frameBoardDimension = [4, 12.7] , 
        latticeDimension = [2, 2.08],
        waveDimensions = [10, 40, 0, enumWaveTypeBoth],
        intervalCount = 3
    )
{
    intervalWidth = frameDimension.y / (intervalCount + 1);
    // intervalWidth = (frameDimension.y - waveDimensions.y) / (intervalCount + 1);
    waveType = waveDimensions[enumWaveType];
    echo(intervalWidth = intervalWidth, frameDimension_y = frameDimension.y, count = (frameDimension.y/intervalWidth -1));
    //vertical
    // translate([ - frameDimension.x/2, - frameDimension.y/2, 0])
     translate([ - frameDimension.x/2, 0, 0])
    {
        for(i = [0 : 1 : intervalCount-1])
        {
            let ( waveType = 
                (
                    waveType == enumWaveTypeBoth ? 
                    ( i % 2 != 0 ? enumWaveTypeCos : enumWaveTypeSin) 
                    : waveType
                )
            )
            {
                // echo(i = i, intervalWidth = intervalWidth,  t = [ 0, ((i * intervalWidth + intervalWidth) + waveDimensions.y/2) - frameDimension.y/2, 0]);
                // translate([ 0, ((i * intervalWidth + intervalWidth) + waveDimensions.y/2) - frameDimension.y/2, 0])
                translate([ 0, ((i * intervalWidth + intervalWidth)) - frameDimension.y/2, 0])
                render() {
                    polyline
                        (
                            [waveDimensions.x, waveDimensions.y, frameDimension.x, waveType],
                            latticeDimension = latticeDimension
                        );                     
                }
            }
        }            
    }
}


//
// wave = [width, height, length, type]
//
module polyline(wave = [0,0,0,0], latticeDimension = [2,2])
{
    // echo(wave = wave);
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