module bit_reverse_loader #(
    parameter OUT_WIDTH = 32
) (
    input clk,
    input rst_n,
    input start,
    output busy,
    output done,
    output [9:0] src_addr,
    input  signed [15:0] src_data,
    output reg dst_we,
    output reg [9:0] dst_addr,
    output reg signed [OUT_WIDTH-1:0] dst_re,
    output reg signed [OUT_WIDTH-1:0] dst_im
);
    reg        active;
    reg        done_r;
    reg [9:0]  idx;
    wire [9:0] bitrev_addr;

    bit_reverse10 u_bit_reverse10 (
        .din (idx),
        .dout(bitrev_addr)
    );

    assign busy = active;
    assign done = done_r;
    assign src_addr = idx;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            active <= 1'b0;
            done_r <= 1'b0;
            idx    <= 10'd0;
        end else begin
            done_r <= 1'b0;

            if (start && !active) begin
                active <= 1'b1;
                idx    <= 10'd0;
            end else if (active) begin
                if (idx == 10'd1023) begin
                    active <= 1'b0;
                    done_r <= 1'b1;
                end
                idx <= idx + 10'd1;
            end
        end
    end

    always @(*) begin
        dst_we   = active;
        dst_addr = bitrev_addr;
        dst_re   = {{(OUT_WIDTH-16){src_data[15]}}, src_data};
        dst_im   = {OUT_WIDTH{1'b0}};
    end
endmodule
