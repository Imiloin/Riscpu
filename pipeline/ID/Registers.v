`include "../riscv_def.v"


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

    always @(*) begin
        if (rst) begin
            read_data1 = 0;
            read_data2 = 0;
        end else begin
            read_data1 = (rs1 == rd) ? write_data : registers[rs1];
            read_data2 = (rs2 == rd) ? write_data : registers[rs2];
        end
    end


    // Debugging
`ifdef DEBUG
    integer i;

    always @(posedge clk) begin
        if (regwrite && rd != 0) begin
            $display("Time: %t, Written data: %h(%d) to register %d", $time,
                     write_data, write_data, rd);
        end
    end

    initial begin
        #100000;
        $display("Registers content:");
        for (i = 0; i < `REG_SIZE; i = i + 1) begin
            $display("Reg[%d] = %h", i, registers[i]);
        end
    end
`endif

endmodule
