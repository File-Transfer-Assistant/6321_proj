module fft_output_quantizer #(
    parameter IN_WIDTH = 32,
    parameter SHIFT_BITS = 8
) (
    input      signed [IN_WIDTH-1:0]  in_re,
    input      signed [IN_WIDTH-1:0]  in_im,
    output reg signed [15:0]          out_re,
    output reg signed [15:0]          out_im
);
    localparam signed [15:0] MAX_Q97 = 16'sh7fff;
    localparam signed [15:0] MIN_Q97 = 16'sh8000;

    reg signed [IN_WIDTH:0] rounded_re;
    reg signed [IN_WIDTH:0] rounded_im;
    reg signed [IN_WIDTH:0] shifted_re;
    reg signed [IN_WIDTH:0] shifted_im;

    function [15:0] sat_q97;
        input signed [IN_WIDTH:0] value;
        begin
            if (value > MAX_Q97) begin
                sat_q97 = MAX_Q97;
            end else if (value < MIN_Q97) begin
                sat_q97 = MIN_Q97;
            end else begin
                sat_q97 = value[15:0];
            end
        end
    endfunction

    always @(*) begin
        if (in_re >= 0) begin
            rounded_re = in_re + ({{IN_WIDTH{1'b0}}, 1'b1} << (SHIFT_BITS - 1));
        end else begin
            rounded_re = in_re - ({{IN_WIDTH{1'b0}}, 1'b1} << (SHIFT_BITS - 1));
        end

        if (in_im >= 0) begin
            rounded_im = in_im + ({{IN_WIDTH{1'b0}}, 1'b1} << (SHIFT_BITS - 1));
        end else begin
            rounded_im = in_im - ({{IN_WIDTH{1'b0}}, 1'b1} << (SHIFT_BITS - 1));
        end

        shifted_re = rounded_re >>> SHIFT_BITS;
        shifted_im = rounded_im >>> SHIFT_BITS;

        out_re = sat_q97(shifted_re);
        out_im = sat_q97(shifted_im);
    end
endmodule
