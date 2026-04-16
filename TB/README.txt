Testbench files for the 1024-point FFT RTL.

Files in this folder:
- tb_fft1024_top.v : top-level simulation testbench for fft1024_top

Expected runtime input files:
- input/input_q1_15_v3.hex
  Format: 10240 lines, one 16-bit Q1.15 hex word per line
- input/twiddle_q15.hex
  Format: 512 lines, one 32-bit hex word per line
  Upper 16 bits are real in Q1.15, lower 16 bits are imag in Q1.15

Generated output file:
- hw_fft_block_q97.txt
  Format: 1024 lines, each line is "real imag" in signed Q9.7

Notes:
- BLOCK_ID is configured inside tb_fft1024_top.v.
- The RTL design files remain in the hw folder.
- The testbench currently opens files using paths relative to the simulation working directory:
  input/input_q1_15_v3.hex and input/twiddle_q15.hex
- The files in golden_out are golden FFT outputs, not testbench inputs.
- golden_out/*.txt include a one-line header and contain FFT results, so they are suitable for output comparison, not for loading DUT inputs.
