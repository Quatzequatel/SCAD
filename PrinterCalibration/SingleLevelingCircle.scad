
PadOD = 60;
SampleWidth = 30;
PadID = PadOD - SampleWidth;
PadHeight = 0.8;

xFactor = [0,1,-1,1,-1];
yFactor = [0,1,1,-1,-1];
// function xFactor(i) = lookup(i, [0,1,-1,1,-1]);
// function yFactor(i) = lookup(i, [0,1,1,-1,-1]);
$fn=100;

Build();
module Build()
{
    PadCreate(PadOD, PadID, PadHeight);
}

module PadCreate(od, id, height, x=0, y=0, z=0) 
{
    echo("PadCreate", dia=od, height=height, x=x, y=y, z=z);
    translate([ x, y, z]) 
    {
        linear_extrude(height =height)
        difference()
        {
            circle(d=od);        
            circle(d=id);
        }   
    }
}