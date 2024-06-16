`include "riscv_def.v"


module EXMEM (
    input clk,
    input rst,
    input exflush,  // flush the EX/MEM pipeline
    // from EX stage
    input [`REG_DATA_WIDTH-1:0] read_data2_forwarded_ex,
    input [`PC_WIDTH-1:0] sum_ex,
    input alu_branch_ex,
    input [`REG_DATA_WIDTH-1:0] alu_result_ex,
    // from IDEX
    input [`RS_WIDTH-1:0] rd_ex,
    input branch_ex,
    input memread_ex,
    input memtoreg_ex,
    input memwrite_ex,
    input regwrite_ex,
    input aluinputpc_ex,
    input branchjalx_ex,
    input alu2pc_ex,
    input [`PC_WIDTH-1:0] pcplus4_ex,
    // outputs
    output reg [`REG_DATA_WIDTH-1:0] read_data2_forwarded_mem,
    output reg [`PC_WIDTH-1:0] sum_mem,
    output reg alu_branch_mem,
    output reg [`REG_DATA_WIDTH-1:0] alu_result_mem,
    output reg [`RS_WIDTH-1:0] rd_mem,
    output reg branch_mem,
    output reg memread_mem,
    output reg memtoreg_mem,
    output reg memwrite_mem,
    output reg regwrite_mem,
    output reg aluinputpc_mem,
    output reg branchjalx_mem,
    output reg alu2pc_mem,
    output reg [`PC_WIDTH-1:0] pcplus4_mem
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            read_data2_forwarded_mem <= 0;
            sum_mem <= 0;
            alu_branch_mem <= 0;
            alu_result_mem <= 0;
            rd_mem <= 0;
            branch_mem <= 0;
            memread_mem <= 0;
            memtoreg_mem <= 0;
            memwrite_mem <= 0;
            regwrite_mem <= 0;
            aluinputpc_mem <= 0;
            branchjalx_mem <= 0;
            alu2pc_mem <= 0;
            pcplus4_mem <= 0;
        end else if (exflush) begin
            read_data2_forwarded_mem <= 0;
            sum_mem <= 0;
            alu_branch_mem <= 0;
            alu_result_mem <= 0;
            rd_mem <= 0;
            branch_mem <= 0;
            memread_mem <= 0;
            memtoreg_mem <= 0;
            memwrite_mem <= 0;
            regwrite_mem <= 0;
            aluinputpc_mem <= 0;
            branchjalx_mem <= 0;
            alu2pc_mem <= 0;
            pcplus4_mem <= 0;
        end else begin
            read_data2_forwarded_mem <= read_data2_forwarded_ex;
            sum_mem <= sum_ex;
            alu_branch_mem <= alu_branch_ex;
            alu_result_mem <= alu_result_ex;
            rd_mem <= rd_ex;
            branch_mem <= branch_ex;
            memread_mem <= memread_ex;
            memtoreg_mem <= memtoreg_ex;
            memwrite_mem <= memwrite_ex;
            regwrite_mem <= regwrite_ex;
            aluinputpc_mem <= aluinputpc_ex;
            branchjalx_mem <= branchjalx_ex;
            alu2pc_mem <= alu2pc_ex;
            pcplus4_mem <= pcplus4_ex;
        end
    end

endmodule
