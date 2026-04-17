`timescale 1ns / 1ps

module twiddle_rom (
    input  wire        clk,
    input  wire [8:0]  addr,
    input  wire        ext_we,
    input  wire [8:0]  ext_addr,
    input  wire [31:0] ext_din,
    output wire [31:0] dout,
    output wire [31:0] ext_dout
);
    localparam [2:0] EMA_CFG = 3'b000;
    reg         ext_we_q;
    reg [8:0]   ram_addr_q;
    reg [31:0]  ext_din_q;
    wire [31:0] ram_q;

    always @(negedge clk) begin
        ext_we_q   <= ext_we;
        ram_addr_q <= ext_we ? ext_addr : addr;
        ext_din_q  <= ext_din;
    end

    sram00 u_sram00 (
        .Q(ram_q),
        .CLK(clk),
        .CEN(1'b0),
        .WEN(ext_we_q ? 4'b0000 : 4'b1111),
        .A(ram_addr_q),
        .D(ext_din_q),
        .EMA(EMA_CFG),
        .GWEN(ext_we_q ? 1'b0 : 1'b1),
        .RETN(1'b1)
    );

    assign dout = ram_q;
    assign ext_dout = ram_q;

endmodule
