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
        frameProperties,
        waveDimensions = [10, 40, 0, enumWaveTypeBoth]
    )
{
    intervalWidth = frameProperties[enumPropertyFrame].y / (frameProperties[enumPropertyInterval] + 1);
    // intervalWidth = (frameDimension.y - waveDimensions.y) / (intervalCount + 1);
    waveType = waveDimensions[enumWaveType];
    echo(intervalWidth = intervalWidth, frameDimension_y = frameProperties[enumPropertyFrame].y, count = (frameProperties[enumPropertyFrame].y/intervalWidth -1));
    //vertical
    // translate([ - frameDimension.x/2, - frameDimension.y/2, 0])
     translate([ - frameProperties[enumPropertyFrame].x/2, 0, 0])
    {
        for(i = [0 : 1 : frameProperties[enumPropertyInterval]-1])
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
                translate([ 0, ((i * intervalWidth + intervalWidth)) - frameProperties[enumPropertyFrame].y/2, 0])
                render() {
                    polyline
                        (
                            [waveDimensions.x, waveDimensions.y, frameProperties[enumPropertyFrame].x, waveType],
                            latticeDimension = frameProperties[enumPropertyLattice]
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