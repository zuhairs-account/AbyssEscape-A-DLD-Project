`timescale 1ns / 1ps

module main(
    input clk,
    input start,
    input restart,
    input vauxp6,
    input vauxn6,
    input vauxp7,
    input vauxn7,
    input vauxp15,
    input vauxn15,
    input vauxp14,
    input vauxn14,
    
    output h_sync,
    output v_sync,
    output [11:0] rgb
);

reg [1:0] cstate; //current state stored as 3 bits
reg [1:0] nstate; //next state

wire winflag;
wire deathflag;

initial
begin
    cstate=2'b00;
end

always @(posedge clk)
begin
    cstate<=nstate;
    nstate[1]<=(cstate[1]&~restart)|(cstate[0]&~restart&deathflag)|(cstate[0]&~restart&winflag);
    nstate[0]<=(cstate[0]&~restart&~winflag)|(~cstate[1]&~cstate[0]&start)|(cstate[1]&cstate[0]&~restart);
    
end

gameplay game(cstate,clk,vauxp6,vauxn6,vauxp7,vauxn7,vauxp15,vauxn15,vauxp14,vauxn14,restart,start,h_sync,v_sync,rgb,winflag,deathflag);

endmodule
