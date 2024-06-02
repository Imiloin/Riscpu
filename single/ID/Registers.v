`include "riscv_def.v"


module Registers (
    input clk,
    input rst,
    input regwrite,  // write enable
    input [`RS_WIDTH-1:0] rs1,  // read register 1
    input [`RS_WIDTH-1:0] rs2,  // read register 2
    input [`RS_WIDTH-1:0] rd,  // write register
    input [`REG_DATA_WIDTH-1:0] write_data,
    output reg [`REG_DATA_WIDTH-1:0] read_data1,
    output reg [`REG_DATA_WIDTH-1:0] read_data2
);

    reg [`REG_DATA_WIDTH-1:0] registers[0:`REG_SIZE-1];

    always @(posedge clk) begin
        if (rst) begin
            registers[0] <= 0;  // x0 is always 0
        end else if (regwrite && rd != 0) begin
            registers[rd] <= write_data;
        end else begin
            // do nothing
            registers[0] <= 0;
        end
    end

    assign read_data1 = registers[rs1];
    assign read_data2 = registers[rs2];

endmodule
