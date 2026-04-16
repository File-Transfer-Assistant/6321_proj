`timescale 1ns / 1ps

module sram_1024x32 (
    input  wire        clk,
    // Port A
    input  wire        we_a,
    input  wire [9:0]  addr_a,
    input  wire [31:0] din_a,
    output reg  [31:0] dout_a,
    // Port B
    input  wire        we_b,
    input  wire [9:0]  addr_b,
    input  wire [31:0] din_b,
    output reg  [31:0] dout_b
);
    reg [31:0] mem [0:1023];

    // Port A
    always @(posedge clk) begin
        if (we_a) mem[addr_a] <= din_a;
        dout_a <= mem[addr_a];
    end

    // Port B
    always @(posedge clk) begin
        if (we_b) mem[addr_b] <= din_b;
        dout_b <= mem[addr_b];
    end
endmodule
