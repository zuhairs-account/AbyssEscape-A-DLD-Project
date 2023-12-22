`timescale 1ns / 1ps

module timeout_screen(
    input [9:0]xloc,
    input [9:0]yloc,
    input video_on,
    output [11:0] rgb
    );
wire [3:0] white;
assign white = video_on ? ((
// edit this part, currently it shows two squares at (50-100, 50-100) and (150-200, 50-100) respectively

(xloc >= 200 & xloc < 230 & yloc >= 220 & yloc < 225)||(xloc >= 210 & xloc < 220 & yloc >= 220 & yloc < 285)||// <---drawing T
(xloc >= 240 & xloc < 250 & yloc >= 220 & yloc < 285)|| //<--- drawing I
(xloc >= 260 & xloc < 269 & yloc >= 220 & yloc < 285)||
(xloc >= 281 & xloc < 290 & yloc >= 220 & yloc < 285)||
(xloc >= 269 & xloc < 273 & yloc >= 225 & yloc < 235)|| 
(xloc >= 273 & xloc < 277 & yloc >= 236 & yloc < 240)|| 
(xloc >= 277 & xloc < 281 & yloc >= 225 & yloc < 235)||//<----drawing M
(xloc >= 300 & xloc < 330 & yloc >= 220 & yloc < 225)||(xloc >= 300 & xloc < 330 & yloc >= 280 & yloc < 285)||(xloc >= 300 & xloc < 305 & yloc >= 225 & yloc < 230)||(xloc >= 300 & xloc < 310 & yloc >= 230 & yloc < 280)||(xloc >= 315 & xloc < 325 & yloc >= 250  & yloc < 255)||// <---drawing E 

(xloc >= 345 & xloc < 365 & yloc >= 220 & yloc < 225)||(xloc >= 345 & xloc < 365 & yloc >= 280 & yloc < 285)||(xloc >= 360 & xloc < 370 & yloc >= 225 & yloc < 235)||(xloc >= 340 & xloc < 350 & yloc >= 270 & yloc < 280)||(xloc >= 340 & xloc < 350 & yloc >= 225 & yloc < 245)||(xloc >= 360 & xloc < 370 & yloc >= 260 & yloc < 280 )|| (xloc >= 340 & xloc < 355 & yloc >= 245 & yloc < 250)||(xloc >= 345 & xloc < 365 & yloc >= 250 & yloc < 255)||(xloc >= 355 & xloc < 370 & yloc >= 255 & yloc < 260 )||// <---drawing S

(xloc >= 410 & xloc < 420 & yloc >= 220 & yloc < 280)||(xloc >= 415 & xloc <435 & yloc >= 280 & yloc < 285)||(xloc >= 430 & xloc < 440 & yloc >= 220 & yloc < 280)||//<----drawing U

(xloc >= 450 & xloc < 475 & yloc >= 220 & yloc < 225)||
(xloc >= 450 & xloc < 455 & yloc >= 225 & yloc < 230)||
(xloc >= 450 & xloc < 460 & yloc >= 230 & yloc < 285)||
(xloc >= 465 & xloc < 475 & yloc >= 250  & yloc < 255)|| (xloc >= 470 & xloc < 480 & yloc >= 225  & yloc < 250)// <---drawing P

// do not edit beyond this point
) ? 4'hF:4'h0):(4'h0);
assign rgb = {white, 4'h0, 4'h0};
endmodule