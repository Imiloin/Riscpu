`include "riscv_def.v"


module EX (  // Execution Unit, execute operation or calculate address
    input clk,
    input rst,
    input [`RS_WIDTH-1:0] rs1,
    input [`RS_WIDTH-1:0] rs2,
    input [`PC_WIDTH-1:0] pc,  // need a pc input to support jal (x[rd] = pc + 4)
    input [`REG_DATA_WIDTH-1:0] read_data1,  // data from register file or memory for rs1
    input [`REG_DATA_WIDTH-1:0] read_data2,  // data from register file or memory for rs2
    input [`IMM_WIDTH-1:0] immediate,  // immediate value from ImmGen
    input [`REG_DATA_WIDTH-1:0] wb_data_mem,  // data to be written back at MEM stage
    input [`REG_DATA_WIDTH-1:0] write_data_wb,  // data to be written back at WB stage
    input aluinputpc,  // ALU 1st operand source, 0 for rs1, 1 for pc
    input alusrc,  // ALU 2nd operand source, 0 for rs2, 1 for immediate
    input inst30,  // 30th bit of instruction
    input [`FUNCT3_WIDTH-1:0] funct3,  // function 3
    input [1:0] aluop,  // ALU operation, 00 add to get an address, 01 B type, 10 R type, 11 I type(operation)
    input [`RS_WIDTH-1:0] rd_mem,  // rd from MEM stage
    input [`RS_WIDTH-1:0] rd_wb,  // rd from WB stage
    input regwrite_mem,  // regwrite from MEM stage
    input regwrite_wb,  // regwrite from WB stage
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

    // instanciate ALU input selection mux
    wire [`REG_DATA_WIDTH-1:0] alu_op1;
    wire [`REG_DATA_WIDTH-1:0] alu_op2;
    wire [1:0] forwarda;  // rs1 forward control signal from Forwarding unit
    wire [1:0] forwardb;  // rs2 forward control signal from Forwarding unit
    ALUMux u_alumux (
        .clk(clk),
        .rst(rst),
        .read_data1_ex(read_data1),
        .read_data2_ex(read_data2),
        .pc_ex(pc),
        .immediate_ex(immediate),
        .wb_data_mem(wb_data_mem),
        .write_data_wb(write_data_wb),
        .aluinputpc_ex(aluinputpc),
        .alusrc_ex(alusrc),
        .forwarda(forwarda),
        .forwardb(forwardb),
        .alu_op1(alu_op1),
        .alu_op2(alu_op2)
    );

    // instanciate ALU
    ALU u_alu (
        .clk(clk),
        .rst(rst),
        .alu_op1(alu_op1),
        .alu_op2(alu_op2),
        .inst30(inst30),
        .funct3(funct3),
        .aluop(aluop),
        .alu_branch(alu_branch),
        .alu_result(alu_result)
    );

    // instanciate Forwarding unit
    Forwarding u_forwarding (
        .clk(clk),
        .rst(rst),
        .rs1_ex(rs1),
        .rs2_ex(rs2),
        .rd_mem(rd_mem),
        .rd_wb(rd_wb),
        .regwrite_mem(regwrite_mem),
        .regwrite_wb(regwrite_wb),
        .forwarda(forwarda),
        .forwardb(forwardb)
    );

endmodule
