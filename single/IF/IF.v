`include "riscv_def.v"


module IF (  // Instruction Fetch Unit, fetches the next instruction to be executed
    input clk,
    input rst,
    input [`XLEN-1:0] inst_i,  // input instruction from instruction memory
    input pcsrc,  // select the source of pc
    input [`PC_WIDTH-1:0] pctarget,  // pc + imm (branch, jal) or alu_result (jalr)
    output [`PC_WIDTH-1:0] pcplus4,  // pc + 4
    output reg [`PC_WIDTH-1:0] pc,  // next pc to be executed
    output [`XLEN-1:0] inst_addr_o,  // instruction fetch address
    output inst_ce_o,   // instruction fetch enable
    output [`XLEN-1:0] instruction  // instruction fetched
);
    
    assign inst_ce_o = ~rst;  // enable instruction fetch by default
    
    assign instruction = inst_i;
    
    /////// should pc be a reg or wire?
    assign pcplus4 = pc + 4;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            pc <= 0;  // or -4?
        end else if (pcsrc) begin
            pc <= pctarget;
        end else begin
            pc <= pcplus4;
        end
    end

    assign inst_addr_o = pc;

endmodule
