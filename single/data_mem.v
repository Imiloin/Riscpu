module data_mem (  // Data Memory
    input  wire        clk,
    input  wire        ce,      // enable
    input  wire        we,      // write enable, 1 for write, 0 for read
    input  wire [31:0] addr,    // data address
    input  wire [31:0] data_i,  // data input for write
    output reg  [31:0] data_o,  // data output for read
    output wire [31:0] verify   // verification data for read

);

    reg [7:0] data[0:32'h400];
    initial $readmemh("data_mem.txt", data);

    assign verify = {data[15], data[14], data[13], data[12]};

    always @(posedge clk) begin
        if (ce == 1'b0) begin

        end else if (we == 1'b1) begin
            data[addr]   <= data_i[7:0];
            data[addr+1] <= data_i[15:8];
            data[addr+2] <= data_i[23:16];
            data[addr+3] <= data_i[31:24];
        end
    end

    always @* begin
        if (ce == 1'b0) begin
            data_o <= 32'b0;
        end else if (we == 1'b0) begin
            data_o <= {data[addr+3], data[addr+2], data[addr+1], data[addr]};
        end else begin
            data_o <= 32'b0;
        end
    end

endmodule
