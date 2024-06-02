`include "riscv_def.v"


module ID (  // Instruction Decode Unit, decode the instruction or read the register file
    input clk,
    input rst,
    input [`XLEN-1:0] instruction,  // instruction to be decoded
    output [`REG_DATA_WIDTH:0] read_data1,  // data from register file or memory for rs1
    output [`REG_DATA_WIDTH:0] read_data2,  // data from register file or memory for rs2
    output [`IMM_WIDTH-1:0] immediate  // immediate value from ImmGen
);

    wire [`FUNC7_WIDTH-1:0] func7;  // function 7
    wire [`RS_WIDTH-1:0] rs2;  // source register 2
    wire [`RS_WIDTH-1:0] rs1;  // source register 1
    wire [`FUNCT3_WIDTH-1:0] funct3;  // function 3
    wire [`RS_WIDTH-1:0] rd;  // destination register
    wire [`OPCODE_WIDTH-1:0] opcode;  // operation code

    assign func7 = instruction[`FUNC7];
    assign rs2 = instruction[`RS2];
    assign rs1 = instruction[`RS1];
    assign funct3 = instruction[`FUNCT3];
    assign rd = instruction[`RD];
    assign opcode = instruction[`OPCODE];

    // instanciate Control module
    
    // instanciate the register file

    // instanciate Immediate Generator module

endmodule
