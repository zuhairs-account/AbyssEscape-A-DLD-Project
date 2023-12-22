`timescale 1ms / 1ps

module gameplay(
input [1:0] cstate,                     //game state
            input clk,                  //clock
            input vauxp6,               //p6, n6, p7, n7 are analog inputs for player 1
        input vauxn6,
        input vauxp7,
        input vauxn7,
    input vauxp15,                      //while these are for player 2
    input vauxn15,
    input vauxp14,
    input vauxn14,
    input restart,
    input start,
            output h_sync,              //sync related stuff
            output v_sync,
            output reg [11:0]rgb,       //the rgb output
            output reg winflag,      //who won?
            output reg deathflag
            );

reg moveright = 0;
reg moveleft = 0;
reg movedown = 0;
reg moveup = 0;

wire char_on;
wire mon_on;
wire key_on;
wire maze_on;
wire gate_on;

wire enable;  
wire ready;
wire [15:0] data;  
reg [6:0] Address_in;  //stuff from the joystick code
      
initial
begin
    winflag = 0;
    deathflag = 0;
    gameoverflag = 0;
    tlstate = 1;
end
      
xadc_wiz_0  XLXI_7 (.daddr_in(Address_in),
   .dclk_in(clk),
   .den_in(enable),
   .di_in(),
   .dwe_in(),
   .busy_out(),                    
   .vauxp6(vauxp6),
   .vauxn6(vauxn6),
   .vauxp7(vauxp7),
   .vauxn7(vauxn7),
   .vauxp14(vauxp14),
   .vauxn14(vauxn14),
   .vauxp15(vauxp15),
   .vauxn15(vauxn15),
   .vn_in(),
   .vp_in(),
   .alarm_out(),
   .do_out(data),
   //.reset_in(),
   .eoc_out(enable),
   .channel_out(),
   .drdy_out(ready));
   
wire video_on;
wire [10:0] hpos;
wire [10:0] vpos;
wire [11:0] startrgb;
wire [11:0] timergb;
wire [11:0] deathrgb;
wire [11:0] bgrgb;
wire [11:0] winrgb;
wire [11:0] charrgb;
wire [11:0] monrgb;
wire [11:0] keyrgb;
wire [11:0] gatergb;
wire [11:0] death1rgb;
wire [11:0] death2rgb;
wire [11:0] death3rgb;
reg gameoverflag;

start_screen s(hpos, vpos,video_on,startrgb);
timeout_screen t(hpos, vpos,video_on,timergb);

death_screen d(hpos, vpos, video_on, deathrgb);
bg_rom bg(clk, vpos, hpos, bgrgb);
death_1_rom death_1(clk, vpos, hpos, death1rgb);
death_2_rom death_2(clk, vpos, hpos, death2rgb);
death_3_rom death_3(clk, vpos, hpos, death3rgb);
createMaze maze(hpos, vpos, maze_on);
win_screen r(hpos, vpos, video_on, winrgb);
gen_sync sync(.clk(clk),.h_sync(h_sync),.v_sync(v_sync), .video_on(video_on), .x_loc(hpos), .y_loc(vpos));

reg [10:0] charx;
reg [10:0] chary;

reg [10:0] monx;
reg [10:0] mony;

reg [10:0] keyx;
reg [10:0] keyy;

reg [10:0] gatex;
reg [10:0] gatey;

reg gatestate;
initial
begin
    charx = 11'd280;
    chary = 11'd20;
    monx = 11'd470;
    mony = 11'd320;
    keyx = 11'd360;
    keyy = 11'd25;
    gatex = 11'd30;
    gatey = 11'd420;
    gatestate = 0;
end

reg flip = 1'b0;                  //a curious flip... what is this? (i changed from negedge to posedge... let's see if that messes up smthn
always @(posedge v_sync) begin
    flip = flip + 1;
    case (flip)                         //this part handles joystick input
    0: begin
            Address_in = 8'h16;         //move player 1 left or right
            case (data[15:12])       
                    11, 12, 13 : begin
                  movedown<=1;
                  end    
                  0 : begin
                        moveup<=1;
                  end
                  
                default : begin
                moveup<=0;
                movedown<=0;
                end
            endcase
      end
      1: begin                                  //this one's for player 1 up and down
      Address_in = 8'h1e;
      case (data[15:12])
              11, 12, 13 : begin
            moveright<=1;
            end
            
            0 : begin
                  moveleft = 1; //1
            end
            default : begin
            moveright=0;
            moveleft<=0;
            end
      endcase
      end
endcase
end

reg [1:0] direction;
reg [3:0] cooldown = 0;
reg [6:0] framecount;
reg [3:0] smallnum;
reg [3:0] mednum;
reg [3:0] bignum = 0;
/*
reg movingAtX;
reg movingAtY;
*/

reg tlstate;
reg brstate;
reg upstate;

reg restartCount = 1'b0;
reg [6:0] jumpcount;
reg [1:0] jumpframe;

reg timeflag;

initial begin
timeflag = 0;
end


always @(posedge v_sync)
    begin
        if (bignum == 0 && mednum == 0 && smallnum == 0)
        begin
            timeflag <= 1;
            deathflag <= 1;
        end
        if ((bignum != 0 || mednum != 0 || smallnum != 0) && cstate == 1)        //check out what on earth is going on here
        begin
            framecount <= framecount + 1;
            if (framecount == 60)
            begin
                framecount <= 0;
                smallnum <= smallnum - 1;
                if (smallnum == 0)
                begin
                    smallnum <= 9;
                    mednum <= mednum - 1;
                    if (mednum == 0)
                    begin
                        mednum <= 9;
                        bignum <= bignum - 1;
                    end
                end
            end
        end
        if (cstate == 3 && gameoverflag == 0 && jumpframe != 3)
        begin
            jumpcount <= jumpcount + 1;
            if (jumpcount == 75)
            begin
                jumpframe <= jumpframe + 1;
                jumpcount <= 0;
                if (jumpframe == 3)
                    gameoverflag <= 1;
            end
        end
        cooldown <= cooldown + 1;
        if (cooldown == 2)
        begin
            cooldown <= 0;
            if (restart == 1)
            begin
                bignum <= 4'd0;
                mednum <= 4'd9;
                smallnum <= 4'd9;
                charx = 11'd280;
                chary = 11'd20;
                monx = 11'd470;
                mony = 11'd320;
                restartCount <= restartCount + 1;
                gatestate <= 0;
                deathflag <= 0;
                timeflag <= 0;
                gameoverflag <= 0;
                jumpframe <= 0;
                winflag <= 0;
                tlstate <= 1;
                brstate <= 0;
                upstate <= 0;
                /*
                
    keyx = 11'd360;
    keyy = 11'd20;
    gatex = 11'd30;
    gatey = 11'd420;
                */
                if (restartCount == 1)
                begin
                    restartCount <= 0;
                    keyx = 11'd30;
                    keyy = 11'd425;
                    gatex = 11'd360;
                    gatey = 11'd30;
                end
                else
                begin                
                    keyx = 11'd360;
                    keyy = 11'd30;
                    gatex = 11'd30;
                    gatey = 11'd425;
                end
                    
                /*
                movingAtX <= 0;
                movingAtY <= 0;
                */
            end
            else
          if (moveright && (charx + 22 + 10 < 640) && (charx + 22> 0) &&
                    ((charx + 4 >= 15 & charx + 22 <= 55 & chary >= 15 & chary + 28 <= 260) ||(charx + 4 >= 15 & charx + 22 <= 55 & chary >= 275 & chary + 28 <= 395) 
                    ||(charx + 4 >= 15 & charx + 22 <= 625 & chary >= 410 & chary + 28 <= 465)
                    ||(charx + 4 >= 15 & charx + 22 <= 250 & chary >= 15 & chary + 28 <= 70) ||(charx + 4 >= 335 & charx + 22 <= 625 & chary >= 15 & chary + 28 <= 70) 
                    ||(charx + 4 >= 570 & charx + 22 <= 625 & chary >= 15 & chary + 28 <= 140) ||(charx + 4 >= 265 & charx + 22 <= 320 & chary >= 0 & chary + 28 <= 140) 
                    ||(charx + 4 >= 70 & charx + 22 <= 320 & chary >=85 & chary + 28 <=140) ||(charx + 4 >= 505 & charx + 22 <= 625 & chary >=85 & chary + 28 <=140)
                    ||(charx + 4 >= 335 & charx + 22 <= 490 & chary >=85 & chary + 28 <= 140) ||(charx + 4 >=505 & charx + 22 <=640 & chary >= 155 & chary + 28 <= 205) 
                    ||(charx + 4 >=505 & charx + 22 <= 555 & chary >=85 & chary + 28 <= 205) ||(charx + 4 >= 265 & charx + 22 <= 320 & chary >=300 & chary + 28 <= 465) 
                    ||(charx + 4 >= 570 & charx + 22 <=625 & chary >= 155 & chary + 28 <= 245) ||(charx + 4 >= 445 & charx + 22 <= 625 & chary >= 213 & chary + 28 <= 245)
                    ||(charx + 4 >= 445 & charx + 22 <= 490 & chary >= 85 & chary + 28 <= 245) ||(charx + 4 >= 505 & charx + 22 <=555 & chary >= 220 & chary + 28 <=300) 
                    ||(charx + 4 >= 445 & charx + 22 <= 555 & chary >= 260 & chary + 28 <= 300)||(charx + 4 >= 585 & charx + 22 <= 625 & chary >=315 & chary + 28 <= 465) 
                    ||(charx + 4 >= 515 & charx + 22 <=570 & chary >= 315 & chary + 28 <= 395) ||(charx + 4 >= 335 & charx + 22 <= 380 & chary >=85  & chary + 28 <= 260)
                    ||(charx + 4 >= 395 & charx + 22 <= 625 & chary >=315 & chary + 28 <= 360)||(charx + 4 >= 390 & charx + 22 <=435 & chary >= 85 & chary + 28 <= 140)
                    ||(charx + 4 >= 390 & charx + 22 <=435 & chary >= 155 & chary + 28 <= 360) 
                    ||(charx + 4 >= 265 & charx + 22 <=390 & chary >= 375 & chary + 28 <= 410)||(charx + 4 >= 265 & charx + 22 <= 350 & chary >=300 & chary + 28 <= 345) 
                    ||(charx + 4 >= 265 & charx + 22 <=380 & chary >= 215 & chary + 28 <= 260) ||(charx + 4 >= 185 & charx + 22 <= 235 & chary >= 215 & chary + 28 <= 465)
                    ||(charx + 4 >= 70 & charx + 22 <= 125 & chary >=85 & chary + 28 <= 200) ||(charx + 4 >= 15  & charx + 22 <=125 & chary >= 155 & chary + 28 <= 200) 
                    ||(charx + 4 >=15 & charx + 22 <= 125 & chary >= 215 & chary + 28 <= 260)||(charx + 4 >= 15 & charx + 22 <= 125 & chary >=275 & chary + 28 <= 315) 
                    ||(charx + 4 >= 70 & charx + 22 <=125 & chary >= 215 & chary + 28 <= 315) ||(charx + 4 >= 15 & charx + 22 <= 175 & chary >= 355 & chary + 28 <= 395)
                     ||(charx + 4 >= 135 & charx + 22 <=235 & chary >= 315 & chary + 28 <= 395) 
                    ||(charx + 4 >= 135 & charx + 22 <= 435 & chary >= 155 & chary + 28 <= 200)||(charx + 4 >= 135 & charx + 22 <= 180 & chary >=155 & chary + 28 <= 300) 
                    ||(charx + 4 >= 135 & charx + 22 <=235 & chary >= 215 & chary + 28 <= 300)))


 //move right is priority
          begin
                direction = 2'b11;
                charx <= charx + 4;
          end
          else if (moveleft && (charx - 4 < 640) && (charx - 4> 0) && 
                    ((charx - 4 >= 15 & charx + 14 <= 55 & chary >= 15 & chary + 28 <= 260) ||(charx - 4 >= 15 & charx + 14 <= 55 & chary >= 275 & chary + 28 <= 395) 
                    ||(charx - 4 >= 15 & charx + 14 <= 625 & chary >= 410 & chary + 28 <= 465)
                    ||(charx - 4 >= 15 & charx + 14 <= 250 & chary >= 15 & chary + 28 <= 70) ||(charx - 4 >= 335 & charx + 14 <= 625 & chary >= 15 & chary + 28 <= 70) 
                    ||(charx - 4 >= 570 & charx + 14 <= 625 & chary >= 15 & chary + 28 <= 140) ||(charx - 4 >= 265 & charx + 14 <= 320 & chary >= 0 & chary + 28 <= 140) 
                    ||(charx - 4 >= 70 & charx + 14 <= 320 & chary >=85 & chary + 28 <=140) ||(charx - 4 >= 505 & charx + 14 <= 625 & chary >=85 & chary + 28 <=140)
                    ||(charx - 4 >= 335 & charx + 14 <= 490 & chary >=85 & chary + 28 <= 140) ||(charx - 4 >=505 & charx + 14 <=640 & chary >= 155 & chary + 28 <= 205) 
                    ||(charx - 4 >=505 & charx + 14 <= 555 & chary >=85 & chary + 28 <= 205) ||(charx - 4 >= 265 & charx + 14 <= 320 & chary >=300 & chary + 28 <= 465) 
                    ||(charx - 4 >= 570 & charx + 14 <=625 & chary >= 155 & chary + 28 <= 245) ||(charx - 4 >= 445 & charx + 14 <= 625 & chary >= 213 & chary + 28 <= 245)
                    ||(charx - 4 >= 445 & charx + 14 <= 490 & chary >= 85 & chary + 28 <= 245) ||(charx - 4 >= 505 & charx + 14 <=555 & chary >= 220 & chary + 28 <=300) 
                    ||(charx - 4 >= 445 & charx + 14 <= 555 & chary >= 260 & chary + 28 <= 300)||(charx - 4 >= 585 & charx + 14 <= 625 & chary >=315 & chary + 28 <= 465) 
                    ||(charx - 4 >= 515 & charx + 14 <=570 & chary >= 315 & chary + 28 <= 395) ||(charx - 4 >= 335 & charx + 14 <= 380 & chary >=85  & chary + 28 <= 260)
                    ||(charx - 4 >= 395 & charx + 14 <= 625 & chary >=315 & chary + 28 <= 360)||(charx - 4 >= 390 & charx + 14 <=435 & chary >= 85 & chary + 28<= 140)
                    ||(charx - 4 >= 390 & charx + 14 <=435 & chary >= 155 & chary + 28 <= 360) 
                    ||(charx - 4 >= 265 & charx + 14 <=390 & chary >= 375 & chary + 28 <= 410)||(charx - 4 >= 265 & charx + 14 <= 350 & chary >=300 & chary + 28 <= 345) 
                    ||(charx - 4 >= 265 & charx + 14 <=380 & chary >= 215 & chary + 28 <= 260) ||(charx - 4 >= 185 & charx + 14 <= 235 & chary >= 215 & chary + 28 <= 465)
                    ||(charx - 4 >= 70 & charx + 14 <= 125 & chary >=85 & chary + 28 <= 200) ||(charx - 4 >= 15  & charx + 14 <=125 & chary >= 155 & chary + 28 <= 200) 
                    ||(charx - 4 >=15 & charx + 14 <= 125 & chary >= 215 & chary + 28 <= 260)||(charx - 4 >= 15 & charx + 14 <= 125 & chary >=275 & chary + 28 <= 315) 
                    ||(charx - 4 >= 70 & charx + 14 <=125 & chary >= 215 & chary + 28 <= 315) ||(charx - 4 >= 15 & charx + 14 <= 175 & chary >= 355 & chary + 28 <= 395)
                     ||(charx - 4 >= 135 & charx + 14 <=235 & chary >= 315 & chary + 28 <= 395) 
                    ||(charx - 4 >= 135 & charx + 14 <= 435 & chary >= 155 & chary + 28 <= 200)||(charx - 4 >= 135 & charx + 14 <= 180 & chary >=155 & chary + 28 <= 300) 
                    ||(charx - 4 >= 135 & charx + 14 <=235 & chary >= 215 & chary + 28 <= 300)))

 //otherwise move left
          begin
                direction = 2'b10;
                charx <= charx - 4;
          end
          else if (movedown && (chary + 32 + 10 < 480) && (chary + 32> 0) && 
                    ((charx >= 15 & charx + 18 <= 55 & chary + 4 >= 15 & chary + 32 <= 260) ||(charx >= 15 & charx + 18 <= 55 & chary + 4 >= 275 & chary + 32 <= 395) 
                    ||(charx >= 15 & charx + 18 <= 625 & chary + 4 >= 410 & chary + 32 <= 465)
                    ||(charx >= 15 & charx + 18 <= 250 & chary + 4 >= 15 & chary + 32 <= 70) ||(charx >= 335 & charx + 18 <= 625 & chary + 4 >= 15 & chary + 32 <= 70) 
                    ||(charx >= 570 & charx + 18 <= 625 & chary + 4 >= 15 & chary + 32 <= 140) ||(charx >= 265 & charx + 18 <= 320 & chary + 4 >= 0 & chary + 32 <= 140) 
                    ||(charx >= 70 & charx + 18 <= 320 & chary + 4 >=85 & chary + 32 <=140) ||(charx >= 505 & charx + 18 <= 625 & chary + 4 >=85 & chary + 32 <=140)
                    ||(charx >= 335 & charx + 18 <= 490 & chary + 4 >=85 & chary + 32 <= 140) ||(charx >=505 & charx + 18 <=640 & chary + 4 >= 155 & chary + 32 <= 205) 
                    ||(charx >=505 & charx + 18 <= 555 & chary + 4 >=85 & chary + 32 <= 205) ||(charx >= 265 & charx + 18 <= 320 & chary + 4 >=300 & chary + 32 <= 465) 
                    ||(charx >= 570 & charx + 18 <=625 & chary + 4 >= 155 & chary + 32 <= 245) ||(charx >= 445 & charx + 18 <= 625 & chary + 4 >= 213 & chary + 32 <= 245)
                    ||(charx >= 445 & charx + 18 <= 490 & chary + 4 >= 85 & chary + 32 <= 245) ||(charx >= 505 & charx + 18 <=555 & chary + 4 >= 220 & chary + 32 <=300) 
                    ||(charx >= 445 & charx + 18 <= 555 & chary + 4 >= 260 & chary + 32 <= 300)||(charx >= 585 & charx + 18 <= 625 & chary + 4 >=315 & chary + 32 <= 465) 
                    ||(charx >= 515 & charx + 18 <=570 & chary + 4 >= 315 & chary + 32 <= 395) ||(charx >= 335 & charx + 18 <= 380 & chary + 4 >=85  & chary + 32 <= 260)
                    ||(charx >= 395 & charx + 18 <= 625 & chary + 4 >=315 & chary + 32 <= 360) ||(charx >= 390 & charx + 18 <=435 & chary + 4 >= 85 & chary + 32 <= 140)
                    ||(charx >= 390 & charx + 18 <=435 & chary + 4 >= 155 & chary + 32 <= 360) 
                    ||(charx >= 265 & charx + 18 <=390 & chary + 4 >= 375 & chary + 32 <= 410)||(charx >= 265 & charx + 18 <= 350 & chary + 4 >=300 & chary + 32 <= 345) 
                    ||(charx >= 265 & charx + 18 <=380 & chary + 4 >= 215 & chary + 32 <= 260) ||(charx >= 185 & charx + 18 <= 235 & chary + 4 >= 215 & chary + 32 <= 465)
                    ||(charx >= 70 & charx + 18 <= 125 & chary + 4 >=85 & chary + 32 <= 200) ||(charx >= 15  & charx + 18 <=125 & chary + 4 >= 155 & chary + 32 <= 200) 
                    ||(charx >=15 & charx + 18 <= 125 & chary + 4 >= 215 & chary + 32 <= 260)||(charx >= 15 & charx + 18 <= 125 & chary + 4 >=275 & chary + 32 <= 315) 
                    ||(charx >= 70 & charx + 18 <=125 & chary + 4 >= 215 & chary + 32 <= 315) ||(charx >= 15 & charx + 18 <= 175 & chary + 4 >= 355 & chary + 32 <= 395)
                     ||(charx >= 135 & charx + 18 <=235 & chary + 4 >= 315 & chary + 32 <= 395) 
                    ||(charx >= 135 & charx + 18 <= 435 & chary + 4 >= 155 & chary + 32 <= 200)||(charx >= 135 & charx + 18 <= 180 & chary + 4 >=155 & chary + 32 <= 300) 
                    ||(charx >= 135 & charx + 18 <=235 & chary + 4 >= 215 & chary + 32 <= 300)))



 //move right is priority
          begin
                direction = 2'b00;
                chary <= chary + 4;
          end
          else if ((moveup && (chary - 4 < 480) && (chary - 4 > 0)) && 
                    ((charx >= 15 & charx + 18 <= 55 & chary - 4 >= 15 & chary + 24 <= 260) ||(charx >= 15 & charx + 18 <= 55 & chary - 4 >= 275 & chary + 24 <= 395) 
                    ||(charx >= 15 & charx + 18 <= 625 & chary - 4 >= 410 & chary + 24 <= 465)
                    ||(charx >= 15 & charx + 18 <= 250 & chary - 4 >= 15 & chary + 24 <= 70) ||(charx >= 335 & charx + 18 <= 625 & chary - 4 >= 15 & chary + 24 <= 70) 
                    ||(charx >= 570 & charx + 18 <= 625 & chary - 4 >= 15 & chary + 24 <= 140) ||(charx >= 265 & charx + 18 <= 320 & chary - 4 >= 0 & chary + 24 <= 140) 
                    ||(charx >= 70 & charx + 18 <= 320 & chary - 4 >=85 & chary + 24 <=140) ||(charx >= 505 & charx + 18 <= 625 & chary - 4 >=85 & chary + 24 <=140)
                    ||(charx >= 335 & charx + 18 <= 490 & chary - 4 >=85 & chary + 24 <= 140) ||(charx >=505 & charx + 18 <=640 & chary - 4 >= 155 & chary + 24 <= 205) 
                    ||(charx >= 505 & charx + 18 <= 555 & chary - 4 >=85 & chary + 24 <= 205) ||(charx >= 265 & charx + 18 <= 320 & chary - 4 >=300 & chary + 24 <= 465) 
                    ||(charx >= 570 & charx + 18 <=625 & chary - 4 >= 155 & chary + 24 <= 245) ||(charx >= 445 & charx + 18 <= 625 & chary - 4 >= 213 & chary + 24 <= 245)
                    ||(charx >= 445 & charx + 18 <= 490 & chary - 4 >= 85 & chary + 24 <= 245) ||(charx >= 505 & charx + 18 <=555 & chary - 4 >= 220 & chary + 24 <=300) 
                    ||(charx >= 445 & charx + 18 <= 555 & chary - 4 >= 260 & chary + 24 <= 300)||(charx >= 585 & charx + 18 <= 625 & chary - 4 >=315 & chary + 24 <= 465) 
                    ||(charx >= 515 & charx + 18 <=570 & chary - 4 >= 315 & chary + 24 <= 395) ||(charx >= 335 & charx + 18 <= 380 & chary - 4 >=85  & chary + 24 <= 260)
                    ||(charx >= 395 & charx + 18 <= 625 & chary - 4 >=315 & chary + 24 <= 360) ||(charx >= 390 & charx + 18 <=435 & chary - 4 >= 85 & chary + 24 <= 140)
                    ||(charx >= 390 & charx + 18 <=435 & chary - 4 >= 155 & chary + 24 <= 360)  
                    ||(charx >= 265 & charx + 18 <=390 & chary - 4 >= 375 & chary + 24 <= 410)||(charx >= 265 & charx + 18 <= 350 & chary - 4 >=300 & chary + 24 <= 345) 
                    ||(charx >= 265 & charx + 18 <=380 & chary - 4 >= 215 & chary + 24 <= 260) ||(charx >= 185 & charx + 18 <= 235 & chary - 4 >= 215 & chary + 24 <= 465)
                    ||(charx >= 70 & charx + 18 <= 125 & chary - 4 >=85 & chary + 24 <= 200) ||(charx >= 15  & charx + 18 <=125 & chary - 4 >= 155 & chary + 24 <= 200) 
                    ||(charx >= 15 & charx + 18 <= 125 & chary - 4 >= 215 & chary + 24 <= 260)||(charx >= 15 & charx + 18 <= 125 & chary - 4 >=275 & chary + 24 <= 315) 
                    ||(charx >= 70 & charx + 18 <=125 & chary - 4 >= 215 & chary + 24 <= 315) ||(charx >= 15 & charx + 18 <= 175 & chary - 4 >= 355 & chary + 24 <= 395)
                    ||(charx >= 135 & charx + 18 <=235 & chary - 4 >= 315 & chary + 24 <= 395) 
                    ||(charx >= 135 & charx + 18 <= 435 & chary - 4 >= 155 & chary + 24 <= 200)||(charx >= 135 & charx + 18 <= 180 & chary - 4 >=155 & chary + 24 <= 300) 
                    ||(charx >= 135 & charx + 18 <=235 & chary - 4 >= 215 & chary + 24 <= 300)))


  //otherwise move left
          begin
                direction = 2'b01;
                chary <= chary - 4;
          end
   
      if ((charx + 17 > monx) && (charx < monx + 35) && (chary + 25 > mony) && (chary < mony + 50))
                deathflag <= 1;
      if ((charx + 10 > keyx) && (charx < keyx + 10) && (chary + 10 > keyy) && (chary < keyy + 10))
                gatestate <= 1;
      if ((charx + 10 > gatex) && (charx < gatex + 10) && (chary + 17 > gatey) && (chary < gatey + 17) && gatestate == 1)
                winflag <= 1;
      if (cstate==1)
      begin
            if (/*(movingAtY == 1) && */(charx + 17 > monx) && (charx < monx + 35) &&
           (((charx >= 390 & charx <=435 & chary >= 155 & chary <= 360)&&(monx >= 390 & monx <=435 & mony >= 155 & mony <= 360))||
            ((charx >= 335 & charx <= 380 & chary >=85  & chary <= 260)&&(monx >= 335 & monx <= 380 & mony >=85  & mony <= 260))||
            ((charx >= 185 & charx <= 235 & chary >= 215 & chary <= 465)&&(monx >= 185 & monx <= 235 & mony >= 215 & mony <= 465))))
           begin
               if (chary + 25 > mony)
                    mony <= mony + 16;
               else if (chary < mony + 50)
                    mony <= mony - 16;
               end 
          else if (/*(movingAtX == 1) && */(chary + 25 > mony) && (chary < mony + 50) && 
            (((charx >= 135 & charx <=435 & chary >= 155 & chary <= 200)&&(monx >= 135 & monx <=435 & mony >= 155 & mony <= 200))||
            ((chary >= 400 & chary <= 465)&&(mony >= 400 & mony <= 465))||
            ((charx >= 395 & charx <= 625 & chary >=315 & chary <= 360) && (monx >= 395 & monx <= 625 & mony >=315 & mony <= 360))))
               begin
               if (charx + 17 > monx)
                    monx <= monx + 16;
               else if (charx < monx + 35)
                    monx <= monx - 16;
               end 
          else
          begin
            if (tlstate == 1)
            begin
                if (
                        ((monx - 4 >= 15 & monx + 11 <= 55 & mony >= 15 & mony + 25 <= 260) ||(monx - 4 >= 15 & monx + 11 <= 55 & mony >= 275 & mony + 25 <= 395) 
                        ||(monx - 4 >= 15 & monx + 11 <= 625 & mony >= 410 & mony + 25 <= 465)
                        ||(monx - 4 >= 15 & monx + 11 <= 250 & mony >= 15 & mony + 25 <= 70) ||(monx - 4 >= 335 & monx + 11 <= 625 & mony >= 15 & mony + 25 <= 70) 
                        ||(monx - 4 >= 570 & monx + 11 <= 625 & mony >= 15 & mony + 25 <= 140) ||(monx - 4 >= 265 & monx + 11 <= 320 & mony >= 0 & mony + 25 <= 140) 
                        ||(monx - 4 >= 70 & monx + 11 <= 320 & mony >=85 & mony + 25 <=140) ||(monx - 4 >= 505 & monx + 11 <= 625 & mony >=85 & mony + 25 <=140)
                        ||(monx - 4 >= 335 & monx + 11 <= 490 & mony >=85 & mony + 25 <= 140) ||(monx - 4 >=505 & monx + 11 <=640 & mony >= 155 & mony + 25 <= 205) 
                        ||(monx - 4 >=505 & monx + 11 <= 555 & mony >=85 & mony + 25 <= 205) ||(monx - 4 >= 265 & monx + 11 <= 320 & mony >=300 & mony + 25 <= 465) 
                        ||(monx - 4 >= 570 & monx + 11 <=625 & mony >= 155 & mony + 25 <= 245) ||(monx - 4 >= 445 & monx + 11 <= 625 & mony >= 213 & mony + 25 <= 245)
                        ||(monx - 4 >= 445 & monx + 11 <= 490 & mony >= 85 & mony + 25 <= 245) ||(monx - 4 >= 505 & monx + 11 <=555 & mony >= 220 & mony + 25 <=300) 
                        ||(monx - 4 >= 445 & monx + 11 <= 555 & mony >= 260 & mony + 25 <= 300)||(monx - 4 >= 585 & monx + 11 <= 625 & mony >=315 & mony + 25 <= 465) 
                        ||(monx - 4 >= 515 & monx + 11 <=570 & mony >= 315 & mony + 25 <= 395) ||(monx - 4 >= 335 & monx + 11 <= 380 & mony >=85  & mony + 25 <= 260)
                        ||(monx - 4 >= 395 & monx + 11 <= 625 & mony >=315 & mony + 25 <= 360) ||(monx - 4 >= 390 & monx + 11 <=435 & mony >= 85 & mony + 25 <= 140)
                        ||(monx - 4 >= 390 & monx + 11 <=435 & mony >= 155 & mony + 25 <= 360) 
                        ||(monx - 4 >= 265 & monx + 11 <=390 & mony >= 375 & mony + 25 <= 410)||(monx - 4 >= 265 & monx + 11 <= 350 & mony >=300 & mony + 25 <= 345) 
                        ||(monx - 4 >= 265 & monx + 11 <=380 & mony >= 215 & mony + 25 <= 260) ||(monx - 4 >= 185 & monx + 11 <= 235 & mony >= 215 & mony + 25 <= 465)
                        ||(monx - 4 >= 70 & monx + 11 <= 125 & mony >=85 & mony + 25 <= 200) ||(monx - 4 >= 15  & monx + 11 <=125 & mony >= 155 & mony + 25 <= 200) 
                        ||(monx - 4 >=15 & monx + 11 <= 125 & mony >= 215 & mony + 25 <= 260)||(monx - 4 >= 15 & monx + 11 <= 125 & mony >=275 & mony + 25 <= 315) 
                        ||(monx - 4 >= 70 & monx + 11 <=125 & mony >= 215 & mony + 25 <= 315) ||(monx - 4 >= 15 & monx + 11 <= 175 & mony >= 355 & mony + 25 <= 395)
                         ||(monx - 4 >= 135 & monx + 11 <=235 & mony >= 315 & mony + 25 <= 395) 
                        ||(monx - 4 >= 135 & monx + 11 <= 435 & mony >= 155 & mony + 25 <= 200)||(monx - 4 >= 135 & monx + 11 <= 180 & mony >=155 & mony + 25 <= 300) 
                        ||(monx - 4 >= 135 & monx + 11 <=235 & mony >= 215 & mony + 25 <= 300)))
    
     //we move left
              begin
                    monx <= monx - 5;
                    /*
                    movingAtX <= 1;
                    movingAtY <= 0;
                    */
              end
              else if (
                        ((monx >= 15 & monx + 15 <= 55 & mony - 4 >= 15 & mony + 21 <= 260) ||(monx >= 15 & monx + 15 <= 55 & mony - 4 >= 275 & mony + 21 <= 395) 
                        ||(monx >= 15 & monx + 15 <= 625 & mony - 4 >= 410 & mony + 21 <= 465)
                        ||(monx >= 15 & monx + 15 <= 250 & mony - 4 >= 15 & mony + 21 <= 70) ||(monx >= 335 & monx + 15 <= 625 & mony - 4 >= 15 & mony + 21 <= 70) 
                        ||(monx >= 570 & monx + 15 <= 625 & mony - 4 >= 15 & mony + 21 <= 140) ||(monx >= 265 & monx + 15 <= 320 & mony - 4 >= 0 & mony + 21 <= 140) 
                        ||(monx >= 70 & monx + 15 <= 320 & mony - 4 >=85 & mony + 21 <=140) ||(monx >= 505 & monx + 15 <= 625 & mony - 4 >=85 & mony + 21 <=140)
                        ||(monx >= 335 & monx + 15 <= 490 & mony - 4 >=85 & mony + 21 <= 140) ||(monx >=505 & monx + 15 <=640 & mony - 4 >= 155 & mony + 21 <= 205) 
                        ||(monx >= 505 & monx + 15 <= 555 & mony - 4 >=85 & mony + 21 <= 205) ||(monx >= 265 & monx + 15 <= 320 & mony - 4 >=300 & mony + 21 <= 465) 
                        ||(monx >= 570 & monx + 15 <=625 & mony - 4 >= 155 & mony + 21 <= 245) ||(monx >= 445 & monx + 15 <= 625 & mony - 4 >= 213 & mony + 21 <= 245)
                        ||(monx >= 445 & monx + 15 <= 490 & mony - 4 >= 85 & mony + 21 <= 245) ||(monx >= 505 & monx + 15 <=555 & mony - 4 >= 220 & mony + 21 <=300) 
                        ||(monx >= 445 & monx + 15 <= 555 & mony - 4 >= 260 & mony + 21 <= 300)||(monx >= 585 & monx + 15 <= 625 & mony - 4 >=315 & mony + 21 <= 465) 
                        ||(monx >= 515 & monx + 15 <=570 & mony - 4 >= 315 & mony + 21 <= 395) ||(monx >= 335 & monx + 15 <= 380 & mony - 4 >=85  & mony + 21 <= 260)
                        ||(monx >= 395 & monx + 15 <= 625 & mony - 4 >=315 & mony + 21 <= 360) ||(monx >= 390 & monx + 15 <=435 & mony - 4 >= 85 & mony + 21 <= 140)
                        ||(monx >= 390 & monx + 15 <=435 & mony - 4 >= 155 & mony + 21 <= 360) 
                        ||(monx >= 265 & monx + 15 <=390 & mony - 4 >= 375 & mony + 21 <= 410)||(monx >= 265 & monx + 15 <= 350 & mony - 4 >=300 & mony + 21 <= 345) 
                        ||(monx >= 265 & monx + 15 <=380 & mony - 4 >= 215 & mony + 21 <= 260) ||(monx >= 185 & monx + 15 <= 235 & mony - 4 >= 215 & mony + 21 <= 465)
                        ||(monx >= 70 & monx + 15 <= 125 & mony - 4 >=85 & mony + 21 <= 200) ||(monx >= 15  & monx + 15 <=125 & mony - 4 >= 155 & mony + 21 <= 200) 
                        ||(monx >= 15 & monx + 15 <= 125 & mony - 4 >= 215 & mony + 21 <= 260)||(monx >= 15 & monx + 15 <= 125 & mony - 4 >=275 & mony + 21 <= 315) 
                        ||(monx >= 70 & monx + 15 <=125 & mony - 4 >= 215 & mony + 21 <= 315) ||(monx >= 15 & monx + 15 <= 175 & mony - 4 >= 355 & mony + 21 <= 395)
                        ||(monx >= 135 & monx + 15 <=235 & mony - 4 >= 315 & mony + 21 <= 395) 
                        ||(monx >= 135 & monx + 15 <= 435 & mony - 4 >= 155 & mony + 21 <= 200)||(monx >= 135 & monx + 15 <= 180 & mony - 4 >=155 & mony + 21 <= 300) 
                        ||(monx >= 135 & monx + 15 <=235 & mony - 4 >= 215 & mony + 21 <= 300)))

  //we move up
              begin
                    mony <= mony - 5;
                    /*
                    movingAtX <= 0;
                    movingAtY <= 1;
                    */
              end
            else
            begin
                tlstate <= 0;
                brstate <= 1;
            end
        
        end
        else if (brstate == 1)
            begin
                if (
                    ((monx >= 15 & monx + 15 <= 55 & mony + 4 >= 15 & mony + 29 <= 260) ||(monx >= 15 & monx + 15 <= 55 & mony + 4 >= 275 & mony + 29 <= 395) 
                    ||(monx >= 15 & monx + 15 <= 625 & mony + 4 >= 410 & mony + 29 <= 465)
                    ||(monx >= 15 & monx + 15 <= 250 & mony + 4 >= 15 & mony + 29 <= 70) ||(monx >= 335 & monx + 15 <= 625 & mony + 4 >= 15 & mony + 29 <= 70) 
                    ||(monx >= 570 & monx + 15 <= 625 & mony + 4 >= 15 & mony + 29 <= 140) ||(monx >= 265 & monx + 15 <= 320 & mony + 4 >= 0 & mony + 29 <= 140) 
                    ||(monx >= 70 & monx + 15 <= 320 & mony + 4 >=85 & mony + 29 <=140) ||(monx >= 505 & monx + 15 <= 625 & mony + 4 >=85 & mony + 29 <=140)
                    ||(monx >= 335 & monx + 15 <= 490 & mony + 4 >=85 & mony + 29 <= 140) ||(monx >=505 & monx + 15 <=640 & mony + 4 >= 155 & mony + 29 <= 205) 
                    ||(monx >=505 & monx + 15 <= 555 & mony + 4 >=85 & mony + 29 <= 205) ||(monx >= 265 & monx + 15 <= 320 & mony + 4 >=300 & mony + 29 <= 465) 
                    ||(monx >= 570 & monx + 15 <=625 & mony + 4 >= 155 & mony + 29 <= 245) ||(monx >= 445 & monx + 15 <= 625 & mony + 4 >= 213 & mony + 29 <= 245)
                    ||(monx >= 445 & monx + 15 <= 490 & mony + 4 >= 85 & mony + 29 <= 245) ||(monx >= 505 & monx + 15 <=555 & mony + 4 >= 220 & mony + 29 <=300) 
                    ||(monx >= 445 & monx + 15 <= 555 & mony + 4 >= 260 & mony + 29 <= 300)||(monx >= 585 & monx + 15 <= 625 & mony + 4 >=315 & mony + 29 <= 465) 
                    ||(monx >= 515 & monx + 15 <=570 & mony + 4 >= 315 & mony + 29 <= 395) ||(monx >= 335 & monx + 15 <= 380 & mony + 4 >=85  & mony + 29 <= 260)
                    ||(monx >= 395 & monx + 15 <= 625 & mony + 4 >=315 & mony + 29 <= 360) ||(monx >= 390 & monx + 15 <=435 & mony + 4 >= 85 & mony + 29 <= 140)
                    ||(monx >= 390 & monx + 15 <=435 & mony + 4 >= 155 & mony + 29 <= 360) 
                    ||(monx >= 265 & monx + 15 <=390 & mony + 4 >= 375 & mony + 29 <= 410)||(monx >= 265 & monx + 15 <= 350 & mony + 4 >=300 & mony + 29 <= 345) 
                    ||(monx >= 265 & monx + 15 <=380 & mony + 4 >= 215 & mony + 29 <= 260) ||(monx >= 185 & monx + 15 <= 235 & mony + 4 >= 215 & mony + 29 <= 465)
                    ||(monx >= 70 & monx + 15 <= 125 & mony + 4 >=85 & mony + 29 <= 200) ||(monx >= 15  & monx + 15 <=125 & mony + 4 >= 155 & mony + 29 <= 200) 
                    ||(monx >=15 & monx + 15 <= 125 & mony + 4 >= 215 & mony + 29 <= 260)||(monx >= 15 & monx + 15 <= 125 & mony + 4 >=275 & mony + 29 <= 315) 
                    ||(monx >= 70 & monx + 15 <=125 & mony + 4 >= 215 & mony + 29 <= 315) ||(monx >= 15 & monx + 15 <= 175 & mony + 4 >= 355 & mony + 29 <= 395)
                     ||(monx >= 135 & monx + 15 <=235 & mony + 4 >= 315 & mony + 29 <= 395) 
                    ||(monx >= 135 & monx + 15 <= 435 & mony + 4 >= 155 & mony + 29 <= 200)||(monx >= 135 & monx + 15 <= 180 & mony + 4 >=155 & mony + 29 <= 300) 
                    ||(monx >= 135 & monx + 15 <=235 & mony + 4 >= 215 & mony + 29 <= 300))
                    && mony + 29 <= 450)

 //we move down
          begin
                mony <= mony + 5;
                /*
                movingAtX <= 0;
                movingAtY <= 1;
                */
          end

              else if (
                        ((monx + 4 >= 15 & monx + 19 <= 55 & mony >= 15 & mony + 25 <= 260) ||(monx + 4 >= 15 & monx + 19 <= 55 & mony >= 275 & mony + 25 <= 395) 
                        ||(monx + 4 >= 15 & monx + 19 <= 625 & mony >= 410 & mony + 25 <= 465)
                        ||(monx + 4 >= 15 & monx + 19 <= 250 & mony >= 15 & mony + 25 <= 70) ||(monx + 4 >= 335 & monx + 19 <= 625 & mony >= 15 & mony + 25 <= 70) 
                        ||(monx + 4 >= 570 & monx + 19 <= 625 & mony >= 15 & mony + 25 <= 140) ||(monx + 4 >= 265 & monx + 19 <= 320 & mony >= 0 & mony + 25 <= 140) 
                        ||(monx + 4 >= 70 & monx + 19 <= 320 & mony >=85 & mony + 25 <=140) ||(monx + 4 >= 505 & monx + 19 <= 625 & mony >=85 & mony + 25 <=140)
                        ||(monx + 4 >= 335 & monx + 19 <= 490 & mony >=85 & mony + 25 <= 140) ||(monx + 4 >=505 & monx + 19 <=640 & mony >= 155 & mony + 25 <= 205) 
                        ||(monx + 4 >=505 & monx + 19 <= 555 & mony >=85 & mony + 25 <= 205) ||(monx + 4 >= 265 & monx + 19 <= 320 & mony >=300 & mony + 25 <= 465) 
                        ||(monx + 4 >= 570 & monx + 19 <=625 & mony >= 155 & mony + 25 <= 245) ||(monx + 4 >= 445 & monx + 19 <= 625 & mony >= 213 & mony + 25 <= 245)
                        ||(monx + 4 >= 445 & monx + 19 <= 490 & mony >= 85 & mony + 25 <= 245) ||(monx + 4 >= 505 & monx + 19 <=555 & mony >= 220 & mony + 25 <=300) 
                        ||(monx + 4 >= 445 & monx + 19 <= 555 & mony >= 260 & mony + 25 <= 300)||(monx + 4 >= 585 & monx + 19 <= 625 & mony >=315 & mony + 25 <= 465) 
                        ||(monx + 4 >= 515 & monx + 19 <=570 & mony >= 315 & mony + 25 <= 395) ||(monx + 4 >= 335 & monx + 19 <= 380 & mony >=85  & mony + 25 <= 260)
                        ||(monx + 4 >= 395 & monx + 19 <= 625 & mony >=315 & mony + 25 <= 360) ||(monx + 4 >= 390 & monx + 19 <=435 & mony >= 85 & mony + 25 <= 140) 
                         ||(monx + 4 >= 390 & monx + 19 <=435 & mony >= 155 & mony + 25 <= 360) 
                        ||(monx + 4 >= 265 & monx + 19 <=390 & mony >= 375 & mony + 25 <= 410)||(monx + 4 >= 265 & monx + 19 <= 350 & mony >=300 & mony + 25 <= 345) 
                        ||(monx + 4 >= 265 & monx + 19 <=380 & mony >= 215 & mony + 25 <= 260) ||(monx + 4 >= 185 & monx + 19 <= 235 & mony >= 215 & mony + 25 <= 465)
                        ||(monx + 4 >= 70 & monx + 19 <= 125 & mony >=85 & mony + 25 <= 200) ||(monx + 4 >= 15  & monx + 19 <=125 & mony >= 155 & mony + 25 <= 200) 
                        ||(monx + 4 >=15 & monx + 19 <= 125 & mony >= 215 & mony + 25 <= 260)||(monx + 4 >= 15 & monx + 19 <= 125 & mony >=275 & mony + 25 <= 315) 
                        ||(monx + 4 >= 70 & monx + 19 <=125 & mony >= 215 & mony + 25 <= 315) ||(monx + 4 >= 15 & monx + 19 <= 175 & mony >= 355 & mony + 25 <= 395)
                         ||(monx + 4 >= 135 & monx + 19 <=235 & mony >= 315 & mony + 25 <= 395) 
                        ||(monx + 4 >= 135 & monx + 19 <= 435 & mony >= 155 & mony + 25 <= 200)||(monx + 4 >= 135 & monx + 19 <= 180 & mony >=155 & mony + 25 <= 300) 
                        ||(monx + 4 >= 135 & monx + 19 <=235 & mony >= 215 & mony + 25 <= 300)))
            
     //we move right
              begin
                    monx <= monx + 5;
                    /*
                    movingAtX <= 1;
                    movingAtY <= 0;
                    */
              end
            else
            begin
                brstate <= 0;
                upstate <= 1;
            end
           end
      else if (upstate == 1)
            begin
                if (
                    ((monx >= 15 & monx + 15 <= 55 & mony - 4 >= 15 & mony + 21 <= 260) ||(monx >= 15 & monx + 15 <= 55 & mony - 4 >= 275 & mony + 21 <= 395) 
                    ||(monx >= 15 & monx + 15 <= 625 & mony - 4 >= 410 & mony + 21 <= 465)
                    ||(monx >= 15 & monx + 15 <= 250 & mony - 4 >= 15 & mony + 21 <= 70) ||(monx >= 335 & monx + 15 <= 625 & mony - 4 >= 15 & mony + 21 <= 70) 
                    ||(monx >= 570 & monx + 15 <= 625 & mony - 4 >= 15 & mony + 21 <= 140) ||(monx >= 265 & monx + 15 <= 320 & mony - 4 >= 0 & mony + 21 <= 140) 
                    ||(monx >= 70 & monx + 15 <= 320 & mony - 4 >=85 & mony + 21 <=140) ||(monx >= 505 & monx + 15 <= 625 & mony - 4 >=85 & mony + 21 <=140)
                    ||(monx >= 335 & monx + 15 <= 490 & mony - 4 >=85 & mony + 21 <= 140) ||(monx >=505 & monx + 15 <=640 & mony - 4 >= 155 & mony + 21 <= 205) 
                    ||(monx >= 505 & monx + 15 <= 555 & mony - 4 >=85 & mony + 21 <= 205) ||(monx >= 265 & monx + 15 <= 320 & mony - 4 >=300 & mony + 21 <= 465) 
                    ||(monx >= 570 & monx + 15 <=625 & mony - 4 >= 155 & mony + 21 <= 245) ||(monx >= 445 & monx + 15 <= 625 & mony - 4 >= 213 & mony + 21 <= 245)
                    ||(monx >= 445 & monx + 15 <= 490 & mony - 4 >= 85 & mony + 21 <= 245) ||(monx >= 505 & monx + 15 <=555 & mony - 4 >= 220 & mony + 21 <=300) 
                    ||(monx >= 445 & monx + 15 <= 555 & mony - 4 >= 260 & mony + 21 <= 300)||(monx >= 585 & monx + 15 <= 625 & mony - 4 >=315 & mony + 21 <= 465) 
                    ||(monx >= 515 & monx + 15 <=570 & mony - 4 >= 315 & mony + 21 <= 395) ||(monx >= 335 & monx + 15 <= 380 & mony - 4 >=85  & mony + 21 <= 260)
                    ||(monx >= 395 & monx + 15 <= 625 & mony - 4 >=315 & mony + 21 <= 360) ||(monx >= 390 & monx + 15 <=435 & mony - 4 >= 85 & mony + 21 <= 140) 
                    ||(monx >= 390 & monx + 15 <=435 & mony - 4 >= 155 & mony + 21 <= 360) 
                    ||(monx >= 265 & monx + 15 <=390 & mony - 4 >= 375 & mony + 21 <= 410)||(monx >= 265 & monx + 15 <= 350 & mony - 4 >=300 & mony + 21 <= 345) 
                    ||(monx >= 265 & monx + 15 <=380 & mony - 4 >= 215 & mony + 21 <= 260) ||(monx >= 185 & monx + 15 <= 235 & mony - 4 >= 215 & mony + 21 <= 465)
                    ||(monx >= 70 & monx + 15 <= 125 & mony - 4 >=85 & mony + 21 <= 200) ||(monx >= 15  & monx + 15 <=125 & mony - 4 >= 155 & mony + 21 <= 200) 
                    ||(monx >= 15 & monx + 15 <= 125 & mony - 4 >= 215 & mony + 21 <= 260)||(monx >= 15 & monx + 15 <= 125 & mony - 4 >=275 & mony + 21 <= 315) 
                    ||(monx >= 70 & monx + 15 <=125 & mony - 4 >= 215 & mony + 21 <= 315) ||(monx >= 15 & monx + 15 <= 175 & mony - 4 >= 355 & mony + 21 <= 395)
                    ||(monx >= 135 & monx + 15 <=235 & mony - 4 >= 315 & mony + 21 <= 395) 
                    ||(monx >= 135 & monx + 15 <= 435 & mony - 4 >= 155 & mony + 21 <= 200)||(monx >= 135 & monx + 15 <= 180 & mony - 4 >=155 & mony + 21 <= 300) 
                    ||(monx >= 135 & monx + 15 <=235 & mony - 4 >= 215 & mony + 21 <= 300)))

  //we move up
                  begin
                        mony <= mony - 5;
                        /*
                        movingAtX <= 0;
                        movingAtY <= 1;
                        */
                  end
            else
            begin
                upstate <= 0;
                tlstate <= 1;
                /*
                        movingAtX <= 0;
                        movingAtY <= 0;
                        */
            end
       end
       end
       end
    end
end

    
numbers lastnum(clk, hpos, vpos, 10'd600, 10'd20, smallnum, small_on);
numbers midnum(clk, hpos, vpos, 10'd570, 10'd20, mednum, med_on);
numbers firstnum(clk, hpos, vpos, 10'd540, 10'd20, bignum, big_on);

charWrap char(clk, charx, chary, hpos, vpos, direction, charrgb, char_on);
monsterWrap monster(clk, monx, mony, hpos, vpos, monrgb, mon_on);
keyWrap key(clk, keyx, keyy, hpos, vpos, keyrgb, key_on);
gateWrap gate(clk, gatex, gatey, hpos, vpos, gatestate, gatergb, gate_on);
// Check if the character touches the monster

 always @(posedge clk) begin
       if (video_on == 1) begin
            if (cstate==0) begin
                  rgb<=startrgb;
                  end
            else if (cstate==2) begin
                  rgb<=winrgb;
                  if (small_on)
                        rgb<=12'hF00;
                  else if (med_on)
                        rgb<=12'hF00;
                  else if (big_on)
                        rgb<=12'hF00;
                  end
            else if (cstate==3) begin
                  if (jumpframe == 0)
                      rgb<=death1rgb;
                  else if (jumpframe == 1)
                      rgb<=death2rgb;
                  else if (jumpframe == 2)
                      rgb<=death3rgb;
                  else if (jumpframe == 3)
                  begin
                      if (timeflag == 1)
                        rgb <= timergb;
                      else if (timeflag == 0)
                        rgb<=deathrgb;
                  end
                  end
            else if (cstate==1) begin
                  if (small_on)
                        rgb<=12'hF00;
                  else if (med_on)
                        rgb<=12'hF00;
                  else if (big_on)
                        rgb<=12'hF00;
                  else if (char_on && charrgb != 12'b000011111111)
                        rgb<=charrgb;
                  else if (mon_on && monrgb != 12'b000011111111)
                        rgb<=monrgb;
                  else if (key_on && keyrgb != 12'b000011111111 && gatestate == 0)
                        rgb<=keyrgb;
                  else if (gate_on && gatergb != 12'b000011111111)
                        rgb<=gatergb;
                  else if (~maze_on)
                        rgb<=12'hF00;
                  else
                        rgb<=bgrgb;
                  end
            else
                begin
                rgb<=12'h000;
                end
            end
        else
            begin
            rgb<=12'h000;
            end
    end
endmodule
