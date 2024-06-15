`include "riscv_def.v"


module Branch (
    input  clk,
    input  rst,
    input  branch,
    input  alu_branch,
    input  branchjalx,
    output pcsrc,
    output flush
);

    assign pcsrc = branchjalx || (branch & alu_branch);
    // flush when branch is taken
    assign flush = pcsrc;

endmodule
