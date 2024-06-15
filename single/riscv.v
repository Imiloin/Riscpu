`include "riscv_def.v"


module riscv (

    input wire clk,
    input wire rst,  // high is reset

    // inst_mem
    input  wire [31:0] inst_i,       // input instruction
    output wire [31:0] inst_addr_o,  // instruction fetch address
    output wire        inst_ce_o,    // instruction fetch enable

    // data_mem
    input wire [31:0] data_i,  // data memory read data
    output wire data_we_o,  // data memory write enable, 1 for write, 0 for read
    output wire data_ce_o,  // data memory enable
    output wire [31:0] data_addr_o,  // data memory address
    output wire [31:0] data_o  // data memory write data

);

    //// instance modules ////

    // instanciate IF
    wire pcsrc;
    wire [`PC_WIDTH-1:0] pctarget;
    wire [`PC_WIDTH-1:0] pcplus4;
    wire [`PC_WIDTH-1:0] pc;
    wire [`XLEN-1:0] instruction;
    IF u_IF (
        .clk(clk),
        .rst(rst),
        .inst_i(inst_i),
        .pcsrc(pcsrc),
        .pctarget(pctarget),
        .pcplus4(pcplus4),
        .pc(pc),
        .inst_addr_o(inst_addr_o),
        .inst_ce_o(inst_ce_o),
        .instruction(instruction)
    );

    // instanciate ID
    wire [`REG_DATA_WIDTH-1:0] write_data;
    wire inst30;
    wire [`FUNCT3_WIDTH-1:0] funct3;
    wire [`RS_WIDTH-1:0] rd;
    wire branch;
    wire memread;
    wire memtoreg;
    wire [1:0] aluop;
    wire memwrite;
    wire alusrc;
    // wire regwrite;
    wire aluinputpc;
    wire branchjalx;
    wire alu2pc;
    wire [`REG_DATA_WIDTH-1:0] read_data1;
    wire [`REG_DATA_WIDTH-1:0] read_data2;
    wire [`IMM_WIDTH-1:0] immediate;
    ID u_ID (
        .clk(clk),
        .rst(rst),
        .instruction(instruction),
        .write_data(write_data),
        .inst30(inst30),
        .funct3(funct3),
        .rd(rd),
        .branch(branch),
        .memread(memread),
        .memtoreg(memtoreg),
        .aluop(aluop),
        .memwrite(memwrite),
        .alusrc(alusrc),
        // .regwrite(regwrite),  // not used for single-cycle implementation (defined in ID)
        .aluinputpc(aluinputpc),
        .branchjalx(branchjalx),
        .alu2pc(alu2pc),
        .read_data1(read_data1),
        .read_data2(read_data2),
        .immediate(immediate)
    );

    // instanciate EX
    wire [`PC_WIDTH-1:0] sum;
    wire alu_branch;
    wire [`REG_DATA_WIDTH-1:0] alu_result;
    EX u_EX (
        .clk(clk),
        .rst(rst),
        .pc(pc),
        .read_data1(read_data1),
        .read_data2(read_data2),
        .immediate(immediate),
        .aluinputpc(aluinputpc),
        .alusrc(alusrc),
        .inst30(inst30),
        .funct3(funct3),
        .aluop(aluop),
        .sum(sum),
        .alu_branch(alu_branch),
        .alu_result(alu_result)
    );

    // instanciate MEM
    wire [`REG_DATA_WIDTH-1:0] wb_data;
    MEM u_MEM (
        .clk(clk),
        .rst(rst),
        .memread(memread),
        .memwrite(memwrite),
        .alu_result(alu_result),
        .read_data2(read_data2),
        .pcplus4(pcplus4),
        .branchjalx(branchjalx),
        .branch(branch),
        .alu_branch(alu_branch),
        .sum(sum),
        .alu2pc(alu2pc),
        .data_we_o(data_we_o),
        .data_ce_o(data_ce_o),
        .pcsrc(pcsrc),
        .data_addr_o(data_addr_o),
        .data_o(data_o),
        .wb_data(wb_data),
        .pctarget(pctarget)
    );

    // instanciate WB
    WB u_WB (
        .clk(clk),
        .rst(rst),
        .data_i(data_i),
        .wb_data(wb_data),
        .memtoreg(memtoreg),
        .write_data(write_data)
    );

endmodule
