gap = 9;
bandlength =80;
seedcube =23;
bandwidth=35;
//totalbandlength=gap+bandlength+gap
centerpoint= (bandlength/2)+gap;

linear_extrude(3) difference(){
square([bandwidth,gap+bandlength+gap]);
 
    translate([OffsetY(),OffsetX(gap),0]){square(seedcube);}
    translate([OffsetY(),OffsetSeedCube(OffsetX()*2),0])square(seedcube);
}

function OffsetX(x=0)=(((bandlength/2)-seedcube)/2)+x;

function OffsetY(y=0)=((bandwidth-seedcube)/2)+y;

function OffsetSeedCube(x=0) = OffsetX(gap)+seedcube+x;
