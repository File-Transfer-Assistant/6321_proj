module bit_reverse10 (
    input  wire [9:0] in_idx,
    output wire [9:0] out_idx
);
    assign out_idx = {
        in_idx[0],
        in_idx[1],
        in_idx[2],
        in_idx[3],
        in_idx[4],
        in_idx[5],
        in_idx[6],
        in_idx[7],
        in_idx[8],
        in_idx[9]
    };
endmodule
