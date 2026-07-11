`timescale 1ns/1ps
`define DELAY #1

module sram_twiddle_wrapper #(
    parameter DW = 32,
    parameter AW = 9
) (
    input               clk,
    input               cen,
    input               gwen,
    input  [AW-1:0]     addr,
    input  [DW-1:0]     din,
    output [DW-1:0]     dout
);

    integer row;
    integer col;
    reg [31:0] init_mem [0:511];

    wire             cen_delayed;
    wire             gwen_delayed;
    wire [AW-1:0]    addr_delayed;
    wire [DW-1:0]    din_delayed;

    assign `DELAY cen_delayed  = cen;
    assign `DELAY gwen_delayed = gwen;
    assign `DELAY addr_delayed = addr;
    assign `DELAY din_delayed  = din;

    sram_twiddle sram_twiddle_inst (
        .Q    (dout),
        .CLK  (clk),
        .CEN  (cen_delayed),
        .WEN  (4'b0000),
        .A    (addr_delayed),
        .D    (din_delayed),
        .EMA  (3'b000),
        .GWEN (gwen_delayed),
        .RETN (1'b1)
    );

    initial begin
        $readmemh("../../input/twiddle_q15.hex", init_mem);
        for (row = 0; row < 32; row = row + 1) begin
            sram_twiddle_inst.mem[row] = {512{1'b0}};
            for (col = 0; col < 16; col = col + 1) begin
                sram_twiddle_inst.mem[row][496 + col] = init_mem[row * 16 + col][31];
                sram_twiddle_inst.mem[row][480 + col] = init_mem[row * 16 + col][30];
                sram_twiddle_inst.mem[row][464 + col] = init_mem[row * 16 + col][29];
                sram_twiddle_inst.mem[row][448 + col] = init_mem[row * 16 + col][28];
                sram_twiddle_inst.mem[row][432 + col] = init_mem[row * 16 + col][27];
                sram_twiddle_inst.mem[row][416 + col] = init_mem[row * 16 + col][26];
                sram_twiddle_inst.mem[row][400 + col] = init_mem[row * 16 + col][25];
                sram_twiddle_inst.mem[row][384 + col] = init_mem[row * 16 + col][24];
                sram_twiddle_inst.mem[row][368 + col] = init_mem[row * 16 + col][23];
                sram_twiddle_inst.mem[row][352 + col] = init_mem[row * 16 + col][22];
                sram_twiddle_inst.mem[row][336 + col] = init_mem[row * 16 + col][21];
                sram_twiddle_inst.mem[row][320 + col] = init_mem[row * 16 + col][20];
                sram_twiddle_inst.mem[row][304 + col] = init_mem[row * 16 + col][19];
                sram_twiddle_inst.mem[row][288 + col] = init_mem[row * 16 + col][18];
                sram_twiddle_inst.mem[row][272 + col] = init_mem[row * 16 + col][17];
                sram_twiddle_inst.mem[row][256 + col] = init_mem[row * 16 + col][16];
                sram_twiddle_inst.mem[row][240 + col] = init_mem[row * 16 + col][15];
                sram_twiddle_inst.mem[row][224 + col] = init_mem[row * 16 + col][14];
                sram_twiddle_inst.mem[row][208 + col] = init_mem[row * 16 + col][13];
                sram_twiddle_inst.mem[row][192 + col] = init_mem[row * 16 + col][12];
                sram_twiddle_inst.mem[row][176 + col] = init_mem[row * 16 + col][11];
                sram_twiddle_inst.mem[row][160 + col] = init_mem[row * 16 + col][10];
                sram_twiddle_inst.mem[row][144 + col] = init_mem[row * 16 + col][9];
                sram_twiddle_inst.mem[row][128 + col] = init_mem[row * 16 + col][8];
                sram_twiddle_inst.mem[row][112 + col] = init_mem[row * 16 + col][7];
                sram_twiddle_inst.mem[row][96 + col] = init_mem[row * 16 + col][6];
                sram_twiddle_inst.mem[row][80 + col] = init_mem[row * 16 + col][5];
                sram_twiddle_inst.mem[row][64 + col] = init_mem[row * 16 + col][4];
                sram_twiddle_inst.mem[row][48 + col] = init_mem[row * 16 + col][3];
                sram_twiddle_inst.mem[row][32 + col] = init_mem[row * 16 + col][2];
                sram_twiddle_inst.mem[row][16 + col] = init_mem[row * 16 + col][1];
                sram_twiddle_inst.mem[row][0 + col] = init_mem[row * 16 + col][0];
            end
        end
    end

endmodule
