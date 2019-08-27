module InstructionDecode(reset, clk, Instruction, PC_plus_4, RegWriteEn, Write_register, 
        WriteData, Interrupt, EX_MEM_ALU_out, WB_WriteData, ID_EX_RegisterRd, ID_EX_RegWrite,
        EX_MEM_RegisterRd, EX_MEM_RegWrite, MEM_WB_RegisterRd, MEM_WB_RegWrite,
        ID_EX_MemRead, EX_MEM_MemRead,
        ALUSrc1, ALUSrc2, ALUOp, MemWrite, MemRead, MemtoReg, Funct, LU_out,
        shamt, RegWriteThis, WriteRegisterThis, Databus1, Databus2,  
        PCSrc, Jump_target, Branch_target, PC_plus_4_out, RegisterRs, RegisterRt, 
        IF_ID_flush, IF_ID_stall, ID_EX_flush);
    input reset, clk;
    input [31:0] Instruction;
    input [31:0] PC_plus_4;
    input RegWriteEn; // enables writing in register now (determined by some previous instr.) 
    input [4:0] Write_register; // which reg to write now (decided by some previous instr.)
    input [31:0] WriteData; // an input: the data to write
    input Interrupt;
    input [4:0] ID_EX_RegisterRd; // for judging if stall is needed
    input ID_EX_RegWrite; // for judging if stall is needed
    input [31:0] EX_MEM_ALU_out; // for forwarding
    input [31:0] WB_WriteData; // for forwarding
    input [4:0] EX_MEM_RegisterRd; // for judging if fowrding is needed
    input EX_MEM_RegWrite; // for judging if forwarding is needed
    input [4:0] MEM_WB_RegisterRd; // for judging if forwarding is needed
    input MEM_WB_RegWrite; // for judging if forwarding is needed
    input ID_EX_MemRead; // for judging if forwarding is needed
    input EX_MEM_MemRead; // for judging if forwarding is needed in case of Branch
    output ALUSrc1;
    output ALUSrc2;
    output [3:0] ALUOp;
    output MemWrite;
    output MemRead;
    output [1:0] MemtoReg;
    output [5:0] Funct;
    output [31:0] LU_out; // processed immediate number
    output [4:0] shamt; //shift amount in case of encountering sll, srl, sra
    output RegWriteThis; // indicates if current instruction eventually needs to write reg
    output [4:0] WriteRegisterThis; // indicates which reg this instr. will eventually write
    output [31:0] Databus1; // data read from register[instruction[25:21]] 
    output [31:0] Databus2; // data read from register[instruction[20:16]]
    output [2:0] PCSrc;
    output [31:0] Jump_target;
    output [31:0] Branch_target;
    output [31:0] PC_plus_4_out; // through to EX: PC_plus_4_out = PC_plus_4;
    output [4:0] RegisterRs; // to determine if EX/MEM or MEM/WB forwarding is needed
    output [4:0] RegisterRt; // to determine if EX/MEM or MEM/WB forwarding is needed
    output IF_ID_flush;
    output IF_ID_stall;
    output ID_EX_flush;
    
    
    assign RegisterRs = Instruction[25:21];
    assign RegisterRt = Instruction[20:16];
    assign PC_plus_4_out = PC_plus_4[31:0];
    assign shamt = Instruction[10:6];
    
    wire BadOpException;
    wire Branch;
    wire ExtOp;
    wire LuOp;
    wire [1:0] RegDst;
    assign Funct = Instruction[5:0];
    Control ControlInstance(
		.OpCode(Instruction[31:26]), .Funct(Instruction[5:0]), .Interrupt(Interrupt),
		.PCSrc(PCSrc), .Branch(Branch), .RegWrite(RegWriteThis), .RegDst(RegDst), 
		.MemRead(MemRead),	.MemWrite(MemWrite), .MemtoReg(MemtoReg),
		.ALUSrc1(ALUSrc1), .ALUSrc2(ALUSrc2), .ExtOp(ExtOp), .LuOp(LuOp), .ALUOp(ALUOp),
		.BadOp(BadOpException));
   
   // decides the jump target
    assign Jump_target = {PC_plus_4[31:28], Instruction[25:0], 2'b00};
    
    // decides the desitination register that current instrucion will eventually write
	assign WriteRegisterThis = (RegDst == 2'b00)? Instruction[20:16]: (RegDst == 2'b01)? Instruction[15:11]: 5'b11111;
    
    RegisterFile RegisterFileInstance(.reset(reset), .clk(clk), .Interrupt(Interrupt),
        .Exception(BadOpException), .RegWrite(RegWriteEn), 
		.Read_register1(Instruction[25:21]), .Read_register2(Instruction[20:16]), .Write_register(Write_register),
		.Write_data(WriteData), .PC_plus_4(PC_plus_4), .Read_data1(Databus1), .Read_data2(Databus2));
	
	// immediate number extension
	wire [31:0] Ext_out;
	assign Ext_out = {ExtOp? {16{Instruction[15]}}: 16'h0000, Instruction[15:0]};
	assign LU_out = LuOp? {Instruction[15:0], 16'h0000}: Ext_out;
	
	// Process Branch-y instr.'s; contains forwarding
	wire [1:0] ForwardC;
	wire [1:0] ForwardD;
	wire [31:0] compare_in1;
	wire [31:0] compare_in2;
    wire Condition_reached;
    
    assign IF_ID_stall = ( (Branch && ID_EX_RegWrite && (ID_EX_RegisterRd==Instruction[25:21] || ID_EX_RegisterRd==Instruction[20:16])) || (Branch && EX_MEM_MemRead && (EX_MEM_RegisterRd==Instruction[25:21] || EX_MEM_RegisterRd==Instruction[20:16])) || ( ~MemRead && ID_EX_MemRead && (ID_EX_RegisterRd==Instruction[25:21] || ID_EX_RegisterRd==Instruction[20:16])) )? 1'b1: 1'b0;
    
	assign ForwardC = (Branch && EX_MEM_RegWrite && EX_MEM_RegisterRd!=5'b00000 && EX_MEM_RegisterRd==Instruction[25:21])? 2'b10:
	    (Branch && MEM_WB_RegWrite && MEM_WB_RegisterRd!=5'b00000 && MEM_WB_RegisterRd==Instruction[25:21] && ( EX_MEM_RegisterRd!=Instruction[25:21] || ~EX_MEM_RegWrite ))? 2'b01: 2'b00;
	assign ForwardD = (Branch && EX_MEM_RegWrite && EX_MEM_RegisterRd!=5'b00000 && EX_MEM_RegisterRd==Instruction[20:16])? 2'b10:
	    (Branch && MEM_WB_RegWrite && MEM_WB_RegisterRd!=5'b00000 && MEM_WB_RegisterRd==Instruction[20:16] && ( EX_MEM_RegisterRd!=Instruction[20:16] || ~EX_MEM_RegWrite ))? 2'b01: 2'b00;
	assign compare_in1 = (ForwardC==2'b10)? EX_MEM_ALU_out:
	    (ForwardC==2'b01)? WB_WriteData: Databus1; // needs forwarding
	assign compare_in2 = (ForwardD==2'b10)? EX_MEM_ALU_out:
	    (ForwardD==2'b01)? WB_WriteData: Databus2; // needs forwarding
	Signed_compare SignedCompareInstance(
	    .OpCode(Instruction[31:26]), .in1(compare_in1), .in2(compare_in2), 
	    .Condition_reached(Condition_reached)
	);
	assign Branch_target = (Branch & Condition_reached)? PC_plus_4 + {LU_out[29:0], 2'b00}: PC_plus_4;

    assign IF_ID_flush = (BadOpException || Interrupt)? 1: // if exception in ID, flush IF_ID
        IF_ID_stall? 0:  // if stall, dont flush
        (PCSrc==3'b010 || PCSrc==3'b011 || PCSrc==3'b100 || PCSrc==3'b101 || (PCSrc==3'b001 && Condition_reached))? 1: 0;
	
	assign ID_EX_flush = BadOpException;
	
endmodule
