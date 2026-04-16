module bit_reverse10 (
    input      [9:0] din,
    output     [9:0] dout
);
    assign dout = {
        din[0], din[1], din[2], din[3], din[4],
        din[5], din[6], din[7], din[8], din[9]
    };
endmodule
