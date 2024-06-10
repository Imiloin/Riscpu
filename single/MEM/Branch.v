`include "riscv_def.v"


module Branch (
    input  clk,
    input  rst,
    input  branch,
    input  alu_branch,
    output pcsrc
);

    assign pcsrc = branch & alu_branch;

endmodule
