`include "riscv_def.v"


module MEMWB (
    input clk,
    input rst,
    // from Data Memory
    input [`REG_DATA_WIDTH-1:0] data_i_mem,
    // from MEM stage
    input [`REG_DATA_WIDTH-1:0] wb_data_mem,
    // from EXMEM
    input [`RS_WIDTH-1:0] rd_mem,
    input memtoreg_mem,
    input regwrite_mem,
    // outputs
    output reg [`REG_DATA_WIDTH-1:0] data_i_wb,
    output reg [`REG_DATA_WIDTH-1:0] wb_data_wb,
    output reg [`RS_WIDTH-1:0] rd_wb,
    output reg memtoreg_wb,
    output reg regwrite_wb
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            data_i_wb <= 0;
            wb_data_wb <= 0;
            rd_wb <= 0;
            memtoreg_wb <= 0;
            regwrite_wb <= 0;
        end else begin
            data_i_wb <= data_i_mem;
            wb_data_wb <= wb_data_mem;
            rd_wb <= rd_mem;
            memtoreg_wb <= memtoreg_mem;
            regwrite_wb <= regwrite_mem;
        end
    end

endmodule
