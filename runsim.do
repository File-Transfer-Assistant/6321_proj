##################################################
#  Modelsim do file to run simulation
##################################################

vlib work
vmap work work

# include the testbench file
vlog +acc -incr tb_fft.v

# include verilog modules
vlog +acc -incr ../../rtl/fft/butterfly_unit.v
vlog +acc -incr ../../rtl/fft/fft_controller.v
vlog +acc -incr ../../rtl/fft/sram00.v
vlog +acc -incr ../../rtl/fft/sram01.v
vlog +acc -incr ../../rtl/fft/sram_1024x32.v
vlog +acc -incr ../../rtl/fft/twiddle_rom.v
vlog +acc -incr ../../rtl/fft/fft_processor_top.v

# run simulation and check waveforms
vsim -voptargs=+acc -t ps -lib work tb_fft
view wave
do waveformat.do
run -all
