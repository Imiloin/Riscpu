`include "../riscv_def.v"


module HazardDetection (
    input clk,
    input rst,
    input [`RS_WIDTH-1:0] rs1_id,
    input [`RS_WIDTH-1:0] rs2_id,
    input [`RS_WIDTH-1:0] rd_ex,
    input memread_ex,
    output pcwrite,
    output ifidwrite,
    output clearcontrol  // set control signals to 0
);

    wire stall;
    assign stall = memread_ex && ((rd_ex == rs1_id) || (rd_ex == rs2_id));

    assign pcwrite = ~stall;
    assign ifidwrite = ~stall;
    assign clearcontrol = stall;

endmodule
