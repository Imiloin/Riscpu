`include "riscv_def.v"


module IFID (
    input clk,
    input rst,
    input ifidwrite,  // do not stall to IF/ID pipeline
    input ifflush,  // flush the IF/ID pipeline
    // from IF stage
    input [`PC_WIDTH-1:0] pcplus4_if,
    input [`PC_WIDTH-1:0] pc_if,
    input [`XLEN-1:0] instruction_if,
    // outputs
    output reg [`PC_WIDTH-1:0] pcplus4_id,
    output reg [`PC_WIDTH-1:0] pc_id,
    output reg [`XLEN-1:0] instruction_id
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            pcplus4_id <= 0;
            pc_id <= 0;
            instruction_id <= 0;
        end else if (ifflush) begin
            pcplus4_id <= 0;
            pc_id <= 0;
            instruction_id <= 0;
        end else if (ifidwrite) begin
            pcplus4_id <= pcplus4_if;
            pc_id <= pc_if;
            instruction_id <= instruction_if;
        end else begin
            pcplus4_id <= pcplus4_id;
            pc_id <= pc_id;
            instruction_id <= instruction_id;
        end
    end

endmodule
