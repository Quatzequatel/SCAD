/*
lib for common constants;
i.e. enums
*/
//machine values
NozzleWidth = 1.0;
LayerHeight = 0.24;
InitialLayerHeight = 0.4;
ISDEBUGEMODE = true;

function LayersToHeight(layers) = 
  echo(NozzleWidth = NozzleWidth, InitialLayerHeight = InitialLayerHeight, LayerHeight = LayerHeight) 
  InitialLayerHeight + (LayerHeight * (layers - 1));
function HeightToLayers(height) = (height - InitialLayerHeight)/LayerHeight;

function isVector(args) = args.x != undef;

module debugEcho(lable, args) 
{
  if(ISDEBUGEMODE)
  {
    let(foobar = fargsEcho(lable, args));
  }
}

function fargsEcho(lable, args) = 
isVector(args) ?
[   for(i = [0 : len(args)-1])
       echo(str(lable, " ", i ), args[i])
] : echo(lable, args);

// function debugEcho(lable, value) =
// let
// (
//     nothing = 
//         [ 
//             for (i = [1:1]) 
//                 if (ISDEBUGEMODE) echo(str(lable, ": ", value)) 
//         ]
        
// ) "";

// function fargsEcho(lable, args) = 
// let
// (
//   doOnce = 
//   [
//     for (one = [1:1])  
//       if (args.x != undef)
//       if (ISDEBUGEMODE)
//         for(i = [0 : len(args)-1])
//           echo(str(str(lable, " ", i ), ": ", args[i]))
//       else echo(str(lable, "xxxxx : ", args))
//   ]
// ) "";

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

//Mounting holes
woodscrewHeadRad = 4.6228;  //Number 8 wood screw head radius
woodscrewThreadRad = 2.1336;    //Number 8 wood screw thread radius
woodscrewHeadHeight = 2.8448;  //Number 8 wood screw head height

woodScrewShankDiaN_4 = 0.112 * mmPerInch;
woodScrewShankDiaN_5 = 0.125 * mmPerInch;
woodScrewShankDiaN_6 = 0.138 * mmPerInch;
woodScrewShankDiaN_7 = 0.151 * mmPerInch;
woodScrewShankDiaN_8 = 0.164 * mmPerInch;
woodScrewShankDiaN_9 = 0.177 * mmPerInch;
woodScrewShankDiaN_10 = 0.190 * mmPerInch;

CubeFaces = [
  [0,1,2,3],  // bottom
  [4,5,1,0],  // front
  [7,6,5,4],  // top
  [5,6,2,1],  // right
  [6,7,3,2],  // back
  [7,4,0,3]]; // left