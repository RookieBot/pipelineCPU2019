
module Periphery_RAM(reset, rd, wr, addr, rdata, wdata);
    input reset, rd, wr;
    input [31:0] addr;
    input [31:0] wdata;
    output reg [31:0] rdata;
    
    reg [31:0] TH;
    reg [31:0] TL;
    reg [2:0] TCON;
    reg [7:0] led;
    reg [11:0] digi;
    reg [31:0] systick;
    always @ (*) begin
        if(rd) begin
            case(addr)
                32'h40000000: rdata <= TH;
                32'h40000004: rdata <= TL;
                32'h40000008: rdata <= {29'b0, TCON};
                32'h4000000c: rdata <= {24'b0, led};
                32'h40000010: rdata <= {20'b0, digi};
                32'h40000014: rdata <= systick;
                default: rdata <= 32'b0;
            endcase
        end
        else rdata <= 32'b0;
        if(wr) begin
            case(addr)
                32'h40000000: TH <= wdata;
                32'h40000004: TL <= wdata;
                32'h40000008: TCON <= wdata[2:0];
                32'h4000000c: led <= wdata[7:0];
                32'h40000010: digi <= wdata[11:0];
            endcase
        end
    end
    
endmodule
