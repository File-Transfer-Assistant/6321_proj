run:
	vsim -do "runsim.do"

run_func:
	vsim -c -do "do runsim_func.do; quit -f"

clean:
	rm -rf work modelsim.ini
	rm -rf *.log *.syn *.rpt *.mr *.nl.v *.sdf *.svf *.vcd transcript *.wlf
	rm -rf *.result hw_output_frame*.txt hw_output_frame*_aligned.txt
