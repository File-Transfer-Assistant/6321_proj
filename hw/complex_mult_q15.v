module complex_mult_q15 #(
    parameter A_WIDTH = 32,
    parameter TW_WIDTH = 16,
    parameter FRAC_BITS = 15
) (
    input      signed [A_WIDTH-1:0]   a_re,
    input      signed [A_WIDTH-1:0]   a_im,
    input      signed [TW_WIDTH-1:0]  b_re,
    input      signed [TW_WIDTH-1:0]  b_im,
    output     signed [A_WIDTH-1:0]   p_re,
    output     signed [A_WIDTH-1:0]   p_im
);
    localparam MUL_W = A_WIDTH + TW_WIDTH;

    wire signed [MUL_W-1:0] ar_br = a_re * b_re;
    wire signed [MUL_W-1:0] ai_bi = a_im * b_im;
    wire signed [MUL_W-1:0] ar_bi = a_re * b_im;
    wire signed [MUL_W-1:0] ai_br = a_im * b_re;

    wire signed [MUL_W:0] mult_re = ar_br - ai_bi;
    wire signed [MUL_W:0] mult_im = ar_bi + ai_br;

    wire signed [MUL_W:0] mult_re_shift = mult_re >>> FRAC_BITS;
    wire signed [MUL_W:0] mult_im_shift = mult_im >>> FRAC_BITS;

    assign p_re = mult_re_shift[A_WIDTH-1:0];
    assign p_im = mult_im_shift[A_WIDTH-1:0];
endmodule
