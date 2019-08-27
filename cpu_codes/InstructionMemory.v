
module InstructionMemory(clk, Address, Instruction);
    input clk;
	input [31:0] Address;
	output reg [31:0] Instruction;
	
	/*
	always @(*)
		case (Address[9:2])
			// addi $a0, $zero, 12345 #(0x3039)
			8'd0:    Instruction <= {6'h08, 5'd0 , 5'd4 , 16'h3039};
			// addiu $a1, $zero, -11215 #(0xd431)
			8'd1:    Instruction <= {6'h09, 5'd0 , 5'd5 , 16'hd431};
			// sll $a2, $a1, 16
			8'd2:    Instruction <= {6'h00, 5'd0 , 5'd5 , 5'd6 , 5'd16 , 6'h00};
			// sra $a3, $a2, 16
			8'd3:    Instruction <= {6'h00, 5'd0 , 5'd6 , 5'd7 , 5'd16 , 6'h03};
			// beq $a3, $a1, L1
			8'd4:    Instruction <= {6'h04, 5'd7 , 5'd5 , 16'h0001};
			// lui $a0, -11111 #(0xd499)
			8'd5:    Instruction <= {6'h0f, 5'd0 , 5'd4 , 16'hd499};
			// L1:
			// add $t0, $a2, $a0
			8'd6:    Instruction <= {6'h00, 5'd6 , 5'd4 , 5'd8 , 5'd0 , 6'h20};
			// sra $t1, $t0, 8
			8'd7:    Instruction <= {6'h00, 5'd0 , 5'd8 , 5'd9 , 5'd8 , 6'h03};
			// addi $t2, $zero, -12345 #(0xcfc7)
			8'd8:    Instruction <= {6'h08, 5'd0 , 5'd10, 16'hcfc7};
			// slt $v0, $a0, $t2
			8'd9:    Instruction <= {6'h00, 5'd4 , 5'd10 , 5'd2 , 5'd0 , 6'h2a};
			// sltu $v1, $a0, $t2
			8'd10:   Instruction <= {6'h00, 5'd4 , 5'd10 , 5'd3 , 5'd0 , 6'h2b};
			// Loop:
			// j Loop
			8'd11:   Instruction <= {6'h02, 26'd11};
			
			default: Instruction <= 32'h00000000;
		endcase
	*/
	/*always @ (Address or posedge clk)
	    case(Address[9:2])
	        8'd0: Instruction <= 32'h20040003;
	        8'd1: Instruction <= 32'h0c100003;
	        8'd2: Instruction <= 32'h1000ffff;
	        8'd3: Instruction <= 32'h23bdfff8;
	        8'd4: Instruction <= 32'hafbf0004;
	        8'd5: Instruction <= 32'hafa40000;
	        8'd6: Instruction <= 32'h28880001;
	        8'd7: Instruction <= 32'h11000003;
	        8'd8: Instruction <= 32'h00001026;
	        8'd9: Instruction <= 32'h23bd0008;
	        8'd10: Instruction <= 32'h03e00008;
	        8'd11: Instruction <= 32'h2084ffff;
	        8'd12: Instruction <= 32'h0c100003;
	        8'd13: Instruction <= 32'h8fa40000;
	        8'd14: Instruction <= 32'h8fbf0004;
	        8'd15: Instruction <= 32'h23bd0008;
	        8'd16: Instruction <= 32'h00821020;
	        8'd17: Instruction <= 32'h03e00008;
	        default: Instruction <= 32'h00000000;
	    endcase*/
	   /* always @ (Address or posedge clk)
	        case(Address[9:2])
	            8'd0: Instruction <= 32'h00000000;
                8'd1: Instruction <= 32'h24100000;
                8'd2: Instruction <= 32'h24180064;
                8'd3: Instruction <= 32'hae180000;
                8'd4: Instruction <= 32'h22190000;
                8'd5: Instruction <= 32'h23390004;
                8'd6: Instruction <= 32'haf380000;
                8'd7: Instruction <= 32'h2318ffff;
                8'd8: Instruction <= 32'h1700fffc;
                8'd9: Instruction <= 32'h8e110000;
                8'd10: Instruction <= 32'h24040001;
                8'd11: Instruction <= 32'h00112821;
                8'd12: Instruction <= 32'h0c10000e;
                8'd13: Instruction <= 32'h08100045;
                8'd14: Instruction <= 32'h00045821;
                8'd15: Instruction <= 32'h00056021;
                8'd16: Instruction <= 32'h016c5021;
                8'd17: Instruction <= 32'h000a5043;
                8'd18: Instruction <= 32'h000a5080;
                8'd19: Instruction <= 32'h01505021;
                8'd20: Instruction <= 32'h8d4a0000;
                8'd21: Instruction <= 32'h000b6880;
                8'd22: Instruction <= 32'h01b06820;
                8'd23: Instruction <= 32'h8dae0000;
                8'd24: Instruction <= 32'h01ca082a;
                8'd25: Instruction <= 32'h10200002;
                8'd26: Instruction <= 32'h216b0001;
                8'd27: Instruction <= 32'h08100015;
                8'd28: Instruction <= 32'h000c7880;
                8'd29: Instruction <= 32'h01f07820;
                8'd30: Instruction <= 32'h8df80000;
                8'd31: Instruction <= 32'h0158082a;
                8'd32: Instruction <= 32'h10200002;
                8'd33: Instruction <= 32'h218cffff;
                8'd34: Instruction <= 32'h0810001c;
                8'd35: Instruction <= 32'h018b082a;
                8'd36: Instruction <= 32'h14200006;
                8'd37: Instruction <= 32'hadb80000;
                8'd38: Instruction <= 32'hadee0000;
                8'd39: Instruction <= 32'h216b0001;
                8'd40: Instruction <= 32'h218cffff;
                8'd41: Instruction <= 32'h018b082a;
                8'd42: Instruction <= 32'h1020ffea;
                8'd43: Instruction <= 32'h008c082a;
                8'd44: Instruction <= 32'h1020000a;
                8'd45: Instruction <= 32'h23bdfff4;
                8'd46: Instruction <= 32'hafa40000;
                8'd47: Instruction <= 32'hafa50004;
                8'd48: Instruction <= 32'hafbf0008;
                8'd49: Instruction <= 32'h000c2821;
                8'd50: Instruction <= 32'h0c10000e;
                8'd51: Instruction <= 32'h8fa40000;
                8'd52: Instruction <= 32'h8fa50004;
                8'd53: Instruction <= 32'h8fbf0008;
                8'd54: Instruction <= 32'h23bd000c;
                8'd55: Instruction <= 32'h0165082a;
                8'd56: Instruction <= 32'h1020000a;
                8'd57: Instruction <= 32'h23bdfff4;
                8'd58: Instruction <= 32'hafa40000;
                8'd59: Instruction <= 32'hafa50004;
                8'd60: Instruction <= 32'hafbf0008;
                8'd61: Instruction <= 32'h000b2021;
                8'd62: Instruction <= 32'h0c10000e;
                8'd63: Instruction <= 32'h8fa40000;
                8'd64: Instruction <= 32'h8fa50004;
                8'd65: Instruction <= 32'h8fbf0008;
                8'd66: Instruction <= 32'h23bd000c;
                8'd67: Instruction <= 32'h24020001;
                8'd68: Instruction <= 32'h03e00008;
                8'd69: Instruction <= 32'h00000000;
                default: Instruction <= 32'h00000000;
	        endcase*/
	       /* always @ (Address or posedge clk)
	        case(Address[9:2])
	            8'd0: Instruction <= 32'h00000000;
                8'd1: Instruction <= 32'h24100000;
                8'd2: Instruction <= 32'h24180064;
                8'd3: Instruction <= 32'hae180000;
                8'd4: Instruction <= 32'h22190000;
                8'd5: Instruction <= 32'h23390004;
                8'd6: Instruction <= 32'haf380000;
                8'd7: Instruction <= 32'h2318ffff;
                8'd8: Instruction <= 32'h1700fffc;
                8'd9: Instruction <= 32'h22040004;
                8'd10: Instruction <= 32'h8e050000;
                8'd11: Instruction <= 32'h24100000;
                8'd12: Instruction <= 32'h0205082a;
                8'd13: Instruction <= 32'h10200014;
                8'd14: Instruction <= 32'h2211ffff;
                8'd15: Instruction <= 32'h0220082a;
                8'd16: Instruction <= 32'h1420000f;
                8'd17: Instruction <= 32'h00114080;
                8'd18: Instruction <= 32'h01044020;
                8'd19: Instruction <= 32'h8d090000;
                8'd20: Instruction <= 32'h8d0a0004;
                8'd21: Instruction <= 32'h0149082a;
                8'd22: Instruction <= 32'h10200009;
                8'd23: Instruction <= 32'h00113021;
                8'd24: Instruction <= 32'h00064080;
                8'd25: Instruction <= 32'h01044020;
                8'd26: Instruction <= 32'h8d090000;
                8'd27: Instruction <= 32'h8d0a0004;
                8'd28: Instruction <= 32'had090004;
                8'd29: Instruction <= 32'had0a0000;
                8'd30: Instruction <= 32'h2231ffff;
                8'd31: Instruction <= 32'h0810000f;
                8'd32: Instruction <= 32'h22100001;
                8'd33: Instruction <= 32'h0810000c;
                8'd34: Instruction <= 32'h00000000;
                default: Instruction <= 32'h00000000;
	        endcase*/
	        always @ (*)
            case(Address[9:2])
                    8'd0: Instruction <= 32'h08100003;
                    8'd1: Instruction <= 32'h08100032;
                    8'd2: Instruction <= 32'h08100035;
                    8'd3: Instruction <= 32'h3c0b4000;
                    8'd4: Instruction <= 32'h216b0000;
                    8'd5: Instruction <= 32'h00006020;
                    8'd6: Instruction <= 32'had6c0008;
                    8'd7: Instruction <= 32'h240cfff0;
                    8'd8: Instruction <= 32'had6c0000;
                    8'd9: Instruction <= 32'h240cffff;
                    8'd10: Instruction <= 32'had6c0004;
                    8'd11: Instruction <= 32'h8d720014;
                    8'd12: Instruction <= 32'h24100000;
                    8'd13: Instruction <= 32'h24180064;
                    8'd14: Instruction <= 32'hae180000;
                    8'd15: Instruction <= 32'h22190000;
                    8'd16: Instruction <= 32'h23390004;
                    8'd17: Instruction <= 32'haf380000;
                    8'd18: Instruction <= 32'h2318ffff;
                    8'd19: Instruction <= 32'h1700fffc;
                    8'd20: Instruction <= 32'h22040004;
                    8'd21: Instruction <= 32'h8e050000;
                    8'd22: Instruction <= 32'h24100000;
                    8'd23: Instruction <= 32'h0205082a;
                    8'd24: Instruction <= 32'h10200014;
                    8'd25: Instruction <= 32'h2211ffff;
                    8'd26: Instruction <= 32'h0220082a;
                    8'd27: Instruction <= 32'h1420000f;
                    8'd28: Instruction <= 32'h00114080;
                    8'd29: Instruction <= 32'h01044020;
                    8'd30: Instruction <= 32'h8d090000;
                    8'd31: Instruction <= 32'h8d0a0004;
                    8'd32: Instruction <= 32'h0149082a;
                    8'd33: Instruction <= 32'h10200009;
                    8'd34: Instruction <= 32'h00113021;
                    8'd35: Instruction <= 32'h00064080;
                    8'd36: Instruction <= 32'h01044020;
                    8'd37: Instruction <= 32'h8d090000;
                    8'd38: Instruction <= 32'h8d0a0004;
                    8'd39: Instruction <= 32'had090004;
                    8'd40: Instruction <= 32'had0a0000;
                    8'd41: Instruction <= 32'h2231ffff;
                    8'd42: Instruction <= 32'h0810001a;
                    8'd43: Instruction <= 32'h22100001;
                    8'd44: Instruction <= 32'h08100017;
                    8'd45: Instruction <= 32'h200c0003;
                    8'd46: Instruction <= 32'had6c0008;
                    8'd47: Instruction <= 32'h00000000;
                    8'd48: Instruction <= 32'h0810002f;
                    8'd49: Instruction <= 32'h0810002f;
                    8'd50: Instruction <= 32'h8d730014;
                    8'd51: Instruction <= 32'h02721022;
                    8'd52: Instruction <= 32'h03400008;
                    8'd53: Instruction <= 32'h00000000;
                    8'd54: Instruction <= 32'h00000000;
                    8'd55: Instruction <= 32'h03400008;
                    default: Instruction <= 32'h00000000;
            endcase
                
endmodule
