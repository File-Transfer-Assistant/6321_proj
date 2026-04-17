`timescale 1ns / 1ps

module sram_1024x32 (
    input  wire        clk,
    input  wire        we_a,
    input  wire [9:0]  addr_a,
    input  wire [31:0] din_a,
    output wire [31:0] dout_a,
    input  wire        we_b,
    input  wire [9:0]  addr_b,
    input  wire [31:0] din_b,
    output wire [31:0] dout_b
);
    localparam [2:0] EMA_CFG = 3'b000;
    reg        we_a_q, we_b_q;
    reg [9:0]  addr_a_q, addr_b_q;
    reg [31:0] din_a_q, din_b_q;

    // The compiler timing model checks hold/setup around the active clock edge.
    // Capture controls on the opposite edge so the macro sees stable inputs.
    always @(negedge clk) begin
        we_a_q   <= we_a;
        addr_a_q <= addr_a;
        din_a_q  <= din_a;
        we_b_q   <= we_b;
        addr_b_q <= addr_b;
        din_b_q  <= din_b;
    end

    sram01 u_sram01 (
        .QA(dout_a),
        .QB(dout_b),
        .CLKA(clk),
        .CENA(1'b0),
        .WENA(we_a_q ? 4'b0000 : 4'b1111),
        .AA(addr_a_q),
        .DA(din_a_q),
        .CLKB(clk),
        .CENB(1'b0),
        .WENB(we_b_q ? 4'b0000 : 4'b1111),
        .AB(addr_b_q),
        .DB(din_b_q),
        .EMAA(EMA_CFG),
        .EMAB(EMA_CFG),
        .GWENA(we_a_q ? 1'b0 : 1'b1),
        .GWENB(we_b_q ? 1'b0 : 1'b1),
        .RETN(1'b1)
    );

endmodule
