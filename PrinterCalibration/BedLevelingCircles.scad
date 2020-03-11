
PadDiameter = 30;
PadHeight = 0.4;
PrintOffeset = 20;
PrintBedX = 200 - PrintOffeset - PadDiameter;
printBedY = 200 - PrintOffeset - PadDiameter;
xFactor = [0,1,-1,1,-1];
yFactor = [0,1,1,-1,-1];
// function xFactor(i) = lookup(i, [0,1,-1,1,-1]);
// function yFactor(i) = lookup(i, [0,1,1,-1,-1]);

Build();
module Build()
{
    PrintBedLevelingCircles();
}

module PrintBedLevelingCircles()
{
    for (i=[0:4]) 
    {
        echo(i=i, x=xFactor[i], y= yFactor[i]);
        PadCreate(PadDiameter, PadHeight, xFactor[i] * PrintBedX, yFactor[i] * printBedY);
    }
}

module PadCreate(dia, height, x=0, y=0, z=0) 
{
    echo("PadCreate", dia=dia, height=height, x=x, y=y, z=z);
    translate([ x, y, z]) {
        linear_extrude(height =height)
        circle(d=dia);        
    }
}