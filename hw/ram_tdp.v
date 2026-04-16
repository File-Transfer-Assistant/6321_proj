module ram_tdp #(
    parameter WIDTH = 16,
    parameter DEPTH = 1024,
    parameter ADDR_W = 10
) (
    input                       clk,
    input                       a_we,
    input      [ADDR_W-1:0]     a_addr,
    input      signed [WIDTH-1:0] a_din,
    output     signed [WIDTH-1:0] a_dout,
    input                       b_we,
    input      [ADDR_W-1:0]     b_addr,
    input      signed [WIDTH-1:0] b_din,
    output     signed [WIDTH-1:0] b_dout
);
    reg signed [WIDTH-1:0] mem [0:DEPTH-1];

    assign a_dout = mem[a_addr];
    assign b_dout = mem[b_addr];

    always @(posedge clk) begin
        if (a_we) begin
            mem[a_addr] <= a_din;
        end
        if (b_we) begin
            mem[b_addr] <= b_din;
        end
    end
endmodule
