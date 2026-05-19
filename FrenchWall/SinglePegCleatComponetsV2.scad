include <constants.scad>;
include <../FrenchWall/ToolHolders_LibraryV2.scad>;
use <../FrenchWall/ToolHolders_Modules_Library.scad>;
use <../FrenchWall/BitTool_holder.scad>;
use <../FrenchWall/SinglePegCleatProperties.scad>;
use <kvpairs.scad>;

use <convert.scad>;

cleat_thickness = 5.2;

PegStore = 
    [
        ["description", "Peg dimension properties"],
        ["x", convert_in2mm(3/8)],
        ["y", convert_in2mm(3/8)],
        ["z", convert_in2mm(2)],
        ["fragments", 60],
        ["move", [0,kv_get(HammerBackwallStore, "move").y,convert_in2mm(3/8)/2]],
        ["from edge", (kv_get(HammerTrayStore, "x")-convert_in2mm(1))/2],
        ["rotate", [90,0, 0]],
        ["color", "LightBlue"]
    ];

TrayStore = 
    [
        ["description", "dimension properties for tool tray"],
        ["x", convert_in2mm(2/8)],
        ["y", convert_in2mm(2/8)],
        ["z", convert_in2mm(0.75)],
        ["move", [0, 0, 0]],
        ["rotate", [0,0, 0]],
        ["color", "LightGrey"]
    ];

CleatStore = ["description", "CleatStore",
        ["x", kv_get(TrayStore, "x")],
        ["y", cleat_thickness],
        ["z", convert_in2mm(0.75)],
        ["parallelogram length", convert_in2mm(0.75)/sin(45) ],
        ["parallelogram thickness", cleat_thickness],
        ["angle", 135],
        ["extrude height", kv_get(TrayStore, "x")],
        ["move", [0, 0, 0]],
        ["from edge", 0],
        ["rotate", [0,0, 0]],
        ["color", "LightGrey"]
];

BackwallStore = [
    ["description", "BackwallStore"],
    ["x", kv_get(CleatStore, "x")], // make backwall wider than cleat to ensure it can be mounted on wall
    ["y", kv_get(CleatStore, "y")],
    ["z", convert_in2mm(2)],
    ["from edge", 0],
    ["cleat", CleatStore],
    ["move", [0, 0, 0]],
    ["rotate", [0,0, 0]],
    ["color", "LightGrey"]
];

// // echo("Single Peg Cleat Components Properties:");
// echo("PegStore = PegStore");
// debugEcho("PegStore", PegStore, true);
// PegStore2 = kv_set(PegStore, "description", "PegStore2");
// echo();
// debugEcho("PegStore", PegStore2, true);
// // PegStore3 = kv_set(PegStore2, "description", "PegStore3");
// PegStore3 = kv_merge(PegStore2, [["x", 10], ["y", 10], ["z", 10]]);
// echo();
// debugEcho("PegStore", PegStore3, true);

draw_single_peg_cleat_hook(pegLengthInches = 2, pegRadiusInches = 4/8, hull = true); 

module draw_single_peg_cleat_hook(pegLengthInches = 1, pegRadiusInches = 3/8, hull = false)
{
    echo();
    echo(FileName = str(pegLengthInches, "_in_single_peg_cleat.stl"));
    echo();

    pegRadius = convert_in2mm(pegRadiusInches);
    pegAdjStore = kv_merge(PegStore, 
        [
            ["description", str(pegLengthInches, " in_single_peg")], 
            ["x", pegRadius], 
            ["y", pegRadius], 
            ["z", convert_in2mm(pegLengthInches)]
        ]);    

    cleatAdjStore = kv_merge(CleatStore, 
        [
            ["description", str(pegLengthInches, " in_single_peg_cleat")], 
            ["extrude height", pegRadius],
            ["move", [0, 0, pegRadius/2]]
        ]
    );

    backwallAdjStore = kv_merge(BackwallStore, 
        [
            ["x", pegRadius], 
            ["z", pegRadius/2],
            ["cleat", cleatAdjStore], 
            // ["move", [-pegRadius/2, 0, 0]],
            ["description", "BackwallAdjStore"],
            ["filename", "BackwallAdjStore.stl"]
        ]
    );

    if(hull)
    {
        hull()
        {
            applyRotate(pegAdjStore)
            applyExtrude(pegAdjStore)
            moveToOrigin(pegAdjStore)
            drawCircleShape2(pegAdjStore);
        }
    }
    else
    {
        applyRotate(pegAdjStore)
        applyExtrude(pegAdjStore)
        moveToOrigin(pegAdjStore)
        drawCircleShape2(pegAdjStore);
    
    }

    translate([ kv_get(TrayStore, "x"), -3, kv_get(TrayStore, "x")])
    rotate([180, 180, -5 ])
    draw_Cleated_Back_Wall(backwallAdjStore);  
}

module moveToOrigin(properties) 
{
    translate([kv_get(properties, "x")/2, kv_get(properties, "y")/2]) children();
}

module applyExtrude(properties)
{
    linear_extrude(kv_get(properties, "z")) children();
}  

module applyRotate(properties)
{
    rotate(kv_get(properties, "rotate")) children();
}

module draw_Cleated_Back_Wall(properties)
{
    // echo(kv_get(properties, "filename"));
    // properties_echo(properties);
    //now wall and cleat is at [0,0]
    //move to positive 0 x-axis.
    translate([kv_get(properties,"x"),0,0])
    //rotate so cleat is external and wall is located at 0 y-axis
    rotate([0,90,180])
    union()
    {
        //draw wall
        drawSquareShape(properties);    
        //draw cleat
        translate([0, kv_get(properties,"y"), kv_get(properties,"z")])
        draw_parallelogram(kv_get(properties, "cleat"));
    }
}

module draw_parallelogram(properties)
{
    /* visual
    
       D----------C
    A----------B

    height distance between lines AB and CD
    angle is angle of AB and AD
    baselength is where point D intersects line AB.
    */
    // properties_echo(properties);

    length = kv_get(properties, "parallelogram length");
    height = kv_get(properties, "parallelogram thickness");
    angle = kv_get(properties, "angle");    
    base_length = height/tan(angle);
    hypotenuse = sqrt(pow(height, 2) + pow(base_length, 2));
    // echo(length=length, height=height, hypotenuse=hypotenuse);

    A = [ 0, 0 ];
    B = [ length, 0 ];
    C = [ length + base_length, height];
    D = [ base_length, height];

    points = [A, B, C, D];
    // echo(points = points);
    color(kv_get(properties, "color"), 0.5)

    translate([0, 0, -hypotenuse])
    rotate([angle - 90, 0, 0])
    rotate([0,90,0])
    linear_extrude(height = kv_get(properties, "extrude height"), center=false)
    polygon(points=points); 
}