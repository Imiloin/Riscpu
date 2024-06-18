`include "../riscv_def.v"


module Branch (
    input  clk,
    input  rst,
    input  branch,
    input  alu_branch,
    input  branchjalx,
    output pcsrc,
    output ifflush,
    output idflush,
    output exflush
);

    assign pcsrc = branchjalx || (branch & alu_branch);
    // flush the instruction and control signals stored when branch is taken
    wire flush;
    assign flush = branchjalx || (branch & alu_branch);
    assign ifflush = flush;
    assign idflush = flush;
    assign exflush = flush;

endmodule
