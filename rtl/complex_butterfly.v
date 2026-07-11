module complex_butterfly (
    input  wire signed [15:0] ar,
    input  wire signed [15:0] ai,
    input  wire signed [15:0] br,
    input  wire signed [15:0] bi,
    input  wire signed [15:0] wr,
    input  wire signed [15:0] wi,
    output wire signed [15:0] xr,
    output wire signed [15:0] xi,
    output wire signed [15:0] yr,
    output wire signed [15:0] yi
);
    wire signed [15:0] tr;
    wire signed [15:0] ti;
    wire signed [31:0] add_r;
    wire signed [31:0] add_i;
    wire signed [31:0] sub_r;
    wire signed [31:0] sub_i;

    complex_mult_q15 u_cmul (
        .ar(br),
        .ai(bi),
        .br(wr),
        .bi(wi),
        .pr(tr),
        .pi(ti)
    );

    assign add_r = ar + tr;
    assign add_i = ai + ti;
    assign sub_r = ar - tr;
    assign sub_i = ai - ti;

    fft_output_quantizer #(.SHIFT(1)) u_qr0 (.din(add_r), .dout(xr));
    fft_output_quantizer #(.SHIFT(1)) u_qi0 (.din(add_i), .dout(xi));
    fft_output_quantizer #(.SHIFT(1)) u_qr1 (.din(sub_r), .dout(yr));
    fft_output_quantizer #(.SHIFT(1)) u_qi1 (.din(sub_i), .dout(yi));
endmodule

