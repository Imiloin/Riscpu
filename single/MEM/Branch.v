`include "../riscv_def.v"


module Branch (
    input  clk,
    input  rst,
    input  branch,
    input  alu_branch,
    input  branchjalx,
    output pcsrc
);

    assign pcsrc = branchjalx || (branch & alu_branch);

endmodule
