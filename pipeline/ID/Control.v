`include "riscv_def.v"


module Control (
    input clk,
    input rst,
    input [`OPCODE_WIDTH-1:0] opcode,
    input clearcontrol,  // clear control signals, from HazardDetection
    output branch,
    output memread,
    output memtoreg,
    output [1:0] aluop,
    output memwrite,
    output alusrc,
    output regwrite,
    output reg aluinputpc,  // use pc as alu input 1 (auipc)
    output reg branchjalx,  // use pc + 4 when memtoreg = 0, and set pcsrc = 1 (jal, jalr)
    output reg alu2pc  // use alu result as pc (jalr)
);

    reg [7:0] ctrlcode;
    
    assign {alusrc, memtoreg, regwrite, memread, memwrite, branch, aluop} = ctrlcode;

    always @(opcode) begin
        if (clearcontrol) begin
            ctrlcode = 8'b00000000;
        end else begin
        case (opcode[6:2])
            `OP_REG: ctrlcode = 8'b00100010;  // R-type
            `OP_JALR: ctrlcode = 8'b10100001;  // I-type, jalr //////
            `OP_IMML: ctrlcode = 8'b11110000;  // I-type, ld like
            `OP_IMMOP: ctrlcode = 8'b10100011;  // I-type, addi like
            `OP_STORE: ctrlcode = 8'b10001000;  // S-type
            `OP_BRANCH: ctrlcode = 8'b00000101;  // B-type  
            `OP_LUI: ctrlcode = 8'b10100000;  // U-type //////
            `OP_AUIPC: ctrlcode = 8'b10100000;  // U-type //////
            `OP_JAL: ctrlcode = 8'b00100100;  // J-type  
            default: ctrlcode = 8'b00000000;
        endcase
        end
    end

    always @(opcode) begin
        if (clearcontrol) begin
            aluinputpc = 1'b0;
        end else if (opcode[6:2] == `OP_AUIPC) begin
            aluinputpc = 1'b1;
        end else begin
            aluinputpc = 1'b0;
        end
    end

    always @(opcode) begin
        if (clearcontrol) begin
            branchjalx = 1'b0;
        end else if (opcode[6:2] == `OP_JAL || opcode[6:2] == `OP_JALR) begin
            branchjalx = 1'b1;
        end else begin
            branchjalx = 1'b0;
        end
    end

    always @(opcode) begin
        if (clearcontrol) begin
            alu2pc = 1'b0;
        end else if (opcode[6:2] == `OP_JALR) begin
            alu2pc = 1'b1;
        end else begin
            alu2pc = 1'b0;
        end
    end

endmodule
