include <constants.scad>;

use <convert.scad>;
use <trigHelpers.scad>;
use <ObjectHelpers.scad>;
use <kvpairs.scad>;

//// This file is for modifying the STL files of the bases to add holes for screws and to remove material to make them lighter.
// The modified STL files will be saved with the name "modified_base_[number].stl" where [number] is the number of the base being modified.
StorePoints =
[
    ["description", "dimension properties for tool tray"],
    ["9", [105.8, 45.63]],
    ["2", [106.8, 45.63]],
    ["6", [105.8, 45.63]],
    ["1", [76.5, 45.63]],
    ["start", [19.6, 45.63]],
    ["end", [14.6, 45.63]]
];

    points9 = 
    [
        [54, 22.5],
        [-52, 22.5],
        [-52, -22.5],
        [54, -22.5],        
    ];

build();

module build(args) 
{
    // modify_base_start();
    // modify_base_end();
    color("yellow", 1)
        modify_base(1);

    translate([1, 0, 30.25+3])
    linear_extrude(height=3, center=true, convexity=10)
    square([kv_get(StorePoints, "1").x + 5, kv_get(StorePoints, "1").y + 5], center=true);

    translate([1, 0, 30.25])
    linear_extrude(height=3, center=true, convexity=10)
    square(kv_get(StorePoints, "1"), center=true);

    translate([54, 22.5, 30.25])
    #cylinder(d=0.2, h=45, center=true, $fn=100);
    
    translate([-52, 22.5, 30.25])
    #cylinder(d=0.2, h=45, center=true, $fn=100);
    
    translate([54, -22.5, 30.25])
    #cylinder(d=0.2, h=45, center=true, $fn=100);
    
    translate([-52, -22.5, 30.25])
    #cylinder(d=0.2, h=45, center=true, $fn=100);

}

module modify_base(args) 
{
    echo();
    echo(FileName = str("modified_base_",args,".stl"));
    echo();

    difference() 
    {
        import_base(args);

        if (args == 1) 
        {
            draw_screw_holes([33,8,12.25, args]);    

            color("LightGrey")
            translate([-1, 4, 0]) 
            cube(size=[30, 15, 20], center=true);   

        }
        if (args == 2) 
        {
            draw_screw_holes([48.5,8,12.25, args]);    

            color("LightGrey")
            translate([-1, 4, 0]) 
            cube(size=[30, 15, 20], center=true);   
        }
        if (args == 6) 
        {
            draw_screw_holes([6.5,8,12.25, args]);    

            color("LightGrey")
            translate([-1, 1, 0]) 
            cube(size=[30, 10, 20], center=true);   
        }        
        if (args == 9) 
        {
            draw_screw_holes([16.8,8,12.25, args]);    


            color("LightGrey")
            translate([4, 1, 0]) 
            cube(size=[30, 10, 20], center=true);   
        }        

    }
    
}

module draw_screw_holes(args) 
{
    height = 45;
    diameter = 4.23;

    if(args[3] == 1) 
    {
        echo("Drawing screw holes for Base_ " , args[3]);

        translate([args[0],args[1],args[2]])
        cylinder(d=diameter, h=height, center=true, $fn=100);
        translate([args[0],args[1],args[2]]+[0,-19,0])
        cylinder(d=diameter, h=height, center=true, $fn=100);

        translate([args[0],args[1],args[2]]+[-69.7,0,0])
        cylinder(d=diameter, h=height, center=true, $fn=100);
        translate([args[0],args[1],args[2]]+[-69.7,-19,0])
        cylinder(d=diameter, h=height, center=true, $fn=100);        
    }
    else if(args[3] == 2) 
    {
        echo("Drawing screw holes for Base_ " , args[3]);

        #translate([args[0],args[1],args[2]])
        cylinder(d=diameter, h=height, center=true, $fn=100);
        translate([args[0],args[1],args[2]]+[0,-19,0])
        cylinder(d=diameter, h=height, center=true, $fn=100);

        translate([args[0],args[1],args[2]]+[-100,0,0])
        cylinder(d=diameter, h=height, center=true, $fn=100);
        translate([args[0],args[1],args[2]]+[-100,-19,0])
        cylinder(d=diameter, h=height, center=true, $fn=100);        
    }
    if(args[3] == 6) 
    {
        echo("Drawing screw holes for Base_ " , args[3]);

        translate([args[0],args[1],args[2]])
        #cylinder(d=diameter, h=height, center=true, $fn=100);
        translate([args[0],args[1],args[2]]+[0,-19,0])
        #cylinder(d=diameter, h=height, center=true, $fn=100);

        translate([args[0],args[1],args[2]]+[-20.25,0,0])
        #cylinder(d=diameter, h=height, center=true, $fn=100);
        translate([args[0],args[1],args[2]]+[-20.25,-19,0])
        #cylinder(d=diameter, h=height, center=true, $fn=100);        
    }
    if(args[3] == 9) 
    {
        echo("Drawing screw holes for Base_ " , args[3]);

        translate([args[0],args[1],args[2]])
        cylinder(d=diameter, h=height, center=true, $fn=100);
        translate([args[0],args[1],args[2]]+[0,-19,0])
        cylinder(d=diameter, h=height, center=true, $fn=100);

        translate([args[0],args[1],args[2]]+[-24.8,0,0])
        cylinder(d=diameter, h=height, center=true, $fn=100);
        translate([args[0],args[1],args[2]]+[-24.8,-19,0])
        cylinder(d=diameter, h=height, center=true, $fn=100);        
    }    

}

module import_base(args) 
{
    translate([0, 0, 30.25])
    rotate([0, 180, 0]) 
    import(str("Base_",args,".stl"), convexity=10);

    // color("LightGrey")
    // translate([-3, 25.5, 11]) 
    // cube(size=[12, 5, 20], center=true);   
}

module modify_base_start(args) 
{
    echo();
    echo(FileName = "modified_base_start.stl");
    echo();

    import("Base_Start.stl");

    color("LightGrey")
    translate([-3, 25.5, 11]) 
    cube(size=[12, 5, 20], center=true);    
}

module modify_base_end(args) {
    echo();
    echo(FileName = "modified_base_end.stl");
    echo();

    difference() 
    {
        import("Base_End.stl");

        color("LightGrey")
        translate([15,0,13]) 
        cube(size=[7.5, 12.5, 7.5], center=true);   
    } 
}