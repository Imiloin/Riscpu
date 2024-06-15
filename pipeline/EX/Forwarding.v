`include "riscv_def.v"


module Forwarding(
    input clk,
    input rst,
    input [`RS_WIDTH-1:0] rs1_ex,
    input [`RS_WIDTH-1:0] rs2_ex,
    input [`RS_WIDTH-1:0] rd_mem,
    input [`RS_WIDTH-1:0] rd_wb,
    input regwrite_mem,
    input regwrite_wb,
    output reg [1:0] forwarda,
    output reg [1:0] forwardb
);

    always @(*) begin
        if (rd_mem == rs1_ex && regwrite_mem) begin
            forwarda = 2'b01;
        end else if (rd_wb == rs1_ex && regwrite_wb) begin
            forwarda = 2'b10;
        end else begin
            forwarda = 2'b00;
        end
    end

    always @(*) begin
        if (rd_mem == rs2_ex && regwrite_mem) begin
            forwardb = 2'b01;
        end else if (rd_wb == rs2_ex && regwrite_wb) begin
            forwardb = 2'b10;
        end else begin
            forwardb = 2'b00;
        end
    end

endmodule
