##################################################
#  Modelsim do file to run SDF simulation
##################################################

vlib work
vmap work work

# include standard cell verilog model
vlog +acc -incr /courses/ee6350/pdk2025/tcbn65gplus/TSMCHOME/digital/Front_End/verilog/tcbn65gplus_140b/tcbn65gplus.v

# include memory compiler models
vlog +acc -incr ../../memory_compiler/sram00/sram00.v
vlog +acc -incr ../../memory_compiler/sram01/sram01.v

# include synthesized netlist and SDF-enabled testbench
vlog +acc -incr ../../dc/fft/fft_processor_top.nl.v
vlog +acc +define+ENABLE_SDF -incr tb_fft.v

# run simulation
vsim -voptargs=+acc -t ps -lib work testbench
view wave
do waveformat.do
run -all
