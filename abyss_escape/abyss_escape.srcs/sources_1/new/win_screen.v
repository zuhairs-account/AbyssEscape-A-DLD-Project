`timescale 1ns / 1ps
module win_screen(
   input [9:0]xloc,
   input [9:0]yloc,
   input video_on,
   output [11:0] rgb
   );
wire [3:0] white;
assign white = video_on ? ((
// edit this part, currently it shows two squares at (50-100, 50-100) and (150-200, 50-100) respectively
(xloc >= 110 & xloc < 120 & yloc >= 220 & yloc < 240)||(xloc >= 115 & xloc < 125 & yloc >= 235 & yloc < 250)||(xloc >= 115 & xloc < 135 & yloc >= 250 & yloc < 255)||(xloc >= 120 & xloc < 130 & yloc >= 255 & yloc < 285)||(xloc >= 130 & xloc < 135 & yloc >= 235 & yloc < 255)||(xloc >= 135 & xloc < 140 & yloc >= 220 & yloc < 240)||// <---drawing Y
(xloc >= 155 & xloc < 175 & yloc >= 220 & yloc < 225)||(xloc >= 150 & xloc < 160 & yloc >= 225 & yloc < 280)||(xloc >= 170 & xloc < 180 & yloc >= 225 & yloc < 280)||(xloc >= 155 & xloc < 175  & yloc >= 280 & yloc < 285)||//<--- drawing O
(xloc >= 190 & xloc < 200 & yloc >= 220 & yloc < 280)||(xloc >= 195 & xloc < 215 & yloc >= 280 & yloc < 285)||(xloc >= 210 & xloc < 220 & yloc >= 220 & yloc < 280)||//<----drawing U
(xloc >= 260 & xloc < 290 & yloc >= 220 & yloc < 225)||(xloc >= 260 & xloc < 290 & yloc >= 280 & yloc < 285)||(xloc >= 260 & xloc < 265 & yloc >= 225 & yloc < 230)||(xloc >= 260 & xloc < 270 & yloc >= 230 & yloc < 280)||(xloc >= 275 & xloc < 285 & yloc >= 250  & yloc < 255)||// <---drawing E
(xloc >= 305 & xloc < 325 & yloc >= 220 & yloc < 225)||(xloc >= 305 & xloc < 325 & yloc >= 280 & yloc < 285)||(xloc >= 320 & xloc < 330 & yloc >= 225 & yloc < 235)||(xloc >= 300 & xloc < 310 & yloc >= 270 & yloc < 280)||(xloc >= 300 & xloc < 310 & yloc >= 225 & yloc < 245)||(xloc >= 320 & xloc < 330 & yloc >= 260 & yloc < 280 )|| (xloc >= 300 & xloc < 315 & yloc >= 245 & yloc < 250)||(xloc >= 305 & xloc < 325 & yloc >= 250 & yloc < 255)||(xloc >= 315 & xloc < 330 & yloc >= 255 & yloc < 260 )||// <---drawing S
(xloc >= 345 & xloc < 365 & yloc >= 220 & yloc < 225)||(xloc >= 340 & xloc < 350 & yloc >= 225 & yloc < 280)||(xloc >= 360 & xloc < 370 & yloc >= 225 & yloc < 240)|| (xloc >= 360 & xloc < 370 & yloc >= 260 & yloc < 280)||(xloc >= 345 & xloc < 365  & yloc >= 280 & yloc < 285)||//<--- drawing C
(xloc >= 400 & xloc < 410 & yloc >= 220 & yloc < 285)||(xloc >= 396 & xloc < 400 & yloc >= 230 & yloc < 240)||(xloc >= 392 & xloc < 396 & yloc >= 240 & yloc < 250)||(xloc >= 388 & xloc < 392 & yloc >= 250 & yloc < 260)||(xloc >= 384 & xloc < 388 & yloc >= 260 & yloc < 270)||(xloc >= 380 & xloc < 384 & yloc >= 270 & yloc < 285)|| (xloc >= 392 & xloc < 400 & yloc >= 270 & yloc < 275)||// <---drawing A
(xloc >= 420 & xloc < 445 & yloc >= 220 & yloc < 225)||(xloc >= 420 & xloc < 425 & yloc >= 225 & yloc < 230)||(xloc >= 420 & xloc < 430 & yloc >= 230 & yloc < 285)||(xloc >= 435 & xloc < 445 & yloc >= 250  & yloc < 255)|| (xloc >= 440 & xloc < 450 & yloc >= 225  & yloc < 250)||// <---drawing P
(xloc >= 460 & xloc < 490 & yloc >= 220 & yloc < 225)||(xloc >= 460 & xloc < 490 & yloc >= 280 & yloc < 285)||(xloc >= 460 & xloc < 465 & yloc >= 225 & yloc < 230)||(xloc >= 460 & xloc < 470 & yloc >= 230 & yloc < 280)||(xloc >= 475 & xloc < 485 & yloc >= 250  & yloc < 255)||// <---drawing E
(xloc >= 500 & xloc < 525 & yloc >= 220 & yloc < 225)||(xloc >= 505 & xloc < 510 & yloc >= 225 & yloc < 230)|| (xloc >= 505 & xloc < 515 & yloc >= 230 & yloc < 280)||(xloc >= 520 & xloc < 530 & yloc >= 225 & yloc < 280)||(xloc >= 500 & xloc < 525 & yloc >= 280 & yloc < 285)|| //<-- drawing D

(xloc >=448 & xloc < 458 & yloc >= 20 & yloc < 24)||
(xloc >=445 & xloc < 448 & yloc >= 23 & yloc < 27)||
(xloc >=448 & xloc < 456 & yloc >= 26 & yloc < 31)||
(xloc >=455 & xloc < 458 & yloc >= 30 & yloc < 37)||
(xloc >=445 & xloc < 456 & yloc >= 36 & yloc < 40)||


(xloc >=463 & xloc < 475 & yloc >= 20 & yloc < 24)||
(xloc >=460 & xloc < 463 & yloc >= 23 & yloc < 37)||
(xloc >=473 & xloc < 476 & yloc >= 23 & yloc < 27)||
(xloc >=473 & xloc < 476 & yloc >= 33 & yloc < 37)||
(xloc >=463 & xloc < 475 & yloc >= 36 & yloc < 40)||


(xloc >=481 & xloc < 493 & yloc >= 20 & yloc < 24)||
(xloc >=478 & xloc < 481 & yloc >= 23 & yloc < 37)||
(xloc >=493 & xloc < 496 & yloc >= 23 & yloc < 37)||
(xloc >=481 & xloc < 493 & yloc >= 36 & yloc < 40)||


(xloc >=498 & xloc < 501 & yloc >= 20 & yloc < 40)||
(xloc >=498 & xloc < 511 & yloc >= 20 & yloc < 24)||
(xloc >=511 & xloc < 514 & yloc >= 23 & yloc < 27)||
(xloc >=498 & xloc < 511 & yloc >= 26 & yloc < 31)||
(xloc >=506 & xloc < 509 & yloc >= 31 & yloc < 34)||
(xloc >=509 & xloc < 512 & yloc >= 33 & yloc < 37)||
(xloc >=512 & xloc < 515 & yloc >= 36 & yloc < 40)||


(xloc >=517 & xloc < 532 & yloc >= 20 & yloc < 24)||
(xloc >=517 & xloc < 520 & yloc >= 20 & yloc < 40)||
(xloc >=517 & xloc < 525 & yloc >= 26 & yloc < 31)||
(xloc >=517 & xloc < 532 & yloc >= 36 & yloc < 40)/*||


(xloc >=535 & xloc < 538 & yloc >= 25 & yloc < 29)||
(xloc >=535 & xloc < 538 & yloc >= 36 & yloc < 40)*/
// do not edit beyond this point
) ? 4'hF:4'h0):(4'h0);
assign rgb = {white, white, white};
endmodule