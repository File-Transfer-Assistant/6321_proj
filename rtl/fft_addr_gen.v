module fft_addr_gen (
    input  wire [3:0] stage,
    input  wire [8:0] bfly,
    output reg  [9:0] addr_a,
    output reg  [9:0] addr_b,
    output reg  [8:0] tw_idx
);
    reg [9:0] m;
    reg [9:0] half;
    reg [9:0] group;
    reg [9:0] k;
    reg [3:0] sh;

    always @(*) begin
        m = 10'd1 << (stage + 1'b1);
        half = 10'd1 << stage;
        group = bfly >> stage;
        k = bfly & (half - 10'd1);

        addr_a = (group * m) + k;
        addr_b = addr_a + half;

        sh = 4'd9 - stage;
        tw_idx = k[8:0] << sh;
    end
endmodule

