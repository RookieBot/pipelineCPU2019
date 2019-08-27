
module InstructionFetch(reset, clk, flush, stall, PCSrc, 
    Jump_target, Branch_target, Databus1, Instruction, PC_plus_4);
    input reset, clk, flush, stall;
    input [2:0] PCSrc;
    input [31:0] Jump_target;
    input [31:0] Branch_target;
    input [31:0] Databus1;
    output [31:0] Instruction;
    output [31:0] PC_plus_4;
    reg [31:0] PC;
    wire [31:0] PC_plus_4_tmp;
    wire [31:0] Instruction_tmp;
    always @(posedge reset or posedge clk)
		if (reset)
			PC <= 32'h00000000;
		else if(stall) PC <= PC;
		else
			PC <= (PCSrc == 3'b000)? {PC[31], PC_plus_4_tmp[30:0]}: // normal execution
	              (PCSrc == 3'b001)? {PC[31], Branch_target[30:0]}: // branch; Branch_target may be PC_plus_4 or the 'real' target
	              (PCSrc == 3'b010)? {PC[31], Jump_target[30:0]}: // jump
	              (PCSrc == 3'b011)? Databus1: // jump register
	              (PCSrc == 3'b100)? 32'h8000_0004:32'h8000_0008; // interrupt and exception, respectively
	assign PC_plus_4_tmp = PC + 32'd4;
	InstructionMemory InstructionMemoryInstance(.clk(clk), .Address({PC[31:0]}), .Instruction(Instruction_tmp));
	assign PC_plus_4 = flush? 32'h0000_0000: PC_plus_4_tmp; // maybe unnecessary
	assign Instruction = flush? 32'h0000_0000: Instruction_tmp;
	
endmodule
