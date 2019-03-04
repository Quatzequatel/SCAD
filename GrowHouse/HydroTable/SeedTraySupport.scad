
cubeRows=3;
cubeColumns=3;
Thickness=2;
CubeSpacing=5;


cubeWidth = 15;
cubeHeight = 57;
drillHole = 12;
drillRadius = 1.5;
drillHoleLength = 14;



spokeCount=24;
spokerows=8;
spokeDia=15;
spokeY=2;
wallWidth=2;

Manafold();

function moveCubeX(x) = (cubeWidth+CubeSpacing)*(x-1);
function moveCubeY(y) = (cubeWidth+CubeSpacing)*(y-1);
function drillHoleX(x) = moveCubeX(x) + (cubeWidth/2);
function drillHoleY(y) = moveCubeY(y) + (cubeWidth/2);
function drillHoleZ() = cubeHeight - drillHole;

module Manafold()
{

        for(x = [1:cubeColumns], Y =[1:cubeRows])
        {
            difference()
            {
            translate([moveCubeX(x), moveCubeY(Y) ,0])
            cube([cubeWidth,cubeWidth,cubeHeight], false);
            translate([drillHoleX(x), drillHoleY(Y),drillHoleZ()])
             color("Green")cylinder($fn=100,drillHoleLength,drillRadius,drillRadius,center=false);
            }
        }
        
}
