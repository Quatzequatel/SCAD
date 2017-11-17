




module OpenBox(length, width, height, wallThickness, center=true)
{
    echo(length=length, width=width, height=height, wallThickness=wallThickness, center=center)
    //union()
    //{
        color("red") cube([length, width, height], center=center);
        //translate([0,0,wallThickness])color("pink") cube(length-wallThickness,width-wallThickness,height, center=center);
    //}
}


module TestOpenBox()
{
    OpenBox(20,20,5,2);
}


//run tests
TestOpenBox();