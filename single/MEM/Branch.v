`include "riscv_def.v"


module Branch (
    input  clk,
    input  rst,
    input  branch,
    input  alu_branch,
    input alu2pc,
    output pcsrc
);

    assign pcsrc = alu2pc ? 1'b1 : branch & alu_branch;

endmodule
