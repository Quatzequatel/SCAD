include <constants.scad>;
include <FencePanel-do.scad>;

use <convert.scad>;
use <trigHelpers.scad>;
use <ObjectHelpers.scad>;
use <dictionary.scad>;
$fn = 100;


build();

module build(args) 
{


    draw_post_pair(fence_post, fence_post_trim);

    translate([0, 0, convert_mm2in(-2)])
    draw_horizontal_boards();

}

module draw_brick(args)
{
    // moveTo(args, "loc")
    applyColor(args)
    applyExtrude(args)
    drawSquare(args);
}

module draw_horizontal_boards()
{
    // translate([0, 0, convert_mm2in(-1)])
    union()
    {
        //base boards
        // for(i = [1:2])
        // {
        //     // color(gdv(fence_4inch_board, "color"), 0.9)
        //     applyColor(fence_4inch_board, 0.5)
        //     move_board_up(spacing(spacers = i+1, thin_boards = 0, thick_boards = i))
        //         extrudeZaxis(fence_4inch_board);        
        // }
        
        // move_board_up(spacing(spacers = 3, thin_boards = 0, thick_boards = 3))
        for (panel=[0:gdv(fence_post, "loc Count")-2]) 
        {
            if(panel == 0)
            {
                moveTo(fence_post, str("vert ", panel + 2))
                translate([panel * (gdv(fence_panel, "x")  + gdv(fence_post_trim, "x")), 0, 0])
                draw_fence_boards(fence_post, fence_4inch_board, 11);
            }
            if (panel == 1) 
            {
                translate([0,0,convert_in2mm(2)])
                moveTo(fence_post, str("vert ", panel + 2))
                translate([panel * (gdv(fence_panel, "x")  + gdv(fence_post_trim, "x")), 0, 0])
                draw_fence_boards(fence_post, fence_4inch_board, 12);
            } 
            if (panel == 2) 
            {
                translate([0,0,convert_in2mm(2)])
                moveTo(fence_post, str("vert ", panel + 2))
                translate([panel * (gdv(fence_panel, "x")  + gdv(fence_post_trim, "x")), 0, 0])
                draw_fence_boards(fence_post, fence_4inch_board, 13);
            } 
            if (panel == 3) 
            {
                translate([0,0,convert_in2mm(3)])
                moveTo(fence_post, str("vert ", panel + 2))
                translate([panel * (gdv(fence_panel, "x")  + gdv(fence_post_trim, "x")), 0, 0])
                draw_fence_boards(fence_post, fence_4inch_board, 12);
            }             
            if (panel == 4) 
            {
                // color("yellow", 0.5)
                translate([0,0,convert_in2mm(3)])
                moveTo(fence_post, str("vert ", panel + 2))
                translate([panel * (gdv(fence_panel, "x")  + gdv(fence_post_trim, "x")), 0, 0])
                draw_fence_boards(fence_post, fence_4inch_board, 13);
            }             
            if (panel == 5) 
            {
                translate([0,0,convert_in2mm(3)])
                moveTo(fence_post, str("vert ", panel + 2))
                translate([panel * (gdv(fence_panel, "x")  + gdv(fence_post_trim, "x")), 0, 0])
                draw_fence_boards(fence_post, fence_4inch_board, 12);
            }             
            if (panel == 6) 
            {
                translate([0,0,convert_in2mm(3)])
                moveTo(fence_post, str("vert ", panel + 2))
                translate([panel * (gdv(fence_panel, "x")  + gdv(fence_post_trim, "x")), 0, 0])
                draw_fence_boards(fence_post, fence_4inch_board, 12);
            }             
            
        }
    }

    //cap board
    // move_board_up(gdv(fence_post, "z"))
    // extrudeZaxis(fence_4inch_board_cap);

}

module draw_fence_boards(posts, boards, boardCount) 
{
    properties_echo(boards);
    // moveTo(posts, str("vert ", index))
    for(i = [0:boardCount])
    {
        color(gdv(boards, "color"), 0.5)
        moveTo(boards, "center")
        move_board_up((gdv(boards, "spacing") + gdv(boards, "z")) * i)
            extrudeZaxis(boards);
    }
}

module extrudeYaxis(dic)
{
    linear_extrude(gdv(dic, "y"))
    square(size = [gdv(dic, "x"), gdv(dic, "z")], center = true);
}

module extrudeZaxis(dic)
{
    linear_extrude(gdv(dic, "z"))
    square(size = [gdv(dic, "x"), gdv(dic, "y")], center = true);
}

module move_board_up(height)
{
    // echo(height = convert_mm2in(height));
    translate([0,0,height]) 
    children();
}

module draw_post(post, trim) 
{
    union()
    {
        moveToCenter(post)
        applyColor(post, 0.9)
        applyExtrude(post)
        drawSquare(post);

        //draw trim
        applyColor(trim, 0.9)        
        applyExtrude(trim)
        union()
        {
            moveTo(trim, "loc 1")
            drawSquare(trim);

            moveTo(trim, "loc 2")
            drawSquare(trim);

            moveTo(trim, "loc 3")
            drawSquare(trim);

            moveTo(trim, "loc 4")
            drawSquare(trim);
        }        
    }

}

module draw_post_pair(post, trim) 
{
    for(i = [1: gdv(post, "loc Count")])
    {
        moveTo(post, str("vert ", i))
        moveTo(post, str("loc ", i))
        draw_post(post, trim);
    }

}

module draw_square(dic)
{
    square(size = [gdv(dic, "x"), gdv(dic, "y")], center = true);
}
