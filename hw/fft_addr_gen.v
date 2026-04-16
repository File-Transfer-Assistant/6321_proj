module fft_addr_gen (
    input      [3:0] stage_idx,
    input      [8:0] butterfly_idx,
    output reg [9:0] a_addr,
    output reg [9:0] b_addr,
    output reg [8:0] tw_addr
);
    reg [9:0] half_span;
    reg [10:0] full_span;
    reg [8:0] j_idx;
    reg [8:0] group_idx;
    reg [9:0] tw_step;
    reg [10:0] base_addr;
    reg [18:0] tw_index_full;

    always @(*) begin
        half_span = (10'd1 << stage_idx);
        full_span = (11'd1 << (stage_idx + 4'd1));
        tw_step   = (10'd512 >> stage_idx);

        j_idx     = butterfly_idx & (half_span - 10'd1);
        group_idx = butterfly_idx >> stage_idx;
        base_addr = (group_idx * full_span) + j_idx;
        tw_index_full = j_idx * tw_step;

        a_addr = base_addr[9:0];
        b_addr = base_addr[9:0] + half_span;
        tw_addr = tw_index_full[8:0];
    end
endmodule
