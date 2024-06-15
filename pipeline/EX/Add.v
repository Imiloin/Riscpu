`include "riscv_def.v"


module Add (
    input clk,
    input rst,
    input signed [`PC_WIDTH-1:0] pc,
    input signed [`IMM_WIDTH-1:0] immediate,
    output signed [`PC_WIDTH-1:0] sum  //////// signed or not?
);

    assign sum = pc + immediate;

endmodule
