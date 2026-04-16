module complex_ram_bank #(
    parameter WIDTH = 32,
    parameter DEPTH = 1024,
    parameter ADDR_W = 10
) (
    input                           clk,
    input                           a_we,
    input      [ADDR_W-1:0]         a_addr,
    input      signed [WIDTH-1:0]   a_re_din,
    input      signed [WIDTH-1:0]   a_im_din,
    output     signed [WIDTH-1:0]   a_re_dout,
    output     signed [WIDTH-1:0]   a_im_dout,
    input                           b_we,
    input      [ADDR_W-1:0]         b_addr,
    input      signed [WIDTH-1:0]   b_re_din,
    input      signed [WIDTH-1:0]   b_im_din,
    output     signed [WIDTH-1:0]   b_re_dout,
    output     signed [WIDTH-1:0]   b_im_dout
);
    ram_tdp #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH),
        .ADDR_W(ADDR_W)
    ) u_ram_re (
        .clk   (clk),
        .a_we  (a_we),
        .a_addr(a_addr),
        .a_din (a_re_din),
        .a_dout(a_re_dout),
        .b_we  (b_we),
        .b_addr(b_addr),
        .b_din (b_re_din),
        .b_dout(b_re_dout)
    );

    ram_tdp #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH),
        .ADDR_W(ADDR_W)
    ) u_ram_im (
        .clk   (clk),
        .a_we  (a_we),
        .a_addr(a_addr),
        .a_din (a_im_din),
        .a_dout(a_im_dout),
        .b_we  (b_we),
        .b_addr(b_addr),
        .b_din (b_im_din),
        .b_dout(b_im_dout)
    );
endmodule
