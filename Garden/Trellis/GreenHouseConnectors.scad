use <convert.scad>;
use <ShapesByPoints.scad>;
use <vectorHelpers.scad>
//standard
$fn = 60;
NozzleWidth = 1.0;
LayerHeight = 0.24;
InitialLayerHeight = 0.4;
mmPerInch = 25.4;
mmPerFoot = 304.8;
ShowBoards = false;
ShowScrews = false;

//screwenum
esDia = 0;
esHead = 1; 
esType = 2;

esTypeHex = 0;
esTypeRound = 1;

screwDiameter = 5;
screwHeadDia = 10;
screwInfo = [screwDiameter, screwHeadDia, esTypeRound];
// boardwidth = convert_in2mm((1.5 - 1/8)/2); //3/4 in board
boardwidth = 25.5; //greenhouse pipe diameter.
tolerance = NozzleWidth;
connectorID = [boardwidth + tolerance, boardwidth + tolerance];
wallThickness = max(screwHeadDia, 4 * NozzleWidth);
connectorOD = [connectorID.x + wallThickness, connectorID.y + wallThickness];

Build();

module Build() 
{
    RhombicuboctahedronConnector(od = connectorOD, id = connectorID);
    // OctagonConnector(od = connectorOD, id = connectorID);
}

module RhombicuboctahedronConnector(od, id)
{
    echo(od = od, id = id);
    difference()
    {
        rotate([0,0, 22.5])
        sphere(r= od.x + 3, $fn = 8);    
        rotate([90, 0, 0])
        boardvisual(od, id);            


        boardvisual(od, id);

        if(ShowScrews)
            #screwholes(od = connectorOD, id = connectorID, screwInfo=screwInfo);
        else
            screwholes(od = connectorOD, id = connectorID, screwInfo=screwInfo);
        //remove half
        translate([0, 0, -connectorOD.x])
        cube(size=[4*connectorOD.x, 4*connectorOD.y, 2*connectorOD.x], center=true);            
    }

    if(ShowBoards)
    {
        % boardvisual(od, id);       
    }
}

module OctagonConnector(od, id)
{
    rotate([180, 0, 0])
    union()
    {
        echo(od = od, id = id);
        difference()
        {
            rotate([0,0, 22.5])
            cylinder(r=od.x, h=od.y, $fn = 8, center=true);
            
            boardvisual(od, id);

            if(ShowScrews)
                #screwholes(od = connectorOD, id = connectorID, screwInfo=screwInfo);
            else
                screwholes(od = connectorOD, id = connectorID, screwInfo=screwInfo);
            //remove half
            translate([0, 0, -connectorOD.x])
            cube(size=[4*connectorOD.x, 4*connectorOD.y, 2*connectorOD.x], center=true);            
        }

        if(ShowBoards)
        {
            % boardvisual(od, id);       
        }       
    }

}

module screwholes(od, id, screwInfo)
{
    for(i = [0 : 1 : 3])
    {
        echo(angle = i * 90 + 45);
        let ( x = cos(i * 90 + 45) * (id.x + NozzleWidth), y = sin(i * 90 + 45) * (id.x + NozzleWidth) )
        {
            p1 = [x, y, id.x];
            p2 = [x, y, -id.x];

            point_sphere(diameter = screwInfo.x, p1=p1, p2=p2);     
            if(screwInfo.z == esTypeHex)
            {
                //screw hex
                point_circle
                    (
                        diameter = screwInfo.y, 
                        p1=vSetValue(v = p1, idx = 2, value = od.y ), 
                        p2=vSetValue(v = p1, idx = 2, value = id.y - screwInfo.y), 
                        fn = 6
                    );                 
            }
            else
            {
                //screw head
                point_sphere
                    (
                        diameter = screwInfo.y, 
                        p1=vSetValue(v = p1, idx = 2, value = od.y), 
                        p2=vSetValue(v = p1, idx = 2, value = id.y -(0.5 * screwInfo.y)), 
                        fn = 100
                    );                   
            }
           
        }
    }
    // zscrewholes(od = od, id = id, screwInfo = screwInfo);
}

module zscrewholes(od, id, screwInfo) 
{
    scalexy = 2;
    for(i = [0 : 1 : 3])
    {
        echo(angle = i * 90);
        let ( x = cos(i * 90 ) * (id.x + screwInfo.x), y = sin(i * 90) * (id.x + screwInfo.x) )
        {
            p1 = [x, y, id.x];
            p2 = [-x, -y, id.x];

            point_sphere(diameter = screwInfo.x, p1=p1, p2=p2); 
            //screw head
            point_sphere
                (
                    
                    diameter = screwInfo.y, 
                    p1=[x - (cos(i * 90) * screwInfo.y/scalexy), y - (sin(i * 90) * screwInfo.y/scalexy), id.x ], 
                    p2=[x - (cos(i * 90) * screwInfo.y/scalexy), y - (sin(i * 90) * screwInfo.y/scalexy), id.x ], 
                    fn = 100
                );                  
        }
    }
}


module boardvisual(od, id) 
{
        boardheight = 5 * id.x;
        rotate([90,0,0])
        translate([0, 0, - boardheight/2])
        linear_extrude(height = boardheight)
        square(size=id, center=true);

        rotate([0,90,0])
        translate([0, 0, - boardheight/2])
        linear_extrude(height = boardheight)
        square(size=id, center=true);    
}

