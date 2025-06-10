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
    wire pcwrite;
    wire [`PC_WIDTH-1:0] pctarget;
    wire [`PC_WIDTH-1:0] pcplus4_if;
    wire [`PC_WIDTH-1:0] pc_if;
    wire [`XLEN-1:0] instruction_if;
    IF u_IF (
        .clk(clk),
        .rst(rst),
        .inst_i(inst_i),
        .pcsrc(pcsrc),
        .pcwrite(pcwrite),
        .pctarget(pctarget),
        .pcplus4(pcplus4_if),
        .pc(pc_if),
        .inst_addr_o(inst_addr_o),
        .inst_ce_o(inst_ce_o),
        .instruction(instruction_if)
    );

    // instanciate IF/ID
    wire ifidwrite;
    wire ifflush;
    wire [`PC_WIDTH-1:0] pcplus4_id;
    wire [`PC_WIDTH-1:0] pc_id;
    wire [`XLEN-1:0] instruction_id;
    IFID u_IFID (
        .clk(clk),
        .rst(rst),
        .ifidwrite(ifidwrite),
        .ifflush(ifflush),
        .pcplus4_if(pcplus4_if),
        .pc_if(pc_if),
        .instruction_if(instruction_if),
        .pcplus4_id(pcplus4_id),
        .pc_id(pc_id),
        .instruction_id(instruction_id)
    );

    // instanciate ID
    wire [`RS_WIDTH-1:0] rd_wb;
    wire [`REG_DATA_WIDTH-1:0] write_data_wb;
    wire [`RS_WIDTH-1:0] rd_ex;
    wire memread_ex;
    wire regwrite_wb;
    wire inst30_id;
    wire [`FUNCT3_WIDTH-1:0] funct3_id;
    wire [`RS_WIDTH-1:0] rd_id;
    wire [`RS_WIDTH-1:0] rs2_id;
    wire [`RS_WIDTH-1:0] rs1_id;
    wire branch_id;
    wire memread_id;
    wire memtoreg_id;
    wire [1:0] aluop_id;
    wire memwrite_id;
    wire alusrc_id;
    wire regwrite_id;
    wire aluinputpc_id;
    wire branchjalx_id;
    wire alu2pc_id;
    wire [`REG_DATA_WIDTH-1:0] read_data1_id;
    wire [`REG_DATA_WIDTH-1:0] read_data2_id;
    wire [`IMM_WIDTH-1:0] immediate_id;
    ID u_ID (
        .clk(clk),
        .rst(rst),
        .instruction(instruction_id),
        .rd_wb(rd_wb),
        .write_data_wb(write_data_wb),
        .rd_ex(rd_ex),
        .memread_ex(memread_ex),
        .regwrite_wb(regwrite_wb),
        .inst30(inst30_id),
        .funct3(funct3_id),
        .rd(rd_id),
        .rs2(rs2_id),
        .rs1(rs1_id),
        .branch(branch_id),
        .memread(memread_id),
        .memtoreg(memtoreg_id),
        .aluop(aluop_id),
        .memwrite(memwrite_id),
        .alusrc(alusrc_id),
        .regwrite(regwrite_id),
        .aluinputpc(aluinputpc_id),
        .branchjalx(branchjalx_id),
        .alu2pc(alu2pc_id),
        .pcwrite(pcwrite),
        .ifidwrite(ifidwrite),
        .read_data1(read_data1_id),
        .read_data2(read_data2_id),
        .immediate(immediate_id)
    );

    // instanciate ID/EX
    wire idflush;
    wire inst30_ex;
    wire [`FUNCT3_WIDTH-1:0] funct3_ex;
    wire [`RS_WIDTH-1:0] rs2_ex;
    wire [`RS_WIDTH-1:0] rs1_ex;
    wire branch_ex;
    wire memtoreg_ex;
    wire [1:0] aluop_ex;
    wire memwrite_ex;
    wire alusrc_ex;
    wire regwrite_ex;
    wire aluinputpc_ex;
    wire branchjalx_ex;
    wire alu2pc_ex;
    wire [`REG_DATA_WIDTH-1:0] read_data1_ex;
    wire [`REG_DATA_WIDTH-1:0] read_data2_ex;
    wire [`IMM_WIDTH-1:0] immediate_ex;
    wire [`PC_WIDTH-1:0] pcplus4_ex;
    wire [`PC_WIDTH-1:0] pc_ex;
    IDEX u_IDEX (
        .clk(clk),
        .rst(rst),
        .idflush(idflush),
        .inst30_id(inst30_id),
        .funct3_id(funct3_id),
        .rd_id(rd_id),
        .rs2_id(rs2_id),
        .rs1_id(rs1_id),
        .branch_id(branch_id),
        .memread_id(memread_id),
        .memtoreg_id(memtoreg_id),
        .aluop_id(aluop_id),
        .memwrite_id(memwrite_id),
        .alusrc_id(alusrc_id),
        .regwrite_id(regwrite_id),
        .aluinputpc_id(aluinputpc_id),
        .branchjalx_id(branchjalx_id),
        .alu2pc_id(alu2pc_id),
        .read_data1_id(read_data1_id),
        .read_data2_id(read_data2_id),
        .immediate_id(immediate_id),
        .pcplus4_id(pcplus4_id),
        .pc_id(pc_id),
        .inst30_ex(inst30_ex),
        .funct3_ex(funct3_ex),
        .rd_ex(rd_ex),
        .rs2_ex(rs2_ex),
        .rs1_ex(rs1_ex),
        .branch_ex(branch_ex),
        .memread_ex(memread_ex),
        .memtoreg_ex(memtoreg_ex),
        .aluop_ex(aluop_ex),
        .memwrite_ex(memwrite_ex),
        .alusrc_ex(alusrc_ex),
        .regwrite_ex(regwrite_ex),
        .aluinputpc_ex(aluinputpc_ex),
        .branchjalx_ex(branchjalx_ex),
        .alu2pc_ex(alu2pc_ex),
        .read_data1_ex(read_data1_ex),
        .read_data2_ex(read_data2_ex),
        .immediate_ex(immediate_ex),
        .pcplus4_ex(pcplus4_ex),
        .pc_ex(pc_ex)
    );

    // instanciate EX
    wire [`REG_DATA_WIDTH-1:0] wb_data_mem;
    wire [`RS_WIDTH-1:0] rd_mem;
    wire regwrite_mem;
    wire [`REG_DATA_WIDTH-1:0] read_data2_forwarded_ex;
    wire [`PC_WIDTH-1:0] sum_ex;
    wire alu_branch_ex;
    wire [`REG_DATA_WIDTH-1:0] alu_result_ex;
    EX u_EX (
        .clk(clk),
        .rst(rst),
        .rs1(rs1_ex),
        .rs2(rs2_ex),
        .pc(pc_ex),
        .read_data1(read_data1_ex),
        .read_data2(read_data2_ex),
        .immediate(immediate_ex),
        .wb_data_mem(wb_data_mem),
        .write_data_wb(write_data_wb),
        .aluinputpc(aluinputpc_ex),
        .alusrc(alusrc_ex),
        .inst30(inst30_ex),
        .funct3(funct3_ex),
        .aluop(aluop_ex),
        .rd_mem(rd_mem),
        .rd_wb(rd_wb),
        .regwrite_mem(regwrite_mem),
        .regwrite_wb(regwrite_wb),
        .read_data2_forwarded(read_data2_forwarded_ex),
        .sum(sum_ex),
        .alu_branch(alu_branch_ex),
        .alu_result(alu_result_ex)
    );

    // instanciate EX/MEM
    wire exflush;
    wire [`REG_DATA_WIDTH-1:0] read_data2_forwarded_mem;
    wire [`PC_WIDTH-1:0] sum_mem;
    wire alu_branch_mem;
    wire [`REG_DATA_WIDTH-1:0] alu_result_mem;
    wire branch_mem;
    wire memread_mem;
    wire memtoreg_mem;
    wire memwrite_mem;
    wire aluinputpc_mem;
    wire branchjalx_mem;
    wire alu2pc_mem;
    wire [`PC_WIDTH-1:0] pcplus4_mem;
    EXMEM u_EXMEM (
        .clk(clk),
        .rst(rst),
        .exflush(exflush),
        .read_data2_forwarded_ex(read_data2_forwarded_ex),
        .sum_ex(sum_ex),
        .alu_branch_ex(alu_branch_ex),
        .alu_result_ex(alu_result_ex),
        .rd_ex(rd_ex),
        .branch_ex(branch_ex),
        .memread_ex(memread_ex),
        .memtoreg_ex(memtoreg_ex),
        .memwrite_ex(memwrite_ex),
        .regwrite_ex(regwrite_ex),
        .aluinputpc_ex(aluinputpc_ex),
        .branchjalx_ex(branchjalx_ex),
        .alu2pc_ex(alu2pc_ex),
        .pcplus4_ex(pcplus4_ex),
        .read_data2_forwarded_mem(read_data2_forwarded_mem),
        .sum_mem(sum_mem),
        .alu_branch_mem(alu_branch_mem),
        .alu_result_mem(alu_result_mem),
        .rd_mem(rd_mem),
        .branch_mem(branch_mem),
        .memread_mem(memread_mem),
        .memtoreg_mem(memtoreg_mem),
        .memwrite_mem(memwrite_mem),
        .regwrite_mem(regwrite_mem),
        .aluinputpc_mem(aluinputpc_mem),
        .branchjalx_mem(branchjalx_mem),
        .alu2pc_mem(alu2pc_mem),
        .pcplus4_mem(pcplus4_mem)
    );

    // instanciate MEM
    MEM u_MEM (
        .clk(clk),
        .rst(rst),
        .memread(memread_mem),
        .memwrite(memwrite_mem),
        .alu_result(alu_result_mem),
        .read_data2_forwarded(read_data2_forwarded_mem),
        .pcplus4(pcplus4_mem),
        .branchjalx(branchjalx_mem),
        .branch(branch_mem),
        .alu_branch(alu_branch_mem),
        .sum(sum_mem),
        .alu2pc(alu2pc_mem),
        .data_we_o(data_we_o),
        .data_ce_o(data_ce_o),
        .pcsrc(pcsrc),
        .ifflush(ifflush),
        .idflush(idflush),
        .exflush(exflush),
        .data_addr_o(data_addr_o),
        .data_o(data_o),
        .wb_data(wb_data_mem),
        .pctarget(pctarget)
    );

    // instanciate MEM/WB
    wire [`REG_DATA_WIDTH-1:0] wb_data_wb;
    wire memtoreg_wb;
    wire [`REG_DATA_WIDTH-1:0] data_i_wb;
    MEMWB u_MEMWB (
        .clk(clk),
        .rst(rst),
        .data_i_mem(data_i),
        .wb_data_mem(wb_data_mem),
        .rd_mem(rd_mem),
        .memtoreg_mem(memtoreg_mem),
        .regwrite_mem(regwrite_mem),
        .data_i_wb(data_i_wb),
        .wb_data_wb(wb_data_wb),
        .rd_wb(rd_wb),
        .memtoreg_wb(memtoreg_wb),
        .regwrite_wb(regwrite_wb)
    );

    // instanciate WB
    WB u_WB (
        .clk(clk),
        .rst(rst),
        .data_i(data_i_wb),
        .wb_data(wb_data_wb),
        .memtoreg(memtoreg_wb),
        .write_data(write_data_wb)
    );

endmodule
