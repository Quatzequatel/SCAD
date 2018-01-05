/*
seed tray 1/2/2018
*/


module squareTube(innerWidth, innerDepth, innerHeight, wallThickness)
{
    difference()
    {
    echo("squareTube()",OuterWidth(innerWidth), OuterLength(innerDepth), OuterHeight(innerHeight),wallThickness);
    cube([OuterWidth(innerWidth), OuterLength(innerDepth), OuterHeight(innerHeight)], false);
    translate([Build != Build_SpacerJig ? wallThickness : wallThickness+SpacerHeight, wallThickness,-1])
        cube([innerWidth, innerDepth, OuterHeight(innerHeight)+2], false);
    }
}

module tube(outerDiameter,wallThickness,length)
{
    difference()
    {
//        echo("tube()",outerDiameter,length,wallThickness);
        cylinder($fn=100,length,d=outerDiameter,center=true);
        translate([0,0,0])
        cylinder($fn=100,length+1,d=(outerDiameter-wallThickness),center=true);
    }
}

module tubeMatrix(rows,columns, spacing, matThickness,outerDiameter,tubeThickness,tubelength)
{
    union()
    {
        mat(rows,columns, spacing, matThickness,outerDiameter,tubelength);

        for(x = [1:rows], y =[1:columns])
        {
            translate([matXmove(x,spacing),matYmove(y,spacing),tubelength/2])
            tube(outerDiameter,tubeThickness,tubelength);
        }
        
        cornerPillers(rows,columns, spacing, matThickness,outerDiameter,tubeThickness,tubelength);
    }
    
    echo("Dimension is :",(rows*spacing),(columns*spacing));
}

function matWidth(rows,spacing)= rows*spacing + spacing/2;
function matDepth(columns,spacing)= matWidth(columns,spacing);
function matXmove(x,spacing) = x*spacing-(spacing/3);
function matYmove(y,spacing) = matXmove(y,spacing);

function includeNibs()=false;
function nibpoints()=[[0,0],[3,0],[5,2],[-2,2]];

module mat(rows,columns, spacing, matThickness,outerDiameter,tubelength)
{
        difference()
        {
            cube([matWidth(rows,spacing),matDepth(columns,spacing),matThickness]);
            for(x = [1:rows], y =[1:columns])
            {
                //note: the /3 below is insurance that -tube is below the cube plane.
                translate([matXmove(x,spacing),matYmove(y,spacing),tubelength/3])
                cylinder($fn=100,tubelength,d=outerDiameter,center=true);
            }
            
            if(includeNibs() == true)
            {
                translate([matWidth(rows,spacing),matDepth(columns,spacing)/2-3,matThickness/2])
                createNib(rows,columns, spacing, matThickness,[180,180,270]);
                
                translate([matWidth(rows,spacing)/2,matDepth(columns,spacing),matThickness/2])
                createNib(rows,columns, spacing, matThickness,[180,0,0]);
            }
        }    
}

module squareTube(innerWidth, innerDepth, innerHeight, wallThickness)
{
    difference()
    {
    echo("squareTube()",OuterWidth(innerWidth), OuterLength(innerDepth), OuterHeight(innerHeight),wallThickness);
    cube([OuterWidth(innerWidth), OuterLength(innerDepth), OuterHeight(innerHeight)], false);
    translate([Build != Build_SpacerJig ? wallThickness : wallThickness+SpacerHeight, wallThickness,-1])
        cube([innerWidth, innerDepth, OuterHeight(innerHeight)+2], false);
    }
}

module cornerPillers(rows,columns, spacing, matThickness,outerDiameter,tubeThickness,tubelength)
{
    collarSpace = 12;
    pillarWidth = outerDiameter/4;
    pillarDepth = pillarWidth;
    pillarHeight = tubelength+collarSpace;
    zMove = pillarHeight/2;
    xMove = -pillarWidth/2;
    yMove = -pillarDepth/2;
    
//    echo("cornerPillers(passed param)",rows,columns, spacing, matThickness,outerDiameter,tubeThickness,tubelength);
//    echo("cornerPillers()",pillarWidth,pillarDepth,pillarHeight,collarSpace,zMove,xMove,yMove);
    //1
    translate([-xMove,-yMove,zMove])
    cube([pillarWidth,pillarDepth,pillarHeight],true);
    //2
    translate([-xMove,7+(columns*spacing),zMove])
    cube([pillarWidth,pillarDepth,pillarHeight],true);
    //3
    translate([7+(rows)*spacing,-yMove,zMove])
    cube([pillarWidth,pillarDepth,pillarHeight],true);
    //4
    translate([7+(rows)*spacing,7+(columns)*spacing,zMove])
    cube([pillarWidth,pillarDepth,pillarHeight],true);
    
    //nibs
    if(includeNibs() == true)
    {
        translate([matWidth(rows,spacing)/2,0,matThickness/2])
        createNib(rows,columns, spacing, matThickness,[180,0,0]);
        
        translate([0,matDepth(columns,spacing)/2,matThickness/2])
        createNib(rows,columns, spacing, matThickness,[180,0,270]);
    }

}

module createNib(rows,columns, spacing, matThickness,rotation)
{
    rotate(rotation)
    linear_extrude(height = matThickness, center = true, convexity = 10, scale=[1,1], $fn=100)
    polygon(nibpoints(),10);    
}

module main()
{
    rows = 20;
    coluumns=20;
    spacing=19.5;
    matThickness=2;
    tubediameter=19.05;
    tubeThickness=1;
    tubeLength=25.4;
    tubeMatrix(rows,coluumns,spacing,matThickness,tubediameter,tubeThickness,tubeLength);

}

main();