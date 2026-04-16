module complex_butterfly #(
    parameter DATA_WIDTH = 32
) (
    input      signed [DATA_WIDTH-1:0] x0_re,
    input      signed [DATA_WIDTH-1:0] x0_im,
    input      signed [DATA_WIDTH-1:0] x1_re,
    input      signed [DATA_WIDTH-1:0] x1_im,
    input      signed [15:0]           tw_re,
    input      signed [15:0]           tw_im,
    output reg signed [DATA_WIDTH-1:0] y0_re,
    output reg signed [DATA_WIDTH-1:0] y0_im,
    output reg signed [DATA_WIDTH-1:0] y1_re,
    output reg signed [DATA_WIDTH-1:0] y1_im
);
    localparam signed [DATA_WIDTH-1:0] MAX_VAL = {1'b0, {(DATA_WIDTH-1){1'b1}}};
    localparam signed [DATA_WIDTH-1:0] MIN_VAL = {1'b1, {(DATA_WIDTH-1){1'b0}}};

    wire signed [DATA_WIDTH-1:0] tw_x1_re;
    wire signed [DATA_WIDTH-1:0] tw_x1_im;
    reg  signed [DATA_WIDTH:0]   sum_re;
    reg  signed [DATA_WIDTH:0]   sum_im;
    reg  signed [DATA_WIDTH:0]   diff_re;
    reg  signed [DATA_WIDTH:0]   diff_im;

    function [DATA_WIDTH-1:0] sat_value;
        input signed [DATA_WIDTH:0] value;
        begin
            if (value > MAX_VAL) begin
                sat_value = MAX_VAL;
            end else if (value < MIN_VAL) begin
                sat_value = MIN_VAL;
            end else begin
                sat_value = value[DATA_WIDTH-1:0];
            end
        end
    endfunction

    complex_mult_q15 #(
        .A_WIDTH(DATA_WIDTH),
        .TW_WIDTH(16),
        .FRAC_BITS(15)
    ) u_complex_mult_q15 (
        .a_re(x1_re),
        .a_im(x1_im),
        .b_re(tw_re),
        .b_im(tw_im),
        .p_re(tw_x1_re),
        .p_im(tw_x1_im)
    );

    always @(*) begin
        sum_re  = x0_re + tw_x1_re;
        sum_im  = x0_im + tw_x1_im;
        diff_re = x0_re - tw_x1_re;
        diff_im = x0_im - tw_x1_im;

        y0_re = sat_value(sum_re);
        y0_im = sat_value(sum_im);
        y1_re = sat_value(diff_re);
        y1_im = sat_value(diff_im);
    end
endmodule
