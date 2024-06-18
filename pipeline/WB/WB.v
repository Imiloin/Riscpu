`include "../riscv_def.v"


module WB (
    input clk,
    input rst,
    input [`REG_DATA_WIDTH-1:0] data_i,  // data memory read data
    input [`REG_DATA_WIDTH-1:0] wb_data,  // data to write back when memtoreg is 0
    input memtoreg,  // memory to register or not
    output [`REG_DATA_WIDTH-1:0] write_data  // data to write back to register file
);

    assign write_data = (memtoreg) ? data_i : wb_data;

endmodule
