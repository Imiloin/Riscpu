`include "riscv_def.v"


module EX (  // Execution Unit, execute operation or calculate address
    input clk,
    input rst,
    input [`PC_WIDTH-1:0] pc,  // need a pc input to support jal (x[rd] = pc + 4)
    input [`REG_DATA_WIDTH-1:0] read_data1,  // data from register file or memory for rs1
    input [`REG_DATA_WIDTH-1:0] read_data2,  // data from register file or memory for rs2
    input [`IMM_WIDTH-1:0] immediate,  // immediate value from ImmGen
    input alusrc,  // ALU 2nd operand source, 0 for rs2, 1 for immediate
    input inst30,  // 30th bit of instruction
    input [`FUNCT3_WIDTH-1:0] funct3,  // function 3
    input [1:0] aluop,  // ALU operation, 00 add to get an address, 01 B type, 10 R type, 11 I type(operation)
    output [`PC_WIDTH-1:0] sum,  // sum of imm and pc
    output alu_branch,  // output of ALU, branch condition meets/not meets
    output [`REG_DATA_WIDTH-1:0] alu_result  // output of ALU, result of operation
);

    // instanciate Adder
    Add u_add (
        .clk(clk),
        .rst(rst),
        .pc(pc),
        .immediate(immediate),
        .sum(sum)
    );

    // instanciate ALU
    ALU u_alu (
        .clk(clk),
        .rst(rst),
        .read_data1(read_data1),
        .read_data2(read_data2),
        .immediate(immediate),
        .alusrc(alusrc),
        .inst30(inst30),
        .funct3(funct3),
        .aluop(aluop),
        .alu_branch(alu_branch),
        .alu_result(alu_result)
    );

endmodule
