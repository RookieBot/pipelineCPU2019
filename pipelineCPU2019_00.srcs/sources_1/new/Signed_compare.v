
module Signed_compare(
    input [5:0] OpCode, 
    input [31:0] in1,
    input [31:0] in2,
    output Condition_reached
    );
    wire ltz, eqz, eq;
    assign ltz = in1[31];
    assign eqz = (in1 == 32'h0);
    assign eq = (in1 == in2);
    assign Condition_reached = (OpCode==6'h04)? eq://beq
	                           (OpCode==6'h05)? ~eq://bne
	                           (OpCode==6'h06)? ltz | eqz: //blez
	                           (OpCode==6'h07)? ~(ltz | eqz)://bgtz
	                           (OpCode==6'h01)? ltz:1'b0;// bltz, else default
endmodule
