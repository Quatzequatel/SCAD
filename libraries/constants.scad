/*
lib for common constants;
i.e. enums
*/
//machine values
NozzleWidth = 1.0;
LayerHeight = 0.24;
InitialLayerHeight = 0.4;

//enums
enThickness = 0;
enWidth = 1;
enDepth = 1; 
enLength = 2;

enX = 0;
enY = 1;
enZ = 2;

//measurements
mmPerInch = 25.4;
mmPerFoot = 12 * mmPerInch;
cmPerInch = mmPerInch/10;
inchesInFoot = 12;
FeetInInch = 1/inchesInFoot;

CubeFaces = [
  [0,1,2,3],  // bottom
  [4,5,1,0],  // front
  [7,6,5,4],  // top
  [5,6,2,1],  // right
  [6,7,3,2],  // back
  [7,4,0,3]]; // left