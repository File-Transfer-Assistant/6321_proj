module complex_mult_q15 (
    input  wire signed [15:0] ar,
    input  wire signed [15:0] ai,
    input  wire signed [15:0] br,
    input  wire signed [15:0] bi,
    output reg  signed [15:0] pr,
    output reg  signed [15:0] pi
);
    localparam signed [63:0] ROUND_HALF = 64'sd16384;

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

    function signed [31:0] q15_round_shift15;
        input signed [63:0] x;
        reg signed [63:0] abs_x;
        reg signed [63:0] q;
        reg signed [63:0] r;
        reg signed [63:0] y;
        begin
            if (x < 0) begin
                abs_x = -x;
            end else begin
                abs_x = x;
            end

            q = abs_x >>> 15;
            r = abs_x & 64'sd32767;

            y = q;
            if ((r > ROUND_HALF) || ((r == ROUND_HALF) && q[0])) begin
                y = q + 64'sd1;
            end

            if (x < 0) begin
                q15_round_shift15 = -y[31:0];
            end else begin
                q15_round_shift15 = y[31:0];
            end
        end
    endfunction

    reg signed [31:0] ar_br;
    reg signed [31:0] ai_bi;
    reg signed [31:0] ar_bi;
    reg signed [31:0] ai_br;
    reg signed [63:0] rr_full;
    reg signed [63:0] ii_full;
    reg signed [31:0] rr;
    reg signed [31:0] ii;

    always @(*) begin
        ar_br = ar * br;
        ai_bi = ai * bi;
        ar_bi = ar * bi;
        ai_br = ai * br;

        rr_full = ar_br - ai_bi;
        ii_full = ar_bi + ai_br;

        rr = q15_round_shift15(rr_full);
        ii = q15_round_shift15(ii_full);

        pr = sat16(rr);
        pi = sat16(ii);
    end
endmodule
