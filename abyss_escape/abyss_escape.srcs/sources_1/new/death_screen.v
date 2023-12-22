`timescale 1ns / 1ps

module death_screen(
    input [9:0]xloc,
    input [9:0]yloc,
    input video_on,
    output [11:0] rgb
    );
wire [3:0] white;

assign white = video_on ? ((
// edit this part, currently it shows two squares at (50-100, 50-100) and (150-200, 50-100) respectively

//(xloc >= 50 & xloc <= 100 & yloc >= 50 & yloc <= 100)||(xloc >= 150 & xloc <= 200 & yloc >= 50 & yloc <= 100)

(xloc >= 140 & xloc < 150 & yloc >= 220 & yloc < 285)||(xloc >= 150 & xloc < 175 & yloc >= 220 & yloc < 225)||(xloc >=155 & xloc < 165 & yloc >= 250 &  yloc < 255)|| //<----drawing f
(xloc >= 185 & xloc < 205 & yloc >= 220 & yloc < 225)||(xloc >= 180 & xloc < 190 & yloc >= 225 & yloc < 280)||(xloc >= 200 & xloc < 210 & yloc >= 225 & yloc < 280)||(xloc >= 185 & xloc < 205 & yloc >= 280 & yloc < 285)||// <--- drawing o 
(xloc >= 220 & xloc < 230 & yloc >= 220 & yloc < 280)||(xloc >= 225 & xloc < 245 & yloc >= 280 & yloc < 285)||(xloc >= 240 & xloc < 250 & yloc >= 220 & yloc < 280)||//<--- drawing u
(xloc >= 265 & xloc < 270 & yloc >= 220 & yloc < 285)||(xloc >= 270 & xloc < 275 & yloc >= 230 & yloc < 245)||(xloc >= 275 & xloc < 280 & yloc >= 240 & yloc < 255)||(xloc >= 280 & xloc < 285 & yloc >= 250 & yloc < 265)||(xloc >= 285 & xloc < 290 & yloc >= 220 & yloc < 285)|| //<---drawing n
(xloc >= 300 & xloc < 325 & yloc >= 220 & yloc < 225)||(xloc >= 305 & xloc < 315 & yloc >= 225 & yloc < 280)||(xloc >= 325 & xloc < 330 & yloc >= 225 & yloc < 280)||(xloc >= 300 & xloc < 325 & yloc >= 280 & yloc < 285)|| //<-- drawing d 
(xloc >= 370 & xloc < 380 & yloc >= 220 & yloc < 240)||(xloc >= 375 & xloc < 385 & yloc >= 235 & yloc < 250)||(xloc >= 375 & xloc < 395 & yloc >= 250 & yloc < 255)||(xloc >= 380 & xloc < 390 & yloc >= 255 & yloc < 285)||(xloc >= 390 & xloc < 395 & yloc >= 235 & yloc < 255)||(xloc >= 395 & xloc < 400 & yloc >= 220 & yloc < 240)||// <---drawing y
(xloc >= 415 & xloc < 435 & yloc >= 220 & yloc < 225)||(xloc >= 410 & xloc < 420 & yloc >= 225 & yloc < 280)||(xloc >= 430 & xloc < 440 & yloc >= 225 & yloc < 280)||(xloc >= 415 & xloc < 435 & yloc >= 280 & yloc < 285)|| //<--- drawing o 
(xloc >= 450 & xloc < 460 & yloc >= 220 & yloc < 280)||(xloc >= 455 & xloc < 475 & yloc >= 280 & yloc < 285)||(xloc >= 470 & xloc < 480 & yloc >= 220 & yloc < 280)//<----drawing u


// do not edit beyond this point
) ? 4'h0:4'hF):(4'hF);
assign rgb = {white, 4'h0, 4'h0};
endmodule
