`timescale 1ns / 1ps

module start_screen(
    input [9:0]xloc,
    input [9:0]yloc,
    input video_on,
    output [11:0] rgb
    );
wire [3:0] white;
//reg [3:0] cyan;

assign white = video_on ? ((

(xloc >= 63 & xloc <= 77 & yloc >= 77 & yloc <= 91)||(xloc >= 63 & xloc <= 70 & yloc >= 91 & yloc <= 98) ||
(xloc >= 63 & xloc <= 70 & yloc >= 63 & yloc <= 70) ||(xloc >= 70 & xloc <= 77 & yloc >= 56 & yloc <= 77) ||
(xloc >= 77 & xloc <= 84 & yloc >= 42 & yloc <= 70) ||(xloc >= 84 & xloc <= 91 & yloc >= 28 & yloc <= 42) ||
(xloc >= 84 & xloc <= 91 & yloc >= 56 & yloc <= 63) ||(xloc >= 91 & xloc <= 98 & yloc >= 35 & yloc <= 70) ||
(xloc >= 98 & xloc <= 105 & yloc >= 56 & yloc <= 84) ||(xloc >= 105 & xloc <= 112 & yloc >= 56 & yloc <= 63) //A

||(xloc >= 119 & xloc <= 126 & yloc >= 28 & yloc <= 56) ||(xloc >= 126 & xloc <= 133 & yloc >= 49 & yloc <= 91)
||(xloc >= 133 & xloc <= 140 & yloc >= 56 & yloc <= 70) ||(xloc >= 133 & xloc <= 140 & yloc >= 84 & yloc <= 91) 
||(xloc >= 140 & xloc <= 147 & yloc >= 63 & yloc <= 70) ||(xloc >= 140 & xloc <= 147 & yloc >= 77 & yloc <= 91) 
||(xloc >= 147 & xloc <= 154 & yloc >= 63 & yloc <= 84) ||(xloc >= 154 & xloc <= 161 & yloc >= 63 & yloc <= 77) //b

||(xloc >= 168 & xloc <= 175 & yloc >= 49 & yloc <= 63) ||(xloc >= 168 & xloc <= 175 & yloc >= 105 & yloc <= 112) 
||(xloc >= 175 & xloc <= 182 & yloc >= 56 & yloc <= 70) ||(xloc >= 175 & xloc <= 182 & yloc >= 91 & yloc <= 105)  
||(xloc >= 182 & xloc <= 189 & yloc >= 63 & yloc <= 91) ||(xloc >= 189 & xloc <= 196 & yloc >= 63 & yloc <= 84) 
||(xloc >= 196 & xloc <= 203 & yloc >= 56 & yloc <= 70) ||(xloc >= 203 & xloc <= 210 & yloc >= 49 & yloc <= 63)//y

||(xloc >= 217 & xloc <= 224 & yloc >= 56 & yloc <= 77) ||(xloc >= 224 & xloc <= 231 & yloc >= 49 & yloc <= 63) 
||(xloc >= 224 & xloc <= 231 & yloc >= 70 & yloc <= 77) ||(xloc >= 231 & xloc <= 238 & yloc >= 42 & yloc <= 56) 
||(xloc >= 231 & xloc <= 238 & yloc >= 63 & yloc <= 77) ||(xloc >= 238 & xloc <= 245 & yloc >= 49 & yloc <= 56) 
||(xloc >= 238 & xloc <= 245 & yloc >= 63 & yloc <= 70) ||(xloc >= 245 & xloc <= 252 & yloc >= 63 & yloc <= 84) 
||(xloc >= 238 & xloc <= 245 & yloc >= 77 & yloc <= 91) ||(xloc >= 231 & xloc <= 238 & yloc >= 84 & yloc <= 91) 
||(xloc >= 224 & xloc <= 231 & yloc >= 91 & yloc <= 98) //s

||(xloc >= 259 & xloc <= 266 & yloc >= 56 & yloc <= 77) ||(xloc >= 266 & xloc <= 273 & yloc >= 49 & yloc <= 63) 
||(xloc >= 266 & xloc <= 273 & yloc >= 70 & yloc <= 77) ||(xloc >= 273 & xloc <= 280 & yloc >= 42 & yloc <= 56) 
||(xloc >= 273 & xloc <= 280 & yloc >= 63 & yloc <= 77) ||(xloc >= 280 & xloc <= 287 & yloc >= 49 & yloc <= 56) 
||(xloc >= 280 & xloc <= 287 & yloc >= 63 & yloc <= 70) ||(xloc >= 287 & xloc <= 294 & yloc >= 63 & yloc <= 84) 
||(xloc >= 280 & xloc <= 287 & yloc >= 77 & yloc <= 91) ||(xloc >= 273 & xloc <= 280 & yloc >= 84 & yloc <= 91) 
||(xloc >= 266 & xloc <= 273 & yloc >= 91 & yloc <= 98) //s

||(xloc >= 322 & xloc <= 329 & yloc >= 35 & yloc <= 42) ||(xloc >= 329 & xloc <= 343 & yloc >= 28 & yloc <= 49) 
||(xloc >= 343 & xloc <= 364 & yloc >= 35 & yloc <= 42) ||(xloc >= 329 & xloc <= 336 & yloc >= 49 & yloc <= 91) 
||(xloc >= 322 & xloc <= 329 & yloc >= 56 & yloc <= 98 ) ||(xloc >= 336 & xloc <= 357 & yloc >= 56 & yloc <= 63) 
||(xloc >= 336 & xloc <= 350 & yloc >= 77 & yloc <= 84)||(xloc >= 336 & xloc <= 343 & yloc >= 84 & yloc <= 91) //E

||(xloc >= 364 & xloc <= 371 & yloc >= 56 & yloc <= 77) ||(xloc >= 371 & xloc <= 378 & yloc >= 49 & yloc <= 63) 
||(xloc >= 371 & xloc <= 378 & yloc >= 70 & yloc <= 77) ||(xloc >= 378 & xloc <= 385 & yloc >= 42 & yloc <= 56) 
||(xloc >= 378 & xloc <= 385 & yloc >= 63 & yloc <= 77) ||(xloc >= 385 & xloc <= 392 & yloc >= 49 & yloc <= 56) 
||(xloc >= 385 & xloc <= 392 & yloc >= 63 & yloc <= 70) ||(xloc >= 392 & xloc <= 399 & yloc >= 63 & yloc <= 84) 
||(xloc >= 385 & xloc <= 392 & yloc >= 77 & yloc <= 91) ||(xloc >= 378 & xloc <= 385 & yloc >= 84 & yloc <= 91) 
||(xloc >= 371 & xloc <= 378 & yloc >= 91 & yloc <= 98) //s

||(xloc >= 413 & xloc <= 420 & yloc >= 56 & yloc <= 84) ||(xloc >= 420 & xloc <= 434 & yloc >= 49 & yloc <= 63) 
||(xloc >= 434 & xloc <= 441 & yloc >= 63 & yloc <= 70) ||(xloc >= 413 & xloc <= 434 & yloc >= 77 & yloc <= 84) //c

||(xloc >= 448 & xloc <= 462 & yloc >= 56 & yloc <= 63) ||(xloc >= 455 & xloc <= 476 & yloc >= 49 & yloc <= 56) 
||(xloc >= 469 & xloc <= 476 & yloc >= 49 & yloc <= 91) ||(xloc >= 455 & xloc <= 462 & yloc >= 70 & yloc <= 91) 
||(xloc >= 462 & xloc <= 469 & yloc >= 70 & yloc <= 77) ||(xloc >= 462 & xloc <= 469 & yloc >= 84 & yloc <= 91) //a

||(xloc >= 490 & xloc <= 497 & yloc >= 70 & yloc <= 105) ||(xloc >= 497 & xloc <= 504 & yloc >= 56 & yloc <= 84) 
||(xloc >= 504 & xloc <= 525 & yloc >= 56 & yloc <= 63) ||(xloc >= 504 & xloc <= 525 & yloc >= 77 & yloc <= 84) 
||(xloc >= 518 & xloc <= 532 & yloc >= 70 & yloc <= 77) ||(xloc >= 525 & xloc <= 532 & yloc >= 63 & yloc <= 70) //p

||(xloc >= 546 & xloc <= 581 & yloc >= 63 & yloc <= 70) ||(xloc >= 553 & xloc <= 560 & yloc >= 56 & yloc <= 63) 
||(xloc >= 567 & xloc <= 574 & yloc >= 56 & yloc <= 63) ||(xloc >= 560 & xloc <= 567 & yloc >= 49 & yloc <= 56) 
||(xloc >= 553 & xloc <= 560 & yloc >= 70 & yloc <= 91) ||(xloc >= 560 & xloc <= 567 & yloc >= 84 & yloc <= 91) 
||(xloc >= 567 & xloc <= 574 & yloc >= 77 & yloc <= 84) //e

//death

|| (xloc >= 217 & xloc <= 224 & yloc >= 210 & yloc <= 301) || (xloc >= 224 & xloc <= 231 & yloc >= 189 & yloc <= 322) 
|| (xloc >= 231 & xloc <= 238 & yloc >= 175 & yloc <= 336) || (xloc >= 238 & xloc <= 245 & yloc >= 168 & yloc <= 259) 
|| (xloc >= 238 & xloc <= 245 & yloc >= 280 & yloc <= 336) || (xloc >= 245 & xloc <= 259 & yloc >= 161 & yloc <= 252) 
|| (xloc >= 245 & xloc <= 252 & yloc >= 301 & yloc <= 336) || (xloc >= 245 & xloc <= 252 & yloc >= 343 & yloc <= 399) 
|| (xloc >= 252 & xloc <= 301 & yloc >= 308 & yloc <= 336) || (xloc >= 252 & xloc <= 259 & yloc >= 371 & yloc <= 406) 
|| (xloc >= 252 & xloc <= 259 & yloc >= 371 & yloc <= 406) || (xloc >= 259 & xloc <= 273 & yloc >= 154 & yloc <= 252) 
|| (xloc >= 259 & xloc <= 301 & yloc >= 336 & yloc <= 343) || (xloc >= 266 & xloc <= 301 & yloc >= 343 & yloc <= 350) 
|| (xloc >= 259 & xloc <= 266 & yloc >= 378 & yloc <= 420) || (xloc >= 266 & xloc <= 273 & yloc >= 385 & yloc <= 434) 
|| (xloc >= 273 & xloc <= 294 & yloc >= 147 & yloc <= 252) || (xloc >= 280 & xloc <= 308 & yloc >= 301 & yloc <= 308) 
|| (xloc >= 273 & xloc <= 301 & yloc >= 308 & yloc <= 336) || (xloc >= 280 & xloc <= 322 & yloc >= 364 & yloc <= 371) 
|| (xloc >= 287 & xloc <= 322 & yloc >= 371 & yloc <= 378) || (xloc >= 280 & xloc <= 287 & yloc >= 378 & yloc <= 392) 
|| (xloc >= 280 & xloc <= 287 & yloc >= 406 & yloc <= 441) || (xloc >= 287 & xloc <= 294 & yloc >= 399 & yloc <= 448) 
|| (xloc >= 294 & xloc <= 315 & yloc >= 294 & yloc <= 301) || (xloc >= 301 & xloc <= 308 & yloc >= 308 & yloc <= 322) 
|| (xloc >= 280 & xloc <= 287 & yloc >= 378 & yloc <= 392) || (xloc >= 294 & xloc <= 301 & yloc >= 385 & yloc <= 392) 
|| (xloc >= 308 & xloc <= 315 & yloc >= 385 & yloc <= 399) || (xloc >= 287 & xloc <= 294 & yloc >= 399 & yloc <= 448) 
|| (xloc >= 294 & xloc <= 301 & yloc >= 413 & yloc <= 448) || (xloc >= 301 & xloc <= 308 & yloc >= 406 & yloc <= 448) 
|| (xloc >= 308 & xloc <= 315 & yloc >= 420 & yloc <= 448) || (xloc >= 315 & xloc <= 322 & yloc >= 406 & yloc <= 448)
|| (xloc >= 294 & xloc <= 322 & yloc >= 140 & yloc <= 259) || (xloc >= 301 & xloc <= 322 & yloc >= 259 & yloc <= 294)
|| (xloc >= 273 & xloc <= 301 & yloc >= 350 & yloc <= 364) || (xloc >= 301 & xloc <= 322 & yloc >= 357 & yloc <= 364)
|| (xloc >= 273 & xloc <= 280 & yloc >= 399 & yloc <= 441)

|| (xloc <= 427 & xloc >= 420 & yloc >= 210 & yloc <= 301) || (xloc <= 420 & xloc >= 413 & yloc >= 189 & yloc <= 322) 
|| (xloc <= 413 & xloc >= 406 & yloc >= 175 & yloc <= 336) || (xloc <= 406 & xloc >= 399 & yloc >= 168 & yloc <= 259) 
|| (xloc <= 406 & xloc >= 399 & yloc >= 280 & yloc <= 336) || (xloc <= 399 & xloc >= 385 & yloc >= 161 & yloc <= 252) 
|| (xloc <= 399 & xloc >= 392 & yloc >= 301 & yloc <= 336) || (xloc <= 399 & xloc >= 392 & yloc >= 343 & yloc <= 399) 
|| (xloc <= 392 & xloc >= 343 & yloc >= 308 & yloc <= 336) || (xloc <= 392 & xloc >= 385 & yloc >= 371 & yloc <= 406) 
|| (xloc <= 392 & xloc >= 385 & yloc >= 371 & yloc <= 406) || (xloc <= 385 & xloc >= 371 & yloc >= 154 & yloc <= 252) 
|| (xloc <= 385 & xloc >= 343 & yloc >= 336 & yloc <= 343) || (xloc <= 378 & xloc >= 343 & yloc >= 343 & yloc <= 350) 
|| (xloc <= 385 & xloc >= 378 & yloc >= 378 & yloc <= 420) || (xloc <= 378 & xloc >= 371 & yloc >= 385 & yloc <= 434) 
|| (xloc <= 371 & xloc >= 350 & yloc >= 147 & yloc <= 252) || (xloc <= 364 & xloc >= 336 & yloc >= 301 & yloc <= 308) 
|| (xloc <= 371 & xloc >= 343 & yloc >= 308 & yloc <= 336) || (xloc <= 364 & xloc >= 322 & yloc >= 364 & yloc <= 371) 
|| (xloc <= 357 & xloc >= 322 & yloc >= 371 & yloc <= 378) || (xloc <= 364 & xloc >= 358 & yloc >= 378 & yloc <= 392) 
|| (xloc <= 364 & xloc >= 357 & yloc >= 406 & yloc <= 441) || (xloc <= 357 & xloc >= 350 & yloc >= 399 & yloc <= 448) 
|| (xloc <= 350 & xloc >= 329 & yloc >= 294 & yloc <= 301) || (xloc <= 343 & xloc >= 336 & yloc >= 308 & yloc <= 322) 
|| (xloc <= 364 & xloc >= 357 & yloc >= 378 & yloc <= 392) || (xloc <= 350 & xloc >= 343 & yloc >= 385 & yloc <= 392) 
|| (xloc <= 336 & xloc >= 329 & yloc >= 385 & yloc <= 399) || (xloc <= 357 & xloc >= 350 & yloc >= 399 & yloc <= 448) 
|| (xloc <= 350 & xloc >= 343 & yloc >= 413 & yloc <= 448) || (xloc <= 343 & xloc >= 336 & yloc >= 406 & yloc <= 448) 
|| (xloc <= 336 & xloc >= 329 & yloc >= 420 & yloc <= 448) || (xloc <= 329 & xloc >= 322 & yloc >= 406 & yloc <= 448)
|| (xloc <= 350 & xloc >= 322 & yloc >= 140 & yloc <= 259) || (xloc <= 343 & xloc >= 322 & yloc >= 259 & yloc <= 294)
|| (xloc <= 371 & xloc >= 343 & yloc >= 350 & yloc <= 364) || (xloc <= 343 & xloc >= 322 & yloc >= 357 & yloc <= 364)
|| (xloc <= 371 & xloc >= 364 & yloc >= 399 & yloc <= 441)

) ? 4'hF:4'h0):(4'h0);
/* sans x komaeda when
always @*
begin
    if (xloc >= 371 & xloc <= 378 & yloc >= 273 & yloc <= 280)
    begin
        cyan <= 4'hF;
    end
    else
    begin
        cyan <= white;
    end
end
assign rgb = {cyan, cyan, white};
*/

assign rgb = {white, white, white};
endmodule
