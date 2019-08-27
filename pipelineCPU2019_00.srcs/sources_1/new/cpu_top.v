`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/08/26 23:47:20
// Design Name: 
// Module Name: cpu_top
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


module cpu_top(sysclk, reset, mem_sel, big_sel, main_finished, BCD);
// mem_sel: a button that decides which array in the array to display
// big_sel: a switch that decides whether to display systick or element of array
// main_finished: a led that indicates if main part of the mips code has been finished
    input sysclk, reset, mem_sel, big_sel; 
    output main_finished; 
    output [10:0] BCD;
    reg clk;
    wire [15:0] disp_reg;
    reg [6:0] mem_switch;
    reg main_finished_reg;
    assign main_finished = main_finished_reg;
    wire mem_sel_new;
    debounce debounceInstance(.clk(sysclk), .key_i(mem_sel), .key_o(mem_sel_new));
    always @ (posedge mem_sel_new) begin
        if(mem_switch==7'd100) mem_switch <= 7'd0;
        else mem_switch <= mem_switch + 1;
    end
    
    always @ (posedge sysclk) clk = ~clk;
    CPU CPUInstance(.reset(reset), .clk(clk));
    always @ (posedge CPUInstance.Interrupt) main_finished_reg = 1'b1;
    assign disp_reg = big_sel? CPUInstance.InstructionDecodeInstance.RegisterFileInstance.RF_data[2]:
        CPUInstance.MemoryInstance.DataMemoryInstance.RAM_data[mem_switch];
    BCDdisplay BCDdisplayInstance(.clk(sysclk), .disp_reg(disp_reg), .cathodes(BCD[6:0]), .an(BCD[10:7]));
    
endmodule
