module EX (  // Execution Unit, execute operation or calculate address
    input clk,
    input rst,
    input [31:0] pc,  // need a pc input to support jal (x[rd] = pc + 4)
);

endmodule
