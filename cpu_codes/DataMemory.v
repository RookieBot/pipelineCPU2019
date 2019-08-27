
module DataMemory(reset, clk, Address, Write_data, Read_data, MemRead, MemWrite, Interrupt);
	input reset, clk;
	input [31:0] Address, Write_data;
	input MemRead, MemWrite;
	output [31:0] Read_data;
	output Interrupt;
	
	parameter RAM_SIZE = 256;
	parameter RAM_SIZE_BIT = 8;
	
	reg [31:0] RAM_data[RAM_SIZE - 1: 0];
	
	//assign Read_data = MemRead? RAM_data[Address[RAM_SIZE_BIT + 1:2]]: 32'h00000000;
	reg [31:0] Read_data_reg;
	assign Read_data = Read_data_reg;
	
	// Timer
	reg [31:0] TH;
	reg [31:0] TL;
	reg [2:0] TCON;
	reg [7:0] led;
	reg [11:0] digi;
	reg [31:0] systick;
	
	assign Interrupt = TCON[2];
	
	// reading
	always @ (*) begin
	    if(MemRead) begin
                if(Address==32'h40000000) Read_data_reg <= TH;
                else if(Address==32'h40000004) Read_data_reg <= TL;
                else if(Address==32'h40000008) Read_data_reg <= {29'b0, TCON};
                else if(Address==32'h4000000c) Read_data_reg <= {24'b0, led};
                else if(Address==32'h40000010) Read_data_reg <= {20'b0, digi};
                else if(Address==32'h40000014) Read_data_reg <= systick;
                else Read_data_reg <= RAM_data[Address[RAM_SIZE_BIT + 1:2]];
            end
        else Read_data_reg <= 32'h00000000;
	end
	
	integer i;
	always @(posedge reset or posedge clk)
		if (reset) begin
		        TH <= 32'h0000_0000;
		        TL <= 32'h0000_0000;
		        TCON <= 3'b000;
		        led <= 8'h00;
		        digi <= 12'h000;
		        systick <= 32'h00000000;
			    for (i = 0; i < RAM_SIZE; i = i + 1)
				    RAM_data[i] <= 32'h00000000;
		    end
	    else if (MemWrite && (Address==32'h40000000 || Address==32'h4000_0004 || Address==32'h4000_0008)) begin
	        systick <= systick + 1;
		    if(Address==32'h4000_0000) TH <= Write_data;
		    else if(Address==32'h4000_0004) TL <= Write_data;
		    else if(Address==32'h4000_0008) TCON <= Write_data[2:0];
		end
		else begin
		    systick <= systick + 1;
		    if(MemWrite) RAM_data[Address[RAM_SIZE_BIT + 1:2]] <= Write_data;
            if(TCON[0]) begin
                    if(TCON[2]) TCON <= 3'b000; // interrupt signal is only high for one clock cycle
                    else if(TL==32'hffff_ffff) begin
                        TL <= TH;
                        if(TCON[1]) TCON[2] <= 1'b1;
                    end
                    else TL <= TL + 1;
            end
        end

			
endmodule
