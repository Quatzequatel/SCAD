TotalWidth = 100;
TotalLength = 100;
InitialThickness = 2; //orginal 2
FinalThickness = 10; //50 for high side.

function quarterLength() = TotalLength/8;
function halfLength() = TotalLength/2;

/*
Notes: 3/30; Added halfLength to make smaller end longer and more flexible.
        and shorten the handle to get into smaller spaces.
*/

union()
{
    //for(j=[0:5])
        for(i = [0:10:FinalThickness])
        {
            
            if(i != 0) 
                {
                    translate([halfLength() + quarterLength()*(i/10)*(i-10),0,0])
                    cube([quarterLength() ,TotalWidth,i]); 
                }
                else 
                {
                    cube([halfLength() ,TotalWidth,InitialThickness]);
                }
            echo(i);
        }
    
}