// FE Release Version: 2.4.24 
//
//       CONFIDENTIAL AND PROPRIETARY SOFTWARE OF ARM PHYSICAL IP, INC.
//      
//       Copyright (c) 1993 - 2026 ARM Physical IP, Inc.  All Rights Reserved.
//      
//       Use of this Software is subject to the terms and conditions of the
//       applicable license agreement with ARM Physical IP, Inc.
//       In addition, this Software is protected by patents, copyright law 
//       and international treaties.
//      
//       The copyright notice(s) in this Software does not indicate actual or
//       intended publication of this Software.
//
//      Verilog model for Synchronous Dual-Port Ram
//
//      Instance Name:              sram01
//      Words:                      1024
//      Bits:                       32
//      Mux:                        16
//      Drive:                      6
//      Write Mask:                 On
//      Extra Margin Adjustment:    On
//      Accelerated Retention Test: Off
//      Redundant Rows:             0
//      Redundant Columns:          0
//      Test Muxes                  Off
//
//      Creation Date:  Thu Apr 16 20:28:08 2026
//      Version: 	r0p1-00eac0
//
//      Modeling Assumptions: This model supports full gate level simulation
//          including proper x-handling and timing check behavior.  Unit
//          delay timing is included in the model. Back-annotation of SDF
//          (v2.1) is supported.  SDF can be created utilyzing the delay
//          calculation views provided with this generator and supported
//          delay calculators.  All buses are modeled [MSB:LSB].  All 
//          ports are padded with Verilog primitives.
//
//      Modeling Limitations: None.
//
//      Known Bugs: None.
//
//      Known Work Arounds: N/A
//
`ifdef ARM_UD_MODEL

`timescale 1 ns/1 ps

`ifdef ARM_UD_DP
`else
`define ARM_UD_DP #0.001
`endif
`ifdef ARM_UD_CP
`else
`define ARM_UD_CP
`endif
`ifdef ARM_UD_SEQ
`else
`define ARM_UD_SEQ #0.01
`endif
`ifdef ARM_UD_CC
`else
`define ARM_UD_CC 0.1
`endif

`celldefine
`ifdef POWER_PINS
module sram01 (QA, QB, CLKA, CENA, WENA, AA, DA, CLKB, CENB, WENB, AB, DB, EMAA, EMAB,
    GWENA, GWENB, RETN, VSS, VDD);
`else
module sram01 (QA, QB, CLKA, CENA, WENA, AA, DA, CLKB, CENB, WENB, AB, DB, EMAA, EMAB,
    GWENA, GWENB, RETN);
`endif

  parameter BITS = 32;
  parameter WORDS = 1024;
  parameter MUX = 16;
  parameter MEM_WIDTH = 512; // redun block size 4, 256 on left, 256 on right
  parameter MEM_HEIGHT = 64;
  parameter WP_SIZE = 8 ;
  parameter UPM_WIDTH = 3;

  output [31:0] QA;
  output [31:0] QB;
  input  CLKA;
  input  CENA;
  input [3:0] WENA;
  input [9:0] AA;
  input [31:0] DA;
  input  CLKB;
  input  CENB;
  input [3:0] WENB;
  input [9:0] AB;
  input [31:0] DB;
  input [2:0] EMAA;
  input [2:0] EMAB;
  input  GWENA;
  input  GWENB;
  input  RETN;
`ifdef POWER_PINS
  inout VSS;
  inout VDD;
`endif

  integer row_address;
  integer mux_address;
  reg [511:0] mem [0:63];
  reg [511:0] row;
  reg LAST_CLKA;
  reg [511:0] data_out;
  reg [511:0] row_mask;
  reg [511:0] new_data;
  reg LAST_CLKB;
  reg [31:0] QA_int;
  reg [31:0] QB_int;
  reg [31:0] writeEnable;
  real previous_CLKA;
  real previous_CLKB;
  initial previous_CLKA = 0;
  initial previous_CLKB = 0;
  reg clk0_int;
  reg clk1_int;
  reg CRENA_legal;
  initial CRENA_legal = 1'b1;
  reg CRENB_legal;
  initial CRENB_legal = 1'b1;

  wire [31:0] QA_;
  wire [31:0] QB_;
 wire  CLKA_;
  wire  CENA_;
  reg  CENA_int;
  wire [3:0] WENA_;
  reg [3:0] WENA_int;
  wire [9:0] AA_;
  reg [9:0] AA_int;
  wire [31:0] DA_;
  reg [31:0] DA_int;
 wire  CLKB_;
  wire  CENB_;
  reg  CENB_int;
  wire [3:0] WENB_;
  reg [3:0] WENB_int;
  wire [9:0] AB_;
  reg [9:0] AB_int;
  wire [31:0] DB_;
  reg [31:0] DB_int;
  wire [2:0] EMAA_;
  reg [2:0] EMAA_int;
  wire [2:0] EMAB_;
  reg [2:0] EMAB_int;
  wire  GWENA_;
  reg  GWENA_int;
  wire  GWENB_;
  reg  GWENB_int;
  wire  RETN_;
  reg  RETN_int;

  assign QA[0] = QA_[0]; 
  assign QA[1] = QA_[1]; 
  assign QA[2] = QA_[2]; 
  assign QA[3] = QA_[3]; 
  assign QA[4] = QA_[4]; 
  assign QA[5] = QA_[5]; 
  assign QA[6] = QA_[6]; 
  assign QA[7] = QA_[7]; 
  assign QA[8] = QA_[8]; 
  assign QA[9] = QA_[9]; 
  assign QA[10] = QA_[10]; 
  assign QA[11] = QA_[11]; 
  assign QA[12] = QA_[12]; 
  assign QA[13] = QA_[13]; 
  assign QA[14] = QA_[14]; 
  assign QA[15] = QA_[15]; 
  assign QA[16] = QA_[16]; 
  assign QA[17] = QA_[17]; 
  assign QA[18] = QA_[18]; 
  assign QA[19] = QA_[19]; 
  assign QA[20] = QA_[20]; 
  assign QA[21] = QA_[21]; 
  assign QA[22] = QA_[22]; 
  assign QA[23] = QA_[23]; 
  assign QA[24] = QA_[24]; 
  assign QA[25] = QA_[25]; 
  assign QA[26] = QA_[26]; 
  assign QA[27] = QA_[27]; 
  assign QA[28] = QA_[28]; 
  assign QA[29] = QA_[29]; 
  assign QA[30] = QA_[30]; 
  assign QA[31] = QA_[31]; 
  assign QB[0] = QB_[0]; 
  assign QB[1] = QB_[1]; 
  assign QB[2] = QB_[2]; 
  assign QB[3] = QB_[3]; 
  assign QB[4] = QB_[4]; 
  assign QB[5] = QB_[5]; 
  assign QB[6] = QB_[6]; 
  assign QB[7] = QB_[7]; 
  assign QB[8] = QB_[8]; 
  assign QB[9] = QB_[9]; 
  assign QB[10] = QB_[10]; 
  assign QB[11] = QB_[11]; 
  assign QB[12] = QB_[12]; 
  assign QB[13] = QB_[13]; 
  assign QB[14] = QB_[14]; 
  assign QB[15] = QB_[15]; 
  assign QB[16] = QB_[16]; 
  assign QB[17] = QB_[17]; 
  assign QB[18] = QB_[18]; 
  assign QB[19] = QB_[19]; 
  assign QB[20] = QB_[20]; 
  assign QB[21] = QB_[21]; 
  assign QB[22] = QB_[22]; 
  assign QB[23] = QB_[23]; 
  assign QB[24] = QB_[24]; 
  assign QB[25] = QB_[25]; 
  assign QB[26] = QB_[26]; 
  assign QB[27] = QB_[27]; 
  assign QB[28] = QB_[28]; 
  assign QB[29] = QB_[29]; 
  assign QB[30] = QB_[30]; 
  assign QB[31] = QB_[31]; 
  assign CLKA_ = CLKA;
  assign CENA_ = CENA;
  assign WENA_[0] = WENA[0];
  assign WENA_[1] = WENA[1];
  assign WENA_[2] = WENA[2];
  assign WENA_[3] = WENA[3];
  assign AA_[0] = AA[0];
  assign AA_[1] = AA[1];
  assign AA_[2] = AA[2];
  assign AA_[3] = AA[3];
  assign AA_[4] = AA[4];
  assign AA_[5] = AA[5];
  assign AA_[6] = AA[6];
  assign AA_[7] = AA[7];
  assign AA_[8] = AA[8];
  assign AA_[9] = AA[9];
  assign DA_[0] = DA[0];
  assign DA_[1] = DA[1];
  assign DA_[2] = DA[2];
  assign DA_[3] = DA[3];
  assign DA_[4] = DA[4];
  assign DA_[5] = DA[5];
  assign DA_[6] = DA[6];
  assign DA_[7] = DA[7];
  assign DA_[8] = DA[8];
  assign DA_[9] = DA[9];
  assign DA_[10] = DA[10];
  assign DA_[11] = DA[11];
  assign DA_[12] = DA[12];
  assign DA_[13] = DA[13];
  assign DA_[14] = DA[14];
  assign DA_[15] = DA[15];
  assign DA_[16] = DA[16];
  assign DA_[17] = DA[17];
  assign DA_[18] = DA[18];
  assign DA_[19] = DA[19];
  assign DA_[20] = DA[20];
  assign DA_[21] = DA[21];
  assign DA_[22] = DA[22];
  assign DA_[23] = DA[23];
  assign DA_[24] = DA[24];
  assign DA_[25] = DA[25];
  assign DA_[26] = DA[26];
  assign DA_[27] = DA[27];
  assign DA_[28] = DA[28];
  assign DA_[29] = DA[29];
  assign DA_[30] = DA[30];
  assign DA_[31] = DA[31];
  assign CLKB_ = CLKB;
  assign CENB_ = CENB;
  assign WENB_[0] = WENB[0];
  assign WENB_[1] = WENB[1];
  assign WENB_[2] = WENB[2];
  assign WENB_[3] = WENB[3];
  assign AB_[0] = AB[0];
  assign AB_[1] = AB[1];
  assign AB_[2] = AB[2];
  assign AB_[3] = AB[3];
  assign AB_[4] = AB[4];
  assign AB_[5] = AB[5];
  assign AB_[6] = AB[6];
  assign AB_[7] = AB[7];
  assign AB_[8] = AB[8];
  assign AB_[9] = AB[9];
  assign DB_[0] = DB[0];
  assign DB_[1] = DB[1];
  assign DB_[2] = DB[2];
  assign DB_[3] = DB[3];
  assign DB_[4] = DB[4];
  assign DB_[5] = DB[5];
  assign DB_[6] = DB[6];
  assign DB_[7] = DB[7];
  assign DB_[8] = DB[8];
  assign DB_[9] = DB[9];
  assign DB_[10] = DB[10];
  assign DB_[11] = DB[11];
  assign DB_[12] = DB[12];
  assign DB_[13] = DB[13];
  assign DB_[14] = DB[14];
  assign DB_[15] = DB[15];
  assign DB_[16] = DB[16];
  assign DB_[17] = DB[17];
  assign DB_[18] = DB[18];
  assign DB_[19] = DB[19];
  assign DB_[20] = DB[20];
  assign DB_[21] = DB[21];
  assign DB_[22] = DB[22];
  assign DB_[23] = DB[23];
  assign DB_[24] = DB[24];
  assign DB_[25] = DB[25];
  assign DB_[26] = DB[26];
  assign DB_[27] = DB[27];
  assign DB_[28] = DB[28];
  assign DB_[29] = DB[29];
  assign DB_[30] = DB[30];
  assign DB_[31] = DB[31];
  assign EMAA_[0] = EMAA[0];
  assign EMAA_[1] = EMAA[1];
  assign EMAA_[2] = EMAA[2];
  assign EMAB_[0] = EMAB[0];
  assign EMAB_[1] = EMAB[1];
  assign EMAB_[2] = EMAB[2];
  assign GWENA_ = GWENA;
  assign GWENB_ = GWENB;
  assign RETN_ = RETN;

  assign `ARM_UD_SEQ QA_ = RETN_ ? (QA_int) : {32{1'b0}};
  assign `ARM_UD_SEQ QB_ = RETN_ ? (QB_int) : {32{1'b0}};

`ifdef INITIALIZE_MEMORY
  integer i;
  initial
    for (i = 0; i < MEM_HEIGHT; i = i + 1)
      mem[i] = {MEM_WIDTH{1'b0}};
`endif

  task failedWrite;
  input port;
  integer i;
  begin
    for (i = 0; i < MEM_HEIGHT; i = i + 1)
      mem[i] = {MEM_WIDTH{1'bx}};
  end
  endtask

  function isBitX;
    input bitIn;
    begin
      isBitX = ( bitIn===1'bx || bitIn===1'bz ) ? 1'b1 : 1'b0;
    end
  endfunction


  task readWriteA;
  begin
    if (RETN_int === 1'bx) begin
      failedWrite(0);
      QA_int = {32{1'bx}};
    end else if (RETN_int === 1'b0 && CENA_int === 1'b0) begin
      failedWrite(0);
      QA_int = {32{1'bx}};
    end else if (RETN_int === 1'b0) begin
      // no cycle in retention mode
    end else if (^{CENA_int, EMAA_int} === 1'bx) begin
      failedWrite(0);
      QA_int = {32{1'bx}};
    end else if ((AA_int >= WORDS) && (CENA_int === 1'b0)) begin
      writeEnable = ~( {32{GWENA_int}} | {WENA_int[3], WENA_int[3], WENA_int[3], WENA_int[3],
         WENA_int[3], WENA_int[3], WENA_int[3], WENA_int[3], WENA_int[2], WENA_int[2],
         WENA_int[2], WENA_int[2], WENA_int[2], WENA_int[2], WENA_int[2], WENA_int[2],
         WENA_int[1], WENA_int[1], WENA_int[1], WENA_int[1], WENA_int[1], WENA_int[1],
         WENA_int[1], WENA_int[1], WENA_int[0], WENA_int[0], WENA_int[0], WENA_int[0],
         WENA_int[0], WENA_int[0], WENA_int[0], WENA_int[0]});
      QA_int = ((writeEnable & DA_int) | (~writeEnable & {32{1'bx}}));
    end else if (CENA_int === 1'b0 && (^AA_int) === 1'bx) begin
      if (GWENA_int !== 1'b1 && (& WENA_int) !== 1'b1) failedWrite(0);
      QA_int = {32{1'bx}};
    end else if (CENA_int === 1'b0) begin
      mux_address = (AA_int & 4'b1111);
      row_address = (AA_int >> 4);
      if (row_address >= 64)
        row = {512{1'bx}};
      else
        row = mem[row_address];
      if( isBitX(GWENA_int) )
        writeEnable = {32{1'bx}};
      else
        writeEnable = ~( {32{GWENA_int}} | {WENA_int[3], WENA_int[3], WENA_int[3],
         WENA_int[3], WENA_int[3], WENA_int[3], WENA_int[3], WENA_int[3], WENA_int[2],
         WENA_int[2], WENA_int[2], WENA_int[2], WENA_int[2], WENA_int[2], WENA_int[2],
         WENA_int[2], WENA_int[1], WENA_int[1], WENA_int[1], WENA_int[1], WENA_int[1],
         WENA_int[1], WENA_int[1], WENA_int[1], WENA_int[0], WENA_int[0], WENA_int[0],
         WENA_int[0], WENA_int[0], WENA_int[0], WENA_int[0], WENA_int[0]});
      row_mask =  ( {15'b000000000000000, writeEnable[31], 15'b000000000000000, writeEnable[30],
          15'b000000000000000, writeEnable[29], 15'b000000000000000, writeEnable[28],
          15'b000000000000000, writeEnable[27], 15'b000000000000000, writeEnable[26],
          15'b000000000000000, writeEnable[25], 15'b000000000000000, writeEnable[24],
          15'b000000000000000, writeEnable[23], 15'b000000000000000, writeEnable[22],
          15'b000000000000000, writeEnable[21], 15'b000000000000000, writeEnable[20],
          15'b000000000000000, writeEnable[19], 15'b000000000000000, writeEnable[18],
          15'b000000000000000, writeEnable[17], 15'b000000000000000, writeEnable[16],
          15'b000000000000000, writeEnable[15], 15'b000000000000000, writeEnable[14],
          15'b000000000000000, writeEnable[13], 15'b000000000000000, writeEnable[12],
          15'b000000000000000, writeEnable[11], 15'b000000000000000, writeEnable[10],
          15'b000000000000000, writeEnable[9], 15'b000000000000000, writeEnable[8],
          15'b000000000000000, writeEnable[7], 15'b000000000000000, writeEnable[6],
          15'b000000000000000, writeEnable[5], 15'b000000000000000, writeEnable[4],
          15'b000000000000000, writeEnable[3], 15'b000000000000000, writeEnable[2],
          15'b000000000000000, writeEnable[1], 15'b000000000000000, writeEnable[0]} << mux_address);
      new_data =  ( {15'b000000000000000, DA_int[31], 15'b000000000000000, DA_int[30],
          15'b000000000000000, DA_int[29], 15'b000000000000000, DA_int[28], 15'b000000000000000, DA_int[27],
          15'b000000000000000, DA_int[26], 15'b000000000000000, DA_int[25], 15'b000000000000000, DA_int[24],
          15'b000000000000000, DA_int[23], 15'b000000000000000, DA_int[22], 15'b000000000000000, DA_int[21],
          15'b000000000000000, DA_int[20], 15'b000000000000000, DA_int[19], 15'b000000000000000, DA_int[18],
          15'b000000000000000, DA_int[17], 15'b000000000000000, DA_int[16], 15'b000000000000000, DA_int[15],
          15'b000000000000000, DA_int[14], 15'b000000000000000, DA_int[13], 15'b000000000000000, DA_int[12],
          15'b000000000000000, DA_int[11], 15'b000000000000000, DA_int[10], 15'b000000000000000, DA_int[9],
          15'b000000000000000, DA_int[8], 15'b000000000000000, DA_int[7], 15'b000000000000000, DA_int[6],
          15'b000000000000000, DA_int[5], 15'b000000000000000, DA_int[4], 15'b000000000000000, DA_int[3],
          15'b000000000000000, DA_int[2], 15'b000000000000000, DA_int[1], 15'b000000000000000, DA_int[0]} << mux_address);
      row = (row & ~row_mask) | (row_mask & (~row_mask | new_data));
      mem[row_address] = row;
      data_out = (row >> mux_address);
      if (GWENA_int !== 1'b0)
        QA_int = {data_out[496], data_out[480], data_out[464], data_out[448], data_out[432],
          data_out[416], data_out[400], data_out[384], data_out[368], data_out[352],
          data_out[336], data_out[320], data_out[304], data_out[288], data_out[272],
          data_out[256], data_out[240], data_out[224], data_out[208], data_out[192],
          data_out[176], data_out[160], data_out[144], data_out[128], data_out[112],
          data_out[96], data_out[80], data_out[64], data_out[48], data_out[32], data_out[16],
          data_out[0]};
      else
        QA_int = {(writeEnable[31]?data_out[496]:QA_int[31]), (writeEnable[30]?data_out[480]:QA_int[30]),
          (writeEnable[29]?data_out[464]:QA_int[29]), (writeEnable[28]?data_out[448]:QA_int[28]),
          (writeEnable[27]?data_out[432]:QA_int[27]), (writeEnable[26]?data_out[416]:QA_int[26]),
          (writeEnable[25]?data_out[400]:QA_int[25]), (writeEnable[24]?data_out[384]:QA_int[24]),
          (writeEnable[23]?data_out[368]:QA_int[23]), (writeEnable[22]?data_out[352]:QA_int[22]),
          (writeEnable[21]?data_out[336]:QA_int[21]), (writeEnable[20]?data_out[320]:QA_int[20]),
          (writeEnable[19]?data_out[304]:QA_int[19]), (writeEnable[18]?data_out[288]:QA_int[18]),
          (writeEnable[17]?data_out[272]:QA_int[17]), (writeEnable[16]?data_out[256]:QA_int[16]),
          (writeEnable[15]?data_out[240]:QA_int[15]), (writeEnable[14]?data_out[224]:QA_int[14]),
          (writeEnable[13]?data_out[208]:QA_int[13]), (writeEnable[12]?data_out[192]:QA_int[12]),
          (writeEnable[11]?data_out[176]:QA_int[11]), (writeEnable[10]?data_out[160]:QA_int[10]),
          (writeEnable[9]?data_out[144]:QA_int[9]), (writeEnable[8]?data_out[128]:QA_int[8]),
          (writeEnable[7]?data_out[112]:QA_int[7]), (writeEnable[6]?data_out[96]:QA_int[6]),
          (writeEnable[5]?data_out[80]:QA_int[5]), (writeEnable[4]?data_out[64]:QA_int[4]),
          (writeEnable[3]?data_out[48]:QA_int[3]), (writeEnable[2]?data_out[32]:QA_int[2]),
          (writeEnable[1]?data_out[16]:QA_int[1]), (writeEnable[0]?data_out[0]:QA_int[0])};
    end
  end
  endtask

  always @ RETN_ begin
    if (RETN_ == 1'b0) begin
      QA_int = {32{1'b0}};
      CENA_int = 1'b0;
      WENA_int = {4{1'b0}};
      AA_int = {10{1'b0}};
      DA_int = {32{1'b0}};
      EMAA_int = {3{1'b0}};
      GWENA_int = 1'b0;
      RETN_int = 1'b0;
    end else begin
      QA_int = {32{1'bx}};
      CENA_int = 1'bx;
      WENA_int = {4{1'bx}};
      AA_int = {10{1'bx}};
      DA_int = {32{1'bx}};
      EMAA_int = {3{1'bx}};
      GWENA_int = 1'bx;
      RETN_int = 1'bx;
    end
    RETN_int = RETN_;
  end

  always @ CLKA_ begin
`ifdef POWER_PINS
    if (VSS === 1'bx || VSS === 1'bz)
      $display("ERROR: Illegal value for VSS %b", VSS);
    if (VDD === 1'bx || VDD === 1'bz)
      $display("ERROR: Illegal value for VDD %b", VDD);
`endif
    if (CLKA_ === 1'bx && (CENA_ !== 1'b1)) begin
      failedWrite(0);
      QA_int = {32{1'bx}};
    end else if (CLKA_ === 1'b1 && LAST_CLKA === 1'b0) begin
      CENA_int = CENA_;
      WENA_int = WENA_;
      AA_int = AA_;
      DA_int = DA_;
      EMAA_int = EMAA_;
      GWENA_int = GWENA_;
      RETN_int = RETN_;
      clk0_int = 1'b0;
      previous_CLKA = $realtime;
      readWriteA;
      if (previous_CLKA == previous_CLKB && is_contention(AA_int, AB_int, ({4{GWENA_int}}|WENA_int),
        ({4{GWENB_int}}|WENB_int)) && (CENA_int !== 1'b1 && CENB_int !== 1'b1)) begin
        if (GWENA_int !== 1'b1 && (& WENA_int) !== 1'b1 && GWENB_int !== 1'b1 && (& WENB_int) !== 1'b1) begin
          DA_int = {32{1'bx}};
          readWriteA;
          DB_int = {32{1'bx}};
          readWriteB;
        end else if (GWENA_int !== 1'b1 && (& WENA_int) !== 1'b1) begin
          QB_int = {32{1'bx}};
        end else if (GWENB_int !== 1'b1 && (& WENB_int) !== 1'b1) begin
          QA_int = {32{1'bx}};
        end else begin
        end
      end
    end
    LAST_CLKA = CLKA_;
  end

  task readWriteB;
  begin
    if (RETN_int === 1'bx) begin
      failedWrite(1);
      QB_int = {32{1'bx}};
    end else if (RETN_int === 1'b0 && CENB_int === 1'b0) begin
      failedWrite(1);
      QB_int = {32{1'bx}};
    end else if (RETN_int === 1'b0) begin
      // no cycle in retention mode
    end else if (^{CENB_int, EMAB_int} === 1'bx) begin
      failedWrite(1);
      QB_int = {32{1'bx}};
    end else if ((AB_int >= WORDS) && (CENB_int === 1'b0)) begin
      writeEnable = ~( {32{GWENB_int}} | {WENB_int[3], WENB_int[3], WENB_int[3], WENB_int[3],
         WENB_int[3], WENB_int[3], WENB_int[3], WENB_int[3], WENB_int[2], WENB_int[2],
         WENB_int[2], WENB_int[2], WENB_int[2], WENB_int[2], WENB_int[2], WENB_int[2],
         WENB_int[1], WENB_int[1], WENB_int[1], WENB_int[1], WENB_int[1], WENB_int[1],
         WENB_int[1], WENB_int[1], WENB_int[0], WENB_int[0], WENB_int[0], WENB_int[0],
         WENB_int[0], WENB_int[0], WENB_int[0], WENB_int[0]});
      QB_int = ((writeEnable & DB_int) | (~writeEnable & {32{1'bx}}));
    end else if (CENB_int === 1'b0 && (^AB_int) === 1'bx) begin
      if (GWENB_int !== 1'b1 && (& WENB_int) !== 1'b1) failedWrite(1);
      QB_int = {32{1'bx}};
    end else if (CENB_int === 1'b0) begin
      mux_address = (AB_int & 4'b1111);
      row_address = (AB_int >> 4);
      if (row_address >= 64)
        row = {512{1'bx}};
      else
        row = mem[row_address];
      if( isBitX(GWENB_int) )
        writeEnable = {32{1'bx}};
      else
        writeEnable = ~( {32{GWENB_int}} | {WENB_int[3], WENB_int[3], WENB_int[3],
         WENB_int[3], WENB_int[3], WENB_int[3], WENB_int[3], WENB_int[3], WENB_int[2],
         WENB_int[2], WENB_int[2], WENB_int[2], WENB_int[2], WENB_int[2], WENB_int[2],
         WENB_int[2], WENB_int[1], WENB_int[1], WENB_int[1], WENB_int[1], WENB_int[1],
         WENB_int[1], WENB_int[1], WENB_int[1], WENB_int[0], WENB_int[0], WENB_int[0],
         WENB_int[0], WENB_int[0], WENB_int[0], WENB_int[0], WENB_int[0]});
      row_mask =  ( {15'b000000000000000, writeEnable[31], 15'b000000000000000, writeEnable[30],
          15'b000000000000000, writeEnable[29], 15'b000000000000000, writeEnable[28],
          15'b000000000000000, writeEnable[27], 15'b000000000000000, writeEnable[26],
          15'b000000000000000, writeEnable[25], 15'b000000000000000, writeEnable[24],
          15'b000000000000000, writeEnable[23], 15'b000000000000000, writeEnable[22],
          15'b000000000000000, writeEnable[21], 15'b000000000000000, writeEnable[20],
          15'b000000000000000, writeEnable[19], 15'b000000000000000, writeEnable[18],
          15'b000000000000000, writeEnable[17], 15'b000000000000000, writeEnable[16],
          15'b000000000000000, writeEnable[15], 15'b000000000000000, writeEnable[14],
          15'b000000000000000, writeEnable[13], 15'b000000000000000, writeEnable[12],
          15'b000000000000000, writeEnable[11], 15'b000000000000000, writeEnable[10],
          15'b000000000000000, writeEnable[9], 15'b000000000000000, writeEnable[8],
          15'b000000000000000, writeEnable[7], 15'b000000000000000, writeEnable[6],
          15'b000000000000000, writeEnable[5], 15'b000000000000000, writeEnable[4],
          15'b000000000000000, writeEnable[3], 15'b000000000000000, writeEnable[2],
          15'b000000000000000, writeEnable[1], 15'b000000000000000, writeEnable[0]} << mux_address);
      new_data =  ( {15'b000000000000000, DB_int[31], 15'b000000000000000, DB_int[30],
          15'b000000000000000, DB_int[29], 15'b000000000000000, DB_int[28], 15'b000000000000000, DB_int[27],
          15'b000000000000000, DB_int[26], 15'b000000000000000, DB_int[25], 15'b000000000000000, DB_int[24],
          15'b000000000000000, DB_int[23], 15'b000000000000000, DB_int[22], 15'b000000000000000, DB_int[21],
          15'b000000000000000, DB_int[20], 15'b000000000000000, DB_int[19], 15'b000000000000000, DB_int[18],
          15'b000000000000000, DB_int[17], 15'b000000000000000, DB_int[16], 15'b000000000000000, DB_int[15],
          15'b000000000000000, DB_int[14], 15'b000000000000000, DB_int[13], 15'b000000000000000, DB_int[12],
          15'b000000000000000, DB_int[11], 15'b000000000000000, DB_int[10], 15'b000000000000000, DB_int[9],
          15'b000000000000000, DB_int[8], 15'b000000000000000, DB_int[7], 15'b000000000000000, DB_int[6],
          15'b000000000000000, DB_int[5], 15'b000000000000000, DB_int[4], 15'b000000000000000, DB_int[3],
          15'b000000000000000, DB_int[2], 15'b000000000000000, DB_int[1], 15'b000000000000000, DB_int[0]} << mux_address);
      row = (row & ~row_mask) | (row_mask & (~row_mask | new_data));
      mem[row_address] = row;
      data_out = (row >> mux_address);
      if (GWENB_int !== 1'b0)
        QB_int = {data_out[496], data_out[480], data_out[464], data_out[448], data_out[432],
          data_out[416], data_out[400], data_out[384], data_out[368], data_out[352],
          data_out[336], data_out[320], data_out[304], data_out[288], data_out[272],
          data_out[256], data_out[240], data_out[224], data_out[208], data_out[192],
          data_out[176], data_out[160], data_out[144], data_out[128], data_out[112],
          data_out[96], data_out[80], data_out[64], data_out[48], data_out[32], data_out[16],
          data_out[0]};
      else
        QB_int = {(writeEnable[31]?data_out[496]:QB_int[31]), (writeEnable[30]?data_out[480]:QB_int[30]),
          (writeEnable[29]?data_out[464]:QB_int[29]), (writeEnable[28]?data_out[448]:QB_int[28]),
          (writeEnable[27]?data_out[432]:QB_int[27]), (writeEnable[26]?data_out[416]:QB_int[26]),
          (writeEnable[25]?data_out[400]:QB_int[25]), (writeEnable[24]?data_out[384]:QB_int[24]),
          (writeEnable[23]?data_out[368]:QB_int[23]), (writeEnable[22]?data_out[352]:QB_int[22]),
          (writeEnable[21]?data_out[336]:QB_int[21]), (writeEnable[20]?data_out[320]:QB_int[20]),
          (writeEnable[19]?data_out[304]:QB_int[19]), (writeEnable[18]?data_out[288]:QB_int[18]),
          (writeEnable[17]?data_out[272]:QB_int[17]), (writeEnable[16]?data_out[256]:QB_int[16]),
          (writeEnable[15]?data_out[240]:QB_int[15]), (writeEnable[14]?data_out[224]:QB_int[14]),
          (writeEnable[13]?data_out[208]:QB_int[13]), (writeEnable[12]?data_out[192]:QB_int[12]),
          (writeEnable[11]?data_out[176]:QB_int[11]), (writeEnable[10]?data_out[160]:QB_int[10]),
          (writeEnable[9]?data_out[144]:QB_int[9]), (writeEnable[8]?data_out[128]:QB_int[8]),
          (writeEnable[7]?data_out[112]:QB_int[7]), (writeEnable[6]?data_out[96]:QB_int[6]),
          (writeEnable[5]?data_out[80]:QB_int[5]), (writeEnable[4]?data_out[64]:QB_int[4]),
          (writeEnable[3]?data_out[48]:QB_int[3]), (writeEnable[2]?data_out[32]:QB_int[2]),
          (writeEnable[1]?data_out[16]:QB_int[1]), (writeEnable[0]?data_out[0]:QB_int[0])};
    end
  end
  endtask

  always @ RETN_ begin
    if (RETN_ == 1'b0) begin
      QB_int = {32{1'b0}};
      CENB_int = 1'b0;
      WENB_int = {4{1'b0}};
      AB_int = {10{1'b0}};
      DB_int = {32{1'b0}};
      EMAB_int = {3{1'b0}};
      GWENB_int = 1'b0;
      RETN_int = 1'b0;
    end else begin
      QB_int = {32{1'bx}};
      CENB_int = 1'bx;
      WENB_int = {4{1'bx}};
      AB_int = {10{1'bx}};
      DB_int = {32{1'bx}};
      EMAB_int = {3{1'bx}};
      GWENB_int = 1'bx;
      RETN_int = 1'bx;
    end
    RETN_int = RETN_;
  end

  always @ CLKB_ begin
`ifdef POWER_PINS
    if (VSS === 1'bx || VSS === 1'bz)
      $display("ERROR: Illegal value for VSS %b", VSS);
    if (VDD === 1'bx || VDD === 1'bz)
      $display("ERROR: Illegal value for VDD %b", VDD);
`endif
    if (CLKB_ === 1'bx && (CENB_ !== 1'b1)) begin
      failedWrite(1);
      QB_int = {32{1'bx}};
    end else if (CLKB_ === 1'b1 && LAST_CLKB === 1'b0) begin
      CENB_int = CENB_;
      WENB_int = WENB_;
      AB_int = AB_;
      DB_int = DB_;
      EMAB_int = EMAB_;
      GWENB_int = GWENB_;
      RETN_int = RETN_;
      clk1_int = 1'b0;
      previous_CLKB = $realtime;
      readWriteB;
      if (previous_CLKA == previous_CLKB && is_contention(AA_int, AB_int, ({4{GWENA_int}}|WENA_int),
        ({4{GWENB_int}}|WENB_int)) && (CENB_int !== 1'b1 && CENA_int !== 1'b1)) begin
        if (GWENA_int !== 1'b1 && (& WENA_int) !== 1'b1 && GWENB_int !== 1'b1 && (& WENB_int) !== 1'b1) begin
          DA_int = {32{1'bx}};
          readWriteA;
          DB_int = {32{1'bx}};
          readWriteB;
        end else if (GWENA_int !== 1'b1 && (& WENA_int) !== 1'b1) begin
          QB_int = {32{1'bx}};
        end else if (GWENB_int !== 1'b1 && (& WENB_int) !== 1'b1) begin
          QA_int = {32{1'bx}};
        end else begin
        end
      end
    end
    LAST_CLKB = CLKB_;
  end


  function is_contention;
    input [9:0] aa;
    input [9:0] ab;
    input [3:0] wena;
    input [3:0] wenb;
    reg result;
  begin
    if ((& wena) === 1'b1 && (& wenb) === 1'b1) begin
      result = 1'b0;
    end else if (aa == ab) begin
      result = 1'b1;
    end else begin
      result = 1'b0;
    end
    is_contention = result;
  end
  endfunction


endmodule
`endcelldefine
`else
`timescale 1 ns/1 ps
`celldefine
`ifdef POWER_PINS
module sram01 (QA, QB, CLKA, CENA, WENA, AA, DA, CLKB, CENB, WENB, AB, DB, EMAA, EMAB,
    GWENA, GWENB, RETN, VSS, VDD);
`else
module sram01 (QA, QB, CLKA, CENA, WENA, AA, DA, CLKB, CENB, WENB, AB, DB, EMAA, EMAB,
    GWENA, GWENB, RETN);
`endif

  parameter BITS = 32;
  parameter WORDS = 1024;
  parameter MUX = 16;
  parameter MEM_WIDTH = 512; // redun block size 4, 256 on left, 256 on right
  parameter MEM_HEIGHT = 64;
  parameter WP_SIZE = 8 ;
  parameter UPM_WIDTH = 3;

  output [31:0] QA;
  output [31:0] QB;
  input  CLKA;
  input  CENA;
  input [3:0] WENA;
  input [9:0] AA;
  input [31:0] DA;
  input  CLKB;
  input  CENB;
  input [3:0] WENB;
  input [9:0] AB;
  input [31:0] DB;
  input [2:0] EMAA;
  input [2:0] EMAB;
  input  GWENA;
  input  GWENB;
  input  RETN;
`ifdef POWER_PINS
  inout VSS;
  inout VDD;
`endif

  integer row_address;
  integer mux_address;
  reg [511:0] mem [0:63];
  reg [511:0] row;
  reg LAST_CLKA;
  reg [511:0] data_out;
  reg [511:0] row_mask;
  reg [511:0] new_data;
  reg LAST_CLKB;
  reg [31:0] QA_int;
  reg [31:0] QB_int;
  reg [31:0] writeEnable;
  real previous_CLKA;
  real previous_CLKB;
  initial previous_CLKA = 0;
  initial previous_CLKB = 0;
  reg  cont_flag0_int;
  reg  cont_flag1_int;
  initial cont_flag0_int = 1'b0;
  initial cont_flag1_int = 1'b0;

  reg NOT_AA0, NOT_AA1, NOT_AA2, NOT_AA3, NOT_AA4, NOT_AA5, NOT_AA6, NOT_AA7, NOT_AA8;
  reg NOT_AA9, NOT_AB0, NOT_AB1, NOT_AB2, NOT_AB3, NOT_AB4, NOT_AB5, NOT_AB6, NOT_AB7;
  reg NOT_AB8, NOT_AB9, NOT_CENA, NOT_CENB, NOT_CLKA_MINH, NOT_CLKA_MINL, NOT_CLKA_PER;
  reg NOT_CLKB_MINH, NOT_CLKB_MINL, NOT_CLKB_PER, NOT_CONTA, NOT_CONTB, NOT_DA0, NOT_DA1;
  reg NOT_DA10, NOT_DA11, NOT_DA12, NOT_DA13, NOT_DA14, NOT_DA15, NOT_DA16, NOT_DA17;
  reg NOT_DA18, NOT_DA19, NOT_DA2, NOT_DA20, NOT_DA21, NOT_DA22, NOT_DA23, NOT_DA24;
  reg NOT_DA25, NOT_DA26, NOT_DA27, NOT_DA28, NOT_DA29, NOT_DA3, NOT_DA30, NOT_DA31;
  reg NOT_DA4, NOT_DA5, NOT_DA6, NOT_DA7, NOT_DA8, NOT_DA9, NOT_DB0, NOT_DB1, NOT_DB10;
  reg NOT_DB11, NOT_DB12, NOT_DB13, NOT_DB14, NOT_DB15, NOT_DB16, NOT_DB17, NOT_DB18;
  reg NOT_DB19, NOT_DB2, NOT_DB20, NOT_DB21, NOT_DB22, NOT_DB23, NOT_DB24, NOT_DB25;
  reg NOT_DB26, NOT_DB27, NOT_DB28, NOT_DB29, NOT_DB3, NOT_DB30, NOT_DB31, NOT_DB4;
  reg NOT_DB5, NOT_DB6, NOT_DB7, NOT_DB8, NOT_DB9, NOT_EMAA0, NOT_EMAA1, NOT_EMAA2;
  reg NOT_EMAB0, NOT_EMAB1, NOT_EMAB2, NOT_GWENA, NOT_GWENB, NOT_RETN, NOT_RETNA, NOT_RETNB;
  reg NOT_WENA0, NOT_WENA1, NOT_WENA2, NOT_WENA3, NOT_WENB0, NOT_WENB1, NOT_WENB2;
  reg NOT_WENB3;
  reg clk0_int;
  reg clk1_int;
  reg CRENA_legal;
  initial CRENA_legal = 1'b1;
  reg CRENB_legal;
  initial CRENB_legal = 1'b1;

  wire [31:0] QA_;
  wire [31:0] QB_;
 wire  CLKA_;
  wire  CENA_;
  reg  CENA_int;
  wire [3:0] WENA_;
  reg [3:0] WENA_int;
  wire [9:0] AA_;
  reg [9:0] AA_int;
  wire [31:0] DA_;
  reg [31:0] DA_int;
 wire  CLKB_;
  wire  CENB_;
  reg  CENB_int;
  wire [3:0] WENB_;
  reg [3:0] WENB_int;
  wire [9:0] AB_;
  reg [9:0] AB_int;
  wire [31:0] DB_;
  reg [31:0] DB_int;
  wire [2:0] EMAA_;
  reg [2:0] EMAA_int;
  wire [2:0] EMAB_;
  reg [2:0] EMAB_int;
  wire  GWENA_;
  reg  GWENA_int;
  wire  GWENB_;
  reg  GWENB_int;
  wire  RETN_;
  reg  RETN_int;

  buf B0(QA[0], QA_[0]);
  buf B1(QA[1], QA_[1]);
  buf B2(QA[2], QA_[2]);
  buf B3(QA[3], QA_[3]);
  buf B4(QA[4], QA_[4]);
  buf B5(QA[5], QA_[5]);
  buf B6(QA[6], QA_[6]);
  buf B7(QA[7], QA_[7]);
  buf B8(QA[8], QA_[8]);
  buf B9(QA[9], QA_[9]);
  buf B10(QA[10], QA_[10]);
  buf B11(QA[11], QA_[11]);
  buf B12(QA[12], QA_[12]);
  buf B13(QA[13], QA_[13]);
  buf B14(QA[14], QA_[14]);
  buf B15(QA[15], QA_[15]);
  buf B16(QA[16], QA_[16]);
  buf B17(QA[17], QA_[17]);
  buf B18(QA[18], QA_[18]);
  buf B19(QA[19], QA_[19]);
  buf B20(QA[20], QA_[20]);
  buf B21(QA[21], QA_[21]);
  buf B22(QA[22], QA_[22]);
  buf B23(QA[23], QA_[23]);
  buf B24(QA[24], QA_[24]);
  buf B25(QA[25], QA_[25]);
  buf B26(QA[26], QA_[26]);
  buf B27(QA[27], QA_[27]);
  buf B28(QA[28], QA_[28]);
  buf B29(QA[29], QA_[29]);
  buf B30(QA[30], QA_[30]);
  buf B31(QA[31], QA_[31]);
  buf B32(QB[0], QB_[0]);
  buf B33(QB[1], QB_[1]);
  buf B34(QB[2], QB_[2]);
  buf B35(QB[3], QB_[3]);
  buf B36(QB[4], QB_[4]);
  buf B37(QB[5], QB_[5]);
  buf B38(QB[6], QB_[6]);
  buf B39(QB[7], QB_[7]);
  buf B40(QB[8], QB_[8]);
  buf B41(QB[9], QB_[9]);
  buf B42(QB[10], QB_[10]);
  buf B43(QB[11], QB_[11]);
  buf B44(QB[12], QB_[12]);
  buf B45(QB[13], QB_[13]);
  buf B46(QB[14], QB_[14]);
  buf B47(QB[15], QB_[15]);
  buf B48(QB[16], QB_[16]);
  buf B49(QB[17], QB_[17]);
  buf B50(QB[18], QB_[18]);
  buf B51(QB[19], QB_[19]);
  buf B52(QB[20], QB_[20]);
  buf B53(QB[21], QB_[21]);
  buf B54(QB[22], QB_[22]);
  buf B55(QB[23], QB_[23]);
  buf B56(QB[24], QB_[24]);
  buf B57(QB[25], QB_[25]);
  buf B58(QB[26], QB_[26]);
  buf B59(QB[27], QB_[27]);
  buf B60(QB[28], QB_[28]);
  buf B61(QB[29], QB_[29]);
  buf B62(QB[30], QB_[30]);
  buf B63(QB[31], QB_[31]);
  buf B64(CLKA_, CLKA);
  buf B65(CENA_, CENA);
  buf B66(WENA_[0], WENA[0]);
  buf B67(WENA_[1], WENA[1]);
  buf B68(WENA_[2], WENA[2]);
  buf B69(WENA_[3], WENA[3]);
  buf B70(AA_[0], AA[0]);
  buf B71(AA_[1], AA[1]);
  buf B72(AA_[2], AA[2]);
  buf B73(AA_[3], AA[3]);
  buf B74(AA_[4], AA[4]);
  buf B75(AA_[5], AA[5]);
  buf B76(AA_[6], AA[6]);
  buf B77(AA_[7], AA[7]);
  buf B78(AA_[8], AA[8]);
  buf B79(AA_[9], AA[9]);
  buf B80(DA_[0], DA[0]);
  buf B81(DA_[1], DA[1]);
  buf B82(DA_[2], DA[2]);
  buf B83(DA_[3], DA[3]);
  buf B84(DA_[4], DA[4]);
  buf B85(DA_[5], DA[5]);
  buf B86(DA_[6], DA[6]);
  buf B87(DA_[7], DA[7]);
  buf B88(DA_[8], DA[8]);
  buf B89(DA_[9], DA[9]);
  buf B90(DA_[10], DA[10]);
  buf B91(DA_[11], DA[11]);
  buf B92(DA_[12], DA[12]);
  buf B93(DA_[13], DA[13]);
  buf B94(DA_[14], DA[14]);
  buf B95(DA_[15], DA[15]);
  buf B96(DA_[16], DA[16]);
  buf B97(DA_[17], DA[17]);
  buf B98(DA_[18], DA[18]);
  buf B99(DA_[19], DA[19]);
  buf B100(DA_[20], DA[20]);
  buf B101(DA_[21], DA[21]);
  buf B102(DA_[22], DA[22]);
  buf B103(DA_[23], DA[23]);
  buf B104(DA_[24], DA[24]);
  buf B105(DA_[25], DA[25]);
  buf B106(DA_[26], DA[26]);
  buf B107(DA_[27], DA[27]);
  buf B108(DA_[28], DA[28]);
  buf B109(DA_[29], DA[29]);
  buf B110(DA_[30], DA[30]);
  buf B111(DA_[31], DA[31]);
  buf B112(CLKB_, CLKB);
  buf B113(CENB_, CENB);
  buf B114(WENB_[0], WENB[0]);
  buf B115(WENB_[1], WENB[1]);
  buf B116(WENB_[2], WENB[2]);
  buf B117(WENB_[3], WENB[3]);
  buf B118(AB_[0], AB[0]);
  buf B119(AB_[1], AB[1]);
  buf B120(AB_[2], AB[2]);
  buf B121(AB_[3], AB[3]);
  buf B122(AB_[4], AB[4]);
  buf B123(AB_[5], AB[5]);
  buf B124(AB_[6], AB[6]);
  buf B125(AB_[7], AB[7]);
  buf B126(AB_[8], AB[8]);
  buf B127(AB_[9], AB[9]);
  buf B128(DB_[0], DB[0]);
  buf B129(DB_[1], DB[1]);
  buf B130(DB_[2], DB[2]);
  buf B131(DB_[3], DB[3]);
  buf B132(DB_[4], DB[4]);
  buf B133(DB_[5], DB[5]);
  buf B134(DB_[6], DB[6]);
  buf B135(DB_[7], DB[7]);
  buf B136(DB_[8], DB[8]);
  buf B137(DB_[9], DB[9]);
  buf B138(DB_[10], DB[10]);
  buf B139(DB_[11], DB[11]);
  buf B140(DB_[12], DB[12]);
  buf B141(DB_[13], DB[13]);
  buf B142(DB_[14], DB[14]);
  buf B143(DB_[15], DB[15]);
  buf B144(DB_[16], DB[16]);
  buf B145(DB_[17], DB[17]);
  buf B146(DB_[18], DB[18]);
  buf B147(DB_[19], DB[19]);
  buf B148(DB_[20], DB[20]);
  buf B149(DB_[21], DB[21]);
  buf B150(DB_[22], DB[22]);
  buf B151(DB_[23], DB[23]);
  buf B152(DB_[24], DB[24]);
  buf B153(DB_[25], DB[25]);
  buf B154(DB_[26], DB[26]);
  buf B155(DB_[27], DB[27]);
  buf B156(DB_[28], DB[28]);
  buf B157(DB_[29], DB[29]);
  buf B158(DB_[30], DB[30]);
  buf B159(DB_[31], DB[31]);
  buf B160(EMAA_[0], EMAA[0]);
  buf B161(EMAA_[1], EMAA[1]);
  buf B162(EMAA_[2], EMAA[2]);
  buf B163(EMAB_[0], EMAB[0]);
  buf B164(EMAB_[1], EMAB[1]);
  buf B165(EMAB_[2], EMAB[2]);
  buf B166(GWENA_, GWENA);
  buf B167(GWENB_, GWENB);
  buf B168(RETN_, RETN);

  assign QA_ = RETN_ ? (QA_int) : {32{1'b0}};
  assign QB_ = RETN_ ? (QB_int) : {32{1'b0}};

`ifdef INITIALIZE_MEMORY
  integer i;
  initial
    for (i = 0; i < MEM_HEIGHT; i = i + 1)
      mem[i] = {MEM_WIDTH{1'b0}};
`endif

  task failedWrite;
  input port;
  integer i;
  begin
    for (i = 0; i < MEM_HEIGHT; i = i + 1)
      mem[i] = {MEM_WIDTH{1'bx}};
  end
  endtask

  function isBitX;
    input bitIn;
    begin
      isBitX = ( bitIn===1'bx || bitIn===1'bz ) ? 1'b1 : 1'b0;
    end
  endfunction


  task readWriteA;
  begin
    if (RETN_int === 1'bx) begin
      failedWrite(0);
      QA_int = {32{1'bx}};
    end else if (RETN_int === 1'b0 && CENA_int === 1'b0) begin
      failedWrite(0);
      QA_int = {32{1'bx}};
    end else if (RETN_int === 1'b0) begin
      // no cycle in retention mode
    end else if (^{CENA_int, EMAA_int} === 1'bx) begin
      failedWrite(0);
      QA_int = {32{1'bx}};
    end else if ((AA_int >= WORDS) && (CENA_int === 1'b0)) begin
      writeEnable = ~( {32{GWENA_int}} | {WENA_int[3], WENA_int[3], WENA_int[3], WENA_int[3],
         WENA_int[3], WENA_int[3], WENA_int[3], WENA_int[3], WENA_int[2], WENA_int[2],
         WENA_int[2], WENA_int[2], WENA_int[2], WENA_int[2], WENA_int[2], WENA_int[2],
         WENA_int[1], WENA_int[1], WENA_int[1], WENA_int[1], WENA_int[1], WENA_int[1],
         WENA_int[1], WENA_int[1], WENA_int[0], WENA_int[0], WENA_int[0], WENA_int[0],
         WENA_int[0], WENA_int[0], WENA_int[0], WENA_int[0]});
      QA_int = ((writeEnable & DA_int) | (~writeEnable & {32{1'bx}}));
    end else if (CENA_int === 1'b0 && (^AA_int) === 1'bx) begin
      if (GWENA_int !== 1'b1 && (& WENA_int) !== 1'b1) failedWrite(0);
      QA_int = {32{1'bx}};
    end else if (CENA_int === 1'b0) begin
      mux_address = (AA_int & 4'b1111);
      row_address = (AA_int >> 4);
      if (row_address >= 64)
        row = {512{1'bx}};
      else
        row = mem[row_address];
      if( isBitX(GWENA_int) )
        writeEnable = {32{1'bx}};
      else
        writeEnable = ~( {32{GWENA_int}} | {WENA_int[3], WENA_int[3], WENA_int[3],
         WENA_int[3], WENA_int[3], WENA_int[3], WENA_int[3], WENA_int[3], WENA_int[2],
         WENA_int[2], WENA_int[2], WENA_int[2], WENA_int[2], WENA_int[2], WENA_int[2],
         WENA_int[2], WENA_int[1], WENA_int[1], WENA_int[1], WENA_int[1], WENA_int[1],
         WENA_int[1], WENA_int[1], WENA_int[1], WENA_int[0], WENA_int[0], WENA_int[0],
         WENA_int[0], WENA_int[0], WENA_int[0], WENA_int[0], WENA_int[0]});
      row_mask =  ( {15'b000000000000000, writeEnable[31], 15'b000000000000000, writeEnable[30],
          15'b000000000000000, writeEnable[29], 15'b000000000000000, writeEnable[28],
          15'b000000000000000, writeEnable[27], 15'b000000000000000, writeEnable[26],
          15'b000000000000000, writeEnable[25], 15'b000000000000000, writeEnable[24],
          15'b000000000000000, writeEnable[23], 15'b000000000000000, writeEnable[22],
          15'b000000000000000, writeEnable[21], 15'b000000000000000, writeEnable[20],
          15'b000000000000000, writeEnable[19], 15'b000000000000000, writeEnable[18],
          15'b000000000000000, writeEnable[17], 15'b000000000000000, writeEnable[16],
          15'b000000000000000, writeEnable[15], 15'b000000000000000, writeEnable[14],
          15'b000000000000000, writeEnable[13], 15'b000000000000000, writeEnable[12],
          15'b000000000000000, writeEnable[11], 15'b000000000000000, writeEnable[10],
          15'b000000000000000, writeEnable[9], 15'b000000000000000, writeEnable[8],
          15'b000000000000000, writeEnable[7], 15'b000000000000000, writeEnable[6],
          15'b000000000000000, writeEnable[5], 15'b000000000000000, writeEnable[4],
          15'b000000000000000, writeEnable[3], 15'b000000000000000, writeEnable[2],
          15'b000000000000000, writeEnable[1], 15'b000000000000000, writeEnable[0]} << mux_address);
      new_data =  ( {15'b000000000000000, DA_int[31], 15'b000000000000000, DA_int[30],
          15'b000000000000000, DA_int[29], 15'b000000000000000, DA_int[28], 15'b000000000000000, DA_int[27],
          15'b000000000000000, DA_int[26], 15'b000000000000000, DA_int[25], 15'b000000000000000, DA_int[24],
          15'b000000000000000, DA_int[23], 15'b000000000000000, DA_int[22], 15'b000000000000000, DA_int[21],
          15'b000000000000000, DA_int[20], 15'b000000000000000, DA_int[19], 15'b000000000000000, DA_int[18],
          15'b000000000000000, DA_int[17], 15'b000000000000000, DA_int[16], 15'b000000000000000, DA_int[15],
          15'b000000000000000, DA_int[14], 15'b000000000000000, DA_int[13], 15'b000000000000000, DA_int[12],
          15'b000000000000000, DA_int[11], 15'b000000000000000, DA_int[10], 15'b000000000000000, DA_int[9],
          15'b000000000000000, DA_int[8], 15'b000000000000000, DA_int[7], 15'b000000000000000, DA_int[6],
          15'b000000000000000, DA_int[5], 15'b000000000000000, DA_int[4], 15'b000000000000000, DA_int[3],
          15'b000000000000000, DA_int[2], 15'b000000000000000, DA_int[1], 15'b000000000000000, DA_int[0]} << mux_address);
      row = (row & ~row_mask) | (row_mask & (~row_mask | new_data));
      mem[row_address] = row;
      data_out = (row >> mux_address);
      if (GWENA_int !== 1'b0)
        QA_int = {data_out[496], data_out[480], data_out[464], data_out[448], data_out[432],
          data_out[416], data_out[400], data_out[384], data_out[368], data_out[352],
          data_out[336], data_out[320], data_out[304], data_out[288], data_out[272],
          data_out[256], data_out[240], data_out[224], data_out[208], data_out[192],
          data_out[176], data_out[160], data_out[144], data_out[128], data_out[112],
          data_out[96], data_out[80], data_out[64], data_out[48], data_out[32], data_out[16],
          data_out[0]};
      else
        QA_int = {(writeEnable[31]?data_out[496]:QA_int[31]), (writeEnable[30]?data_out[480]:QA_int[30]),
          (writeEnable[29]?data_out[464]:QA_int[29]), (writeEnable[28]?data_out[448]:QA_int[28]),
          (writeEnable[27]?data_out[432]:QA_int[27]), (writeEnable[26]?data_out[416]:QA_int[26]),
          (writeEnable[25]?data_out[400]:QA_int[25]), (writeEnable[24]?data_out[384]:QA_int[24]),
          (writeEnable[23]?data_out[368]:QA_int[23]), (writeEnable[22]?data_out[352]:QA_int[22]),
          (writeEnable[21]?data_out[336]:QA_int[21]), (writeEnable[20]?data_out[320]:QA_int[20]),
          (writeEnable[19]?data_out[304]:QA_int[19]), (writeEnable[18]?data_out[288]:QA_int[18]),
          (writeEnable[17]?data_out[272]:QA_int[17]), (writeEnable[16]?data_out[256]:QA_int[16]),
          (writeEnable[15]?data_out[240]:QA_int[15]), (writeEnable[14]?data_out[224]:QA_int[14]),
          (writeEnable[13]?data_out[208]:QA_int[13]), (writeEnable[12]?data_out[192]:QA_int[12]),
          (writeEnable[11]?data_out[176]:QA_int[11]), (writeEnable[10]?data_out[160]:QA_int[10]),
          (writeEnable[9]?data_out[144]:QA_int[9]), (writeEnable[8]?data_out[128]:QA_int[8]),
          (writeEnable[7]?data_out[112]:QA_int[7]), (writeEnable[6]?data_out[96]:QA_int[6]),
          (writeEnable[5]?data_out[80]:QA_int[5]), (writeEnable[4]?data_out[64]:QA_int[4]),
          (writeEnable[3]?data_out[48]:QA_int[3]), (writeEnable[2]?data_out[32]:QA_int[2]),
          (writeEnable[1]?data_out[16]:QA_int[1]), (writeEnable[0]?data_out[0]:QA_int[0])};
    end
  end
  endtask

  always @ RETN_ begin
    if (RETN_ == 1'b0) begin
      QA_int = {32{1'b0}};
      CENA_int = 1'b0;
      WENA_int = {4{1'b0}};
      AA_int = {10{1'b0}};
      DA_int = {32{1'b0}};
      EMAA_int = {3{1'b0}};
      GWENA_int = 1'b0;
      RETN_int = 1'b0;
    end else begin
      QA_int = {32{1'bx}};
      CENA_int = 1'bx;
      WENA_int = {4{1'bx}};
      AA_int = {10{1'bx}};
      DA_int = {32{1'bx}};
      EMAA_int = {3{1'bx}};
      GWENA_int = 1'bx;
      RETN_int = 1'bx;
    end
    RETN_int = RETN_;
  end

  always @ CLKA_ begin
`ifdef POWER_PINS
    if (VSS === 1'bx || VSS === 1'bz)
      $display("ERROR: Illegal value for VSS %b", VSS);
    if (VDD === 1'bx || VDD === 1'bz)
      $display("ERROR: Illegal value for VDD %b", VDD);
`endif
    if (CLKA_ === 1'bx && (CENA_ !== 1'b1)) begin
      failedWrite(0);
      QA_int = {32{1'bx}};
    end else if (CLKA_ === 1'b1 && LAST_CLKA === 1'b0) begin
      CENA_int = CENA_;
      WENA_int = WENA_;
      AA_int = AA_;
      DA_int = DA_;
      EMAA_int = EMAA_;
      GWENA_int = GWENA_;
      RETN_int = RETN_;
      clk0_int = 1'b0;
      previous_CLKA = $realtime;
      readWriteA;
      if (previous_CLKA == previous_CLKB && is_contention(AA_int, AB_int, ({4{GWENA_int}}|WENA_int),
        ({4{GWENB_int}}|WENB_int)) && (CENA_int !== 1'b1 && CENB_int !== 1'b1)) begin
        if (GWENA_int !== 1'b1 && (& WENA_int) !== 1'b1 && GWENB_int !== 1'b1 && (& WENB_int) !== 1'b1) begin
          DA_int = {32{1'bx}};
          readWriteA;
          DB_int = {32{1'bx}};
          readWriteB;
        end else if (GWENA_int !== 1'b1 && (& WENA_int) !== 1'b1) begin
          QB_int = {32{1'bx}};
        end else if (GWENB_int !== 1'b1 && (& WENB_int) !== 1'b1) begin
          QA_int = {32{1'bx}};
        end else begin
        end
      end
    end
    LAST_CLKA = CLKA_;
  end

  reg globalNotifier0;
  initial globalNotifier0 = 1'b0;

  always @ globalNotifier0 begin
    if ($realtime == 0) begin
    end else if (CENA_int === 1'bx || EMAA_int[0] === 1'bx || EMAA_int[1] === 1'bx || 
      EMAA_int[2] === 1'bx || RETN_int === 1'bx || clk0_int === 1'bx) begin
      QA_int = {32{1'bx}};
      failedWrite(0);
    end else if (cont_flag0_int === 1'bx) begin
      cont_flag0_int = 1'b0;
        if (GWENA_ !== 1'b1 && (& WENA_) !== 1'b1 && GWENB_int !== 1'b1 && (& WENB_int) !== 1'b1) begin
          DA_int = {32{1'bx}};
          readWriteA;
          DB_int = {32{1'bx}};
          readWriteB;
        end else if (GWENA_ !== 1'b1 && (& WENA_) !== 1'b1) begin
          QB_int = {32{1'bx}};
        end else if (GWENB_int !== 1'b1 && (& WENB_int) !== 1'b1) begin
          QA_int = {32{1'bx}};
        end else begin
        end
    end else begin
      readWriteA;
   end
    globalNotifier0 = 1'b0;
  end

  task readWriteB;
  begin
    if (RETN_int === 1'bx) begin
      failedWrite(1);
      QB_int = {32{1'bx}};
    end else if (RETN_int === 1'b0 && CENB_int === 1'b0) begin
      failedWrite(1);
      QB_int = {32{1'bx}};
    end else if (RETN_int === 1'b0) begin
      // no cycle in retention mode
    end else if (^{CENB_int, EMAB_int} === 1'bx) begin
      failedWrite(1);
      QB_int = {32{1'bx}};
    end else if ((AB_int >= WORDS) && (CENB_int === 1'b0)) begin
      writeEnable = ~( {32{GWENB_int}} | {WENB_int[3], WENB_int[3], WENB_int[3], WENB_int[3],
         WENB_int[3], WENB_int[3], WENB_int[3], WENB_int[3], WENB_int[2], WENB_int[2],
         WENB_int[2], WENB_int[2], WENB_int[2], WENB_int[2], WENB_int[2], WENB_int[2],
         WENB_int[1], WENB_int[1], WENB_int[1], WENB_int[1], WENB_int[1], WENB_int[1],
         WENB_int[1], WENB_int[1], WENB_int[0], WENB_int[0], WENB_int[0], WENB_int[0],
         WENB_int[0], WENB_int[0], WENB_int[0], WENB_int[0]});
      QB_int = ((writeEnable & DB_int) | (~writeEnable & {32{1'bx}}));
    end else if (CENB_int === 1'b0 && (^AB_int) === 1'bx) begin
      if (GWENB_int !== 1'b1 && (& WENB_int) !== 1'b1) failedWrite(1);
      QB_int = {32{1'bx}};
    end else if (CENB_int === 1'b0) begin
      mux_address = (AB_int & 4'b1111);
      row_address = (AB_int >> 4);
      if (row_address >= 64)
        row = {512{1'bx}};
      else
        row = mem[row_address];
      if( isBitX(GWENB_int) )
        writeEnable = {32{1'bx}};
      else
        writeEnable = ~( {32{GWENB_int}} | {WENB_int[3], WENB_int[3], WENB_int[3],
         WENB_int[3], WENB_int[3], WENB_int[3], WENB_int[3], WENB_int[3], WENB_int[2],
         WENB_int[2], WENB_int[2], WENB_int[2], WENB_int[2], WENB_int[2], WENB_int[2],
         WENB_int[2], WENB_int[1], WENB_int[1], WENB_int[1], WENB_int[1], WENB_int[1],
         WENB_int[1], WENB_int[1], WENB_int[1], WENB_int[0], WENB_int[0], WENB_int[0],
         WENB_int[0], WENB_int[0], WENB_int[0], WENB_int[0], WENB_int[0]});
      row_mask =  ( {15'b000000000000000, writeEnable[31], 15'b000000000000000, writeEnable[30],
          15'b000000000000000, writeEnable[29], 15'b000000000000000, writeEnable[28],
          15'b000000000000000, writeEnable[27], 15'b000000000000000, writeEnable[26],
          15'b000000000000000, writeEnable[25], 15'b000000000000000, writeEnable[24],
          15'b000000000000000, writeEnable[23], 15'b000000000000000, writeEnable[22],
          15'b000000000000000, writeEnable[21], 15'b000000000000000, writeEnable[20],
          15'b000000000000000, writeEnable[19], 15'b000000000000000, writeEnable[18],
          15'b000000000000000, writeEnable[17], 15'b000000000000000, writeEnable[16],
          15'b000000000000000, writeEnable[15], 15'b000000000000000, writeEnable[14],
          15'b000000000000000, writeEnable[13], 15'b000000000000000, writeEnable[12],
          15'b000000000000000, writeEnable[11], 15'b000000000000000, writeEnable[10],
          15'b000000000000000, writeEnable[9], 15'b000000000000000, writeEnable[8],
          15'b000000000000000, writeEnable[7], 15'b000000000000000, writeEnable[6],
          15'b000000000000000, writeEnable[5], 15'b000000000000000, writeEnable[4],
          15'b000000000000000, writeEnable[3], 15'b000000000000000, writeEnable[2],
          15'b000000000000000, writeEnable[1], 15'b000000000000000, writeEnable[0]} << mux_address);
      new_data =  ( {15'b000000000000000, DB_int[31], 15'b000000000000000, DB_int[30],
          15'b000000000000000, DB_int[29], 15'b000000000000000, DB_int[28], 15'b000000000000000, DB_int[27],
          15'b000000000000000, DB_int[26], 15'b000000000000000, DB_int[25], 15'b000000000000000, DB_int[24],
          15'b000000000000000, DB_int[23], 15'b000000000000000, DB_int[22], 15'b000000000000000, DB_int[21],
          15'b000000000000000, DB_int[20], 15'b000000000000000, DB_int[19], 15'b000000000000000, DB_int[18],
          15'b000000000000000, DB_int[17], 15'b000000000000000, DB_int[16], 15'b000000000000000, DB_int[15],
          15'b000000000000000, DB_int[14], 15'b000000000000000, DB_int[13], 15'b000000000000000, DB_int[12],
          15'b000000000000000, DB_int[11], 15'b000000000000000, DB_int[10], 15'b000000000000000, DB_int[9],
          15'b000000000000000, DB_int[8], 15'b000000000000000, DB_int[7], 15'b000000000000000, DB_int[6],
          15'b000000000000000, DB_int[5], 15'b000000000000000, DB_int[4], 15'b000000000000000, DB_int[3],
          15'b000000000000000, DB_int[2], 15'b000000000000000, DB_int[1], 15'b000000000000000, DB_int[0]} << mux_address);
      row = (row & ~row_mask) | (row_mask & (~row_mask | new_data));
      mem[row_address] = row;
      data_out = (row >> mux_address);
      if (GWENB_int !== 1'b0)
        QB_int = {data_out[496], data_out[480], data_out[464], data_out[448], data_out[432],
          data_out[416], data_out[400], data_out[384], data_out[368], data_out[352],
          data_out[336], data_out[320], data_out[304], data_out[288], data_out[272],
          data_out[256], data_out[240], data_out[224], data_out[208], data_out[192],
          data_out[176], data_out[160], data_out[144], data_out[128], data_out[112],
          data_out[96], data_out[80], data_out[64], data_out[48], data_out[32], data_out[16],
          data_out[0]};
      else
        QB_int = {(writeEnable[31]?data_out[496]:QB_int[31]), (writeEnable[30]?data_out[480]:QB_int[30]),
          (writeEnable[29]?data_out[464]:QB_int[29]), (writeEnable[28]?data_out[448]:QB_int[28]),
          (writeEnable[27]?data_out[432]:QB_int[27]), (writeEnable[26]?data_out[416]:QB_int[26]),
          (writeEnable[25]?data_out[400]:QB_int[25]), (writeEnable[24]?data_out[384]:QB_int[24]),
          (writeEnable[23]?data_out[368]:QB_int[23]), (writeEnable[22]?data_out[352]:QB_int[22]),
          (writeEnable[21]?data_out[336]:QB_int[21]), (writeEnable[20]?data_out[320]:QB_int[20]),
          (writeEnable[19]?data_out[304]:QB_int[19]), (writeEnable[18]?data_out[288]:QB_int[18]),
          (writeEnable[17]?data_out[272]:QB_int[17]), (writeEnable[16]?data_out[256]:QB_int[16]),
          (writeEnable[15]?data_out[240]:QB_int[15]), (writeEnable[14]?data_out[224]:QB_int[14]),
          (writeEnable[13]?data_out[208]:QB_int[13]), (writeEnable[12]?data_out[192]:QB_int[12]),
          (writeEnable[11]?data_out[176]:QB_int[11]), (writeEnable[10]?data_out[160]:QB_int[10]),
          (writeEnable[9]?data_out[144]:QB_int[9]), (writeEnable[8]?data_out[128]:QB_int[8]),
          (writeEnable[7]?data_out[112]:QB_int[7]), (writeEnable[6]?data_out[96]:QB_int[6]),
          (writeEnable[5]?data_out[80]:QB_int[5]), (writeEnable[4]?data_out[64]:QB_int[4]),
          (writeEnable[3]?data_out[48]:QB_int[3]), (writeEnable[2]?data_out[32]:QB_int[2]),
          (writeEnable[1]?data_out[16]:QB_int[1]), (writeEnable[0]?data_out[0]:QB_int[0])};
    end
  end
  endtask

  always @ RETN_ begin
    if (RETN_ == 1'b0) begin
      QB_int = {32{1'b0}};
      CENB_int = 1'b0;
      WENB_int = {4{1'b0}};
      AB_int = {10{1'b0}};
      DB_int = {32{1'b0}};
      EMAB_int = {3{1'b0}};
      GWENB_int = 1'b0;
      RETN_int = 1'b0;
    end else begin
      QB_int = {32{1'bx}};
      CENB_int = 1'bx;
      WENB_int = {4{1'bx}};
      AB_int = {10{1'bx}};
      DB_int = {32{1'bx}};
      EMAB_int = {3{1'bx}};
      GWENB_int = 1'bx;
      RETN_int = 1'bx;
    end
    RETN_int = RETN_;
  end

  always @ CLKB_ begin
`ifdef POWER_PINS
    if (VSS === 1'bx || VSS === 1'bz)
      $display("ERROR: Illegal value for VSS %b", VSS);
    if (VDD === 1'bx || VDD === 1'bz)
      $display("ERROR: Illegal value for VDD %b", VDD);
`endif
    if (CLKB_ === 1'bx && (CENB_ !== 1'b1)) begin
      failedWrite(1);
      QB_int = {32{1'bx}};
    end else if (CLKB_ === 1'b1 && LAST_CLKB === 1'b0) begin
      CENB_int = CENB_;
      WENB_int = WENB_;
      AB_int = AB_;
      DB_int = DB_;
      EMAB_int = EMAB_;
      GWENB_int = GWENB_;
      RETN_int = RETN_;
      clk1_int = 1'b0;
      previous_CLKB = $realtime;
      readWriteB;
      if (previous_CLKA == previous_CLKB && is_contention(AA_int, AB_int, ({4{GWENA_int}}|WENA_int),
        ({4{GWENB_int}}|WENB_int)) && (CENB_int !== 1'b1 && CENA_int !== 1'b1)) begin
        if (GWENA_int !== 1'b1 && (& WENA_int) !== 1'b1 && GWENB_int !== 1'b1 && (& WENB_int) !== 1'b1) begin
          DA_int = {32{1'bx}};
          readWriteA;
          DB_int = {32{1'bx}};
          readWriteB;
        end else if (GWENA_int !== 1'b1 && (& WENA_int) !== 1'b1) begin
          QB_int = {32{1'bx}};
        end else if (GWENB_int !== 1'b1 && (& WENB_int) !== 1'b1) begin
          QA_int = {32{1'bx}};
        end else begin
        end
      end
    end
    LAST_CLKB = CLKB_;
  end

  reg globalNotifier1;
  initial globalNotifier1 = 1'b0;

  always @ globalNotifier1 begin
    if ($realtime == 0) begin
    end else if (CENB_int === 1'bx || EMAB_int[0] === 1'bx || EMAB_int[1] === 1'bx || 
      EMAB_int[2] === 1'bx || RETN_int === 1'bx || clk1_int === 1'bx) begin
      QB_int = {32{1'bx}};
      failedWrite(1);
    end else if (cont_flag1_int === 1'bx) begin
      cont_flag1_int = 1'b0;
        if (GWENA_int !== 1'b1 && (& WENA_int) !== 1'b1 && GWENB_ !== 1'b1 && (& WENB_) !== 1'b1) begin
          DA_int = {32{1'bx}};
          readWriteA;
          DB_int = {32{1'bx}};
          readWriteB;
        end else if (GWENA_int !== 1'b1 && (& WENA_int) !== 1'b1) begin
          QB_int = {32{1'bx}};
        end else if (GWENB_ !== 1'b1 && (& WENB_) !== 1'b1) begin
          QA_int = {32{1'bx}};
        end else begin
        end
    end else begin
      readWriteB;
   end
    globalNotifier1 = 1'b0;
  end

  always @ NOT_AA0 begin
    AA_int[0] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_AA1 begin
    AA_int[1] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_AA2 begin
    AA_int[2] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_AA3 begin
    AA_int[3] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_AA4 begin
    AA_int[4] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_AA5 begin
    AA_int[5] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_AA6 begin
    AA_int[6] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_AA7 begin
    AA_int[7] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_AA8 begin
    AA_int[8] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_AA9 begin
    AA_int[9] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_AB0 begin
    AB_int[0] = 1'bx;
    if ( globalNotifier1 === 1'b0 ) globalNotifier1 = 1'bx;
  end
  always @ NOT_AB1 begin
    AB_int[1] = 1'bx;
    if ( globalNotifier1 === 1'b0 ) globalNotifier1 = 1'bx;
  end
  always @ NOT_AB2 begin
    AB_int[2] = 1'bx;
    if ( globalNotifier1 === 1'b0 ) globalNotifier1 = 1'bx;
  end
  always @ NOT_AB3 begin
    AB_int[3] = 1'bx;
    if ( globalNotifier1 === 1'b0 ) globalNotifier1 = 1'bx;
  end
  always @ NOT_AB4 begin
    AB_int[4] = 1'bx;
    if ( globalNotifier1 === 1'b0 ) globalNotifier1 = 1'bx;
  end
  always @ NOT_AB5 begin
    AB_int[5] = 1'bx;
    if ( globalNotifier1 === 1'b0 ) globalNotifier1 = 1'bx;
  end
  always @ NOT_AB6 begin
    AB_int[6] = 1'bx;
    if ( globalNotifier1 === 1'b0 ) globalNotifier1 = 1'bx;
  end
  always @ NOT_AB7 begin
    AB_int[7] = 1'bx;
    if ( globalNotifier1 === 1'b0 ) globalNotifier1 = 1'bx;
  end
  always @ NOT_AB8 begin
    AB_int[8] = 1'bx;
    if ( globalNotifier1 === 1'b0 ) globalNotifier1 = 1'bx;
  end
  always @ NOT_AB9 begin
    AB_int[9] = 1'bx;
    if ( globalNotifier1 === 1'b0 ) globalNotifier1 = 1'bx;
  end
  always @ NOT_CENA begin
    CENA_int = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_CENB begin
    CENB_int = 1'bx;
    if ( globalNotifier1 === 1'b0 ) globalNotifier1 = 1'bx;
  end
  always @ NOT_DA0 begin
    DA_int[0] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_DA10 begin
    DA_int[10] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_DA11 begin
    DA_int[11] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_DA12 begin
    DA_int[12] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_DA13 begin
    DA_int[13] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_DA14 begin
    DA_int[14] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_DA15 begin
    DA_int[15] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_DA16 begin
    DA_int[16] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_DA17 begin
    DA_int[17] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_DA18 begin
    DA_int[18] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_DA19 begin
    DA_int[19] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_DA1 begin
    DA_int[1] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_DA20 begin
    DA_int[20] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_DA21 begin
    DA_int[21] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_DA22 begin
    DA_int[22] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_DA23 begin
    DA_int[23] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_DA24 begin
    DA_int[24] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_DA25 begin
    DA_int[25] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_DA26 begin
    DA_int[26] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_DA27 begin
    DA_int[27] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_DA28 begin
    DA_int[28] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_DA29 begin
    DA_int[29] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_DA2 begin
    DA_int[2] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_DA30 begin
    DA_int[30] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_DA31 begin
    DA_int[31] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_DA3 begin
    DA_int[3] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_DA4 begin
    DA_int[4] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_DA5 begin
    DA_int[5] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_DA6 begin
    DA_int[6] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_DA7 begin
    DA_int[7] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_DA8 begin
    DA_int[8] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_DA9 begin
    DA_int[9] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_DB0 begin
    DB_int[0] = 1'bx;
    if ( globalNotifier1 === 1'b0 ) globalNotifier1 = 1'bx;
  end
  always @ NOT_DB10 begin
    DB_int[10] = 1'bx;
    if ( globalNotifier1 === 1'b0 ) globalNotifier1 = 1'bx;
  end
  always @ NOT_DB11 begin
    DB_int[11] = 1'bx;
    if ( globalNotifier1 === 1'b0 ) globalNotifier1 = 1'bx;
  end
  always @ NOT_DB12 begin
    DB_int[12] = 1'bx;
    if ( globalNotifier1 === 1'b0 ) globalNotifier1 = 1'bx;
  end
  always @ NOT_DB13 begin
    DB_int[13] = 1'bx;
    if ( globalNotifier1 === 1'b0 ) globalNotifier1 = 1'bx;
  end
  always @ NOT_DB14 begin
    DB_int[14] = 1'bx;
    if ( globalNotifier1 === 1'b0 ) globalNotifier1 = 1'bx;
  end
  always @ NOT_DB15 begin
    DB_int[15] = 1'bx;
    if ( globalNotifier1 === 1'b0 ) globalNotifier1 = 1'bx;
  end
  always @ NOT_DB16 begin
    DB_int[16] = 1'bx;
    if ( globalNotifier1 === 1'b0 ) globalNotifier1 = 1'bx;
  end
  always @ NOT_DB17 begin
    DB_int[17] = 1'bx;
    if ( globalNotifier1 === 1'b0 ) globalNotifier1 = 1'bx;
  end
  always @ NOT_DB18 begin
    DB_int[18] = 1'bx;
    if ( globalNotifier1 === 1'b0 ) globalNotifier1 = 1'bx;
  end
  always @ NOT_DB19 begin
    DB_int[19] = 1'bx;
    if ( globalNotifier1 === 1'b0 ) globalNotifier1 = 1'bx;
  end
  always @ NOT_DB1 begin
    DB_int[1] = 1'bx;
    if ( globalNotifier1 === 1'b0 ) globalNotifier1 = 1'bx;
  end
  always @ NOT_DB20 begin
    DB_int[20] = 1'bx;
    if ( globalNotifier1 === 1'b0 ) globalNotifier1 = 1'bx;
  end
  always @ NOT_DB21 begin
    DB_int[21] = 1'bx;
    if ( globalNotifier1 === 1'b0 ) globalNotifier1 = 1'bx;
  end
  always @ NOT_DB22 begin
    DB_int[22] = 1'bx;
    if ( globalNotifier1 === 1'b0 ) globalNotifier1 = 1'bx;
  end
  always @ NOT_DB23 begin
    DB_int[23] = 1'bx;
    if ( globalNotifier1 === 1'b0 ) globalNotifier1 = 1'bx;
  end
  always @ NOT_DB24 begin
    DB_int[24] = 1'bx;
    if ( globalNotifier1 === 1'b0 ) globalNotifier1 = 1'bx;
  end
  always @ NOT_DB25 begin
    DB_int[25] = 1'bx;
    if ( globalNotifier1 === 1'b0 ) globalNotifier1 = 1'bx;
  end
  always @ NOT_DB26 begin
    DB_int[26] = 1'bx;
    if ( globalNotifier1 === 1'b0 ) globalNotifier1 = 1'bx;
  end
  always @ NOT_DB27 begin
    DB_int[27] = 1'bx;
    if ( globalNotifier1 === 1'b0 ) globalNotifier1 = 1'bx;
  end
  always @ NOT_DB28 begin
    DB_int[28] = 1'bx;
    if ( globalNotifier1 === 1'b0 ) globalNotifier1 = 1'bx;
  end
  always @ NOT_DB29 begin
    DB_int[29] = 1'bx;
    if ( globalNotifier1 === 1'b0 ) globalNotifier1 = 1'bx;
  end
  always @ NOT_DB2 begin
    DB_int[2] = 1'bx;
    if ( globalNotifier1 === 1'b0 ) globalNotifier1 = 1'bx;
  end
  always @ NOT_DB30 begin
    DB_int[30] = 1'bx;
    if ( globalNotifier1 === 1'b0 ) globalNotifier1 = 1'bx;
  end
  always @ NOT_DB31 begin
    DB_int[31] = 1'bx;
    if ( globalNotifier1 === 1'b0 ) globalNotifier1 = 1'bx;
  end
  always @ NOT_DB3 begin
    DB_int[3] = 1'bx;
    if ( globalNotifier1 === 1'b0 ) globalNotifier1 = 1'bx;
  end
  always @ NOT_DB4 begin
    DB_int[4] = 1'bx;
    if ( globalNotifier1 === 1'b0 ) globalNotifier1 = 1'bx;
  end
  always @ NOT_DB5 begin
    DB_int[5] = 1'bx;
    if ( globalNotifier1 === 1'b0 ) globalNotifier1 = 1'bx;
  end
  always @ NOT_DB6 begin
    DB_int[6] = 1'bx;
    if ( globalNotifier1 === 1'b0 ) globalNotifier1 = 1'bx;
  end
  always @ NOT_DB7 begin
    DB_int[7] = 1'bx;
    if ( globalNotifier1 === 1'b0 ) globalNotifier1 = 1'bx;
  end
  always @ NOT_DB8 begin
    DB_int[8] = 1'bx;
    if ( globalNotifier1 === 1'b0 ) globalNotifier1 = 1'bx;
  end
  always @ NOT_DB9 begin
    DB_int[9] = 1'bx;
    if ( globalNotifier1 === 1'b0 ) globalNotifier1 = 1'bx;
  end
  always @ NOT_EMAA0 begin
    EMAA_int[0] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_EMAA1 begin
    EMAA_int[1] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_EMAA2 begin
    EMAA_int[2] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_EMAB0 begin
    EMAB_int[0] = 1'bx;
    if ( globalNotifier1 === 1'b0 ) globalNotifier1 = 1'bx;
  end
  always @ NOT_EMAB1 begin
    EMAB_int[1] = 1'bx;
    if ( globalNotifier1 === 1'b0 ) globalNotifier1 = 1'bx;
  end
  always @ NOT_EMAB2 begin
    EMAB_int[2] = 1'bx;
    if ( globalNotifier1 === 1'b0 ) globalNotifier1 = 1'bx;
  end
  always @ NOT_GWENA begin
    GWENA_int = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_GWENB begin
    GWENB_int = 1'bx;
    if ( globalNotifier1 === 1'b0 ) globalNotifier1 = 1'bx;
  end
  always @ NOT_RETN begin
    RETN_int = 1'bx;
    if( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
    if( globalNotifier1 === 1'b0 ) globalNotifier1 = 1'bx;
  end
  always @ NOT_RETNA begin
    RETN_int = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_RETNB begin
    RETN_int = 1'bx;
    if ( globalNotifier1 === 1'b0 ) globalNotifier1 = 1'bx;
  end
  always @ NOT_WENA0 begin
    WENA_int[0] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_WENA1 begin
    WENA_int[1] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_WENA2 begin
    WENA_int[2] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_WENA3 begin
    WENA_int[3] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_WENB0 begin
    WENB_int[0] = 1'bx;
    if ( globalNotifier1 === 1'b0 ) globalNotifier1 = 1'bx;
  end
  always @ NOT_WENB1 begin
    WENB_int[1] = 1'bx;
    if ( globalNotifier1 === 1'b0 ) globalNotifier1 = 1'bx;
  end
  always @ NOT_WENB2 begin
    WENB_int[2] = 1'bx;
    if ( globalNotifier1 === 1'b0 ) globalNotifier1 = 1'bx;
  end
  always @ NOT_WENB3 begin
    WENB_int[3] = 1'bx;
    if ( globalNotifier1 === 1'b0 ) globalNotifier1 = 1'bx;
  end
  always @ NOT_CLKA_MINH begin
    clk0_int = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_CLKA_MINL begin
    clk0_int = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_CLKA_PER begin
    clk0_int = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_CLKB_MINH begin
    clk1_int = 1'bx;
    if ( globalNotifier1 === 1'b0 ) globalNotifier1 = 1'bx;
  end
  always @ NOT_CLKB_MINL begin
    clk1_int = 1'bx;
    if ( globalNotifier1 === 1'b0 ) globalNotifier1 = 1'bx;
  end
  always @ NOT_CLKB_PER begin
    clk1_int = 1'bx;
    if ( globalNotifier1 === 1'b0 ) globalNotifier1 = 1'bx;
  end
  always @ NOT_CONTA begin
    cont_flag0_int = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_CONTB begin
    cont_flag1_int = 1'bx;
    if ( globalNotifier1 === 1'b0 ) globalNotifier1 = 1'bx;
  end

  function is_contention;
    input [9:0] aa;
    input [9:0] ab;
    input [3:0] wena;
    input [3:0] wenb;
    reg result;
  begin
    if ((& wena) === 1'b1 && (& wenb) === 1'b1) begin
      result = 1'b0;
    end else if (aa == ab) begin
      result = 1'b1;
    end else begin
      result = 1'b0;
    end
    is_contention = result;
  end
  endfunction

   wire contA_flag = is_contention(AB_, AA_int, ({4{GWENB_}}|WENB_), ({4{GWENA_int}}|WENA_int)) & (CENB_ !== 1'b1 && CENA_int !== 1'b1);
   wire contB_flag = is_contention(AA_, AB_int, ({4{GWENA_}}|WENA_), ({4{GWENB_int}}|WENB_int)) & (CENA_ !== 1'b1 && CENB_int !== 1'b1);

  wire CENA_flag;
  wire flagA;
  wire DA_flag0;
  wire DA_flag1;
  wire DA_flag2;
  wire DA_flag3;
  wire DA_flag4;
  wire DA_flag5;
  wire DA_flag6;
  wire DA_flag7;
  wire DA_flag8;
  wire DA_flag9;
  wire DA_flag10;
  wire DA_flag11;
  wire DA_flag12;
  wire DA_flag13;
  wire DA_flag14;
  wire DA_flag15;
  wire DA_flag16;
  wire DA_flag17;
  wire DA_flag18;
  wire DA_flag19;
  wire DA_flag20;
  wire DA_flag21;
  wire DA_flag22;
  wire DA_flag23;
  wire DA_flag24;
  wire DA_flag25;
  wire DA_flag26;
  wire DA_flag27;
  wire DA_flag28;
  wire DA_flag29;
  wire DA_flag30;
  wire DA_flag31;
  wire cyc_flagA;
  wire CENB_flag;
  wire flagB;
  wire DB_flag0;
  wire DB_flag1;
  wire DB_flag2;
  wire DB_flag3;
  wire DB_flag4;
  wire DB_flag5;
  wire DB_flag6;
  wire DB_flag7;
  wire DB_flag8;
  wire DB_flag9;
  wire DB_flag10;
  wire DB_flag11;
  wire DB_flag12;
  wire DB_flag13;
  wire DB_flag14;
  wire DB_flag15;
  wire DB_flag16;
  wire DB_flag17;
  wire DB_flag18;
  wire DB_flag19;
  wire DB_flag20;
  wire DB_flag21;
  wire DB_flag22;
  wire DB_flag23;
  wire DB_flag24;
  wire DB_flag25;
  wire DB_flag26;
  wire DB_flag27;
  wire DB_flag28;
  wire DB_flag29;
  wire DB_flag30;
  wire DB_flag31;
  wire cyc_flagB;
  wire contA_EMAA2eq0andEMAA1eq0andEMAA0eq0;
  wire contA_EMAA2eq0andEMAA1eq0andEMAA0eq1;
  wire contA_EMAA2eq0andEMAA1eq1andEMAA0eq0;
  wire contA_EMAA2eq0andEMAA1eq1andEMAA0eq1;
  wire contA_EMAA2eq1andEMAA1eq0andEMAA0eq0;
  wire contA_EMAA2eq1andEMAA1eq0andEMAA0eq1;
  wire contA_EMAA2eq1andEMAA1eq1andEMAA0eq0;
  wire contA_EMAA2eq1andEMAA1eq1andEMAA0eq1;
  wire contB_EMAB2eq0andEMAB1eq0andEMAB0eq0;
  wire contB_EMAB2eq0andEMAB1eq0andEMAB0eq1;
  wire contB_EMAB2eq0andEMAB1eq1andEMAB0eq0;
  wire contB_EMAB2eq0andEMAB1eq1andEMAB0eq1;
  wire contB_EMAB2eq1andEMAB1eq0andEMAB0eq0;
  wire contB_EMAB2eq1andEMAB1eq0andEMAB0eq1;
  wire contB_EMAB2eq1andEMAB1eq1andEMAB0eq0;
  wire contB_EMAB2eq1andEMAB1eq1andEMAB0eq1;
  wire EMAA2eq0andEMAA1eq0andEMAA0eq0;
  wire EMAA2eq0andEMAA1eq0andEMAA0eq1;
  wire EMAA2eq0andEMAA1eq1andEMAA0eq0;
  wire EMAA2eq0andEMAA1eq1andEMAA0eq1;
  wire EMAA2eq1andEMAA1eq0andEMAA0eq0;
  wire EMAA2eq1andEMAA1eq0andEMAA0eq1;
  wire EMAA2eq1andEMAA1eq1andEMAA0eq0;
  wire EMAA2eq1andEMAA1eq1andEMAA0eq1;
  wire EMAB2eq0andEMAB1eq0andEMAB0eq0;
  wire EMAB2eq0andEMAB1eq0andEMAB0eq1;
  wire EMAB2eq0andEMAB1eq1andEMAB0eq0;
  wire EMAB2eq0andEMAB1eq1andEMAB0eq1;
  wire EMAB2eq1andEMAB1eq0andEMAB0eq0;
  wire EMAB2eq1andEMAB1eq0andEMAB0eq1;
  wire EMAB2eq1andEMAB1eq1andEMAB0eq0;
  wire EMAB2eq1andEMAB1eq1andEMAB0eq1;
  assign CENA_flag = 1'b1;
  assign flagA = !CENA_;
  assign DA_flag0 = !(CENA_ || WENA_[0] || GWENA_);
  assign DA_flag1 = !(CENA_ || WENA_[0] || GWENA_);
  assign DA_flag2 = !(CENA_ || WENA_[0] || GWENA_);
  assign DA_flag3 = !(CENA_ || WENA_[0] || GWENA_);
  assign DA_flag4 = !(CENA_ || WENA_[0] || GWENA_);
  assign DA_flag5 = !(CENA_ || WENA_[0] || GWENA_);
  assign DA_flag6 = !(CENA_ || WENA_[0] || GWENA_);
  assign DA_flag7 = !(CENA_ || WENA_[0] || GWENA_);
  assign DA_flag8 = !(CENA_ || WENA_[1] || GWENA_);
  assign DA_flag9 = !(CENA_ || WENA_[1] || GWENA_);
  assign DA_flag10 = !(CENA_ || WENA_[1] || GWENA_);
  assign DA_flag11 = !(CENA_ || WENA_[1] || GWENA_);
  assign DA_flag12 = !(CENA_ || WENA_[1] || GWENA_);
  assign DA_flag13 = !(CENA_ || WENA_[1] || GWENA_);
  assign DA_flag14 = !(CENA_ || WENA_[1] || GWENA_);
  assign DA_flag15 = !(CENA_ || WENA_[1] || GWENA_);
  assign DA_flag16 = !(CENA_ || WENA_[2] || GWENA_);
  assign DA_flag17 = !(CENA_ || WENA_[2] || GWENA_);
  assign DA_flag18 = !(CENA_ || WENA_[2] || GWENA_);
  assign DA_flag19 = !(CENA_ || WENA_[2] || GWENA_);
  assign DA_flag20 = !(CENA_ || WENA_[2] || GWENA_);
  assign DA_flag21 = !(CENA_ || WENA_[2] || GWENA_);
  assign DA_flag22 = !(CENA_ || WENA_[2] || GWENA_);
  assign DA_flag23 = !(CENA_ || WENA_[2] || GWENA_);
  assign DA_flag24 = !(CENA_ || WENA_[3] || GWENA_);
  assign DA_flag25 = !(CENA_ || WENA_[3] || GWENA_);
  assign DA_flag26 = !(CENA_ || WENA_[3] || GWENA_);
  assign DA_flag27 = !(CENA_ || WENA_[3] || GWENA_);
  assign DA_flag28 = !(CENA_ || WENA_[3] || GWENA_);
  assign DA_flag29 = !(CENA_ || WENA_[3] || GWENA_);
  assign DA_flag30 = !(CENA_ || WENA_[3] || GWENA_);
  assign DA_flag31 = !(CENA_ || WENA_[3] || GWENA_);
  assign cyc_flagA = !CENA_;
  assign CENB_flag = 1'b1;
  assign flagB = !CENB_;
  assign DB_flag0 = !(CENB_ || WENB_[0] || GWENB_);
  assign DB_flag1 = !(CENB_ || WENB_[0] || GWENB_);
  assign DB_flag2 = !(CENB_ || WENB_[0] || GWENB_);
  assign DB_flag3 = !(CENB_ || WENB_[0] || GWENB_);
  assign DB_flag4 = !(CENB_ || WENB_[0] || GWENB_);
  assign DB_flag5 = !(CENB_ || WENB_[0] || GWENB_);
  assign DB_flag6 = !(CENB_ || WENB_[0] || GWENB_);
  assign DB_flag7 = !(CENB_ || WENB_[0] || GWENB_);
  assign DB_flag8 = !(CENB_ || WENB_[1] || GWENB_);
  assign DB_flag9 = !(CENB_ || WENB_[1] || GWENB_);
  assign DB_flag10 = !(CENB_ || WENB_[1] || GWENB_);
  assign DB_flag11 = !(CENB_ || WENB_[1] || GWENB_);
  assign DB_flag12 = !(CENB_ || WENB_[1] || GWENB_);
  assign DB_flag13 = !(CENB_ || WENB_[1] || GWENB_);
  assign DB_flag14 = !(CENB_ || WENB_[1] || GWENB_);
  assign DB_flag15 = !(CENB_ || WENB_[1] || GWENB_);
  assign DB_flag16 = !(CENB_ || WENB_[2] || GWENB_);
  assign DB_flag17 = !(CENB_ || WENB_[2] || GWENB_);
  assign DB_flag18 = !(CENB_ || WENB_[2] || GWENB_);
  assign DB_flag19 = !(CENB_ || WENB_[2] || GWENB_);
  assign DB_flag20 = !(CENB_ || WENB_[2] || GWENB_);
  assign DB_flag21 = !(CENB_ || WENB_[2] || GWENB_);
  assign DB_flag22 = !(CENB_ || WENB_[2] || GWENB_);
  assign DB_flag23 = !(CENB_ || WENB_[2] || GWENB_);
  assign DB_flag24 = !(CENB_ || WENB_[3] || GWENB_);
  assign DB_flag25 = !(CENB_ || WENB_[3] || GWENB_);
  assign DB_flag26 = !(CENB_ || WENB_[3] || GWENB_);
  assign DB_flag27 = !(CENB_ || WENB_[3] || GWENB_);
  assign DB_flag28 = !(CENB_ || WENB_[3] || GWENB_);
  assign DB_flag29 = !(CENB_ || WENB_[3] || GWENB_);
  assign DB_flag30 = !(CENB_ || WENB_[3] || GWENB_);
  assign DB_flag31 = !(CENB_ || WENB_[3] || GWENB_);
  assign cyc_flagB = !CENB_;
  assign contA_EMAA2eq0andEMAA1eq0andEMAA0eq0 = EMAA2eq0andEMAA1eq0andEMAA0eq0 && contA_flag;
  assign contA_EMAA2eq0andEMAA1eq0andEMAA0eq1 = EMAA2eq0andEMAA1eq0andEMAA0eq1 && contA_flag;
  assign contA_EMAA2eq0andEMAA1eq1andEMAA0eq0 = EMAA2eq0andEMAA1eq1andEMAA0eq0 && contA_flag;
  assign contA_EMAA2eq0andEMAA1eq1andEMAA0eq1 = EMAA2eq0andEMAA1eq1andEMAA0eq1 && contA_flag;
  assign contA_EMAA2eq1andEMAA1eq0andEMAA0eq0 = EMAA2eq1andEMAA1eq0andEMAA0eq0 && contA_flag;
  assign contA_EMAA2eq1andEMAA1eq0andEMAA0eq1 = EMAA2eq1andEMAA1eq0andEMAA0eq1 && contA_flag;
  assign contA_EMAA2eq1andEMAA1eq1andEMAA0eq0 = EMAA2eq1andEMAA1eq1andEMAA0eq0 && contA_flag;
  assign contA_EMAA2eq1andEMAA1eq1andEMAA0eq1 = EMAA2eq1andEMAA1eq1andEMAA0eq1 && contA_flag;
  assign contB_EMAB2eq0andEMAB1eq0andEMAB0eq0 = EMAB2eq0andEMAB1eq0andEMAB0eq0 && contB_flag;
  assign contB_EMAB2eq0andEMAB1eq0andEMAB0eq1 = EMAB2eq0andEMAB1eq0andEMAB0eq1 && contB_flag;
  assign contB_EMAB2eq0andEMAB1eq1andEMAB0eq0 = EMAB2eq0andEMAB1eq1andEMAB0eq0 && contB_flag;
  assign contB_EMAB2eq0andEMAB1eq1andEMAB0eq1 = EMAB2eq0andEMAB1eq1andEMAB0eq1 && contB_flag;
  assign contB_EMAB2eq1andEMAB1eq0andEMAB0eq0 = EMAB2eq1andEMAB1eq0andEMAB0eq0 && contB_flag;
  assign contB_EMAB2eq1andEMAB1eq0andEMAB0eq1 = EMAB2eq1andEMAB1eq0andEMAB0eq1 && contB_flag;
  assign contB_EMAB2eq1andEMAB1eq1andEMAB0eq0 = EMAB2eq1andEMAB1eq1andEMAB0eq0 && contB_flag;
  assign contB_EMAB2eq1andEMAB1eq1andEMAB0eq1 = EMAB2eq1andEMAB1eq1andEMAB0eq1 && contB_flag;
  assign EMAA2eq0andEMAA1eq0andEMAA0eq0 = !EMAA_[2] && !EMAA_[1] && !EMAA_[0] && cyc_flagA;
  assign EMAA2eq0andEMAA1eq0andEMAA0eq1 = !EMAA_[2] && !EMAA_[1] && EMAA_[0] && cyc_flagA;
  assign EMAA2eq0andEMAA1eq1andEMAA0eq0 = !EMAA_[2] && EMAA_[1] && !EMAA_[0] && cyc_flagA;
  assign EMAA2eq0andEMAA1eq1andEMAA0eq1 = !EMAA_[2] && EMAA_[1] && EMAA_[0] && cyc_flagA;
  assign EMAA2eq1andEMAA1eq0andEMAA0eq0 = EMAA_[2] && !EMAA_[1] && !EMAA_[0] && cyc_flagA;
  assign EMAA2eq1andEMAA1eq0andEMAA0eq1 = EMAA_[2] && !EMAA_[1] && EMAA_[0] && cyc_flagA;
  assign EMAA2eq1andEMAA1eq1andEMAA0eq0 = EMAA_[2] && EMAA_[1] && !EMAA_[0] && cyc_flagA;
  assign EMAA2eq1andEMAA1eq1andEMAA0eq1 = EMAA_[2] && EMAA_[1] && EMAA_[0] && cyc_flagA;
  assign EMAB2eq0andEMAB1eq0andEMAB0eq0 = !EMAB_[2] && !EMAB_[1] && !EMAB_[0] && cyc_flagB;
  assign EMAB2eq0andEMAB1eq0andEMAB0eq1 = !EMAB_[2] && !EMAB_[1] && EMAB_[0] && cyc_flagB;
  assign EMAB2eq0andEMAB1eq1andEMAB0eq0 = !EMAB_[2] && EMAB_[1] && !EMAB_[0] && cyc_flagB;
  assign EMAB2eq0andEMAB1eq1andEMAB0eq1 = !EMAB_[2] && EMAB_[1] && EMAB_[0] && cyc_flagB;
  assign EMAB2eq1andEMAB1eq0andEMAB0eq0 = EMAB_[2] && !EMAB_[1] && !EMAB_[0] && cyc_flagB;
  assign EMAB2eq1andEMAB1eq0andEMAB0eq1 = EMAB_[2] && !EMAB_[1] && EMAB_[0] && cyc_flagB;
  assign EMAB2eq1andEMAB1eq1andEMAB0eq0 = EMAB_[2] && EMAB_[1] && !EMAB_[0] && cyc_flagB;
  assign EMAB2eq1andEMAB1eq1andEMAB0eq1 = EMAB_[2] && EMAB_[1] && EMAB_[0] && cyc_flagB;

  specify
      $hold(posedge CENA, negedge RETN, 1.000, NOT_RETN);
      $setuphold(posedge CLKA &&& CENA_flag, posedge CENA, 1.000, 0.500, NOT_CENA);
      $setuphold(posedge CLKA &&& CENA_flag, negedge CENA, 1.000, 0.500, NOT_CENA);
      $setuphold(posedge CLKA &&& flagA, posedge WENA[3], 1.000, 0.500, NOT_WENA3);
      $setuphold(posedge CLKA &&& flagA, negedge WENA[3], 1.000, 0.500, NOT_WENA3);
      $setuphold(posedge CLKA &&& flagA, posedge WENA[2], 1.000, 0.500, NOT_WENA2);
      $setuphold(posedge CLKA &&& flagA, negedge WENA[2], 1.000, 0.500, NOT_WENA2);
      $setuphold(posedge CLKA &&& flagA, posedge WENA[1], 1.000, 0.500, NOT_WENA1);
      $setuphold(posedge CLKA &&& flagA, negedge WENA[1], 1.000, 0.500, NOT_WENA1);
      $setuphold(posedge CLKA &&& flagA, posedge WENA[0], 1.000, 0.500, NOT_WENA0);
      $setuphold(posedge CLKA &&& flagA, negedge WENA[0], 1.000, 0.500, NOT_WENA0);
      $setuphold(posedge CLKA &&& flagA, posedge GWENA, 1.000, 0.500, NOT_GWENA);
      $setuphold(posedge CLKA &&& flagA, negedge GWENA, 1.000, 0.500, NOT_GWENA);
      $setuphold(posedge CLKA &&& flagA, posedge AA[9], 1.000, 0.500, NOT_AA9);
      $setuphold(posedge CLKA &&& flagA, negedge AA[9], 1.000, 0.500, NOT_AA9);
      $setuphold(posedge CLKA &&& flagA, posedge AA[8], 1.000, 0.500, NOT_AA8);
      $setuphold(posedge CLKA &&& flagA, negedge AA[8], 1.000, 0.500, NOT_AA8);
      $setuphold(posedge CLKA &&& flagA, posedge AA[7], 1.000, 0.500, NOT_AA7);
      $setuphold(posedge CLKA &&& flagA, negedge AA[7], 1.000, 0.500, NOT_AA7);
      $setuphold(posedge CLKA &&& flagA, posedge AA[6], 1.000, 0.500, NOT_AA6);
      $setuphold(posedge CLKA &&& flagA, negedge AA[6], 1.000, 0.500, NOT_AA6);
      $setuphold(posedge CLKA &&& flagA, posedge AA[5], 1.000, 0.500, NOT_AA5);
      $setuphold(posedge CLKA &&& flagA, negedge AA[5], 1.000, 0.500, NOT_AA5);
      $setuphold(posedge CLKA &&& flagA, posedge AA[4], 1.000, 0.500, NOT_AA4);
      $setuphold(posedge CLKA &&& flagA, negedge AA[4], 1.000, 0.500, NOT_AA4);
      $setuphold(posedge CLKA &&& flagA, posedge AA[3], 1.000, 0.500, NOT_AA3);
      $setuphold(posedge CLKA &&& flagA, negedge AA[3], 1.000, 0.500, NOT_AA3);
      $setuphold(posedge CLKA &&& flagA, posedge AA[2], 1.000, 0.500, NOT_AA2);
      $setuphold(posedge CLKA &&& flagA, negedge AA[2], 1.000, 0.500, NOT_AA2);
      $setuphold(posedge CLKA &&& flagA, posedge AA[1], 1.000, 0.500, NOT_AA1);
      $setuphold(posedge CLKA &&& flagA, negedge AA[1], 1.000, 0.500, NOT_AA1);
      $setuphold(posedge CLKA &&& flagA, posedge AA[0], 1.000, 0.500, NOT_AA0);
      $setuphold(posedge CLKA &&& flagA, negedge AA[0], 1.000, 0.500, NOT_AA0);
      $setuphold(posedge CLKA &&& DA_flag31, posedge DA[31], 1.000, 0.500, NOT_DA31);
      $setuphold(posedge CLKA &&& DA_flag31, negedge DA[31], 1.000, 0.500, NOT_DA31);
      $setuphold(posedge CLKA &&& DA_flag30, posedge DA[30], 1.000, 0.500, NOT_DA30);
      $setuphold(posedge CLKA &&& DA_flag30, negedge DA[30], 1.000, 0.500, NOT_DA30);
      $setuphold(posedge CLKA &&& DA_flag29, posedge DA[29], 1.000, 0.500, NOT_DA29);
      $setuphold(posedge CLKA &&& DA_flag29, negedge DA[29], 1.000, 0.500, NOT_DA29);
      $setuphold(posedge CLKA &&& DA_flag28, posedge DA[28], 1.000, 0.500, NOT_DA28);
      $setuphold(posedge CLKA &&& DA_flag28, negedge DA[28], 1.000, 0.500, NOT_DA28);
      $setuphold(posedge CLKA &&& DA_flag27, posedge DA[27], 1.000, 0.500, NOT_DA27);
      $setuphold(posedge CLKA &&& DA_flag27, negedge DA[27], 1.000, 0.500, NOT_DA27);
      $setuphold(posedge CLKA &&& DA_flag26, posedge DA[26], 1.000, 0.500, NOT_DA26);
      $setuphold(posedge CLKA &&& DA_flag26, negedge DA[26], 1.000, 0.500, NOT_DA26);
      $setuphold(posedge CLKA &&& DA_flag25, posedge DA[25], 1.000, 0.500, NOT_DA25);
      $setuphold(posedge CLKA &&& DA_flag25, negedge DA[25], 1.000, 0.500, NOT_DA25);
      $setuphold(posedge CLKA &&& DA_flag24, posedge DA[24], 1.000, 0.500, NOT_DA24);
      $setuphold(posedge CLKA &&& DA_flag24, negedge DA[24], 1.000, 0.500, NOT_DA24);
      $setuphold(posedge CLKA &&& DA_flag23, posedge DA[23], 1.000, 0.500, NOT_DA23);
      $setuphold(posedge CLKA &&& DA_flag23, negedge DA[23], 1.000, 0.500, NOT_DA23);
      $setuphold(posedge CLKA &&& DA_flag22, posedge DA[22], 1.000, 0.500, NOT_DA22);
      $setuphold(posedge CLKA &&& DA_flag22, negedge DA[22], 1.000, 0.500, NOT_DA22);
      $setuphold(posedge CLKA &&& DA_flag21, posedge DA[21], 1.000, 0.500, NOT_DA21);
      $setuphold(posedge CLKA &&& DA_flag21, negedge DA[21], 1.000, 0.500, NOT_DA21);
      $setuphold(posedge CLKA &&& DA_flag20, posedge DA[20], 1.000, 0.500, NOT_DA20);
      $setuphold(posedge CLKA &&& DA_flag20, negedge DA[20], 1.000, 0.500, NOT_DA20);
      $setuphold(posedge CLKA &&& DA_flag19, posedge DA[19], 1.000, 0.500, NOT_DA19);
      $setuphold(posedge CLKA &&& DA_flag19, negedge DA[19], 1.000, 0.500, NOT_DA19);
      $setuphold(posedge CLKA &&& DA_flag18, posedge DA[18], 1.000, 0.500, NOT_DA18);
      $setuphold(posedge CLKA &&& DA_flag18, negedge DA[18], 1.000, 0.500, NOT_DA18);
      $setuphold(posedge CLKA &&& DA_flag17, posedge DA[17], 1.000, 0.500, NOT_DA17);
      $setuphold(posedge CLKA &&& DA_flag17, negedge DA[17], 1.000, 0.500, NOT_DA17);
      $setuphold(posedge CLKA &&& DA_flag16, posedge DA[16], 1.000, 0.500, NOT_DA16);
      $setuphold(posedge CLKA &&& DA_flag16, negedge DA[16], 1.000, 0.500, NOT_DA16);
      $setuphold(posedge CLKA &&& DA_flag15, posedge DA[15], 1.000, 0.500, NOT_DA15);
      $setuphold(posedge CLKA &&& DA_flag15, negedge DA[15], 1.000, 0.500, NOT_DA15);
      $setuphold(posedge CLKA &&& DA_flag14, posedge DA[14], 1.000, 0.500, NOT_DA14);
      $setuphold(posedge CLKA &&& DA_flag14, negedge DA[14], 1.000, 0.500, NOT_DA14);
      $setuphold(posedge CLKA &&& DA_flag13, posedge DA[13], 1.000, 0.500, NOT_DA13);
      $setuphold(posedge CLKA &&& DA_flag13, negedge DA[13], 1.000, 0.500, NOT_DA13);
      $setuphold(posedge CLKA &&& DA_flag12, posedge DA[12], 1.000, 0.500, NOT_DA12);
      $setuphold(posedge CLKA &&& DA_flag12, negedge DA[12], 1.000, 0.500, NOT_DA12);
      $setuphold(posedge CLKA &&& DA_flag11, posedge DA[11], 1.000, 0.500, NOT_DA11);
      $setuphold(posedge CLKA &&& DA_flag11, negedge DA[11], 1.000, 0.500, NOT_DA11);
      $setuphold(posedge CLKA &&& DA_flag10, posedge DA[10], 1.000, 0.500, NOT_DA10);
      $setuphold(posedge CLKA &&& DA_flag10, negedge DA[10], 1.000, 0.500, NOT_DA10);
      $setuphold(posedge CLKA &&& DA_flag9, posedge DA[9], 1.000, 0.500, NOT_DA9);
      $setuphold(posedge CLKA &&& DA_flag9, negedge DA[9], 1.000, 0.500, NOT_DA9);
      $setuphold(posedge CLKA &&& DA_flag8, posedge DA[8], 1.000, 0.500, NOT_DA8);
      $setuphold(posedge CLKA &&& DA_flag8, negedge DA[8], 1.000, 0.500, NOT_DA8);
      $setuphold(posedge CLKA &&& DA_flag7, posedge DA[7], 1.000, 0.500, NOT_DA7);
      $setuphold(posedge CLKA &&& DA_flag7, negedge DA[7], 1.000, 0.500, NOT_DA7);
      $setuphold(posedge CLKA &&& DA_flag6, posedge DA[6], 1.000, 0.500, NOT_DA6);
      $setuphold(posedge CLKA &&& DA_flag6, negedge DA[6], 1.000, 0.500, NOT_DA6);
      $setuphold(posedge CLKA &&& DA_flag5, posedge DA[5], 1.000, 0.500, NOT_DA5);
      $setuphold(posedge CLKA &&& DA_flag5, negedge DA[5], 1.000, 0.500, NOT_DA5);
      $setuphold(posedge CLKA &&& DA_flag4, posedge DA[4], 1.000, 0.500, NOT_DA4);
      $setuphold(posedge CLKA &&& DA_flag4, negedge DA[4], 1.000, 0.500, NOT_DA4);
      $setuphold(posedge CLKA &&& DA_flag3, posedge DA[3], 1.000, 0.500, NOT_DA3);
      $setuphold(posedge CLKA &&& DA_flag3, negedge DA[3], 1.000, 0.500, NOT_DA3);
      $setuphold(posedge CLKA &&& DA_flag2, posedge DA[2], 1.000, 0.500, NOT_DA2);
      $setuphold(posedge CLKA &&& DA_flag2, negedge DA[2], 1.000, 0.500, NOT_DA2);
      $setuphold(posedge CLKA &&& DA_flag1, posedge DA[1], 1.000, 0.500, NOT_DA1);
      $setuphold(posedge CLKA &&& DA_flag1, negedge DA[1], 1.000, 0.500, NOT_DA1);
      $setuphold(posedge CLKA &&& DA_flag0, posedge DA[0], 1.000, 0.500, NOT_DA0);
      $setuphold(posedge CLKA &&& DA_flag0, negedge DA[0], 1.000, 0.500, NOT_DA0);
      $setuphold(posedge CLKA &&& cyc_flagA, posedge EMAA[2], 1.000, 0.500, NOT_EMAA2);
      $setuphold(posedge CLKA &&& cyc_flagA, negedge EMAA[2], 1.000, 0.500, NOT_EMAA2);
      $setuphold(posedge CLKA &&& cyc_flagA, posedge EMAA[1], 1.000, 0.500, NOT_EMAA1);
      $setuphold(posedge CLKA &&& cyc_flagA, negedge EMAA[1], 1.000, 0.500, NOT_EMAA1);
      $setuphold(posedge CLKA &&& cyc_flagA, posedge EMAA[0], 1.000, 0.500, NOT_EMAA0);
      $setuphold(posedge CLKA &&& cyc_flagA, negedge EMAA[0], 1.000, 0.500, NOT_EMAA0);
      $setuphold(posedge CLKA, posedge RETN, 1.000, 0.500, NOT_RETNA);
      $setuphold(posedge CLKA, negedge RETN, 1.000, 0.500, NOT_RETNA);
      $hold(posedge RETN, negedge CENA, 1.000, NOT_RETN);
      $hold(posedge CENB, negedge RETN, 1.000, NOT_RETN);
      $setuphold(posedge CLKB &&& CENB_flag, posedge CENB, 1.000, 0.500, NOT_CENB);
      $setuphold(posedge CLKB &&& CENB_flag, negedge CENB, 1.000, 0.500, NOT_CENB);
      $setuphold(posedge CLKB &&& flagB, posedge WENB[3], 1.000, 0.500, NOT_WENB3);
      $setuphold(posedge CLKB &&& flagB, negedge WENB[3], 1.000, 0.500, NOT_WENB3);
      $setuphold(posedge CLKB &&& flagB, posedge WENB[2], 1.000, 0.500, NOT_WENB2);
      $setuphold(posedge CLKB &&& flagB, negedge WENB[2], 1.000, 0.500, NOT_WENB2);
      $setuphold(posedge CLKB &&& flagB, posedge WENB[1], 1.000, 0.500, NOT_WENB1);
      $setuphold(posedge CLKB &&& flagB, negedge WENB[1], 1.000, 0.500, NOT_WENB1);
      $setuphold(posedge CLKB &&& flagB, posedge WENB[0], 1.000, 0.500, NOT_WENB0);
      $setuphold(posedge CLKB &&& flagB, negedge WENB[0], 1.000, 0.500, NOT_WENB0);
      $setuphold(posedge CLKB &&& flagB, posedge GWENB, 1.000, 0.500, NOT_GWENB);
      $setuphold(posedge CLKB &&& flagB, negedge GWENB, 1.000, 0.500, NOT_GWENB);
      $setuphold(posedge CLKB &&& flagB, posedge AB[9], 1.000, 0.500, NOT_AB9);
      $setuphold(posedge CLKB &&& flagB, negedge AB[9], 1.000, 0.500, NOT_AB9);
      $setuphold(posedge CLKB &&& flagB, posedge AB[8], 1.000, 0.500, NOT_AB8);
      $setuphold(posedge CLKB &&& flagB, negedge AB[8], 1.000, 0.500, NOT_AB8);
      $setuphold(posedge CLKB &&& flagB, posedge AB[7], 1.000, 0.500, NOT_AB7);
      $setuphold(posedge CLKB &&& flagB, negedge AB[7], 1.000, 0.500, NOT_AB7);
      $setuphold(posedge CLKB &&& flagB, posedge AB[6], 1.000, 0.500, NOT_AB6);
      $setuphold(posedge CLKB &&& flagB, negedge AB[6], 1.000, 0.500, NOT_AB6);
      $setuphold(posedge CLKB &&& flagB, posedge AB[5], 1.000, 0.500, NOT_AB5);
      $setuphold(posedge CLKB &&& flagB, negedge AB[5], 1.000, 0.500, NOT_AB5);
      $setuphold(posedge CLKB &&& flagB, posedge AB[4], 1.000, 0.500, NOT_AB4);
      $setuphold(posedge CLKB &&& flagB, negedge AB[4], 1.000, 0.500, NOT_AB4);
      $setuphold(posedge CLKB &&& flagB, posedge AB[3], 1.000, 0.500, NOT_AB3);
      $setuphold(posedge CLKB &&& flagB, negedge AB[3], 1.000, 0.500, NOT_AB3);
      $setuphold(posedge CLKB &&& flagB, posedge AB[2], 1.000, 0.500, NOT_AB2);
      $setuphold(posedge CLKB &&& flagB, negedge AB[2], 1.000, 0.500, NOT_AB2);
      $setuphold(posedge CLKB &&& flagB, posedge AB[1], 1.000, 0.500, NOT_AB1);
      $setuphold(posedge CLKB &&& flagB, negedge AB[1], 1.000, 0.500, NOT_AB1);
      $setuphold(posedge CLKB &&& flagB, posedge AB[0], 1.000, 0.500, NOT_AB0);
      $setuphold(posedge CLKB &&& flagB, negedge AB[0], 1.000, 0.500, NOT_AB0);
      $setuphold(posedge CLKB &&& DB_flag31, posedge DB[31], 1.000, 0.500, NOT_DB31);
      $setuphold(posedge CLKB &&& DB_flag31, negedge DB[31], 1.000, 0.500, NOT_DB31);
      $setuphold(posedge CLKB &&& DB_flag30, posedge DB[30], 1.000, 0.500, NOT_DB30);
      $setuphold(posedge CLKB &&& DB_flag30, negedge DB[30], 1.000, 0.500, NOT_DB30);
      $setuphold(posedge CLKB &&& DB_flag29, posedge DB[29], 1.000, 0.500, NOT_DB29);
      $setuphold(posedge CLKB &&& DB_flag29, negedge DB[29], 1.000, 0.500, NOT_DB29);
      $setuphold(posedge CLKB &&& DB_flag28, posedge DB[28], 1.000, 0.500, NOT_DB28);
      $setuphold(posedge CLKB &&& DB_flag28, negedge DB[28], 1.000, 0.500, NOT_DB28);
      $setuphold(posedge CLKB &&& DB_flag27, posedge DB[27], 1.000, 0.500, NOT_DB27);
      $setuphold(posedge CLKB &&& DB_flag27, negedge DB[27], 1.000, 0.500, NOT_DB27);
      $setuphold(posedge CLKB &&& DB_flag26, posedge DB[26], 1.000, 0.500, NOT_DB26);
      $setuphold(posedge CLKB &&& DB_flag26, negedge DB[26], 1.000, 0.500, NOT_DB26);
      $setuphold(posedge CLKB &&& DB_flag25, posedge DB[25], 1.000, 0.500, NOT_DB25);
      $setuphold(posedge CLKB &&& DB_flag25, negedge DB[25], 1.000, 0.500, NOT_DB25);
      $setuphold(posedge CLKB &&& DB_flag24, posedge DB[24], 1.000, 0.500, NOT_DB24);
      $setuphold(posedge CLKB &&& DB_flag24, negedge DB[24], 1.000, 0.500, NOT_DB24);
      $setuphold(posedge CLKB &&& DB_flag23, posedge DB[23], 1.000, 0.500, NOT_DB23);
      $setuphold(posedge CLKB &&& DB_flag23, negedge DB[23], 1.000, 0.500, NOT_DB23);
      $setuphold(posedge CLKB &&& DB_flag22, posedge DB[22], 1.000, 0.500, NOT_DB22);
      $setuphold(posedge CLKB &&& DB_flag22, negedge DB[22], 1.000, 0.500, NOT_DB22);
      $setuphold(posedge CLKB &&& DB_flag21, posedge DB[21], 1.000, 0.500, NOT_DB21);
      $setuphold(posedge CLKB &&& DB_flag21, negedge DB[21], 1.000, 0.500, NOT_DB21);
      $setuphold(posedge CLKB &&& DB_flag20, posedge DB[20], 1.000, 0.500, NOT_DB20);
      $setuphold(posedge CLKB &&& DB_flag20, negedge DB[20], 1.000, 0.500, NOT_DB20);
      $setuphold(posedge CLKB &&& DB_flag19, posedge DB[19], 1.000, 0.500, NOT_DB19);
      $setuphold(posedge CLKB &&& DB_flag19, negedge DB[19], 1.000, 0.500, NOT_DB19);
      $setuphold(posedge CLKB &&& DB_flag18, posedge DB[18], 1.000, 0.500, NOT_DB18);
      $setuphold(posedge CLKB &&& DB_flag18, negedge DB[18], 1.000, 0.500, NOT_DB18);
      $setuphold(posedge CLKB &&& DB_flag17, posedge DB[17], 1.000, 0.500, NOT_DB17);
      $setuphold(posedge CLKB &&& DB_flag17, negedge DB[17], 1.000, 0.500, NOT_DB17);
      $setuphold(posedge CLKB &&& DB_flag16, posedge DB[16], 1.000, 0.500, NOT_DB16);
      $setuphold(posedge CLKB &&& DB_flag16, negedge DB[16], 1.000, 0.500, NOT_DB16);
      $setuphold(posedge CLKB &&& DB_flag15, posedge DB[15], 1.000, 0.500, NOT_DB15);
      $setuphold(posedge CLKB &&& DB_flag15, negedge DB[15], 1.000, 0.500, NOT_DB15);
      $setuphold(posedge CLKB &&& DB_flag14, posedge DB[14], 1.000, 0.500, NOT_DB14);
      $setuphold(posedge CLKB &&& DB_flag14, negedge DB[14], 1.000, 0.500, NOT_DB14);
      $setuphold(posedge CLKB &&& DB_flag13, posedge DB[13], 1.000, 0.500, NOT_DB13);
      $setuphold(posedge CLKB &&& DB_flag13, negedge DB[13], 1.000, 0.500, NOT_DB13);
      $setuphold(posedge CLKB &&& DB_flag12, posedge DB[12], 1.000, 0.500, NOT_DB12);
      $setuphold(posedge CLKB &&& DB_flag12, negedge DB[12], 1.000, 0.500, NOT_DB12);
      $setuphold(posedge CLKB &&& DB_flag11, posedge DB[11], 1.000, 0.500, NOT_DB11);
      $setuphold(posedge CLKB &&& DB_flag11, negedge DB[11], 1.000, 0.500, NOT_DB11);
      $setuphold(posedge CLKB &&& DB_flag10, posedge DB[10], 1.000, 0.500, NOT_DB10);
      $setuphold(posedge CLKB &&& DB_flag10, negedge DB[10], 1.000, 0.500, NOT_DB10);
      $setuphold(posedge CLKB &&& DB_flag9, posedge DB[9], 1.000, 0.500, NOT_DB9);
      $setuphold(posedge CLKB &&& DB_flag9, negedge DB[9], 1.000, 0.500, NOT_DB9);
      $setuphold(posedge CLKB &&& DB_flag8, posedge DB[8], 1.000, 0.500, NOT_DB8);
      $setuphold(posedge CLKB &&& DB_flag8, negedge DB[8], 1.000, 0.500, NOT_DB8);
      $setuphold(posedge CLKB &&& DB_flag7, posedge DB[7], 1.000, 0.500, NOT_DB7);
      $setuphold(posedge CLKB &&& DB_flag7, negedge DB[7], 1.000, 0.500, NOT_DB7);
      $setuphold(posedge CLKB &&& DB_flag6, posedge DB[6], 1.000, 0.500, NOT_DB6);
      $setuphold(posedge CLKB &&& DB_flag6, negedge DB[6], 1.000, 0.500, NOT_DB6);
      $setuphold(posedge CLKB &&& DB_flag5, posedge DB[5], 1.000, 0.500, NOT_DB5);
      $setuphold(posedge CLKB &&& DB_flag5, negedge DB[5], 1.000, 0.500, NOT_DB5);
      $setuphold(posedge CLKB &&& DB_flag4, posedge DB[4], 1.000, 0.500, NOT_DB4);
      $setuphold(posedge CLKB &&& DB_flag4, negedge DB[4], 1.000, 0.500, NOT_DB4);
      $setuphold(posedge CLKB &&& DB_flag3, posedge DB[3], 1.000, 0.500, NOT_DB3);
      $setuphold(posedge CLKB &&& DB_flag3, negedge DB[3], 1.000, 0.500, NOT_DB3);
      $setuphold(posedge CLKB &&& DB_flag2, posedge DB[2], 1.000, 0.500, NOT_DB2);
      $setuphold(posedge CLKB &&& DB_flag2, negedge DB[2], 1.000, 0.500, NOT_DB2);
      $setuphold(posedge CLKB &&& DB_flag1, posedge DB[1], 1.000, 0.500, NOT_DB1);
      $setuphold(posedge CLKB &&& DB_flag1, negedge DB[1], 1.000, 0.500, NOT_DB1);
      $setuphold(posedge CLKB &&& DB_flag0, posedge DB[0], 1.000, 0.500, NOT_DB0);
      $setuphold(posedge CLKB &&& DB_flag0, negedge DB[0], 1.000, 0.500, NOT_DB0);
      $setuphold(posedge CLKB &&& cyc_flagB, posedge EMAB[2], 1.000, 0.500, NOT_EMAB2);
      $setuphold(posedge CLKB &&& cyc_flagB, negedge EMAB[2], 1.000, 0.500, NOT_EMAB2);
      $setuphold(posedge CLKB &&& cyc_flagB, posedge EMAB[1], 1.000, 0.500, NOT_EMAB1);
      $setuphold(posedge CLKB &&& cyc_flagB, negedge EMAB[1], 1.000, 0.500, NOT_EMAB1);
      $setuphold(posedge CLKB &&& cyc_flagB, posedge EMAB[0], 1.000, 0.500, NOT_EMAB0);
      $setuphold(posedge CLKB &&& cyc_flagB, negedge EMAB[0], 1.000, 0.500, NOT_EMAB0);
      $setuphold(posedge CLKB, posedge RETN, 1.000, 0.500, NOT_RETNB);
      $setuphold(posedge CLKB, negedge RETN, 1.000, 0.500, NOT_RETNB);
      $hold(posedge RETN, negedge CENB, 1.000, NOT_RETN);
      $setup(posedge CLKA, posedge CLKB &&& contA_EMAA2eq0andEMAA1eq0andEMAA0eq0, 3.000, NOT_CONTB);
      $setup(posedge CLKA, posedge CLKB &&& contA_EMAA2eq0andEMAA1eq0andEMAA0eq1, 3.000, NOT_CONTB);
      $setup(posedge CLKA, posedge CLKB &&& contA_EMAA2eq0andEMAA1eq1andEMAA0eq0, 3.000, NOT_CONTB);
      $setup(posedge CLKA, posedge CLKB &&& contA_EMAA2eq0andEMAA1eq1andEMAA0eq1, 3.000, NOT_CONTB);
      $setup(posedge CLKA, posedge CLKB &&& contA_EMAA2eq1andEMAA1eq0andEMAA0eq0, 3.000, NOT_CONTB);
      $setup(posedge CLKA, posedge CLKB &&& contA_EMAA2eq1andEMAA1eq0andEMAA0eq1, 3.000, NOT_CONTB);
      $setup(posedge CLKA, posedge CLKB &&& contA_EMAA2eq1andEMAA1eq1andEMAA0eq0, 3.000, NOT_CONTB);
      $setup(posedge CLKA, posedge CLKB &&& contA_EMAA2eq1andEMAA1eq1andEMAA0eq1, 3.000, NOT_CONTB);
      $setup(posedge CLKB, posedge CLKA &&& contB_EMAB2eq0andEMAB1eq0andEMAB0eq0, 3.000, NOT_CONTA);
      $setup(posedge CLKB, posedge CLKA &&& contB_EMAB2eq0andEMAB1eq0andEMAB0eq1, 3.000, NOT_CONTA);
      $setup(posedge CLKB, posedge CLKA &&& contB_EMAB2eq0andEMAB1eq1andEMAB0eq0, 3.000, NOT_CONTA);
      $setup(posedge CLKB, posedge CLKA &&& contB_EMAB2eq0andEMAB1eq1andEMAB0eq1, 3.000, NOT_CONTA);
      $setup(posedge CLKB, posedge CLKA &&& contB_EMAB2eq1andEMAB1eq0andEMAB0eq0, 3.000, NOT_CONTA);
      $setup(posedge CLKB, posedge CLKA &&& contB_EMAB2eq1andEMAB1eq0andEMAB0eq1, 3.000, NOT_CONTA);
      $setup(posedge CLKB, posedge CLKA &&& contB_EMAB2eq1andEMAB1eq1andEMAB0eq0, 3.000, NOT_CONTA);
      $setup(posedge CLKB, posedge CLKA &&& contB_EMAB2eq1andEMAB1eq1andEMAB0eq1, 3.000, NOT_CONTA);

      $width(posedge CLKA &&& cyc_flagA, 1.000, 0, NOT_CLKA_MINH);
      $width(negedge CLKA &&& cyc_flagA, 1.000, 0, NOT_CLKA_MINL);
`ifdef NO_SDTC
      $period(posedge CLKA  &&& cyc_flagA, 3.000, NOT_CLKA_PER);
`else
      $period(posedge CLKA &&& EMAA2eq0andEMAA1eq0andEMAA0eq0, 3.000, NOT_CLKA_PER);
      $period(posedge CLKA &&& EMAA2eq0andEMAA1eq0andEMAA0eq1, 3.000, NOT_CLKA_PER);
      $period(posedge CLKA &&& EMAA2eq0andEMAA1eq1andEMAA0eq0, 3.000, NOT_CLKA_PER);
      $period(posedge CLKA &&& EMAA2eq0andEMAA1eq1andEMAA0eq1, 3.000, NOT_CLKA_PER);
      $period(posedge CLKA &&& EMAA2eq1andEMAA1eq0andEMAA0eq0, 3.000, NOT_CLKA_PER);
      $period(posedge CLKA &&& EMAA2eq1andEMAA1eq0andEMAA0eq1, 3.000, NOT_CLKA_PER);
      $period(posedge CLKA &&& EMAA2eq1andEMAA1eq1andEMAA0eq0, 3.000, NOT_CLKA_PER);
      $period(posedge CLKA &&& EMAA2eq1andEMAA1eq1andEMAA0eq1, 3.000, NOT_CLKA_PER);
`endif

      $width(posedge CLKB &&& cyc_flagB, 1.000, 0, NOT_CLKB_MINH);
      $width(negedge CLKB &&& cyc_flagB, 1.000, 0, NOT_CLKB_MINL);
`ifdef NO_SDTC
      $period(posedge CLKB  &&& cyc_flagB, 3.000, NOT_CLKB_PER);
`else
      $period(posedge CLKB &&& EMAB2eq0andEMAB1eq0andEMAB0eq0, 3.000, NOT_CLKB_PER);
      $period(posedge CLKB &&& EMAB2eq0andEMAB1eq0andEMAB0eq1, 3.000, NOT_CLKB_PER);
      $period(posedge CLKB &&& EMAB2eq0andEMAB1eq1andEMAB0eq0, 3.000, NOT_CLKB_PER);
      $period(posedge CLKB &&& EMAB2eq0andEMAB1eq1andEMAB0eq1, 3.000, NOT_CLKB_PER);
      $period(posedge CLKB &&& EMAB2eq1andEMAB1eq0andEMAB0eq0, 3.000, NOT_CLKB_PER);
      $period(posedge CLKB &&& EMAB2eq1andEMAB1eq0andEMAB0eq1, 3.000, NOT_CLKB_PER);
      $period(posedge CLKB &&& EMAB2eq1andEMAB1eq1andEMAB0eq0, 3.000, NOT_CLKB_PER);
      $period(posedge CLKB &&& EMAB2eq1andEMAB1eq1andEMAB0eq1, 3.000, NOT_CLKB_PER);
`endif

      if ((EMAA[2] == 1'b0) && (EMAA[1] == 1'b0) && (EMAA[0] == 1'b0))
        (posedge CLKA => (QA[31]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b0) && (EMAA[1] == 1'b0) && (EMAA[0] == 1'b1))
        (posedge CLKA => (QA[31]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b0) && (EMAA[1] == 1'b1) && (EMAA[0] == 1'b0))
        (posedge CLKA => (QA[31]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b0) && (EMAA[1] == 1'b1) && (EMAA[0] == 1'b1))
        (posedge CLKA => (QA[31]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b1) && (EMAA[1] == 1'b0) && (EMAA[0] == 1'b0))
        (posedge CLKA => (QA[31]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b1) && (EMAA[1] == 1'b0) && (EMAA[0] == 1'b1))
        (posedge CLKA => (QA[31]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b1) && (EMAA[1] == 1'b1) && (EMAA[0] == 1'b0))
        (posedge CLKA => (QA[31]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b1) && (EMAA[1] == 1'b1) && (EMAA[0] == 1'b1))
        (posedge CLKA => (QA[31]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b0) && (EMAA[1] == 1'b0) && (EMAA[0] == 1'b0))
        (posedge CLKA => (QA[30]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b0) && (EMAA[1] == 1'b0) && (EMAA[0] == 1'b1))
        (posedge CLKA => (QA[30]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b0) && (EMAA[1] == 1'b1) && (EMAA[0] == 1'b0))
        (posedge CLKA => (QA[30]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b0) && (EMAA[1] == 1'b1) && (EMAA[0] == 1'b1))
        (posedge CLKA => (QA[30]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b1) && (EMAA[1] == 1'b0) && (EMAA[0] == 1'b0))
        (posedge CLKA => (QA[30]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b1) && (EMAA[1] == 1'b0) && (EMAA[0] == 1'b1))
        (posedge CLKA => (QA[30]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b1) && (EMAA[1] == 1'b1) && (EMAA[0] == 1'b0))
        (posedge CLKA => (QA[30]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b1) && (EMAA[1] == 1'b1) && (EMAA[0] == 1'b1))
        (posedge CLKA => (QA[30]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b0) && (EMAA[1] == 1'b0) && (EMAA[0] == 1'b0))
        (posedge CLKA => (QA[29]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b0) && (EMAA[1] == 1'b0) && (EMAA[0] == 1'b1))
        (posedge CLKA => (QA[29]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b0) && (EMAA[1] == 1'b1) && (EMAA[0] == 1'b0))
        (posedge CLKA => (QA[29]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b0) && (EMAA[1] == 1'b1) && (EMAA[0] == 1'b1))
        (posedge CLKA => (QA[29]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b1) && (EMAA[1] == 1'b0) && (EMAA[0] == 1'b0))
        (posedge CLKA => (QA[29]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b1) && (EMAA[1] == 1'b0) && (EMAA[0] == 1'b1))
        (posedge CLKA => (QA[29]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b1) && (EMAA[1] == 1'b1) && (EMAA[0] == 1'b0))
        (posedge CLKA => (QA[29]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b1) && (EMAA[1] == 1'b1) && (EMAA[0] == 1'b1))
        (posedge CLKA => (QA[29]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b0) && (EMAA[1] == 1'b0) && (EMAA[0] == 1'b0))
        (posedge CLKA => (QA[28]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b0) && (EMAA[1] == 1'b0) && (EMAA[0] == 1'b1))
        (posedge CLKA => (QA[28]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b0) && (EMAA[1] == 1'b1) && (EMAA[0] == 1'b0))
        (posedge CLKA => (QA[28]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b0) && (EMAA[1] == 1'b1) && (EMAA[0] == 1'b1))
        (posedge CLKA => (QA[28]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b1) && (EMAA[1] == 1'b0) && (EMAA[0] == 1'b0))
        (posedge CLKA => (QA[28]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b1) && (EMAA[1] == 1'b0) && (EMAA[0] == 1'b1))
        (posedge CLKA => (QA[28]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b1) && (EMAA[1] == 1'b1) && (EMAA[0] == 1'b0))
        (posedge CLKA => (QA[28]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b1) && (EMAA[1] == 1'b1) && (EMAA[0] == 1'b1))
        (posedge CLKA => (QA[28]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b0) && (EMAA[1] == 1'b0) && (EMAA[0] == 1'b0))
        (posedge CLKA => (QA[27]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b0) && (EMAA[1] == 1'b0) && (EMAA[0] == 1'b1))
        (posedge CLKA => (QA[27]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b0) && (EMAA[1] == 1'b1) && (EMAA[0] == 1'b0))
        (posedge CLKA => (QA[27]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b0) && (EMAA[1] == 1'b1) && (EMAA[0] == 1'b1))
        (posedge CLKA => (QA[27]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b1) && (EMAA[1] == 1'b0) && (EMAA[0] == 1'b0))
        (posedge CLKA => (QA[27]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b1) && (EMAA[1] == 1'b0) && (EMAA[0] == 1'b1))
        (posedge CLKA => (QA[27]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b1) && (EMAA[1] == 1'b1) && (EMAA[0] == 1'b0))
        (posedge CLKA => (QA[27]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b1) && (EMAA[1] == 1'b1) && (EMAA[0] == 1'b1))
        (posedge CLKA => (QA[27]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b0) && (EMAA[1] == 1'b0) && (EMAA[0] == 1'b0))
        (posedge CLKA => (QA[26]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b0) && (EMAA[1] == 1'b0) && (EMAA[0] == 1'b1))
        (posedge CLKA => (QA[26]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b0) && (EMAA[1] == 1'b1) && (EMAA[0] == 1'b0))
        (posedge CLKA => (QA[26]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b0) && (EMAA[1] == 1'b1) && (EMAA[0] == 1'b1))
        (posedge CLKA => (QA[26]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b1) && (EMAA[1] == 1'b0) && (EMAA[0] == 1'b0))
        (posedge CLKA => (QA[26]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b1) && (EMAA[1] == 1'b0) && (EMAA[0] == 1'b1))
        (posedge CLKA => (QA[26]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b1) && (EMAA[1] == 1'b1) && (EMAA[0] == 1'b0))
        (posedge CLKA => (QA[26]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b1) && (EMAA[1] == 1'b1) && (EMAA[0] == 1'b1))
        (posedge CLKA => (QA[26]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b0) && (EMAA[1] == 1'b0) && (EMAA[0] == 1'b0))
        (posedge CLKA => (QA[25]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b0) && (EMAA[1] == 1'b0) && (EMAA[0] == 1'b1))
        (posedge CLKA => (QA[25]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b0) && (EMAA[1] == 1'b1) && (EMAA[0] == 1'b0))
        (posedge CLKA => (QA[25]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b0) && (EMAA[1] == 1'b1) && (EMAA[0] == 1'b1))
        (posedge CLKA => (QA[25]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b1) && (EMAA[1] == 1'b0) && (EMAA[0] == 1'b0))
        (posedge CLKA => (QA[25]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b1) && (EMAA[1] == 1'b0) && (EMAA[0] == 1'b1))
        (posedge CLKA => (QA[25]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b1) && (EMAA[1] == 1'b1) && (EMAA[0] == 1'b0))
        (posedge CLKA => (QA[25]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b1) && (EMAA[1] == 1'b1) && (EMAA[0] == 1'b1))
        (posedge CLKA => (QA[25]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b0) && (EMAA[1] == 1'b0) && (EMAA[0] == 1'b0))
        (posedge CLKA => (QA[24]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b0) && (EMAA[1] == 1'b0) && (EMAA[0] == 1'b1))
        (posedge CLKA => (QA[24]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b0) && (EMAA[1] == 1'b1) && (EMAA[0] == 1'b0))
        (posedge CLKA => (QA[24]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b0) && (EMAA[1] == 1'b1) && (EMAA[0] == 1'b1))
        (posedge CLKA => (QA[24]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b1) && (EMAA[1] == 1'b0) && (EMAA[0] == 1'b0))
        (posedge CLKA => (QA[24]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b1) && (EMAA[1] == 1'b0) && (EMAA[0] == 1'b1))
        (posedge CLKA => (QA[24]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b1) && (EMAA[1] == 1'b1) && (EMAA[0] == 1'b0))
        (posedge CLKA => (QA[24]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b1) && (EMAA[1] == 1'b1) && (EMAA[0] == 1'b1))
        (posedge CLKA => (QA[24]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b0) && (EMAA[1] == 1'b0) && (EMAA[0] == 1'b0))
        (posedge CLKA => (QA[23]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b0) && (EMAA[1] == 1'b0) && (EMAA[0] == 1'b1))
        (posedge CLKA => (QA[23]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b0) && (EMAA[1] == 1'b1) && (EMAA[0] == 1'b0))
        (posedge CLKA => (QA[23]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b0) && (EMAA[1] == 1'b1) && (EMAA[0] == 1'b1))
        (posedge CLKA => (QA[23]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b1) && (EMAA[1] == 1'b0) && (EMAA[0] == 1'b0))
        (posedge CLKA => (QA[23]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b1) && (EMAA[1] == 1'b0) && (EMAA[0] == 1'b1))
        (posedge CLKA => (QA[23]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b1) && (EMAA[1] == 1'b1) && (EMAA[0] == 1'b0))
        (posedge CLKA => (QA[23]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b1) && (EMAA[1] == 1'b1) && (EMAA[0] == 1'b1))
        (posedge CLKA => (QA[23]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b0) && (EMAA[1] == 1'b0) && (EMAA[0] == 1'b0))
        (posedge CLKA => (QA[22]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b0) && (EMAA[1] == 1'b0) && (EMAA[0] == 1'b1))
        (posedge CLKA => (QA[22]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b0) && (EMAA[1] == 1'b1) && (EMAA[0] == 1'b0))
        (posedge CLKA => (QA[22]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b0) && (EMAA[1] == 1'b1) && (EMAA[0] == 1'b1))
        (posedge CLKA => (QA[22]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b1) && (EMAA[1] == 1'b0) && (EMAA[0] == 1'b0))
        (posedge CLKA => (QA[22]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b1) && (EMAA[1] == 1'b0) && (EMAA[0] == 1'b1))
        (posedge CLKA => (QA[22]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b1) && (EMAA[1] == 1'b1) && (EMAA[0] == 1'b0))
        (posedge CLKA => (QA[22]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b1) && (EMAA[1] == 1'b1) && (EMAA[0] == 1'b1))
        (posedge CLKA => (QA[22]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b0) && (EMAA[1] == 1'b0) && (EMAA[0] == 1'b0))
        (posedge CLKA => (QA[21]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b0) && (EMAA[1] == 1'b0) && (EMAA[0] == 1'b1))
        (posedge CLKA => (QA[21]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b0) && (EMAA[1] == 1'b1) && (EMAA[0] == 1'b0))
        (posedge CLKA => (QA[21]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b0) && (EMAA[1] == 1'b1) && (EMAA[0] == 1'b1))
        (posedge CLKA => (QA[21]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b1) && (EMAA[1] == 1'b0) && (EMAA[0] == 1'b0))
        (posedge CLKA => (QA[21]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b1) && (EMAA[1] == 1'b0) && (EMAA[0] == 1'b1))
        (posedge CLKA => (QA[21]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b1) && (EMAA[1] == 1'b1) && (EMAA[0] == 1'b0))
        (posedge CLKA => (QA[21]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b1) && (EMAA[1] == 1'b1) && (EMAA[0] == 1'b1))
        (posedge CLKA => (QA[21]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b0) && (EMAA[1] == 1'b0) && (EMAA[0] == 1'b0))
        (posedge CLKA => (QA[20]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b0) && (EMAA[1] == 1'b0) && (EMAA[0] == 1'b1))
        (posedge CLKA => (QA[20]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b0) && (EMAA[1] == 1'b1) && (EMAA[0] == 1'b0))
        (posedge CLKA => (QA[20]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b0) && (EMAA[1] == 1'b1) && (EMAA[0] == 1'b1))
        (posedge CLKA => (QA[20]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b1) && (EMAA[1] == 1'b0) && (EMAA[0] == 1'b0))
        (posedge CLKA => (QA[20]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b1) && (EMAA[1] == 1'b0) && (EMAA[0] == 1'b1))
        (posedge CLKA => (QA[20]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b1) && (EMAA[1] == 1'b1) && (EMAA[0] == 1'b0))
        (posedge CLKA => (QA[20]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b1) && (EMAA[1] == 1'b1) && (EMAA[0] == 1'b1))
        (posedge CLKA => (QA[20]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b0) && (EMAA[1] == 1'b0) && (EMAA[0] == 1'b0))
        (posedge CLKA => (QA[19]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b0) && (EMAA[1] == 1'b0) && (EMAA[0] == 1'b1))
        (posedge CLKA => (QA[19]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b0) && (EMAA[1] == 1'b1) && (EMAA[0] == 1'b0))
        (posedge CLKA => (QA[19]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b0) && (EMAA[1] == 1'b1) && (EMAA[0] == 1'b1))
        (posedge CLKA => (QA[19]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b1) && (EMAA[1] == 1'b0) && (EMAA[0] == 1'b0))
        (posedge CLKA => (QA[19]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b1) && (EMAA[1] == 1'b0) && (EMAA[0] == 1'b1))
        (posedge CLKA => (QA[19]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b1) && (EMAA[1] == 1'b1) && (EMAA[0] == 1'b0))
        (posedge CLKA => (QA[19]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b1) && (EMAA[1] == 1'b1) && (EMAA[0] == 1'b1))
        (posedge CLKA => (QA[19]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b0) && (EMAA[1] == 1'b0) && (EMAA[0] == 1'b0))
        (posedge CLKA => (QA[18]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b0) && (EMAA[1] == 1'b0) && (EMAA[0] == 1'b1))
        (posedge CLKA => (QA[18]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b0) && (EMAA[1] == 1'b1) && (EMAA[0] == 1'b0))
        (posedge CLKA => (QA[18]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b0) && (EMAA[1] == 1'b1) && (EMAA[0] == 1'b1))
        (posedge CLKA => (QA[18]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b1) && (EMAA[1] == 1'b0) && (EMAA[0] == 1'b0))
        (posedge CLKA => (QA[18]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b1) && (EMAA[1] == 1'b0) && (EMAA[0] == 1'b1))
        (posedge CLKA => (QA[18]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b1) && (EMAA[1] == 1'b1) && (EMAA[0] == 1'b0))
        (posedge CLKA => (QA[18]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b1) && (EMAA[1] == 1'b1) && (EMAA[0] == 1'b1))
        (posedge CLKA => (QA[18]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b0) && (EMAA[1] == 1'b0) && (EMAA[0] == 1'b0))
        (posedge CLKA => (QA[17]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b0) && (EMAA[1] == 1'b0) && (EMAA[0] == 1'b1))
        (posedge CLKA => (QA[17]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b0) && (EMAA[1] == 1'b1) && (EMAA[0] == 1'b0))
        (posedge CLKA => (QA[17]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b0) && (EMAA[1] == 1'b1) && (EMAA[0] == 1'b1))
        (posedge CLKA => (QA[17]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b1) && (EMAA[1] == 1'b0) && (EMAA[0] == 1'b0))
        (posedge CLKA => (QA[17]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b1) && (EMAA[1] == 1'b0) && (EMAA[0] == 1'b1))
        (posedge CLKA => (QA[17]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b1) && (EMAA[1] == 1'b1) && (EMAA[0] == 1'b0))
        (posedge CLKA => (QA[17]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b1) && (EMAA[1] == 1'b1) && (EMAA[0] == 1'b1))
        (posedge CLKA => (QA[17]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b0) && (EMAA[1] == 1'b0) && (EMAA[0] == 1'b0))
        (posedge CLKA => (QA[16]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b0) && (EMAA[1] == 1'b0) && (EMAA[0] == 1'b1))
        (posedge CLKA => (QA[16]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b0) && (EMAA[1] == 1'b1) && (EMAA[0] == 1'b0))
        (posedge CLKA => (QA[16]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b0) && (EMAA[1] == 1'b1) && (EMAA[0] == 1'b1))
        (posedge CLKA => (QA[16]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b1) && (EMAA[1] == 1'b0) && (EMAA[0] == 1'b0))
        (posedge CLKA => (QA[16]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b1) && (EMAA[1] == 1'b0) && (EMAA[0] == 1'b1))
        (posedge CLKA => (QA[16]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b1) && (EMAA[1] == 1'b1) && (EMAA[0] == 1'b0))
        (posedge CLKA => (QA[16]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b1) && (EMAA[1] == 1'b1) && (EMAA[0] == 1'b1))
        (posedge CLKA => (QA[16]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b0) && (EMAA[1] == 1'b0) && (EMAA[0] == 1'b0))
        (posedge CLKA => (QA[15]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b0) && (EMAA[1] == 1'b0) && (EMAA[0] == 1'b1))
        (posedge CLKA => (QA[15]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b0) && (EMAA[1] == 1'b1) && (EMAA[0] == 1'b0))
        (posedge CLKA => (QA[15]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b0) && (EMAA[1] == 1'b1) && (EMAA[0] == 1'b1))
        (posedge CLKA => (QA[15]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b1) && (EMAA[1] == 1'b0) && (EMAA[0] == 1'b0))
        (posedge CLKA => (QA[15]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b1) && (EMAA[1] == 1'b0) && (EMAA[0] == 1'b1))
        (posedge CLKA => (QA[15]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b1) && (EMAA[1] == 1'b1) && (EMAA[0] == 1'b0))
        (posedge CLKA => (QA[15]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b1) && (EMAA[1] == 1'b1) && (EMAA[0] == 1'b1))
        (posedge CLKA => (QA[15]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b0) && (EMAA[1] == 1'b0) && (EMAA[0] == 1'b0))
        (posedge CLKA => (QA[14]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b0) && (EMAA[1] == 1'b0) && (EMAA[0] == 1'b1))
        (posedge CLKA => (QA[14]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b0) && (EMAA[1] == 1'b1) && (EMAA[0] == 1'b0))
        (posedge CLKA => (QA[14]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b0) && (EMAA[1] == 1'b1) && (EMAA[0] == 1'b1))
        (posedge CLKA => (QA[14]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b1) && (EMAA[1] == 1'b0) && (EMAA[0] == 1'b0))
        (posedge CLKA => (QA[14]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b1) && (EMAA[1] == 1'b0) && (EMAA[0] == 1'b1))
        (posedge CLKA => (QA[14]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b1) && (EMAA[1] == 1'b1) && (EMAA[0] == 1'b0))
        (posedge CLKA => (QA[14]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b1) && (EMAA[1] == 1'b1) && (EMAA[0] == 1'b1))
        (posedge CLKA => (QA[14]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b0) && (EMAA[1] == 1'b0) && (EMAA[0] == 1'b0))
        (posedge CLKA => (QA[13]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b0) && (EMAA[1] == 1'b0) && (EMAA[0] == 1'b1))
        (posedge CLKA => (QA[13]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b0) && (EMAA[1] == 1'b1) && (EMAA[0] == 1'b0))
        (posedge CLKA => (QA[13]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b0) && (EMAA[1] == 1'b1) && (EMAA[0] == 1'b1))
        (posedge CLKA => (QA[13]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b1) && (EMAA[1] == 1'b0) && (EMAA[0] == 1'b0))
        (posedge CLKA => (QA[13]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b1) && (EMAA[1] == 1'b0) && (EMAA[0] == 1'b1))
        (posedge CLKA => (QA[13]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b1) && (EMAA[1] == 1'b1) && (EMAA[0] == 1'b0))
        (posedge CLKA => (QA[13]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b1) && (EMAA[1] == 1'b1) && (EMAA[0] == 1'b1))
        (posedge CLKA => (QA[13]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b0) && (EMAA[1] == 1'b0) && (EMAA[0] == 1'b0))
        (posedge CLKA => (QA[12]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b0) && (EMAA[1] == 1'b0) && (EMAA[0] == 1'b1))
        (posedge CLKA => (QA[12]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b0) && (EMAA[1] == 1'b1) && (EMAA[0] == 1'b0))
        (posedge CLKA => (QA[12]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b0) && (EMAA[1] == 1'b1) && (EMAA[0] == 1'b1))
        (posedge CLKA => (QA[12]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b1) && (EMAA[1] == 1'b0) && (EMAA[0] == 1'b0))
        (posedge CLKA => (QA[12]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b1) && (EMAA[1] == 1'b0) && (EMAA[0] == 1'b1))
        (posedge CLKA => (QA[12]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b1) && (EMAA[1] == 1'b1) && (EMAA[0] == 1'b0))
        (posedge CLKA => (QA[12]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b1) && (EMAA[1] == 1'b1) && (EMAA[0] == 1'b1))
        (posedge CLKA => (QA[12]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b0) && (EMAA[1] == 1'b0) && (EMAA[0] == 1'b0))
        (posedge CLKA => (QA[11]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b0) && (EMAA[1] == 1'b0) && (EMAA[0] == 1'b1))
        (posedge CLKA => (QA[11]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b0) && (EMAA[1] == 1'b1) && (EMAA[0] == 1'b0))
        (posedge CLKA => (QA[11]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b0) && (EMAA[1] == 1'b1) && (EMAA[0] == 1'b1))
        (posedge CLKA => (QA[11]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b1) && (EMAA[1] == 1'b0) && (EMAA[0] == 1'b0))
        (posedge CLKA => (QA[11]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b1) && (EMAA[1] == 1'b0) && (EMAA[0] == 1'b1))
        (posedge CLKA => (QA[11]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b1) && (EMAA[1] == 1'b1) && (EMAA[0] == 1'b0))
        (posedge CLKA => (QA[11]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b1) && (EMAA[1] == 1'b1) && (EMAA[0] == 1'b1))
        (posedge CLKA => (QA[11]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b0) && (EMAA[1] == 1'b0) && (EMAA[0] == 1'b0))
        (posedge CLKA => (QA[10]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b0) && (EMAA[1] == 1'b0) && (EMAA[0] == 1'b1))
        (posedge CLKA => (QA[10]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b0) && (EMAA[1] == 1'b1) && (EMAA[0] == 1'b0))
        (posedge CLKA => (QA[10]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b0) && (EMAA[1] == 1'b1) && (EMAA[0] == 1'b1))
        (posedge CLKA => (QA[10]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b1) && (EMAA[1] == 1'b0) && (EMAA[0] == 1'b0))
        (posedge CLKA => (QA[10]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b1) && (EMAA[1] == 1'b0) && (EMAA[0] == 1'b1))
        (posedge CLKA => (QA[10]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b1) && (EMAA[1] == 1'b1) && (EMAA[0] == 1'b0))
        (posedge CLKA => (QA[10]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b1) && (EMAA[1] == 1'b1) && (EMAA[0] == 1'b1))
        (posedge CLKA => (QA[10]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b0) && (EMAA[1] == 1'b0) && (EMAA[0] == 1'b0))
        (posedge CLKA => (QA[9]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b0) && (EMAA[1] == 1'b0) && (EMAA[0] == 1'b1))
        (posedge CLKA => (QA[9]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b0) && (EMAA[1] == 1'b1) && (EMAA[0] == 1'b0))
        (posedge CLKA => (QA[9]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b0) && (EMAA[1] == 1'b1) && (EMAA[0] == 1'b1))
        (posedge CLKA => (QA[9]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b1) && (EMAA[1] == 1'b0) && (EMAA[0] == 1'b0))
        (posedge CLKA => (QA[9]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b1) && (EMAA[1] == 1'b0) && (EMAA[0] == 1'b1))
        (posedge CLKA => (QA[9]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b1) && (EMAA[1] == 1'b1) && (EMAA[0] == 1'b0))
        (posedge CLKA => (QA[9]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b1) && (EMAA[1] == 1'b1) && (EMAA[0] == 1'b1))
        (posedge CLKA => (QA[9]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b0) && (EMAA[1] == 1'b0) && (EMAA[0] == 1'b0))
        (posedge CLKA => (QA[8]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b0) && (EMAA[1] == 1'b0) && (EMAA[0] == 1'b1))
        (posedge CLKA => (QA[8]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b0) && (EMAA[1] == 1'b1) && (EMAA[0] == 1'b0))
        (posedge CLKA => (QA[8]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b0) && (EMAA[1] == 1'b1) && (EMAA[0] == 1'b1))
        (posedge CLKA => (QA[8]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b1) && (EMAA[1] == 1'b0) && (EMAA[0] == 1'b0))
        (posedge CLKA => (QA[8]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b1) && (EMAA[1] == 1'b0) && (EMAA[0] == 1'b1))
        (posedge CLKA => (QA[8]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b1) && (EMAA[1] == 1'b1) && (EMAA[0] == 1'b0))
        (posedge CLKA => (QA[8]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b1) && (EMAA[1] == 1'b1) && (EMAA[0] == 1'b1))
        (posedge CLKA => (QA[8]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b0) && (EMAA[1] == 1'b0) && (EMAA[0] == 1'b0))
        (posedge CLKA => (QA[7]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b0) && (EMAA[1] == 1'b0) && (EMAA[0] == 1'b1))
        (posedge CLKA => (QA[7]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b0) && (EMAA[1] == 1'b1) && (EMAA[0] == 1'b0))
        (posedge CLKA => (QA[7]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b0) && (EMAA[1] == 1'b1) && (EMAA[0] == 1'b1))
        (posedge CLKA => (QA[7]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b1) && (EMAA[1] == 1'b0) && (EMAA[0] == 1'b0))
        (posedge CLKA => (QA[7]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b1) && (EMAA[1] == 1'b0) && (EMAA[0] == 1'b1))
        (posedge CLKA => (QA[7]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b1) && (EMAA[1] == 1'b1) && (EMAA[0] == 1'b0))
        (posedge CLKA => (QA[7]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b1) && (EMAA[1] == 1'b1) && (EMAA[0] == 1'b1))
        (posedge CLKA => (QA[7]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b0) && (EMAA[1] == 1'b0) && (EMAA[0] == 1'b0))
        (posedge CLKA => (QA[6]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b0) && (EMAA[1] == 1'b0) && (EMAA[0] == 1'b1))
        (posedge CLKA => (QA[6]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b0) && (EMAA[1] == 1'b1) && (EMAA[0] == 1'b0))
        (posedge CLKA => (QA[6]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b0) && (EMAA[1] == 1'b1) && (EMAA[0] == 1'b1))
        (posedge CLKA => (QA[6]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b1) && (EMAA[1] == 1'b0) && (EMAA[0] == 1'b0))
        (posedge CLKA => (QA[6]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b1) && (EMAA[1] == 1'b0) && (EMAA[0] == 1'b1))
        (posedge CLKA => (QA[6]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b1) && (EMAA[1] == 1'b1) && (EMAA[0] == 1'b0))
        (posedge CLKA => (QA[6]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b1) && (EMAA[1] == 1'b1) && (EMAA[0] == 1'b1))
        (posedge CLKA => (QA[6]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b0) && (EMAA[1] == 1'b0) && (EMAA[0] == 1'b0))
        (posedge CLKA => (QA[5]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b0) && (EMAA[1] == 1'b0) && (EMAA[0] == 1'b1))
        (posedge CLKA => (QA[5]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b0) && (EMAA[1] == 1'b1) && (EMAA[0] == 1'b0))
        (posedge CLKA => (QA[5]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b0) && (EMAA[1] == 1'b1) && (EMAA[0] == 1'b1))
        (posedge CLKA => (QA[5]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b1) && (EMAA[1] == 1'b0) && (EMAA[0] == 1'b0))
        (posedge CLKA => (QA[5]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b1) && (EMAA[1] == 1'b0) && (EMAA[0] == 1'b1))
        (posedge CLKA => (QA[5]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b1) && (EMAA[1] == 1'b1) && (EMAA[0] == 1'b0))
        (posedge CLKA => (QA[5]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b1) && (EMAA[1] == 1'b1) && (EMAA[0] == 1'b1))
        (posedge CLKA => (QA[5]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b0) && (EMAA[1] == 1'b0) && (EMAA[0] == 1'b0))
        (posedge CLKA => (QA[4]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b0) && (EMAA[1] == 1'b0) && (EMAA[0] == 1'b1))
        (posedge CLKA => (QA[4]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b0) && (EMAA[1] == 1'b1) && (EMAA[0] == 1'b0))
        (posedge CLKA => (QA[4]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b0) && (EMAA[1] == 1'b1) && (EMAA[0] == 1'b1))
        (posedge CLKA => (QA[4]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b1) && (EMAA[1] == 1'b0) && (EMAA[0] == 1'b0))
        (posedge CLKA => (QA[4]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b1) && (EMAA[1] == 1'b0) && (EMAA[0] == 1'b1))
        (posedge CLKA => (QA[4]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b1) && (EMAA[1] == 1'b1) && (EMAA[0] == 1'b0))
        (posedge CLKA => (QA[4]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b1) && (EMAA[1] == 1'b1) && (EMAA[0] == 1'b1))
        (posedge CLKA => (QA[4]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b0) && (EMAA[1] == 1'b0) && (EMAA[0] == 1'b0))
        (posedge CLKA => (QA[3]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b0) && (EMAA[1] == 1'b0) && (EMAA[0] == 1'b1))
        (posedge CLKA => (QA[3]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b0) && (EMAA[1] == 1'b1) && (EMAA[0] == 1'b0))
        (posedge CLKA => (QA[3]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b0) && (EMAA[1] == 1'b1) && (EMAA[0] == 1'b1))
        (posedge CLKA => (QA[3]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b1) && (EMAA[1] == 1'b0) && (EMAA[0] == 1'b0))
        (posedge CLKA => (QA[3]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b1) && (EMAA[1] == 1'b0) && (EMAA[0] == 1'b1))
        (posedge CLKA => (QA[3]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b1) && (EMAA[1] == 1'b1) && (EMAA[0] == 1'b0))
        (posedge CLKA => (QA[3]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b1) && (EMAA[1] == 1'b1) && (EMAA[0] == 1'b1))
        (posedge CLKA => (QA[3]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b0) && (EMAA[1] == 1'b0) && (EMAA[0] == 1'b0))
        (posedge CLKA => (QA[2]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b0) && (EMAA[1] == 1'b0) && (EMAA[0] == 1'b1))
        (posedge CLKA => (QA[2]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b0) && (EMAA[1] == 1'b1) && (EMAA[0] == 1'b0))
        (posedge CLKA => (QA[2]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b0) && (EMAA[1] == 1'b1) && (EMAA[0] == 1'b1))
        (posedge CLKA => (QA[2]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b1) && (EMAA[1] == 1'b0) && (EMAA[0] == 1'b0))
        (posedge CLKA => (QA[2]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b1) && (EMAA[1] == 1'b0) && (EMAA[0] == 1'b1))
        (posedge CLKA => (QA[2]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b1) && (EMAA[1] == 1'b1) && (EMAA[0] == 1'b0))
        (posedge CLKA => (QA[2]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b1) && (EMAA[1] == 1'b1) && (EMAA[0] == 1'b1))
        (posedge CLKA => (QA[2]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b0) && (EMAA[1] == 1'b0) && (EMAA[0] == 1'b0))
        (posedge CLKA => (QA[1]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b0) && (EMAA[1] == 1'b0) && (EMAA[0] == 1'b1))
        (posedge CLKA => (QA[1]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b0) && (EMAA[1] == 1'b1) && (EMAA[0] == 1'b0))
        (posedge CLKA => (QA[1]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b0) && (EMAA[1] == 1'b1) && (EMAA[0] == 1'b1))
        (posedge CLKA => (QA[1]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b1) && (EMAA[1] == 1'b0) && (EMAA[0] == 1'b0))
        (posedge CLKA => (QA[1]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b1) && (EMAA[1] == 1'b0) && (EMAA[0] == 1'b1))
        (posedge CLKA => (QA[1]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b1) && (EMAA[1] == 1'b1) && (EMAA[0] == 1'b0))
        (posedge CLKA => (QA[1]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b1) && (EMAA[1] == 1'b1) && (EMAA[0] == 1'b1))
        (posedge CLKA => (QA[1]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b0) && (EMAA[1] == 1'b0) && (EMAA[0] == 1'b0))
        (posedge CLKA => (QA[0]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b0) && (EMAA[1] == 1'b0) && (EMAA[0] == 1'b1))
        (posedge CLKA => (QA[0]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b0) && (EMAA[1] == 1'b1) && (EMAA[0] == 1'b0))
        (posedge CLKA => (QA[0]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b0) && (EMAA[1] == 1'b1) && (EMAA[0] == 1'b1))
        (posedge CLKA => (QA[0]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b1) && (EMAA[1] == 1'b0) && (EMAA[0] == 1'b0))
        (posedge CLKA => (QA[0]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b1) && (EMAA[1] == 1'b0) && (EMAA[0] == 1'b1))
        (posedge CLKA => (QA[0]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b1) && (EMAA[1] == 1'b1) && (EMAA[0] == 1'b0))
        (posedge CLKA => (QA[0]:1'b0))=(1.000, 1.000);
      if ((EMAA[2] == 1'b1) && (EMAA[1] == 1'b1) && (EMAA[0] == 1'b1))
        (posedge CLKA => (QA[0]:1'b0))=(1.000, 1.000);

      (RETN => (QA[31] +: 1'b0)) = (1.000);
      (RETN => (QA[30] +: 1'b0)) = (1.000);
      (RETN => (QA[29] +: 1'b0)) = (1.000);
      (RETN => (QA[28] +: 1'b0)) = (1.000);
      (RETN => (QA[27] +: 1'b0)) = (1.000);
      (RETN => (QA[26] +: 1'b0)) = (1.000);
      (RETN => (QA[25] +: 1'b0)) = (1.000);
      (RETN => (QA[24] +: 1'b0)) = (1.000);
      (RETN => (QA[23] +: 1'b0)) = (1.000);
      (RETN => (QA[22] +: 1'b0)) = (1.000);
      (RETN => (QA[21] +: 1'b0)) = (1.000);
      (RETN => (QA[20] +: 1'b0)) = (1.000);
      (RETN => (QA[19] +: 1'b0)) = (1.000);
      (RETN => (QA[18] +: 1'b0)) = (1.000);
      (RETN => (QA[17] +: 1'b0)) = (1.000);
      (RETN => (QA[16] +: 1'b0)) = (1.000);
      (RETN => (QA[15] +: 1'b0)) = (1.000);
      (RETN => (QA[14] +: 1'b0)) = (1.000);
      (RETN => (QA[13] +: 1'b0)) = (1.000);
      (RETN => (QA[12] +: 1'b0)) = (1.000);
      (RETN => (QA[11] +: 1'b0)) = (1.000);
      (RETN => (QA[10] +: 1'b0)) = (1.000);
      (RETN => (QA[9] +: 1'b0)) = (1.000);
      (RETN => (QA[8] +: 1'b0)) = (1.000);
      (RETN => (QA[7] +: 1'b0)) = (1.000);
      (RETN => (QA[6] +: 1'b0)) = (1.000);
      (RETN => (QA[5] +: 1'b0)) = (1.000);
      (RETN => (QA[4] +: 1'b0)) = (1.000);
      (RETN => (QA[3] +: 1'b0)) = (1.000);
      (RETN => (QA[2] +: 1'b0)) = (1.000);
      (RETN => (QA[1] +: 1'b0)) = (1.000);
      (RETN => (QA[0] +: 1'b0)) = (1.000);
      if ((EMAB[2] == 1'b0) && (EMAB[1] == 1'b0) && (EMAB[0] == 1'b0))
        (posedge CLKB => (QB[31]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b0) && (EMAB[1] == 1'b0) && (EMAB[0] == 1'b1))
        (posedge CLKB => (QB[31]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b0) && (EMAB[1] == 1'b1) && (EMAB[0] == 1'b0))
        (posedge CLKB => (QB[31]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b0) && (EMAB[1] == 1'b1) && (EMAB[0] == 1'b1))
        (posedge CLKB => (QB[31]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b1) && (EMAB[1] == 1'b0) && (EMAB[0] == 1'b0))
        (posedge CLKB => (QB[31]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b1) && (EMAB[1] == 1'b0) && (EMAB[0] == 1'b1))
        (posedge CLKB => (QB[31]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b1) && (EMAB[1] == 1'b1) && (EMAB[0] == 1'b0))
        (posedge CLKB => (QB[31]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b1) && (EMAB[1] == 1'b1) && (EMAB[0] == 1'b1))
        (posedge CLKB => (QB[31]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b0) && (EMAB[1] == 1'b0) && (EMAB[0] == 1'b0))
        (posedge CLKB => (QB[30]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b0) && (EMAB[1] == 1'b0) && (EMAB[0] == 1'b1))
        (posedge CLKB => (QB[30]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b0) && (EMAB[1] == 1'b1) && (EMAB[0] == 1'b0))
        (posedge CLKB => (QB[30]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b0) && (EMAB[1] == 1'b1) && (EMAB[0] == 1'b1))
        (posedge CLKB => (QB[30]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b1) && (EMAB[1] == 1'b0) && (EMAB[0] == 1'b0))
        (posedge CLKB => (QB[30]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b1) && (EMAB[1] == 1'b0) && (EMAB[0] == 1'b1))
        (posedge CLKB => (QB[30]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b1) && (EMAB[1] == 1'b1) && (EMAB[0] == 1'b0))
        (posedge CLKB => (QB[30]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b1) && (EMAB[1] == 1'b1) && (EMAB[0] == 1'b1))
        (posedge CLKB => (QB[30]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b0) && (EMAB[1] == 1'b0) && (EMAB[0] == 1'b0))
        (posedge CLKB => (QB[29]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b0) && (EMAB[1] == 1'b0) && (EMAB[0] == 1'b1))
        (posedge CLKB => (QB[29]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b0) && (EMAB[1] == 1'b1) && (EMAB[0] == 1'b0))
        (posedge CLKB => (QB[29]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b0) && (EMAB[1] == 1'b1) && (EMAB[0] == 1'b1))
        (posedge CLKB => (QB[29]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b1) && (EMAB[1] == 1'b0) && (EMAB[0] == 1'b0))
        (posedge CLKB => (QB[29]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b1) && (EMAB[1] == 1'b0) && (EMAB[0] == 1'b1))
        (posedge CLKB => (QB[29]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b1) && (EMAB[1] == 1'b1) && (EMAB[0] == 1'b0))
        (posedge CLKB => (QB[29]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b1) && (EMAB[1] == 1'b1) && (EMAB[0] == 1'b1))
        (posedge CLKB => (QB[29]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b0) && (EMAB[1] == 1'b0) && (EMAB[0] == 1'b0))
        (posedge CLKB => (QB[28]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b0) && (EMAB[1] == 1'b0) && (EMAB[0] == 1'b1))
        (posedge CLKB => (QB[28]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b0) && (EMAB[1] == 1'b1) && (EMAB[0] == 1'b0))
        (posedge CLKB => (QB[28]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b0) && (EMAB[1] == 1'b1) && (EMAB[0] == 1'b1))
        (posedge CLKB => (QB[28]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b1) && (EMAB[1] == 1'b0) && (EMAB[0] == 1'b0))
        (posedge CLKB => (QB[28]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b1) && (EMAB[1] == 1'b0) && (EMAB[0] == 1'b1))
        (posedge CLKB => (QB[28]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b1) && (EMAB[1] == 1'b1) && (EMAB[0] == 1'b0))
        (posedge CLKB => (QB[28]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b1) && (EMAB[1] == 1'b1) && (EMAB[0] == 1'b1))
        (posedge CLKB => (QB[28]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b0) && (EMAB[1] == 1'b0) && (EMAB[0] == 1'b0))
        (posedge CLKB => (QB[27]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b0) && (EMAB[1] == 1'b0) && (EMAB[0] == 1'b1))
        (posedge CLKB => (QB[27]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b0) && (EMAB[1] == 1'b1) && (EMAB[0] == 1'b0))
        (posedge CLKB => (QB[27]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b0) && (EMAB[1] == 1'b1) && (EMAB[0] == 1'b1))
        (posedge CLKB => (QB[27]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b1) && (EMAB[1] == 1'b0) && (EMAB[0] == 1'b0))
        (posedge CLKB => (QB[27]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b1) && (EMAB[1] == 1'b0) && (EMAB[0] == 1'b1))
        (posedge CLKB => (QB[27]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b1) && (EMAB[1] == 1'b1) && (EMAB[0] == 1'b0))
        (posedge CLKB => (QB[27]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b1) && (EMAB[1] == 1'b1) && (EMAB[0] == 1'b1))
        (posedge CLKB => (QB[27]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b0) && (EMAB[1] == 1'b0) && (EMAB[0] == 1'b0))
        (posedge CLKB => (QB[26]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b0) && (EMAB[1] == 1'b0) && (EMAB[0] == 1'b1))
        (posedge CLKB => (QB[26]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b0) && (EMAB[1] == 1'b1) && (EMAB[0] == 1'b0))
        (posedge CLKB => (QB[26]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b0) && (EMAB[1] == 1'b1) && (EMAB[0] == 1'b1))
        (posedge CLKB => (QB[26]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b1) && (EMAB[1] == 1'b0) && (EMAB[0] == 1'b0))
        (posedge CLKB => (QB[26]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b1) && (EMAB[1] == 1'b0) && (EMAB[0] == 1'b1))
        (posedge CLKB => (QB[26]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b1) && (EMAB[1] == 1'b1) && (EMAB[0] == 1'b0))
        (posedge CLKB => (QB[26]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b1) && (EMAB[1] == 1'b1) && (EMAB[0] == 1'b1))
        (posedge CLKB => (QB[26]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b0) && (EMAB[1] == 1'b0) && (EMAB[0] == 1'b0))
        (posedge CLKB => (QB[25]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b0) && (EMAB[1] == 1'b0) && (EMAB[0] == 1'b1))
        (posedge CLKB => (QB[25]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b0) && (EMAB[1] == 1'b1) && (EMAB[0] == 1'b0))
        (posedge CLKB => (QB[25]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b0) && (EMAB[1] == 1'b1) && (EMAB[0] == 1'b1))
        (posedge CLKB => (QB[25]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b1) && (EMAB[1] == 1'b0) && (EMAB[0] == 1'b0))
        (posedge CLKB => (QB[25]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b1) && (EMAB[1] == 1'b0) && (EMAB[0] == 1'b1))
        (posedge CLKB => (QB[25]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b1) && (EMAB[1] == 1'b1) && (EMAB[0] == 1'b0))
        (posedge CLKB => (QB[25]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b1) && (EMAB[1] == 1'b1) && (EMAB[0] == 1'b1))
        (posedge CLKB => (QB[25]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b0) && (EMAB[1] == 1'b0) && (EMAB[0] == 1'b0))
        (posedge CLKB => (QB[24]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b0) && (EMAB[1] == 1'b0) && (EMAB[0] == 1'b1))
        (posedge CLKB => (QB[24]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b0) && (EMAB[1] == 1'b1) && (EMAB[0] == 1'b0))
        (posedge CLKB => (QB[24]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b0) && (EMAB[1] == 1'b1) && (EMAB[0] == 1'b1))
        (posedge CLKB => (QB[24]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b1) && (EMAB[1] == 1'b0) && (EMAB[0] == 1'b0))
        (posedge CLKB => (QB[24]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b1) && (EMAB[1] == 1'b0) && (EMAB[0] == 1'b1))
        (posedge CLKB => (QB[24]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b1) && (EMAB[1] == 1'b1) && (EMAB[0] == 1'b0))
        (posedge CLKB => (QB[24]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b1) && (EMAB[1] == 1'b1) && (EMAB[0] == 1'b1))
        (posedge CLKB => (QB[24]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b0) && (EMAB[1] == 1'b0) && (EMAB[0] == 1'b0))
        (posedge CLKB => (QB[23]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b0) && (EMAB[1] == 1'b0) && (EMAB[0] == 1'b1))
        (posedge CLKB => (QB[23]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b0) && (EMAB[1] == 1'b1) && (EMAB[0] == 1'b0))
        (posedge CLKB => (QB[23]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b0) && (EMAB[1] == 1'b1) && (EMAB[0] == 1'b1))
        (posedge CLKB => (QB[23]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b1) && (EMAB[1] == 1'b0) && (EMAB[0] == 1'b0))
        (posedge CLKB => (QB[23]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b1) && (EMAB[1] == 1'b0) && (EMAB[0] == 1'b1))
        (posedge CLKB => (QB[23]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b1) && (EMAB[1] == 1'b1) && (EMAB[0] == 1'b0))
        (posedge CLKB => (QB[23]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b1) && (EMAB[1] == 1'b1) && (EMAB[0] == 1'b1))
        (posedge CLKB => (QB[23]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b0) && (EMAB[1] == 1'b0) && (EMAB[0] == 1'b0))
        (posedge CLKB => (QB[22]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b0) && (EMAB[1] == 1'b0) && (EMAB[0] == 1'b1))
        (posedge CLKB => (QB[22]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b0) && (EMAB[1] == 1'b1) && (EMAB[0] == 1'b0))
        (posedge CLKB => (QB[22]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b0) && (EMAB[1] == 1'b1) && (EMAB[0] == 1'b1))
        (posedge CLKB => (QB[22]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b1) && (EMAB[1] == 1'b0) && (EMAB[0] == 1'b0))
        (posedge CLKB => (QB[22]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b1) && (EMAB[1] == 1'b0) && (EMAB[0] == 1'b1))
        (posedge CLKB => (QB[22]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b1) && (EMAB[1] == 1'b1) && (EMAB[0] == 1'b0))
        (posedge CLKB => (QB[22]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b1) && (EMAB[1] == 1'b1) && (EMAB[0] == 1'b1))
        (posedge CLKB => (QB[22]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b0) && (EMAB[1] == 1'b0) && (EMAB[0] == 1'b0))
        (posedge CLKB => (QB[21]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b0) && (EMAB[1] == 1'b0) && (EMAB[0] == 1'b1))
        (posedge CLKB => (QB[21]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b0) && (EMAB[1] == 1'b1) && (EMAB[0] == 1'b0))
        (posedge CLKB => (QB[21]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b0) && (EMAB[1] == 1'b1) && (EMAB[0] == 1'b1))
        (posedge CLKB => (QB[21]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b1) && (EMAB[1] == 1'b0) && (EMAB[0] == 1'b0))
        (posedge CLKB => (QB[21]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b1) && (EMAB[1] == 1'b0) && (EMAB[0] == 1'b1))
        (posedge CLKB => (QB[21]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b1) && (EMAB[1] == 1'b1) && (EMAB[0] == 1'b0))
        (posedge CLKB => (QB[21]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b1) && (EMAB[1] == 1'b1) && (EMAB[0] == 1'b1))
        (posedge CLKB => (QB[21]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b0) && (EMAB[1] == 1'b0) && (EMAB[0] == 1'b0))
        (posedge CLKB => (QB[20]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b0) && (EMAB[1] == 1'b0) && (EMAB[0] == 1'b1))
        (posedge CLKB => (QB[20]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b0) && (EMAB[1] == 1'b1) && (EMAB[0] == 1'b0))
        (posedge CLKB => (QB[20]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b0) && (EMAB[1] == 1'b1) && (EMAB[0] == 1'b1))
        (posedge CLKB => (QB[20]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b1) && (EMAB[1] == 1'b0) && (EMAB[0] == 1'b0))
        (posedge CLKB => (QB[20]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b1) && (EMAB[1] == 1'b0) && (EMAB[0] == 1'b1))
        (posedge CLKB => (QB[20]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b1) && (EMAB[1] == 1'b1) && (EMAB[0] == 1'b0))
        (posedge CLKB => (QB[20]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b1) && (EMAB[1] == 1'b1) && (EMAB[0] == 1'b1))
        (posedge CLKB => (QB[20]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b0) && (EMAB[1] == 1'b0) && (EMAB[0] == 1'b0))
        (posedge CLKB => (QB[19]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b0) && (EMAB[1] == 1'b0) && (EMAB[0] == 1'b1))
        (posedge CLKB => (QB[19]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b0) && (EMAB[1] == 1'b1) && (EMAB[0] == 1'b0))
        (posedge CLKB => (QB[19]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b0) && (EMAB[1] == 1'b1) && (EMAB[0] == 1'b1))
        (posedge CLKB => (QB[19]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b1) && (EMAB[1] == 1'b0) && (EMAB[0] == 1'b0))
        (posedge CLKB => (QB[19]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b1) && (EMAB[1] == 1'b0) && (EMAB[0] == 1'b1))
        (posedge CLKB => (QB[19]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b1) && (EMAB[1] == 1'b1) && (EMAB[0] == 1'b0))
        (posedge CLKB => (QB[19]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b1) && (EMAB[1] == 1'b1) && (EMAB[0] == 1'b1))
        (posedge CLKB => (QB[19]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b0) && (EMAB[1] == 1'b0) && (EMAB[0] == 1'b0))
        (posedge CLKB => (QB[18]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b0) && (EMAB[1] == 1'b0) && (EMAB[0] == 1'b1))
        (posedge CLKB => (QB[18]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b0) && (EMAB[1] == 1'b1) && (EMAB[0] == 1'b0))
        (posedge CLKB => (QB[18]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b0) && (EMAB[1] == 1'b1) && (EMAB[0] == 1'b1))
        (posedge CLKB => (QB[18]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b1) && (EMAB[1] == 1'b0) && (EMAB[0] == 1'b0))
        (posedge CLKB => (QB[18]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b1) && (EMAB[1] == 1'b0) && (EMAB[0] == 1'b1))
        (posedge CLKB => (QB[18]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b1) && (EMAB[1] == 1'b1) && (EMAB[0] == 1'b0))
        (posedge CLKB => (QB[18]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b1) && (EMAB[1] == 1'b1) && (EMAB[0] == 1'b1))
        (posedge CLKB => (QB[18]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b0) && (EMAB[1] == 1'b0) && (EMAB[0] == 1'b0))
        (posedge CLKB => (QB[17]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b0) && (EMAB[1] == 1'b0) && (EMAB[0] == 1'b1))
        (posedge CLKB => (QB[17]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b0) && (EMAB[1] == 1'b1) && (EMAB[0] == 1'b0))
        (posedge CLKB => (QB[17]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b0) && (EMAB[1] == 1'b1) && (EMAB[0] == 1'b1))
        (posedge CLKB => (QB[17]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b1) && (EMAB[1] == 1'b0) && (EMAB[0] == 1'b0))
        (posedge CLKB => (QB[17]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b1) && (EMAB[1] == 1'b0) && (EMAB[0] == 1'b1))
        (posedge CLKB => (QB[17]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b1) && (EMAB[1] == 1'b1) && (EMAB[0] == 1'b0))
        (posedge CLKB => (QB[17]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b1) && (EMAB[1] == 1'b1) && (EMAB[0] == 1'b1))
        (posedge CLKB => (QB[17]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b0) && (EMAB[1] == 1'b0) && (EMAB[0] == 1'b0))
        (posedge CLKB => (QB[16]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b0) && (EMAB[1] == 1'b0) && (EMAB[0] == 1'b1))
        (posedge CLKB => (QB[16]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b0) && (EMAB[1] == 1'b1) && (EMAB[0] == 1'b0))
        (posedge CLKB => (QB[16]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b0) && (EMAB[1] == 1'b1) && (EMAB[0] == 1'b1))
        (posedge CLKB => (QB[16]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b1) && (EMAB[1] == 1'b0) && (EMAB[0] == 1'b0))
        (posedge CLKB => (QB[16]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b1) && (EMAB[1] == 1'b0) && (EMAB[0] == 1'b1))
        (posedge CLKB => (QB[16]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b1) && (EMAB[1] == 1'b1) && (EMAB[0] == 1'b0))
        (posedge CLKB => (QB[16]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b1) && (EMAB[1] == 1'b1) && (EMAB[0] == 1'b1))
        (posedge CLKB => (QB[16]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b0) && (EMAB[1] == 1'b0) && (EMAB[0] == 1'b0))
        (posedge CLKB => (QB[15]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b0) && (EMAB[1] == 1'b0) && (EMAB[0] == 1'b1))
        (posedge CLKB => (QB[15]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b0) && (EMAB[1] == 1'b1) && (EMAB[0] == 1'b0))
        (posedge CLKB => (QB[15]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b0) && (EMAB[1] == 1'b1) && (EMAB[0] == 1'b1))
        (posedge CLKB => (QB[15]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b1) && (EMAB[1] == 1'b0) && (EMAB[0] == 1'b0))
        (posedge CLKB => (QB[15]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b1) && (EMAB[1] == 1'b0) && (EMAB[0] == 1'b1))
        (posedge CLKB => (QB[15]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b1) && (EMAB[1] == 1'b1) && (EMAB[0] == 1'b0))
        (posedge CLKB => (QB[15]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b1) && (EMAB[1] == 1'b1) && (EMAB[0] == 1'b1))
        (posedge CLKB => (QB[15]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b0) && (EMAB[1] == 1'b0) && (EMAB[0] == 1'b0))
        (posedge CLKB => (QB[14]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b0) && (EMAB[1] == 1'b0) && (EMAB[0] == 1'b1))
        (posedge CLKB => (QB[14]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b0) && (EMAB[1] == 1'b1) && (EMAB[0] == 1'b0))
        (posedge CLKB => (QB[14]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b0) && (EMAB[1] == 1'b1) && (EMAB[0] == 1'b1))
        (posedge CLKB => (QB[14]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b1) && (EMAB[1] == 1'b0) && (EMAB[0] == 1'b0))
        (posedge CLKB => (QB[14]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b1) && (EMAB[1] == 1'b0) && (EMAB[0] == 1'b1))
        (posedge CLKB => (QB[14]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b1) && (EMAB[1] == 1'b1) && (EMAB[0] == 1'b0))
        (posedge CLKB => (QB[14]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b1) && (EMAB[1] == 1'b1) && (EMAB[0] == 1'b1))
        (posedge CLKB => (QB[14]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b0) && (EMAB[1] == 1'b0) && (EMAB[0] == 1'b0))
        (posedge CLKB => (QB[13]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b0) && (EMAB[1] == 1'b0) && (EMAB[0] == 1'b1))
        (posedge CLKB => (QB[13]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b0) && (EMAB[1] == 1'b1) && (EMAB[0] == 1'b0))
        (posedge CLKB => (QB[13]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b0) && (EMAB[1] == 1'b1) && (EMAB[0] == 1'b1))
        (posedge CLKB => (QB[13]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b1) && (EMAB[1] == 1'b0) && (EMAB[0] == 1'b0))
        (posedge CLKB => (QB[13]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b1) && (EMAB[1] == 1'b0) && (EMAB[0] == 1'b1))
        (posedge CLKB => (QB[13]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b1) && (EMAB[1] == 1'b1) && (EMAB[0] == 1'b0))
        (posedge CLKB => (QB[13]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b1) && (EMAB[1] == 1'b1) && (EMAB[0] == 1'b1))
        (posedge CLKB => (QB[13]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b0) && (EMAB[1] == 1'b0) && (EMAB[0] == 1'b0))
        (posedge CLKB => (QB[12]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b0) && (EMAB[1] == 1'b0) && (EMAB[0] == 1'b1))
        (posedge CLKB => (QB[12]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b0) && (EMAB[1] == 1'b1) && (EMAB[0] == 1'b0))
        (posedge CLKB => (QB[12]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b0) && (EMAB[1] == 1'b1) && (EMAB[0] == 1'b1))
        (posedge CLKB => (QB[12]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b1) && (EMAB[1] == 1'b0) && (EMAB[0] == 1'b0))
        (posedge CLKB => (QB[12]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b1) && (EMAB[1] == 1'b0) && (EMAB[0] == 1'b1))
        (posedge CLKB => (QB[12]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b1) && (EMAB[1] == 1'b1) && (EMAB[0] == 1'b0))
        (posedge CLKB => (QB[12]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b1) && (EMAB[1] == 1'b1) && (EMAB[0] == 1'b1))
        (posedge CLKB => (QB[12]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b0) && (EMAB[1] == 1'b0) && (EMAB[0] == 1'b0))
        (posedge CLKB => (QB[11]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b0) && (EMAB[1] == 1'b0) && (EMAB[0] == 1'b1))
        (posedge CLKB => (QB[11]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b0) && (EMAB[1] == 1'b1) && (EMAB[0] == 1'b0))
        (posedge CLKB => (QB[11]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b0) && (EMAB[1] == 1'b1) && (EMAB[0] == 1'b1))
        (posedge CLKB => (QB[11]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b1) && (EMAB[1] == 1'b0) && (EMAB[0] == 1'b0))
        (posedge CLKB => (QB[11]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b1) && (EMAB[1] == 1'b0) && (EMAB[0] == 1'b1))
        (posedge CLKB => (QB[11]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b1) && (EMAB[1] == 1'b1) && (EMAB[0] == 1'b0))
        (posedge CLKB => (QB[11]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b1) && (EMAB[1] == 1'b1) && (EMAB[0] == 1'b1))
        (posedge CLKB => (QB[11]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b0) && (EMAB[1] == 1'b0) && (EMAB[0] == 1'b0))
        (posedge CLKB => (QB[10]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b0) && (EMAB[1] == 1'b0) && (EMAB[0] == 1'b1))
        (posedge CLKB => (QB[10]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b0) && (EMAB[1] == 1'b1) && (EMAB[0] == 1'b0))
        (posedge CLKB => (QB[10]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b0) && (EMAB[1] == 1'b1) && (EMAB[0] == 1'b1))
        (posedge CLKB => (QB[10]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b1) && (EMAB[1] == 1'b0) && (EMAB[0] == 1'b0))
        (posedge CLKB => (QB[10]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b1) && (EMAB[1] == 1'b0) && (EMAB[0] == 1'b1))
        (posedge CLKB => (QB[10]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b1) && (EMAB[1] == 1'b1) && (EMAB[0] == 1'b0))
        (posedge CLKB => (QB[10]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b1) && (EMAB[1] == 1'b1) && (EMAB[0] == 1'b1))
        (posedge CLKB => (QB[10]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b0) && (EMAB[1] == 1'b0) && (EMAB[0] == 1'b0))
        (posedge CLKB => (QB[9]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b0) && (EMAB[1] == 1'b0) && (EMAB[0] == 1'b1))
        (posedge CLKB => (QB[9]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b0) && (EMAB[1] == 1'b1) && (EMAB[0] == 1'b0))
        (posedge CLKB => (QB[9]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b0) && (EMAB[1] == 1'b1) && (EMAB[0] == 1'b1))
        (posedge CLKB => (QB[9]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b1) && (EMAB[1] == 1'b0) && (EMAB[0] == 1'b0))
        (posedge CLKB => (QB[9]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b1) && (EMAB[1] == 1'b0) && (EMAB[0] == 1'b1))
        (posedge CLKB => (QB[9]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b1) && (EMAB[1] == 1'b1) && (EMAB[0] == 1'b0))
        (posedge CLKB => (QB[9]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b1) && (EMAB[1] == 1'b1) && (EMAB[0] == 1'b1))
        (posedge CLKB => (QB[9]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b0) && (EMAB[1] == 1'b0) && (EMAB[0] == 1'b0))
        (posedge CLKB => (QB[8]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b0) && (EMAB[1] == 1'b0) && (EMAB[0] == 1'b1))
        (posedge CLKB => (QB[8]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b0) && (EMAB[1] == 1'b1) && (EMAB[0] == 1'b0))
        (posedge CLKB => (QB[8]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b0) && (EMAB[1] == 1'b1) && (EMAB[0] == 1'b1))
        (posedge CLKB => (QB[8]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b1) && (EMAB[1] == 1'b0) && (EMAB[0] == 1'b0))
        (posedge CLKB => (QB[8]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b1) && (EMAB[1] == 1'b0) && (EMAB[0] == 1'b1))
        (posedge CLKB => (QB[8]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b1) && (EMAB[1] == 1'b1) && (EMAB[0] == 1'b0))
        (posedge CLKB => (QB[8]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b1) && (EMAB[1] == 1'b1) && (EMAB[0] == 1'b1))
        (posedge CLKB => (QB[8]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b0) && (EMAB[1] == 1'b0) && (EMAB[0] == 1'b0))
        (posedge CLKB => (QB[7]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b0) && (EMAB[1] == 1'b0) && (EMAB[0] == 1'b1))
        (posedge CLKB => (QB[7]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b0) && (EMAB[1] == 1'b1) && (EMAB[0] == 1'b0))
        (posedge CLKB => (QB[7]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b0) && (EMAB[1] == 1'b1) && (EMAB[0] == 1'b1))
        (posedge CLKB => (QB[7]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b1) && (EMAB[1] == 1'b0) && (EMAB[0] == 1'b0))
        (posedge CLKB => (QB[7]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b1) && (EMAB[1] == 1'b0) && (EMAB[0] == 1'b1))
        (posedge CLKB => (QB[7]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b1) && (EMAB[1] == 1'b1) && (EMAB[0] == 1'b0))
        (posedge CLKB => (QB[7]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b1) && (EMAB[1] == 1'b1) && (EMAB[0] == 1'b1))
        (posedge CLKB => (QB[7]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b0) && (EMAB[1] == 1'b0) && (EMAB[0] == 1'b0))
        (posedge CLKB => (QB[6]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b0) && (EMAB[1] == 1'b0) && (EMAB[0] == 1'b1))
        (posedge CLKB => (QB[6]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b0) && (EMAB[1] == 1'b1) && (EMAB[0] == 1'b0))
        (posedge CLKB => (QB[6]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b0) && (EMAB[1] == 1'b1) && (EMAB[0] == 1'b1))
        (posedge CLKB => (QB[6]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b1) && (EMAB[1] == 1'b0) && (EMAB[0] == 1'b0))
        (posedge CLKB => (QB[6]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b1) && (EMAB[1] == 1'b0) && (EMAB[0] == 1'b1))
        (posedge CLKB => (QB[6]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b1) && (EMAB[1] == 1'b1) && (EMAB[0] == 1'b0))
        (posedge CLKB => (QB[6]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b1) && (EMAB[1] == 1'b1) && (EMAB[0] == 1'b1))
        (posedge CLKB => (QB[6]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b0) && (EMAB[1] == 1'b0) && (EMAB[0] == 1'b0))
        (posedge CLKB => (QB[5]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b0) && (EMAB[1] == 1'b0) && (EMAB[0] == 1'b1))
        (posedge CLKB => (QB[5]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b0) && (EMAB[1] == 1'b1) && (EMAB[0] == 1'b0))
        (posedge CLKB => (QB[5]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b0) && (EMAB[1] == 1'b1) && (EMAB[0] == 1'b1))
        (posedge CLKB => (QB[5]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b1) && (EMAB[1] == 1'b0) && (EMAB[0] == 1'b0))
        (posedge CLKB => (QB[5]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b1) && (EMAB[1] == 1'b0) && (EMAB[0] == 1'b1))
        (posedge CLKB => (QB[5]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b1) && (EMAB[1] == 1'b1) && (EMAB[0] == 1'b0))
        (posedge CLKB => (QB[5]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b1) && (EMAB[1] == 1'b1) && (EMAB[0] == 1'b1))
        (posedge CLKB => (QB[5]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b0) && (EMAB[1] == 1'b0) && (EMAB[0] == 1'b0))
        (posedge CLKB => (QB[4]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b0) && (EMAB[1] == 1'b0) && (EMAB[0] == 1'b1))
        (posedge CLKB => (QB[4]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b0) && (EMAB[1] == 1'b1) && (EMAB[0] == 1'b0))
        (posedge CLKB => (QB[4]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b0) && (EMAB[1] == 1'b1) && (EMAB[0] == 1'b1))
        (posedge CLKB => (QB[4]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b1) && (EMAB[1] == 1'b0) && (EMAB[0] == 1'b0))
        (posedge CLKB => (QB[4]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b1) && (EMAB[1] == 1'b0) && (EMAB[0] == 1'b1))
        (posedge CLKB => (QB[4]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b1) && (EMAB[1] == 1'b1) && (EMAB[0] == 1'b0))
        (posedge CLKB => (QB[4]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b1) && (EMAB[1] == 1'b1) && (EMAB[0] == 1'b1))
        (posedge CLKB => (QB[4]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b0) && (EMAB[1] == 1'b0) && (EMAB[0] == 1'b0))
        (posedge CLKB => (QB[3]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b0) && (EMAB[1] == 1'b0) && (EMAB[0] == 1'b1))
        (posedge CLKB => (QB[3]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b0) && (EMAB[1] == 1'b1) && (EMAB[0] == 1'b0))
        (posedge CLKB => (QB[3]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b0) && (EMAB[1] == 1'b1) && (EMAB[0] == 1'b1))
        (posedge CLKB => (QB[3]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b1) && (EMAB[1] == 1'b0) && (EMAB[0] == 1'b0))
        (posedge CLKB => (QB[3]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b1) && (EMAB[1] == 1'b0) && (EMAB[0] == 1'b1))
        (posedge CLKB => (QB[3]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b1) && (EMAB[1] == 1'b1) && (EMAB[0] == 1'b0))
        (posedge CLKB => (QB[3]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b1) && (EMAB[1] == 1'b1) && (EMAB[0] == 1'b1))
        (posedge CLKB => (QB[3]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b0) && (EMAB[1] == 1'b0) && (EMAB[0] == 1'b0))
        (posedge CLKB => (QB[2]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b0) && (EMAB[1] == 1'b0) && (EMAB[0] == 1'b1))
        (posedge CLKB => (QB[2]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b0) && (EMAB[1] == 1'b1) && (EMAB[0] == 1'b0))
        (posedge CLKB => (QB[2]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b0) && (EMAB[1] == 1'b1) && (EMAB[0] == 1'b1))
        (posedge CLKB => (QB[2]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b1) && (EMAB[1] == 1'b0) && (EMAB[0] == 1'b0))
        (posedge CLKB => (QB[2]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b1) && (EMAB[1] == 1'b0) && (EMAB[0] == 1'b1))
        (posedge CLKB => (QB[2]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b1) && (EMAB[1] == 1'b1) && (EMAB[0] == 1'b0))
        (posedge CLKB => (QB[2]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b1) && (EMAB[1] == 1'b1) && (EMAB[0] == 1'b1))
        (posedge CLKB => (QB[2]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b0) && (EMAB[1] == 1'b0) && (EMAB[0] == 1'b0))
        (posedge CLKB => (QB[1]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b0) && (EMAB[1] == 1'b0) && (EMAB[0] == 1'b1))
        (posedge CLKB => (QB[1]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b0) && (EMAB[1] == 1'b1) && (EMAB[0] == 1'b0))
        (posedge CLKB => (QB[1]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b0) && (EMAB[1] == 1'b1) && (EMAB[0] == 1'b1))
        (posedge CLKB => (QB[1]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b1) && (EMAB[1] == 1'b0) && (EMAB[0] == 1'b0))
        (posedge CLKB => (QB[1]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b1) && (EMAB[1] == 1'b0) && (EMAB[0] == 1'b1))
        (posedge CLKB => (QB[1]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b1) && (EMAB[1] == 1'b1) && (EMAB[0] == 1'b0))
        (posedge CLKB => (QB[1]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b1) && (EMAB[1] == 1'b1) && (EMAB[0] == 1'b1))
        (posedge CLKB => (QB[1]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b0) && (EMAB[1] == 1'b0) && (EMAB[0] == 1'b0))
        (posedge CLKB => (QB[0]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b0) && (EMAB[1] == 1'b0) && (EMAB[0] == 1'b1))
        (posedge CLKB => (QB[0]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b0) && (EMAB[1] == 1'b1) && (EMAB[0] == 1'b0))
        (posedge CLKB => (QB[0]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b0) && (EMAB[1] == 1'b1) && (EMAB[0] == 1'b1))
        (posedge CLKB => (QB[0]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b1) && (EMAB[1] == 1'b0) && (EMAB[0] == 1'b0))
        (posedge CLKB => (QB[0]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b1) && (EMAB[1] == 1'b0) && (EMAB[0] == 1'b1))
        (posedge CLKB => (QB[0]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b1) && (EMAB[1] == 1'b1) && (EMAB[0] == 1'b0))
        (posedge CLKB => (QB[0]:1'b0))=(1.000, 1.000);
      if ((EMAB[2] == 1'b1) && (EMAB[1] == 1'b1) && (EMAB[0] == 1'b1))
        (posedge CLKB => (QB[0]:1'b0))=(1.000, 1.000);

      (RETN => (QB[31] +: 1'b0)) = (1.000);
      (RETN => (QB[30] +: 1'b0)) = (1.000);
      (RETN => (QB[29] +: 1'b0)) = (1.000);
      (RETN => (QB[28] +: 1'b0)) = (1.000);
      (RETN => (QB[27] +: 1'b0)) = (1.000);
      (RETN => (QB[26] +: 1'b0)) = (1.000);
      (RETN => (QB[25] +: 1'b0)) = (1.000);
      (RETN => (QB[24] +: 1'b0)) = (1.000);
      (RETN => (QB[23] +: 1'b0)) = (1.000);
      (RETN => (QB[22] +: 1'b0)) = (1.000);
      (RETN => (QB[21] +: 1'b0)) = (1.000);
      (RETN => (QB[20] +: 1'b0)) = (1.000);
      (RETN => (QB[19] +: 1'b0)) = (1.000);
      (RETN => (QB[18] +: 1'b0)) = (1.000);
      (RETN => (QB[17] +: 1'b0)) = (1.000);
      (RETN => (QB[16] +: 1'b0)) = (1.000);
      (RETN => (QB[15] +: 1'b0)) = (1.000);
      (RETN => (QB[14] +: 1'b0)) = (1.000);
      (RETN => (QB[13] +: 1'b0)) = (1.000);
      (RETN => (QB[12] +: 1'b0)) = (1.000);
      (RETN => (QB[11] +: 1'b0)) = (1.000);
      (RETN => (QB[10] +: 1'b0)) = (1.000);
      (RETN => (QB[9] +: 1'b0)) = (1.000);
      (RETN => (QB[8] +: 1'b0)) = (1.000);
      (RETN => (QB[7] +: 1'b0)) = (1.000);
      (RETN => (QB[6] +: 1'b0)) = (1.000);
      (RETN => (QB[5] +: 1'b0)) = (1.000);
      (RETN => (QB[4] +: 1'b0)) = (1.000);
      (RETN => (QB[3] +: 1'b0)) = (1.000);
      (RETN => (QB[2] +: 1'b0)) = (1.000);
      (RETN => (QB[1] +: 1'b0)) = (1.000);
      (RETN => (QB[0] +: 1'b0)) = (1.000);
  endspecify

endmodule
`endcelldefine
`endif
