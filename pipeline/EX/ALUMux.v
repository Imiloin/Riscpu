`include "riscv_def.v"


module ALUMux (
    input clk,
    input rst,
    input [`REG_DATA_WIDTH-1:0] read_data1_ex,
    input [`REG_DATA_WIDTH-1:0] read_data2_ex,
    input [`PC_WIDTH-1:0] pc_ex,
    input [`IMM_WIDTH-1:0] immediate_ex,
    input [`REG_DATA_WIDTH-1:0] wb_data_mem,  // data to be written back at MEM stage
    input [`REG_DATA_WIDTH-1:0] write_data_wb,  // data to be written back at WB stage
    input aluinputpc_ex,
    input alusrc_ex,
    input [1:0] forwarda,
    input [1:0] forwardb,
    output signed [`REG_DATA_WIDTH-1:0] alu_op1,
    output signed [`REG_DATA_WIDTH-1:0] alu_op2
);

    reg [`REG_DATA_WIDTH-1:0] read_data1_forwarded;
    reg [`REG_DATA_WIDTH-1:0] read_data2_forwarded;

    always @(*) begin
        case (forwarda)
            2'b00:   read_data1_forwarded = read_data1_ex;
            2'b01:   read_data1_forwarded = wb_data_mem;
            2'b10:   read_data1_forwarded = write_data_wb;
            2'b11:   read_data1_forwarded = read_data1_ex;
            default: read_data1_forwarded = 0;  // should never happen
        endcase
    end

    always @(*) begin
        case (forwardb)
            2'b00:   read_data2_forwarded = read_data2_ex;
            2'b01:   read_data2_forwarded = wb_data_mem;
            2'b10:   read_data2_forwarded = write_data_wb;
            2'b11:   read_data2_forwarded = read_data2_ex;
            default: read_data2_forwarded = 0;  // should never happen
        endcase
    end

    assign alu_op1 = (aluinputpc_ex) ? pc_ex : read_data1_forwarded;  // ALU operand 1
    assign alu_op2 = (alusrc_ex) ? immediate_ex : read_data2_forwarded;  // ALU operand 2

endmodule
