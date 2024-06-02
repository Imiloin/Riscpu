`include "riscv_def.v"


module IF (  // Instruction Fetch Unit, fetches the next instruction to be executed
    input clk,
    input rst,
    input pcsrc,  // select the source of pc
    input [`PC_WIDTH-1:0] sum,  // pc + imm
    output [`PC_WIDTH-1:0] pcplus4,  // pc + 4
    output reg [`PC_WIDTH-1:0] pc  // next pc to be executed
);
    /////// should pc be a reg or wire?
    assign pcplus4 = pc + 4;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            pc <= 0;  // or -4?
        end else if (pcsrc) begin
            pc <= sum;
        end else begin
            pc <= pcplus4;
        end
    end

endmodule
