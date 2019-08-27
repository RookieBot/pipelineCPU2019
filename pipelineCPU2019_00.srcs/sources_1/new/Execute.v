
module Execute(PC_plus_4, ALUSrc1, ALUSrc2, ALUOp, MemWrite, MemRead, MemtoReg, 
    LU_out, RegWriteThis, WriteRegisterThis, Databus1, Databus2, Funct, shamt,
    ID_EX_RegisterRs, ID_EX_RegisterRt, EX_MEM_RegisterRd, MEM_WB_RegisterRd,
    EX_MEM_RegWrite, MEM_WB_RegWrite, WB_WriteData, EX_MEM_ALU_out,
    ALU_out, Write_data, PC_plus_4_out, MemWrite_out, MemRead_out, RegWrite_out, 
    WriteRegister_out, MemtoReg_out);
    input [31:0] PC_plus_4;
    input ALUSrc1;
    input ALUSrc2;
    input [3:0] ALUOp;
    input MemWrite;
    input MemRead;
    input [1:0] MemtoReg;
    input [31:0] LU_out;
    input RegWriteThis;
    input [4:0] WriteRegisterThis;
    input [31:0] Databus1;
    input [31:0] Databus2;
    input [5:0] Funct;
    input [4:0] shamt;
    input [4:0] ID_EX_RegisterRs;
    input [4:0] ID_EX_RegisterRt;
    input [4:0] EX_MEM_RegisterRd;
    input [4:0] MEM_WB_RegisterRd;
    input EX_MEM_RegWrite;
    input MEM_WB_RegWrite;
    input [31:0] WB_WriteData;
    input [31:0] EX_MEM_ALU_out;
    output [31:0] ALU_out;
    output [31:0] Write_data; // for sw instruction
    output [31:0] PC_plus_4_out;
    output MemWrite_out;
    output MemRead_out;
    output RegWrite_out;
    output [4:0] WriteRegister_out;
    output [1:0] MemtoReg_out;
    
    wire [1:0] ForwardA; // controls forwarding to databus1 (registerRs)
    wire [1:0] ForwardB; // controls forwarding to databus2 (registerRt)
    // throughputs the control signals & data that will be needed in MEM and WB modules
    assign Write_data = (ForwardB==2'b10)? EX_MEM_ALU_out[31:0]:
        (ForwardB==2'b01)? WB_WriteData[31:0]: Databus2[31:0];
    assign PC_plus_4_out = PC_plus_4[31:0]; // needed in WB
    assign MemWrite_out = MemWrite;
    assign MemRead_out = MemRead;
    assign RegWrite_out = RegWriteThis; // needed in WB, ID
    assign WriteRegister_out = WriteRegisterThis[4:0]; // needed in WB, ID
    assign MemtoReg_out = MemtoReg[1:0]; // needed in WB
    
    wire [4:0] ALUCtl;
    wire Sign;
    ALUControl ALUControlInstance(.ALUOp(ALUOp), .Funct(Funct), .ALUCtl(ALUCtl), .Sign(Sign));

    // forwarding unit:
    assign ForwardA = (EX_MEM_RegWrite && (EX_MEM_RegisterRd!=5'b00000) && (EX_MEM_RegisterRd==ID_EX_RegisterRs))? 2'b10:
        (MEM_WB_RegWrite && (MEM_WB_RegisterRd!=5'b00000) && (MEM_WB_RegisterRd==ID_EX_RegisterRs) && ((EX_MEM_RegisterRd!=ID_EX_RegisterRs) || (~EX_MEM_RegWrite)) )? 2'b01: 2'b00;
    assign ForwardB = (EX_MEM_RegWrite && (EX_MEM_RegisterRd!=5'b00000) && (EX_MEM_RegisterRd==ID_EX_RegisterRt))? 2'b10:
        (MEM_WB_RegWrite && (MEM_WB_RegisterRd!=5'b00000) && (MEM_WB_RegisterRd==ID_EX_RegisterRt) && ((EX_MEM_RegisterRd!=ID_EX_RegisterRt) || (~EX_MEM_RegWrite)) )? 2'b01: 2'b00;

    wire [31:0] ALU_in1;
    wire [31:0] ALU_in2;
    assign ALU_in1 = ALUSrc1? {27'b0000000,shamt[4:0]}: 
        (ForwardA==2'b10)? EX_MEM_ALU_out[31:0]:
        (ForwardA==2'b01)? WB_WriteData[31:0]: Databus1[31:0];
    assign ALU_in2 = ALUSrc2? LU_out[31:0]: 
        (ForwardB==2'b10)? EX_MEM_ALU_out[31:0]:
        (ForwardB==2'b01)? WB_WriteData[31:0]: Databus2[31:0];
    ALU ALUInstance(.in1(ALU_in1), .in2(ALU_in2), .ALUCtl(ALUCtl), .Sign(Sign), .out(ALU_out));
endmodule
