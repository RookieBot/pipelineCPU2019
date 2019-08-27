
module CPU(reset, clk);
	input reset, clk;
	
	
	// declaration of registers between modules
	// declaration of IF/ID registers
	reg [31:0] regIF_ID_instruction;
	reg [31:0] regIF_ID_PC_plus_4;
	
	// declaration of ID/EX registers
	reg [31:0] regID_EX_PC_plus_4;
	reg regID_EX_ALUSrc1;
	reg regID_EX_ALUSrc2;
	reg [3:0] regID_EX_ALUOp;
    reg regID_EX_MemWrite;
    reg regID_EX_MemRead;
    reg [1:0] regID_EX_MemtoReg;
    reg [31:0] regID_EX_LU_out;
    reg regID_EX_RegWrite;
    reg [4:0] regID_EX_WriteRegister;
    reg [31:0] regID_EX_Databus1;
    reg [31:0] regID_EX_Databus2;
    reg [5:0] regID_EX_Funct;
    reg [4:0] regID_EX_shamt;
    reg [4:0] regID_EX_RegisterRs;
    reg [4:0] regID_EX_RegisterRt;
    
    // declaration of EX/MEM registers
    reg [31:0] regEX_MEM_ALU_out;
    reg [31:0] regEX_MEM_Write_data;
    reg [31:0] regEX_MEM_PC_plus_4;
    reg regEX_MEM_MemWrite;
    reg regEX_MEM_MemRead;
    reg regEX_MEM_RegWrite;
    reg [4:0] regEX_MEM_WriteRegister;
    reg [1:0] regEX_MEM_MemtoReg; 
    
    // declaration of MEM/WB registers
    reg [31:0] regMEM_WB_Read_data;
    reg [31:0] regMEM_WB_PC_plus_4;
    reg regMEM_WB_RegWrite;
    reg [4:0] regMEM_WB_WriteRegister; 
    reg [1:0] regMEM_WB_MemtoReg;
    reg [31:0] regMEM_WB_ALU_out; 
    
    wire Interrupt; //detects interruption
    // connection of modules
    // IF
    wire wireFlush, wireStall;
    wire [2:0] wirePCSrc; // output of ID
    wire [31:0] wireJump_target; // output of ID
    wire [31:0] wireBranch_target; // output of ID
    wire [31:0] wireID_EX_Databus1; // output of ID
    wire [31:0] wireIF_ID_instruction;
    wire [31:0] wireIF_ID_PC_plus_4;
    InstructionFetch InstructionFetchInstance(
        .reset(reset), 
        .flush(wireFlush),
        .stall(wireStall),
        .clk(clk), 
        .PCSrc(wirePCSrc), 
        .Jump_target(wireJump_target), 
        .Branch_target(wireBranch_target), 
        .Databus1(wireID_EX_Databus1), 
        .Instruction(wireIF_ID_instruction), 
        .PC_plus_4(wireIF_ID_PC_plus_4)
    );
    // IF/ID registers
    always @ (posedge reset or posedge clk) 
    begin
        if(reset) begin
            regIF_ID_instruction <= 32'h0000_0000;
            regIF_ID_PC_plus_4 <= 32'h0000_0000;
        end
        else if(wireStall) begin
            regIF_ID_instruction <= regIF_ID_instruction;
            regIF_ID_PC_plus_4 <= regIF_ID_PC_plus_4;
        end
        else begin
            regIF_ID_instruction <= wireIF_ID_instruction;
            regIF_ID_PC_plus_4 <= wireIF_ID_PC_plus_4;
        end
    end
    
    // ID
    wire wireID_EX_flush;
    // outputs of WB that are sent to ID for writing register files
    wire WB_RegWrite;
    wire [4:0] WB_Write_register;
    wire [31:0] WB_WriteData;
    // outputs of ID to EX
    wire wireID_EX_ALUSrc1;
    wire wireID_EX_ALUSrc2;
    wire [3:0] wireID_EX_ALUOp;
    wire wireID_EX_MemWrite;
    wire wireID_EX_MemRead;
    wire [1:0] wireID_EX_MemtoReg;
    wire [5:0] wireID_EX_Funct;
    wire [31:0] wireID_EX_LU_out;
    wire [4:0] wireID_EX_shamt;
    wire wireID_EX_RegWrite;
    wire [4:0] wireID_EX_WriteRegister;
    wire [31:0] wireID_EX_Databus2;
    wire [31:0] wireID_EX_PC_plus_4;
    wire [4:0] wireID_EX_RegisterRs;
    wire [4:0] wireID_EX_RegisterRt;
    InstructionDecode InstructionDecodeInstance(
        .reset(reset), 
        .clk(clk), 
        .Instruction(regIF_ID_instruction), 
        .PC_plus_4(regIF_ID_PC_plus_4), 
        .RegWriteEn(WB_RegWrite), 
        .Write_register(WB_Write_register), 
        .WriteData(WB_WriteData), 
        .Interrupt(Interrupt),
        .ID_EX_RegisterRd(regID_EX_WriteRegister), // for forwarding
        .ID_EX_RegWrite(regID_EX_RegWrite), // for forwarding
        .EX_MEM_ALU_out(regEX_MEM_ALU_out), // for forwarding
        .WB_WriteData(WB_WriteData), // for forwarding
        .EX_MEM_RegisterRd(regEX_MEM_WriteRegister), // for forwarding
        .EX_MEM_RegWrite(regEX_MEM_RegWrite), // for forwarding
        .MEM_WB_RegisterRd(regMEM_WB_WriteRegister), // for forwarding
        .MEM_WB_RegWrite(regMEM_WB_RegWrite), // for forwarding
        .ID_EX_MemRead(regID_EX_MemRead), // for forwarding
        .EX_MEM_MemRead(regEX_MEM_MemRead), // for forwarding
        .ALUSrc1(wireID_EX_ALUSrc1), 
        .ALUSrc2(wireID_EX_ALUSrc2), 
        .ALUOp(wireID_EX_ALUOp), 
        .MemWrite(wireID_EX_MemWrite), 
        .MemRead(wireID_EX_MemRead), 
        .MemtoReg(wireID_EX_MemtoReg), 
        .Funct(wireID_EX_Funct), 
        .LU_out(wireID_EX_LU_out),
        .shamt(wireID_EX_shamt), 
        .RegWriteThis(wireID_EX_RegWrite), 
        .WriteRegisterThis(wireID_EX_WriteRegister), 
        .Databus1(wireID_EX_Databus1), 
        .Databus2(wireID_EX_Databus2),  
        .PCSrc(wirePCSrc), 
        .Jump_target(wireJump_target), 
        .Branch_target(wireBranch_target), 
        .PC_plus_4_out(wireID_EX_PC_plus_4),
        .RegisterRs(wireID_EX_RegisterRs),
        .RegisterRt(wireID_EX_RegisterRt),
        .IF_ID_flush(wireFlush),
        .IF_ID_stall(wireStall),
        .ID_EX_flush(wireID_EX_flush)
    );
    // ID/EX registers
    always @ (posedge reset or posedge clk) 
    begin
        if(reset) begin
            regID_EX_PC_plus_4 <= 32'h0000_0000;
	        regID_EX_ALUSrc1 <= 1'b0;
	        regID_EX_ALUSrc2 <= 1'b0;
            regID_EX_ALUOp <= 4'h0;
            regID_EX_MemWrite <= 1'b0;
            regID_EX_MemRead <= 1'b0;
            regID_EX_MemtoReg <= 2'b00;
            regID_EX_LU_out <= 32'h0000_0000;
            regID_EX_RegWrite <= 1'b0;
            regID_EX_WriteRegister <= 5'b00000;
            regID_EX_Databus1 <= 32'h0000_0000;
            regID_EX_Databus2 <= 32'h0000_0000;
            regID_EX_Funct <= 6'b0000_00;
            regID_EX_shamt <= 5'b00000;
            regID_EX_RegisterRs <= 5'b00000;
            regID_EX_RegisterRt <= 5'b00000;
        end
        else begin
            if(wireID_EX_flush || wireStall) begin
            regID_EX_PC_plus_4 <= 32'h0000_0000;
	        regID_EX_ALUSrc1 <= 1'b0;
	        regID_EX_ALUSrc2 <= 1'b0;
            regID_EX_ALUOp <= 4'h0;
            regID_EX_MemWrite <= 1'b0;
            regID_EX_MemRead <= 1'b0;
            regID_EX_MemtoReg <= 2'b00;
            regID_EX_LU_out <= 32'h0000_0000;
            regID_EX_RegWrite <= 1'b0;
            regID_EX_WriteRegister <= 5'b00000;
            regID_EX_Databus1 <= 32'h0000_0000;
            regID_EX_Databus2 <= 32'h0000_0000;
            regID_EX_Funct <= 6'b0000_00;
            regID_EX_shamt <= 5'b00000;
            regID_EX_RegisterRs <= 5'b00000;
            regID_EX_RegisterRt <= 5'b00000;
            end
            else begin
            regID_EX_PC_plus_4 <= wireID_EX_PC_plus_4;
	        regID_EX_ALUSrc1 <= wireID_EX_ALUSrc1;
	        regID_EX_ALUSrc2 <= wireID_EX_ALUSrc2;
            regID_EX_ALUOp <= wireID_EX_ALUOp;
            regID_EX_MemWrite <= wireID_EX_MemWrite;
            regID_EX_MemRead <= wireID_EX_MemRead;
            regID_EX_MemtoReg <= wireID_EX_MemtoReg;
            regID_EX_LU_out <= wireID_EX_LU_out;
            regID_EX_RegWrite <= wireID_EX_RegWrite;
            regID_EX_WriteRegister <= wireID_EX_WriteRegister;
            regID_EX_Databus1 <= wireID_EX_Databus1;
            regID_EX_Databus2 <= wireID_EX_Databus2;
            regID_EX_Funct <= wireID_EX_Funct;
            regID_EX_shamt <= wireID_EX_shamt;
            regID_EX_RegisterRs <= wireID_EX_RegisterRs;
            regID_EX_RegisterRt <= wireID_EX_RegisterRt;
            end
        end
    end
    
    // EX
    // outputs of EX that are sent to MEM
    wire [31:0] wireEX_MEM_ALU_out;
    wire [31:0] wireEX_MEM_Write_data;
    wire [31:0] wireEX_MEM_PC_plus_4;
    wire wireEX_MEM_MemWrite;
    wire wireEX_MEM_MemRead;
    wire wireEX_MEM_RegWrite;
    wire [4:0] wireEX_MEM_WriteRegister;
    wire [1:0] wireEX_MEM_MemtoReg;
    Execute ExecuteInstance(
        .PC_plus_4(regID_EX_PC_plus_4), 
        .ALUSrc1(regID_EX_ALUSrc1), 
        .ALUSrc2(regID_EX_ALUSrc2), 
        .ALUOp(regID_EX_ALUOp), 
        .MemWrite(regID_EX_MemWrite), 
        .MemRead(regID_EX_MemRead), 
        .MemtoReg(regID_EX_MemtoReg), 
        .LU_out(regID_EX_LU_out), 
        .RegWriteThis(regID_EX_RegWrite),
        .WriteRegisterThis(regID_EX_WriteRegister), 
        .Databus1(regID_EX_Databus1), 
        .Databus2(regID_EX_Databus2), 
        .Funct(regID_EX_Funct), 
        .shamt(regID_EX_shamt),
        .ID_EX_RegisterRs(regID_EX_RegisterRs),
        .ID_EX_RegisterRt(regID_EX_RegisterRt),
        .EX_MEM_RegisterRd(regEX_MEM_WriteRegister),
        .MEM_WB_RegisterRd(regMEM_WB_WriteRegister),
        .EX_MEM_RegWrite(regEX_MEM_RegWrite),
        .MEM_WB_RegWrite(regMEM_WB_RegWrite),
        .WB_WriteData(WB_WriteData),
        .EX_MEM_ALU_out(regEX_MEM_ALU_out),
        .ALU_out(wireEX_MEM_ALU_out), 
        .Write_data(wireEX_MEM_Write_data), 
        .PC_plus_4_out(wireEX_MEM_PC_plus_4), 
        .MemWrite_out(wireEX_MEM_MemWrite), 
        .MemRead_out(wireEX_MEM_MemRead), 
        .RegWrite_out(wireEX_MEM_RegWrite), 
        .WriteRegister_out(wireEX_MEM_WriteRegister), 
        .MemtoReg_out(wireEX_MEM_MemtoReg)
    );
    // EX/MEM registers
    always @ (posedge reset or posedge clk) 
    begin
        if(reset) begin
            regEX_MEM_ALU_out <= 32'h0000_0000;
            regEX_MEM_Write_data <= 32'h0000_0000;
            regEX_MEM_PC_plus_4 <= 32'h0000_0000;
            regEX_MEM_MemWrite <= 1'b0; 
            regEX_MEM_MemRead <= 1'b0;
            regEX_MEM_RegWrite <= 1'b0;
            regEX_MEM_WriteRegister <= 5'b00000;
            regEX_MEM_MemtoReg <= 2'b00; 
        end
        else begin
            regEX_MEM_ALU_out <= wireEX_MEM_ALU_out;
            regEX_MEM_Write_data <= wireEX_MEM_Write_data;
            regEX_MEM_PC_plus_4 <= wireEX_MEM_PC_plus_4;
            regEX_MEM_MemWrite <= wireEX_MEM_MemWrite; 
            regEX_MEM_MemRead <= wireEX_MEM_MemRead;
            regEX_MEM_RegWrite <= wireEX_MEM_RegWrite;
            regEX_MEM_WriteRegister <= wireEX_MEM_WriteRegister;
            regEX_MEM_MemtoReg <= wireEX_MEM_MemtoReg; 
        end
    end
    
    // MEM
    // outputs of MEM that are sent to WB
    wire [31:0] wireMEM_WB_Read_data;
    wire [31:0] wireMEM_WB_PC_plus_4;
    wire wireMEM_WB_RegWrite;
    wire [4:0] wireMEM_WB_WriteRegister; 
    wire [1:0] wireMEM_WB_MemtoReg;
    wire [31:0] wireMEM_WB_ALU_out; 
    Memory MemoryInstance(
        .reset(reset), 
        .clk(clk), 
        .ALU_out(regEX_MEM_ALU_out), 
        .Write_data(regEX_MEM_Write_data), 
        .PC_plus_4(regEX_MEM_PC_plus_4),
        .MemWrite(regEX_MEM_MemWrite), 
        .MemRead(regEX_MEM_MemRead), 
        .RegWrite(regEX_MEM_RegWrite), 
        .WriteRegister(regEX_MEM_WriteRegister), 
        .MemtoReg(regEX_MEM_MemtoReg), 
        .Read_data(wireMEM_WB_Read_data), 
        .PC_plus_4_out(wireMEM_WB_PC_plus_4),
        .RegWrite_out(wireMEM_WB_RegWrite), 
        .WriteRegister_out(wireMEM_WB_WriteRegister), 
        .MemtoReg_out(wireMEM_WB_MemtoReg), 
        .ALU_out_thru(wireMEM_WB_ALU_out),
        .Interrupt(Interrupt)
    );
    // MEM/WB registers
    always @ (posedge reset or posedge clk) 
    begin
        if(reset) begin
            regMEM_WB_Read_data <= 32'h0000_0000;
            regMEM_WB_PC_plus_4 <= 32'h0000_0000;
            regMEM_WB_RegWrite <= 1'b0;
            regMEM_WB_WriteRegister <= 5'b00000; 
            regMEM_WB_MemtoReg <= 2'b0;
            regMEM_WB_ALU_out <= 32'h0000_0000;
        end
        else begin
            regMEM_WB_Read_data <= wireMEM_WB_Read_data;
            regMEM_WB_PC_plus_4 <= wireMEM_WB_PC_plus_4;
            regMEM_WB_RegWrite <= wireMEM_WB_RegWrite;
            regMEM_WB_WriteRegister <= wireMEM_WB_WriteRegister; 
            regMEM_WB_MemtoReg <= wireMEM_WB_MemtoReg;
            regMEM_WB_ALU_out <= wireMEM_WB_ALU_out;
        end
    end
    
    // WB
    WriteBack WriteBackInstance(
        .Read_data(regMEM_WB_Read_data), 
        .PC_plus_4(regMEM_WB_PC_plus_4), 
        .ALU_out(regMEM_WB_ALU_out), 
        .RegWrite(regMEM_WB_RegWrite), 
        .WriteRegister(regMEM_WB_WriteRegister), 
        .MemtoReg(regMEM_WB_MemtoReg), 
        .WriteData(WB_WriteData), 
        .RegWrite_out(WB_RegWrite), 
        .WriteRegister_out(WB_Write_register)
    );
    
endmodule
	