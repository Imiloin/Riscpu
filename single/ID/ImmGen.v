`include "riscv_def.v"


module ImmGen (
    input clk,
    input rst,
    input [`XLEN-1:0] instruction,
    output reg [`IMM_WIDTH-1:0] imm  // immediate
);

    wire [`OPCODE_WIDTH-1:0] opcode;  // operation code
    assign opcode = instruction[`OPCODE];

    // `instruction[1:0]` must be `2'b11` for valid RV32I instructions
    // see http://riscvbook.com/chinese/RISC-V-Reader-Chinese-v2p1.pdf p.27
    // already "shift left 1"
    always @(*) begin
        case (opcode[6:2])
            `OP_STORE:  // S-type
            imm = {
                {20{instrusction[31]}},
                instrusction[31:25],
                instrusction[11:8],
                instrusction[7]
            };
            `OP_BRANCH:  // B-type
            imm = {
                {19{instrusction[31]}},
                instrusction[31],
                instrusction[7],
                instrusction[30:25],
                instrusction[11:8],
                1'b0
            };
            `OP_LUI, `OP_AUIPC:
            imm = {instrusction[31:12], {12{1'b0}}};  // U-type
            `OP_JAL:  // J-type
            imm = {
                {11{instrusction[31]}},
                instrusction[31],
                instrusction[19:12],
                instrusction[20],
                instrusction[30:25],
                instrusction[24:21],
                1'b0
            };
            default:  // I-type and R-type. R-type do not use immediate
            imm = {{20{instrusction[31]}}, instrusction[31:20]};
        endcase
    end

endmodule
