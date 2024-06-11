`include "riscv_def.v"


module ID (  // Instruction Decode Unit, decode the instruction or read the register file
    input clk,
    input rst,
    input [`XLEN-1:0] instruction,  // instruction to be decoded
    input [`REG_DATA_WIDTH-1:0] write_data,  // write back data from WB stage
    output inst30,  // 30th bit of instruction
    output [`FUNCT3_WIDTH-1:0] funct3,  // function 3
    output [`RS_WIDTH-1:0] rd,  // destination register
    output branch,  // branch or not
    output memread,  // memory read or not
    output memtoreg,  // memory to register or not
    output [1:0] aluop,  // ALU operation, 00 add to get an address, 01 B type, 10 R type, 11 I type(operation)
    output memwrite,  // memory write or not
    output alusrc,  // ALU 2nd operand source, 0 for rs2, 1 for immediate
    // output regwrite,  // register write or not
    output aluinputpc,  // use pc as ALU 1st input, for auipc instruction
    output branchjalx,  // is a jal or jalr instruction
    output alu2pc,  // use ALU result as pc, for jalr instruction
    output [`REG_DATA_WIDTH-1:0] read_data1,  // data from register file or memory for rs1
    output [`REG_DATA_WIDTH-1:0] read_data2,  // data from register file or memory for rs2
    output [`IMM_WIDTH-1:0] immediate  // immediate value from ImmGen
);

    assign inst30 = instruction[30];
    
    // wire [`FUNCT7_WIDTH-1:0] funct7;  // function 7
    wire [`RS_WIDTH-1:0] rs2;  // source register 2
    wire [`RS_WIDTH-1:0] rs1;  // source register 1
    wire [`OPCODE_WIDTH-1:0] opcode;  // operation code

    assign opcode = instruction[`OPCODE];
    
    // assign funct7 = instruction[`FUNCT7];
    assign rs2 = instruction[`RS2];
    assign rs1 = (opcode[6:2] == `OP_LUI) ? 0 : instruction[`RS1];  // for lui, rs1 is 0, just add 0 and imm
    assign funct3 = instruction[`FUNCT3];
    assign rd = instruction[`RD];
    

    wire regwrite;  // register write or not
    // instanciate Control module
    Control u_control (
        .clk(clk),
        .rst(rst),
        .opcode(opcode),
        .branch(branch),
        .memread(memread),
        .memtoreg(memtoreg),
        .aluop(aluop),
        .memwrite(memwrite),
        .alusrc(alusrc),
        .regwrite(regwrite),
        .aluinputpc(aluinputpc),
        .branchjalx(branchjalx),
        .alu2pc(alu2pc)
    );

    // instanciate the register file
    Registers u_registers (
        .clk(clk),
        .rst(rst),
        .regwrite(regwrite),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .write_data(write_data),
        .read_data1(read_data1),
        .read_data2(read_data2)
    );

    // instanciate Immediate Generator module
    ImmGen u_immgen (
        .clk(clk),
        .rst(rst),
        .instruction(instruction),
        .imm(immediate)
    );

endmodule
