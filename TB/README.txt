Simulation quick start (example with Icarus Verilog):

1) Compile
iverilog -g2012 -o sim_fft1024 ^
  rtl/bit_reverse10.v ^
  rtl/bit_reverse_loader.v ^
  rtl/complex_mult_q15.v ^
  rtl/fft_output_quantizer.v ^
  rtl/complex_butterfly.v ^
  rtl/fft_addr_gen.v ^
  rtl/fft_controller.v ^
  rtl/ram_tdp.v ^
  rtl/complex_ram_bank.v ^
  rtl/fft1024_top.v ^
  tb/tb_fft1024_top.v

2) Run
vvp sim_fft1024

Output:
- results/hardware_rtl_output_block0_q15.hex
