
ShelfWidth=450;
ShelfLength=1220;
Seedrows=8;
Seedcolumns=3;
OutsideMargin=8;

PodSize=95;
PodSpace=40;
PodSpaceX=0;
PodSpaceY=0;

//union()
//{
//    cube([ShelfWidth,ShelfLength,1]);
//    
//    for(x = [0:Seedcolumns], Y =[0:Seedrows])
//    {
//            echo(Y=Y, x=x);
//           translate([((PodSize+PodSpace)*x+(PodSize/2)+OutsideMargin ), ((PodSize+PodSpace)*Y+(PodSize/2)+OutsideMargin),-1]) color("Blue") cylinder(h=20, r=(PodSize/2), center=true);
//            //echo(Y=Y, x=1);
//        echo(x=x, Y=Y);
//    }
//}
    
    module Mesh(BaseX,Height,TopX,center)
{
    cylinder(BaseX,Height,TopX,$fn=4);
}

module main(columns, rows, podSize, Width, Length)
{
    usedWidth = (columns) * podSize;
    usedLength = (rows)*podSize;
    
    PodSpaceX = (ShelfWidth - usedWidth)/(columns+1);
    PodSpaceY = (ShelfLength - usedLength)/(rows+1);
    
    echo(usedWidth=usedWidth, usedLength=usedLength,PodSpaceX=PodSpaceX,PodSpaceY=PodSpaceY);
    
    Tray(columns,rows,PodSpaceX, PodSpaceY);
}

module Tray(seedcolumns, seedrows, podSpaceX, podSpaceY)
{
    
  union()
    {
        cube([ShelfWidth,ShelfLength,1]);
        
        echo(PodSize=PodSize,podSpaceX=podSpaceX,podSpaceY=podSpaceY);
        for(x = [1:seedcolumns], Y =[1:seedrows])
        {
//                echo(Y=Y, x=x);
               translate([((PodSize/2 * x) + (podSpaceX * x)  ), ((PodSize) * Y + (podSpaceY * Y) ),-1]) color("Blue") cylinder(h=20, r=(PodSize/2), center=true);
                //echo(Y=Y, x=1);
//            echo(x=x, Y=Y);
        }
    }  
}

main(Seedcolumns, Seedrows, PodSize, ShelfWidth, ShelfLength);
