
module WriteBack(Read_data, PC_plus_4, ALU_out, RegWrite, WriteRegister, MemtoReg, 
    WriteData, RegWrite_out, WriteRegister_out);
    input [31:0] Read_data; // data read from MEM, for lw
    input [31:0] PC_plus_4; // for jal, jalr
    input [31:0] ALU_out; // for other instructions
    input RegWrite; // Enables writing register, thru to ID
    input [4:0] WriteRegister; // which register to write, thru to ID
    input [1:0] MemtoReg;
    output [31:0] WriteData;
    output RegWrite_out;
    output [4:0] WriteRegister_out;
    
    assign RegWrite_out = RegWrite;
    assign WriteRegister_out = WriteRegister[4:0];
    assign WriteData = (MemtoReg == 2'b00)? ALU_out: 
        (MemtoReg == 2'b01)? Read_data: PC_plus_4;
        
endmodule
