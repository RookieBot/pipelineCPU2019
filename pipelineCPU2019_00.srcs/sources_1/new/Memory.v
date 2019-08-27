
module Memory(reset, clk, ALU_out, Write_data, PC_plus_4, MemWrite, MemRead, 
    RegWrite, WriteRegister, MemtoReg, Read_data, PC_plus_4_out, 
    RegWrite_out, WriteRegister_out, MemtoReg_out, ALU_out_thru, Interrupt);
    input reset, clk;
    input [31:0] ALU_out; // thru to WB
    input [31:0] Write_data; // for sw instruction
    input [31:0] PC_plus_4; // thru to WB
    input MemWrite;
    input MemRead;
    input RegWrite; // thru to WB
    input [4:0] WriteRegister; // thru to WB
    input [1:0] MemtoReg; // thru to WB
    output [31:0] Read_data;
    output [31:0] PC_plus_4_out;
    output RegWrite_out;
    output [4:0] WriteRegister_out; 
    output [1:0] MemtoReg_out;
    output [31:0] ALU_out_thru; 
    output Interrupt;
    
    // through to WB
    assign RegWrite_out = RegWrite;
    assign PC_plus_4_out = PC_plus_4[31:0];
    assign WriteRegister_out = WriteRegister[4:0];
    assign ALU_out_thru = ALU_out[31:0];
    assign MemtoReg_out = MemtoReg[1:0];
    
    DataMemory DataMemoryInstance(.reset(reset), .clk(clk),
     .Address(ALU_out), .Write_data(Write_data), .Read_data(Read_data), 
     .MemRead(MemRead), .MemWrite(MemWrite), .Interrupt(Interrupt));
     
endmodule
