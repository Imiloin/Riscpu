`include "riscv_def.v"


module IDEX (
    input clk,
    input rst,
    input idflush,  // flush the ID/EX pipeline
    // from ID stage
    input inst30_id,
    input [`FUNCT3_WIDTH-1:0] funct3_id,
    input [`RS_WIDTH-1:0] rd_id,
    input [`RS_WIDTH-1:0] rs2_id,
    input [`RS_WIDTH-1:0] rs1_id,
    input branch_id,
    input memread_id,
    input memtoreg_id,
    input [1:0] aluop_id,
    input memwrite_id,
    input alusrc_id,
    input regwrite_id,
    input aluinputpc_id,
    input branchjalx_id,
    input alu2pc_id,
    input [`REG_DATA_WIDTH-1:0] read_data1_id,
    input [`REG_DATA_WIDTH-1:0] read_data2_id,
    input [`IMM_WIDTH-1:0] immediate_id,
    // from IFID
    input [`PC_WIDTH-1:0] pcplus4_id,
    input [`PC_WIDTH-1:0] pc_id,
    // outputs
    output reg inst30_ex,
    output reg [`FUNCT3_WIDTH-1:0] funct3_ex,
    output reg [`RS_WIDTH-1:0] rd_ex,
    output reg [`RS_WIDTH-1:0] rs2_ex,
    output reg [`RS_WIDTH-1:0] rs1_ex,
    output reg branch_ex,
    output reg memread_ex,
    output reg memtoreg_ex,
    output reg [1:0] aluop_ex,
    output reg memwrite_ex,
    output reg alusrc_ex,
    output reg regwrite_ex,
    output reg aluinputpc_ex,
    output reg branchjalx_ex,
    output reg alu2pc_ex,
    output reg [`REG_DATA_WIDTH-1:0] read_data1_ex,
    output reg [`REG_DATA_WIDTH-1:0] read_data2_ex,
    output reg [`IMM_WIDTH-1:0] immediate_ex,
    output reg [`PC_WIDTH-1:0] pcplus4_ex,
    output reg [`PC_WIDTH-1:0] pc_ex
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            inst30_ex <= 0;
            funct3_ex <= 0;
            rd_ex <= 0;
            rs2_ex <= 0;
            rs1_ex <= 0;
            branch_ex <= 0;
            memread_ex <= 0;
            memtoreg_ex <= 0;
            aluop_ex <= 0;
            memwrite_ex <= 0;
            alusrc_ex <= 0;
            regwrite_ex <= 0;
            aluinputpc_ex <= 0;
            branchjalx_ex <= 0;
            alu2pc_ex <= 0;
            read_data1_ex <= 0;
            read_data2_ex <= 0;
            immediate_ex <= 0;
            pcplus4_ex <= 0;
            pc_ex <= 0;
        end else if (idflush) begin
            inst30_ex <= 0;
            funct3_ex <= 0;
            rd_ex <= 0;
            rs2_ex <= 0;
            rs1_ex <= 0;
            branch_ex <= 0;
            memread_ex <= 0;
            memtoreg_ex <= 0;
            aluop_ex <= 0;
            memwrite_ex <= 0;
            alusrc_ex <= 0;
            regwrite_ex <= 0;
            aluinputpc_ex <= 0;
            branchjalx_ex <= 0;
            alu2pc_ex <= 0;
            read_data1_ex <= 0;
            read_data2_ex <= 0;
            immediate_ex <= 0;
            pcplus4_ex <= 0;
            pc_ex <= 0;
        end else begin
            inst30_ex <= inst30_id;
            funct3_ex <= funct3_id;
            rd_ex <= rd_id;
            rs2_ex <= rs2_id;
            rs1_ex <= rs1_id;
            branch_ex <= branch_id;
            memread_ex <= memread_id;
            memtoreg_ex <= memtoreg_id;
            aluop_ex <= aluop_id;
            memwrite_ex <= memwrite_id;
            alusrc_ex <= alusrc_id;
            regwrite_ex <= regwrite_id;
            aluinputpc_ex <= aluinputpc_id;
            branchjalx_ex <= branchjalx_id;
            alu2pc_ex <= alu2pc_id;
            read_data1_ex <= read_data1_id;
            read_data2_ex <= read_data2_id;
            immediate_ex <= immediate_id;
            pcplus4_ex <= pcplus4_id;
            pc_ex <= pc_id;
        end
    end

endmodule
