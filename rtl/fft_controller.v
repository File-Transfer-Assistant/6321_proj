`timescale 1ns / 1ps

module fft_controller (
    input  wire clk,
    input  wire rst_n,
    input  wire start,
    
    output reg        sram_we_a,
    output reg        sram_we_b,
    output wire [9:0] sram_addr_a,
    output wire [9:0] sram_addr_b,
    output reg  [8:0] twiddle_addr,
    
    output reg        is_loading,
    output reg        is_unloading,
    output reg        done
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

    // --- AGU Logic ---
    wire [9:0] distance   = 10'd512 >> stage_cnt;
    wire [9:0] group_size = distance << 1;
    wire [8:0] k_offset   = bf_cnt % distance;
    wire [9:0] group_idx  = bf_cnt / distance;
    
    wire [9:0] read_addr_a = group_idx * group_size + k_offset;
    wire [9:0] read_addr_b = read_addr_a + distance;

    // --- 4-Stage Pipeline Delay matching Butterfly Unit ---
    reg [9:0] addr_a_d1, addr_a_d2, addr_a_d3, addr_a_d4;
    reg [9:0] addr_b_d1, addr_b_d2, addr_b_d3, addr_b_d4;
    reg       we_d1, we_d2, we_d3, we_d4;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            addr_a_d1 <= 0; addr_a_d2 <= 0; addr_a_d3 <= 0; addr_a_d4 <= 0;
            addr_b_d1 <= 0; addr_b_d2 <= 0; addr_b_d3 <= 0; addr_b_d4 <= 0;
            we_d1 <= 0; we_d2 <= 0; we_d3 <= 0; we_d4 <= 0;
        end else begin
            addr_a_d1 <= read_addr_a; addr_a_d2 <= addr_a_d1; addr_a_d3 <= addr_a_d2; addr_a_d4 <= addr_a_d3;
            addr_b_d1 <= read_addr_b; addr_b_d2 <= addr_b_d1; addr_b_d3 <= addr_b_d2; addr_b_d4 <= addr_b_d3;
            we_d1 <= (state == COMPUTE); we_d2 <= we_d1; we_d3 <= we_d2; we_d4 <= we_d3;
        end
    end

    // --- Bit-Reversed Address for Unloading ---
    wire [9:0] bit_reversed_addr = {unload_cnt[0], unload_cnt[1], unload_cnt[2], unload_cnt[3], 
                                    unload_cnt[4], unload_cnt[5], unload_cnt[6], unload_cnt[7], 
                                    unload_cnt[8], unload_cnt[9]};

    // --- MUX for SRAM Addresses ---
    assign sram_addr_a = (state == LOAD)    ? load_cnt :
                         (state == COMPUTE) ? (we_d4 ? addr_a_d4 : read_addr_a) :
                         (state == UNLOAD)  ? bit_reversed_addr : 10'd0;
                         
    assign sram_addr_b = (state == COMPUTE) ? (we_d4 ? addr_b_d4 : read_addr_b) : 10'd0;

    // --- FSM ---
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) state <= IDLE;
        else        state <= next_state;
    end

    always @(*) begin
        next_state = state;
        case (state)
            IDLE:    if (start) next_state = LOAD;
            LOAD:    if (load_cnt == 10'd1023) next_state = COMPUTE;
            COMPUTE: if (stage_cnt == 4'd9 && bf_cnt == 9'd511 && we_d4) next_state = UNLOAD;
            UNLOAD:  if (unload_cnt == 10'd1023) next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

    // --- Counters ---
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            load_cnt <= 0; unload_cnt <= 0; stage_cnt <= 0; bf_cnt <= 0;
            sram_we_a <= 0; sram_we_b <= 0;
            is_loading <= 0; is_unloading <= 0; done <= 0; twiddle_addr <= 0;
        end else begin
            is_loading   <= (state == LOAD);
            is_unloading <= (state == UNLOAD);
            done         <= (state == UNLOAD && unload_cnt == 10'd1023);
            
            case (state)
                LOAD: begin
                    load_cnt <= load_cnt + 1;
                    sram_we_a <= 1'b1; sram_we_b <= 1'b0;
                end
                COMPUTE: begin
                    twiddle_addr <= k_offset << stage_cnt;
                    sram_we_a <= we_d4; 
                    sram_we_b <= we_d4;
                    if (bf_cnt == 511) begin
                        bf_cnt <= 0;
                        if (stage_cnt < 9) stage_cnt <= stage_cnt + 1;
                    end else begin
                        bf_cnt <= bf_cnt + 1;
                    end
                end
                UNLOAD: begin
                    unload_cnt <= unload_cnt + 1;
                    sram_we_a <= 1'b0; sram_we_b <= 1'b0;
                end
                default: begin
                    load_cnt <= 0; unload_cnt <= 0; stage_cnt <= 0; bf_cnt <= 0;
                    sram_we_a <= 0; sram_we_b <= 0;
                end
            endcase
        end
    end
endmodule
