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
            translate([x*spacing,y*spacing,tubelength/2])
            tube(outerDiameter,tubeThickness,tubelength);
        }
        
        cornerPillers(rows,columns, spacing, matThickness,outerDiameter,tubeThickness,tubelength);
    }
    
    echo("Dimension is :",(rows*spacing),(columns*spacing));
}

module mat(rows,columns, spacing, matThickness,outerDiameter,tubelength)
{
        difference()
        {
            cube([(rows+1)*spacing,(columns+1)*spacing,matThickness]);
            for(x = [1:rows], y =[1:columns])
            {
                //note: the /3 below is insurance that -tube is below the cube plane.
                translate([x*spacing,y*spacing,tubelength/3])
                cylinder($fn=100,tubelength,d=outerDiameter,center=true);
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
    collarSpace = 14;
    pillarWidth = outerDiameter/2;
    pillarDepth = pillarWidth;
    pillarHeight = tubelength+collarSpace;
    zMove = pillarHeight/2;
    xMove = -pillarWidth/2;
    yMove = -pillarDepth/2;
    
    echo("cornerPillers(passed param)",rows,columns, spacing, matThickness,outerDiameter,tubeThickness,tubelength);
    echo("cornerPillers()",pillarWidth,pillarDepth,pillarHeight,collarSpace,zMove);
    //1
    translate([-xMove,-yMove,zMove])
    cube([pillarWidth,pillarDepth,pillarHeight],true);
    //2
    translate([-xMove,yMove+(columns+1)*spacing,zMove])
    cube([pillarWidth,pillarDepth,pillarHeight],true);
    //3
    translate([xMove+(rows+1)*spacing,-yMove,zMove])
    cube([pillarWidth,pillarDepth,pillarHeight],true);
    //4
    translate([xMove+(rows+1)*spacing,yMove+(columns+1)*spacing,zMove])
    cube([pillarWidth,pillarDepth,pillarHeight],true);
    
}

module main()
{
    rows = 4;
    coluumns=4;
    spacing=18.75;
    matThickness=2;
    tubediameter=19.05;
    tubeThickness=1;
    tubeLength=25.4;
    tubeMatrix(rows,coluumns,spacing,matThickness,tubediameter,tubeThickness,tubeLength);

}

main();