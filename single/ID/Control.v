`include "riscv_def.v"


module Control (
    input clk,
    input rst,
    input [`OPCODE_WIDTH-1:0] opcode,
    output branch,
    output memread,
    output memtoreg,
    output [1:0] aluop,
    output memwrite,
    output alusrc,
    output regwrite,
    output getpcplus4  // use pc + 4 when memtoreg = 0
);

    assign {alusrc, memtoreg, regwrite, memread, memwrite, branch, aluop} = ctrlcode;

    always @(opcode) begin
        case (opcode[6:2])
            `OP_REG: ctrlcode = 8'b00100010;  // R-type
            // `OP_JALR: ctrlcode = 8'b00000000;  // I-type, jalr
            `OP_IMML: ctrlcode = 8'b11110000;  // I-type, ld like
            `OP_IMMOP: ctrlcode = 8'b10100011;  // I-type, addi like  ////////// aluop?
            `OP_STORE: ctrlcode = 8'b10001000;  // S-type
            `OP_BRANCH: ctrlcode = 8'b00000101;  // B-type  
            // `OP_LUI: ctrlcode = 8'b00000000;  // U-type
            // `OP_AUIPC: ctrlcode = 8'b00000000;  // U-type
            `OP_JAL: ctrlcode = 8'b00100100;  // J-type  
            default: ctrlcode = 8'b00000000;
        endcase
    end

    always @(opcode) begin
        if (opcode[6:2] == `OP_JAL) begin
            getpcplus4 = 1'b1;
        end else begin
            getpcplus4 = 1'b0;
        end
    end

endmodule
