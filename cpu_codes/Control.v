
module Control(OpCode, Funct, Interrupt,
	PCSrc, Branch, RegWrite, RegDst, 
	MemRead, MemWrite, MemtoReg, 
	ALUSrc1, ALUSrc2, ExtOp, LuOp, ALUOp, BadOp);
	input [5:0] OpCode;
	input [5:0] Funct;
	input Interrupt;
	output [2:0] PCSrc;
	output Branch;
	output RegWrite;
	output [1:0] RegDst;
	output MemRead;
	output MemWrite;
	output [1:0] MemtoReg;
	output ALUSrc1;
	output ALUSrc2;
	output ExtOp;
	output LuOp;
	output [3:0] ALUOp;
	output BadOp; 
	
	// Your code below
	assign BadOp = (OpCode>=6'h0d && OpCode!=6'h0f && OpCode!=6'h23 && OpCode!=6'h2b)?1: 0; // exception
	assign PCSrc[2:0] = 
	    (OpCode==6'h02 || OpCode==6'h03) ? 3'b010: // j-type instruction
	    (OpCode==6'h00 && (Funct==6'h08||Funct==6'h09)) ? 3'b011: // jump-register type
	    (OpCode==6'h04 || OpCode==6'h05 || OpCode==6'h06 || OpCode==6'h07 || OpCode==6'h01) ? 2'b001: //beq,bne,blez,bgtz,bltz, respectively
	    (Interrupt)? 3'b100:
	    (BadOp)? 3'b101: 3'b000;
	assign Branch = (OpCode==6'h04 || OpCode==6'h05 || OpCode==6'h06 || OpCode==6'h07 || OpCode==6'h01) ? 1: 0;
	assign RegWrite = (OpCode==6'h2b || OpCode==6'h04 || OpCode==6'h05 || OpCode==6'h06 || OpCode==6'h07 || OpCode==6'h01 || OpCode==6'h02 || (OpCode==6'h00&&Funct==6'h08))? 0: 1;
	assign RegDst[1:0] = 
	    (OpCode==6'h00) ? 2'b01: // most r-types including jalr 
	    (OpCode==6'h03) ? 2'b10: 2'b00; // 0x03: jal; else: i-type or lw
	assign MemRead = (OpCode==6'h23) ? 1: 0; // only high in lw 
	assign MemWrite = (OpCode==6'h2b) ? 1: 0; // only high in sw
	assign MemtoReg[1:0] = 
	    (OpCode==6'h23) ? 2'b01: // lw
	    (OpCode==6'h03 || (OpCode==6'h00&&Funct==6'h09)) ? 2'b10: 2'b00; //  jal or jalr ? 10 : 00
	assign ALUSrc1 = (OpCode==6'h00 && (Funct==6'h00||Funct==6'h02||Funct==6'h03)) ? 1: 0; // sll or srl or sra ? 1 : 0
	assign ALUSrc2 = 
	    (OpCode==6'h00 || OpCode==6'h04 || OpCode==6'h05 || OpCode==6'h06 || OpCode==6'h07 || OpCode==6'h01) ? 0: 1; // moset r-types or branch ? 0 : 1
	assign ExtOp = (OpCode==6'h0c) ? 0: 1; // andi ? 0 : 1
	assign LuOp = (OpCode==6'h0f) ? 1: 0; // lui ? 1 : 0
	// Your code above
	
	assign ALUOp[2:0] = 
		(OpCode == 6'h00)? 3'b010: 
		(OpCode == 6'h04 || OpCode == 6'h05 || OpCode == 6'h06 || OpCode == 6'h07 || OpCode == 6'h01)? 3'b001: 
		(OpCode == 6'h0c)? 3'b100: 
		(OpCode == 6'h0a || OpCode == 6'h0b)? 3'b101: 
		3'b000;
		
	assign ALUOp[3] = OpCode[0];
	
endmodule