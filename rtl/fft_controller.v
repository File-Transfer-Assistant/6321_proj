`timescale 1ns / 1ps

module fft_controller (
    input  wire clk,
    input  wire rst_n,
    input  wire start,
    input  wire tb_skip_load,

    output wire       sram_we_a,
    output wire       sram_we_b,
    output wire [9:0] sram_addr_a,
    output wire [9:0] sram_addr_b,
    output wire [8:0] twiddle_addr,

    output reg        is_loading,
    output reg        is_unloading,
    output reg        done,
    output reg  [3:0] dbg_stage,
    output reg        dbg_stage_done
);

    localparam [1:0] IDLE    = 2'b00;
    localparam [1:0] LOAD    = 2'b01;
    localparam [1:0] COMPUTE = 2'b10;
    localparam [1:0] UNLOAD  = 2'b11;

    reg [1:0] state, next_state;
    reg [9:0] load_cnt;
    reg [9:0] unload_cnt;
    reg [3:0] stage_cnt;
    reg [8:0] bf_cnt;
    reg       compute_phase;

    wire [9:0] distance   = 10'd512 >> stage_cnt;
    wire [9:0] group_size = distance << 1;
    wire [8:0] k_offset   = bf_cnt % distance;
    wire [9:0] group_idx  = bf_cnt / distance;

    wire [9:0] read_addr_a = group_idx * group_size + k_offset;
    wire [9:0] read_addr_b = read_addr_a + distance;
    wire [8:0] twiddle_addr_int = k_offset << stage_cnt;

    wire stage_last = (bf_cnt == 9'd511);
    wire final_compute_done = (state == COMPUTE) && (compute_phase == 1'b1) && stage_last && (stage_cnt == 4'd9);
    wire stage_done_pulse = (state == COMPUTE) && (compute_phase == 1'b1) && stage_last;

    assign sram_we_a = (state == LOAD) || ((state == COMPUTE) && compute_phase);
    assign sram_we_b = (state == COMPUTE) && compute_phase;
    assign sram_addr_a = (state == LOAD)    ? load_cnt :
                         (state == COMPUTE) ? read_addr_a :
                         (state == UNLOAD)  ? {unload_cnt[0], unload_cnt[1], unload_cnt[2], unload_cnt[3],
                                                unload_cnt[4], unload_cnt[5], unload_cnt[6], unload_cnt[7],
                                                unload_cnt[8], unload_cnt[9]} : 10'd0;
    assign sram_addr_b = (state == COMPUTE) ? read_addr_b : 10'd0;
    assign twiddle_addr = (state == COMPUTE) ? twiddle_addr_int : 9'd0;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) state <= IDLE;
        else        state <= next_state;
    end

    always @(*) begin
        next_state = state;
        case (state)
            IDLE:    if (start) next_state = tb_skip_load ? COMPUTE : LOAD;
            LOAD:    if (load_cnt == 10'd1023) next_state = COMPUTE;
            COMPUTE: if (final_compute_done) next_state = UNLOAD;
            UNLOAD:  if (unload_cnt == 10'd1023) next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            load_cnt <= 0;
            unload_cnt <= 0;
            stage_cnt <= 0;
            bf_cnt <= 0;
            compute_phase <= 1'b0;
            is_loading <= 1'b0;
            is_unloading <= 1'b0;
            done <= 1'b0;
            dbg_stage <= 4'd0;
            dbg_stage_done <= 1'b0;
        end else begin
            is_loading <= (state == LOAD);
            is_unloading <= (state == UNLOAD);
            done <= (state == UNLOAD && unload_cnt == 10'd1023);
            dbg_stage <= stage_cnt;
            dbg_stage_done <= stage_done_pulse;

            case (state)
                LOAD: begin
                    load_cnt <= load_cnt + 1'b1;
                end
                COMPUTE: begin
                    compute_phase <= ~compute_phase;
                    if (compute_phase) begin
                        if (stage_last) begin
                            bf_cnt <= 9'd0;
                            if (stage_cnt < 4'd9) stage_cnt <= stage_cnt + 1'b1;
                        end else begin
                            bf_cnt <= bf_cnt + 1'b1;
                        end
                    end
                end
                UNLOAD: begin
                    unload_cnt <= unload_cnt + 1'b1;
                end
                default: begin
                    load_cnt <= 0;
                    unload_cnt <= 0;
                    stage_cnt <= 0;
                    bf_cnt <= 0;
                    compute_phase <= 1'b0;
                end
            endcase
        end
    end
endmodule
