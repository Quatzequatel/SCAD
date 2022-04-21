/*
lib for common constants;
i.e. enums
*/
//machine values
NozzleWidth = 0.4;
LayerHeight = 0.2;
InitialLayerHeight = 0.28;
ISDEBUGEMODE = false;
IS_DEBUG_DEBUG = false;

// test();
// module test(args) {
//  echo(LayersToHeight = LayersToHeight(16));
// }

//puts a foot scale on X and Y axis for point of reference.
module scale(size = 24, increment = convert_in2mm(1), fontsize = 12)
{
  if($preview)
  {
    for (i=[-size:size]) 
    {
        translate([f(i, increment), 0, 0])
        color("red", 0.5)
        union()
        {
            text(text = str(i), size = fontsize);
            rotate([90,0])
            cylinder(r=0.5, h=f(1, increment), center=true);
        }

        translate([0, f(i, increment), 0])
        color("green", 0.5)
        union()
        {
            text(text = str(i), size = fontsize);
            rotate([0,90])
            cylinder(r=0.5, h=f(1, increment), center=true);
        }   
    }     
  }
}

module properties_echo(property)
{
  echo(parent_module(1));
  debugEcho(property.x, property, true);
  echo();
}

module debug_callstack()
{
  echo(parent = parent_module(2), child = parent_module(1));
}

function f(i, increment) = i * increment;

function LayersToHeight(layers) = 
  // echo(NozzleWidth = NozzleWidth, InitialLayerHeight = InitialLayerHeight, LayerHeight = LayerHeight) 
  InitialLayerHeight + (LayerHeight * (layers - 1));
function HeightToLayers(height) = (height - InitialLayerHeight)/LayerHeight;

// returns mm for requested wall count based on NozzelWidth.
function WallThickness(wall_line_count = 1) = wall_line_count > 0 ? wall_line_count * NozzleWidth : wall_line_count;

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

function fargsEcho(lable, args) = echo(parent = parent_module(2), child = parent_module(1))
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
HexBitHoleDia = 8 + 0.6;      // standard hex bit diameter, Actual bit value 7.28. Printed value = 6.71,
                              // value (8) - printed actual (6.71) = 1.29

GRK_cabinet_screw_head_dia = 11;
GRK_cabinet_screw_shank_dia = 4.1656;

ziptie_width = 5;
ziptie_thickness = 1.38;

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