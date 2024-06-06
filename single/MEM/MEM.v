`include "riscv_def.v"


module MEM (  // Memory module, access the data memory
    input clk,
    input rst,
    input memread,  // memory read or not ////// not used
    input memwrite,  // memory write or not
    input [`REG_DATA_WIDTH-1:0] alu_result,  // output of ALU, result of operation
    input [`REG_DATA_WIDTH-1:0] read_data2,  // data from register file or memory for rs2
    output data_we_o,  // data memory write enable, 1 for write, 0 for read
    output data_ce_o,  // data memory enable
    output [`REG_DATA_WIDTH-1:0] data_addr_o,  // data memory address
    output [`REG_DATA_WIDTH-1:0] data_o  // data memory write data
);

    assign data_ce_o = ~rst;  // enable data memory by default

    assign data_we_o = memwrite;

    assign data_addr_o = alu_result;

    assign data_o = read_data2;

endmodule
