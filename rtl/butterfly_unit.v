`timescale 1ns / 1ps

module butterfly_unit (
    input  wire clk,
    input  wire rst_n,

    input  wire signed [15:0] x0_re,
    input  wire signed [15:0] x0_im,
    input  wire signed [15:0] x1_re,
    input  wire signed [15:0] x1_im,

    input  wire signed [15:0] w_re,
    input  wire signed [15:0] w_im,

    output reg  signed [15:0] y0_re,
    output reg  signed [15:0] y0_im,
    output reg  signed [15:0] y1_re,
    output reg  signed [15:0] y1_im
);

    wire signed [16:0] add_re_full = $signed({x0_re[15], x0_re}) + $signed({x1_re[15], x1_re});
    wire signed [16:0] add_im_full = $signed({x0_im[15], x0_im}) + $signed({x1_im[15], x1_im});
    wire signed [16:0] sub_re_full = $signed({x0_re[15], x0_re}) - $signed({x1_re[15], x1_re});
    wire signed [16:0] sub_im_full = $signed({x0_im[15], x0_im}) - $signed({x1_im[15], x1_im});

    wire signed [15:0] add_re_scaled = add_re_full >>> 1;
    wire signed [15:0] add_im_scaled = add_im_full >>> 1;
    wire signed [15:0] sub_re_scaled = sub_re_full >>> 1;
    wire signed [15:0] sub_im_scaled = sub_im_full >>> 1;

    wire signed [31:0] mult_rr = sub_re_scaled * w_re;
    wire signed [31:0] mult_ii = sub_im_scaled * w_im;
    wire signed [31:0] mult_ri = sub_re_scaled * w_im;
    wire signed [31:0] mult_ir = sub_im_scaled * w_re;

    wire signed [32:0] y1_re_full = $signed({mult_rr[31], mult_rr}) - $signed({mult_ii[31], mult_ii});
    wire signed [32:0] y1_im_full = $signed({mult_ri[31], mult_ri}) + $signed({mult_ir[31], mult_ir});

    always @(*) begin
        if (!rst_n) begin
            y0_re = 16'sd0;
            y0_im = 16'sd0;
            y1_re = 16'sd0;
            y1_im = 16'sd0;
        end else begin
            y0_re = add_re_scaled;
            y0_im = add_im_scaled;
            y1_re = y1_re_full >>> 15;
            y1_im = y1_im_full >>> 15;
        end
    end
endmodule
