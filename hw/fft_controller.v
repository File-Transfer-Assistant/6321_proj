module fft_controller (
    input clk,
    input rst_n,
    input start,
    input br_done,
    output br_start,
    output busy,
    output done,
    output stage_active,
    output store_active,
    output reg [3:0] stage_idx,
    output reg [8:0] butterfly_idx,
    output reg stage_src_sel,
    output reg [9:0] store_idx,
    output reg result_bank_sel
);
    localparam [2:0] S_IDLE  = 3'd0;
    localparam [2:0] S_LOAD  = 3'd1;
    localparam [2:0] S_PROC  = 3'd2;
    localparam [2:0] S_STORE = 3'd3;
    localparam [2:0] S_DONE  = 3'd4;

    reg [2:0] state;

    assign br_start = (state == S_IDLE) && start;
    assign stage_active = (state == S_PROC);
    assign store_active = (state == S_STORE);
    assign busy = (state != S_IDLE) && (state != S_DONE);
    assign done = (state == S_DONE);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= S_IDLE;
            stage_idx <= 4'd0;
            butterfly_idx <= 9'd0;
            stage_src_sel <= 1'b1;
            store_idx <= 10'd0;
            result_bank_sel <= 1'b1;
        end else begin
            case (state)
                S_IDLE: begin
                    if (start) begin
                        state <= S_LOAD;
                    end
                end

                S_LOAD: begin
                    if (br_done) begin
                        state         <= S_PROC;
                        stage_idx     <= 4'd0;
                        butterfly_idx <= 9'd0;
                        stage_src_sel <= 1'b1;
                    end
                end

                S_PROC: begin
                    if (butterfly_idx == 9'd511) begin
                        if (stage_idx == 4'd9) begin
                            state           <= S_STORE;
                            store_idx       <= 10'd0;
                            result_bank_sel <= ~stage_src_sel;
                        end else begin
                            stage_idx     <= stage_idx + 4'd1;
                            butterfly_idx <= 9'd0;
                            stage_src_sel <= ~stage_src_sel;
                        end
                    end else begin
                        butterfly_idx <= butterfly_idx + 9'd1;
                    end
                end

                S_STORE: begin
                    if (store_idx == 10'd1023) begin
                        state <= S_DONE;
                    end else begin
                        store_idx <= store_idx + 10'd1;
                    end
                end

                S_DONE: begin
                    if (!start) begin
                        state <= S_IDLE;
                    end
                end

                default: begin
                    state <= S_IDLE;
                end
            endcase
        end
    end
endmodule
