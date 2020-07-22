/*
lib for common constants;
i.e. enums
*/
//machine values
NozzleWidth = 0.8;
LayerHeight = 0.24;
InitialLayerHeight = 0.4;
ISDEBUGEMODE = false;
IS_DEBUG_DEBUG = false;

// test();
// module test(args) {
//  echo(LayersToHeight = LayersToHeight(16));
// }

function LayersToHeight(layers) = 
  // echo(NozzleWidth = NozzleWidth, InitialLayerHeight = InitialLayerHeight, LayerHeight = LayerHeight) 
  InitialLayerHeight + (LayerHeight * (layers - 1));
function HeightToLayers(height) = (height - InitialLayerHeight)/LayerHeight;

function isVector(args) = args.x != undef;
function isString(x) = 
  x == undef      ? false 
  : str(x) == x   ? true
                  : false;

module debugEcho(lable, args, mode) 
{
  bogus = debugDebug(lable, args, mode);
  if(mode || ISDEBUGEMODE)
  {
    let(foobar = fargsEcho(lable, args));
  }
}

function debugDebug(lable, args, mode) = IS_DEBUG_DEBUG ? echo(debugEcho=lable, args, mode) : "";

function fargsEcho(lable, args) = 
let
(
  doOnce = 
  [
    for (one = [1:1])  
      if (isVector(args))
        for(i = [0 : len(args)-1])
          echo(str(str(lable, " ", i ), ": ", args[i]))
      else echo(str(lable, " : ", args))
  ]
) "";

function type(x)=
(
   x==undef?undef
   : floor(x)==x? "int"
   : ( abs(x)+1>abs(x)?"float"
     : str(x)==x?"str"
     : str(x)=="false"||str(x)=="true"?"bool"
     : (x[0]==x[0])&&len(x)!=undef? "arr" // range below doesn't have len
     : let( s=str(x)
         , s2= split(slice(s,1,-1)," : ")
         )
         s[0]=="[" && s[len(s)-1]=="]"
         && all( [ for(x=s2) isint(int(x)) ] )?"range"
        :"unknown"
    )
);

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