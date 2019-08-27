//`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/06/07 21:43:17
// Design Name: 
// Module Name: BCDdisplay
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module BCDdisplay(
input clk,
input [15:0] disp_reg,
output [6:0] cathodes,
output [3:0] an
    );
    reg [16:0] cnt;
    reg [3:0] din;
    reg [3:0] an_t;
    assign an = an_t;
    always @ (posedge clk) begin
        cnt = cnt + 1;
        if(cnt >= 0 && cnt < 25000) 
            begin 
                din = disp_reg[3:0];
                an_t = 4'b1110;
            end
        else if(cnt < 50000) 
            begin 
                din = disp_reg[7:4];
                an_t = 4'b1101;
            end
        else if(cnt < 75000) 
            begin 
                din = disp_reg[11:8];
                an_t = 4'b1011;
            end
        else if(cnt < 100000)
            begin 
                din = disp_reg[15:12];
                an_t = 4'b0111;
            end
        else cnt = 0;
    end
    
    assign cathodes = 
             (din==4'd0)?7'b1000000:
             (din==4'd1)?7'b1111001:
             (din==4'd2)?7'b0100100:
             (din==4'd3)?7'b0110000:
             (din==4'd4)?7'b0011001:
             (din==4'd5)?7'b0010010:
             (din==4'd6)?7'b0000010:
             (din==4'd7)?7'b1111000:
             (din==4'd8)?7'b0000000:
             (din==4'd9)?7'b0010000:
             (din==4'ha)?7'b0001000:
             (din==4'hb)?7'b0000011:
             (din==4'hc)?7'b1000110:
             (din==4'hd)?7'b0100001:
             (din==4'he)?7'b0000100:
             (din==4'hf)?7'b0001110:7'b1111111;
endmodule
