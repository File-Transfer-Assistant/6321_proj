module fft_output_quantizer #(
    parameter SHIFT = 1
) (
    input  wire signed [31:0] din,
    output reg  signed [15:0] dout
);
    localparam signed [31:0] ROUND_HALF = (SHIFT > 0) ? (32'sd1 << (SHIFT - 1)) : 32'sd0;
    localparam signed [31:0] ROUND_MASK = (SHIFT > 0) ? ((32'sd1 << SHIFT) - 32'sd1) : 32'sd0;

    function signed [15:0] sat16;
        input signed [31:0] x;
        begin
            if (x > 32'sd32767) begin
                sat16 = 16'sd32767;
            end else if (x < -32'sd32768) begin
                sat16 = -16'sd32768;
            end else begin
                sat16 = x[15:0];
            end
        end
    endfunction

    function signed [31:0] round_shift_even;
        input signed [31:0] x;
        reg signed [31:0] abs_x;
        reg signed [31:0] q;
        reg signed [31:0] r;
        reg signed [31:0] y;
        begin
            if (SHIFT == 0) begin
                round_shift_even = x;
            end else begin
                if (x < 0) begin
                    abs_x = -x;
                end else begin
                    abs_x = x;
                end

                q = abs_x >>> SHIFT;
                r = abs_x & ROUND_MASK;
                y = q;

                if ((r > ROUND_HALF) || ((r == ROUND_HALF) && q[0])) begin
                    y = q + 32'sd1;
                end

                if (x < 0) begin
                    round_shift_even = -y;
                end else begin
                    round_shift_even = y;
                end
            end
        end
    endfunction

    reg signed [31:0] t;

    always @(*) begin
        t = round_shift_even(din);
        dout = sat16(t);
    end
endmodule
