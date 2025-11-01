VLOG         =/mnt/c/questasim64_2020.1/win64/vlog.exe
VOPT         :=/mnt/c/questasim64_2020.1/win64/vopt.exe
VSIM         :=/mnt/c/questasim64_2020.1/win64/vsim.exe
TOP_NAME     = memory
DEFINES      = +define+FUNCTIONAL\
	       #+define+UNIT_DELAY \
	       +define+SDF_TEST 
PRIMITIVES   =/home/demon/.ciel/ciel/sky130/versions/0fe599b2afb6708d281543108caf8310912f54af/sky130A/libs.ref/sky130_fd_sc_hd/verilog/primitives.v
LIB_FILE     =/home/demon/.ciel/ciel/sky130/versions/0fe599b2afb6708d281543108caf8310912f54af/sky130A/libs.ref/sky130_fd_sc_hd/verilog/sky130_fd_sc_hd.v
IOPATHS      =/home/demon/.ciel/ciel/sky130/versions/0fe599b2afb6708d281543108caf8310912f54af/sky130A/libs.ref/sky130_fd_sc_hd/verilog/
VLOG_OPTIONS = +acc +mnprtb

ELAB_OPTIONS = +acc +mnprtb tb_$(TOP_NAME) -o tb_$(TOP_NAME)_opt

SIM_OPTIONS  = tb_$(TOP_NAME)_opt 

CLEAN_THESE  = *log *transcript \
	       work/ \
	       *wlf


VLOG_PARSE:
	cd $$HOME/regression/gls && \
	$(VLOG) power_globals.v
	$(VLOG) $(PRIMITIVES) && \
	$(VLOG) +define+UNIT_DELAY="#1" $(LIB_FILE) && \
	$(VLOG) $(VLOG_OPTIONS) +define+SDF_TEST tb_$(TOP_NAME).v

ELABORATE:
	$(VOPT) $(ELAB_OPTIONS)

SIM:
	$(VSIM) $(SIM_OPTIONS)

ALL:
	make VLOG_PARSE && make ELABORATE && make SIM
CLEAN:
	rm -rf $(CLEAN_THESE)
