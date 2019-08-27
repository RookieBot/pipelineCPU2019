
module RegisterFile(reset, clk, Interrupt, Exception, RegWrite, 
    Read_register1, Read_register2, Write_register, Write_data, 
    PC_plus_4, Read_data1, Read_data2);
	input reset, clk, Interrupt, Exception;
	input RegWrite;
	input [4:0] Read_register1, Read_register2, Write_register;
	input [31:0] Write_data; 
	input [31:0] PC_plus_4;
	output [31:0] Read_data1, Read_data2;
	
	reg [31:0] RF_data[31:1];
	
	assign Read_data1 = (Read_register1 == 5'b00000)? 32'h00000000: 
	    (RegWrite && Write_register==Read_register1)? Write_data: RF_data[Read_register1];
	assign Read_data2 = (Read_register2 == 5'b00000)? 32'h00000000: 
	    (RegWrite && Write_register==Read_register2)? Write_data: RF_data[Read_register2];
	
	integer i;
	always @(posedge reset or posedge clk) begin
		if (reset) begin
			for (i = 1; i < 32; i = i + 1)
				RF_data[i] <= 32'h00000000;
		end
		else begin 
		    if (RegWrite && (Write_register != 5'b00000)) begin
			    RF_data[Write_register] <= Write_data;
		    end
		    if(Interrupt || Exception) RF_data[26] <= PC_plus_4;
        end
    end
endmodule
			