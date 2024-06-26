`include "../riscv_def.v"


module ALU (
    input clk,
    input rst,
    input [`REG_DATA_WIDTH-1:0] read_data1,
    input [`REG_DATA_WIDTH-1:0] read_data2,
    input [`PC_WIDTH-1:0] pc,
    input [`IMM_WIDTH-1:0] immediate,
    input aluinputpc,
    input alusrc,
    input inst30,
    input [`FUNCT3_WIDTH-1:0] funct3,
    input [1:0] aluop,  // ALU operation, 00 add to get an address, 01 B type, 10 R type, 11 I type(operation)
    output reg alu_branch,  // branch signal
    output reg [`REG_DATA_WIDTH-1:0] alu_result
);

    wire signed [`REG_DATA_WIDTH-1:0] alu_op1, alu_op2;
    assign alu_op1 = (aluinputpc) ? pc : read_data1;  // ALU operand 1
    assign alu_op2 = (alusrc) ? immediate : read_data2;  // ALU operand 2

    wire [`REG_DATA_WIDTH-1:0] alu_op1_unsigned, alu_op2_unsigned;
    assign alu_op1_unsigned = alu_op1;  // ALU operand 1 unsigned
    assign alu_op2_unsigned = alu_op2;  // ALU operand 2 unsigned

    // aluop suggests the type of instruction
    always @(*) begin
        case (aluop)  // aluop has higher priority than alu_operation
            2'b00: begin  // ADD, calc address
                alu_result = alu_op1 + alu_op2;
                alu_branch = 0;
            end
            2'b01: begin  // B type or jarl
                alu_result = (alu_op1 + alu_op2) & 32'hFFFFFFFE;  // make sure the address is word aligned
                case (funct3)  ////// 其实只需要 zero 和 lessthan，合并为1个信号
                    3'b000: begin  // beq
                        alu_branch = (alu_op1 == alu_op2);
                    end
                    3'b001: begin  // bne //////
                        alu_branch = (alu_op1 != alu_op2);
                    end
                    3'b100: begin  // blt
                        alu_branch = (alu_op1 < alu_op2);
                    end
                    3'b101: begin  // bge //////
                        alu_branch = (alu_op1 >= alu_op2);
                    end
                    3'b110: begin  // bltu //////
                        alu_branch = (alu_op1_unsigned < alu_op2_unsigned);
                    end
                    3'b111: begin  // bgeu //////
                        alu_branch = (alu_op1_unsigned >= alu_op2_unsigned);
                    end
                    default: begin  // should not happen
                        alu_branch = 0;
                    end
                endcase
            end
            2'b10: begin  // R type
                alu_branch = 0;
                case (funct3)
                    3'b000: begin  // add or sub
                        alu_result = inst30 ? alu_op1 - alu_op2 : alu_op1 + alu_op2;
                    end
                    3'b001: begin  // sll
                        alu_result = alu_op1 << alu_op2[4:0];
                    end
                    3'b010: begin  // slt //////
                        alu_result = (alu_op1 < alu_op2);
                    end
                    3'b011: begin  // sltu //////
                        alu_result = (alu_op1_unsigned < alu_op2_unsigned);
                    end
                    3'b100: begin  // xor
                        alu_result = alu_op1 ^ alu_op2;
                    end
                    3'b101: begin  // srl or sra //////
                        alu_result = inst30 ? alu_op1 >>> alu_op2[4:0] : alu_op1 >> alu_op2[4:0];
                    end
                    3'b110: begin  // or
                        alu_result = alu_op1 | alu_op2;
                    end
                    3'b111: begin  // and
                        alu_result = alu_op1 & alu_op2;
                    end
                    default: begin  // should not happen
                        alu_result = 0;
                    end
                endcase
            end
            2'b11: begin  // addi-like I type
                alu_branch = 0;
                case (funct3)
                    3'b000: begin  // addi
                        alu_result = alu_op1 + alu_op2;
                    end
                    3'b001: begin  // slli
                        alu_result = alu_op1 << alu_op2[4:0];
                    end
                    3'b010: begin  // slti
                        alu_result = (alu_op1 < alu_op2);
                    end
                    3'b011: begin  // sltiu //////
                        alu_result = (alu_op1_unsigned < alu_op2_unsigned);
                    end
                    3'b100: begin  // xori //////
                        alu_result = alu_op1 ^ alu_op2;
                    end
                    3'b101: begin  // srli or srai //////
                        alu_result = inst30 ? alu_op1 >>> alu_op2[4:0] : alu_op1 >> alu_op2[4:0];
                    end
                    3'b110: begin  // ori //////
                        alu_result = alu_op1 | alu_op2;
                    end
                    3'b111: begin  // andi //////
                        alu_result = alu_op1 & alu_op2;
                    end
                    default: begin  // should not happen
                        alu_result = 0;
                    end
                endcase
            end
            default: begin  // should not happen
                alu_result = 0;
                alu_branch = 0;
            end
        endcase
    end

endmodule
