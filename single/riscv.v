module riscv (

    input wire clk,
    input wire rst,  // high is reset

    // inst_mem
    input  wire [31:0] inst_i,       // input instruction
    output wire [31:0] inst_addr_o,  // instruction fetch address
    output wire        inst_ce_o,    // instruction fetch enable

    // data_mem
    input  wire [31:0] data_i,       // data memory read data
    output wire        data_we_o,    // data memory write enable, 1 for write, 0 for read
    output wire        data_ce_o,    // data memory enable
    output wire [31:0] data_addr_o,  // data memory address
    output wire [31:0] data_o        // data memory write data

);

    // instance modules





endmodule
