LIB_PATH = lib
GDS_PATH = gds
MODULE_PATH = module
INCLUDE_PATH = include
OUTPUT_PATH = output
GLS_PATH = gls_model
MACRO_PATH = macros

STA_PATH = $(OUTPUT_PATH)/sta
SYNTH_PATH = $(OUTPUT_PATH)/synth
COMPILED_TLV_PATH = $(OUTPUT_PATH)/compiled_tlv
PRE_SYNTH_SIM_PATH = $(OUTPUT_PATH)/pre_synth_sim
POST_SYNTH_SIM_PATH = $(OUTPUT_PATH)/post_synth_sim

.PHONY: all
all: sim

.PHONY: sim
sim: pre_synth_sim post_synth_sim

.PHONY: clean
clean:
	rm -rf $(OUTPUT_PATH)

.PHONY: tlv
tlv:
	sandpiper-saas -i $(MODULE_PATH)/rvmyth.tlv -o rvmyth.v \
		--bestsv --noline -p verilog --outdir $(OUTPUT_PATH)/compiled_tlv

.PHONY: pre_synth_sim
pre_synth_sim: $(COMPILED_TLV_PATH)
	#if [ ! -f "$(PRE_SYNTH_SIM_PATH)/pre_synth_sim.vcd" ]; then \
		#mkdir -p $(PRE_SYNTH_SIM_PATH); \
		iverilog -o $(PRE_SYNTH_SIM_PATH)/pre_synth_sim.out -DPRE_SYNTH_SIM \
			$(MODULE_PATH)/testbench.v \
			-I $(INCLUDE_PATH) -I $(MODULE_PATH) -I $(MACRO_PATH); \
		cd $(PRE_SYNTH_SIM_PATH); ./pre_synth_sim.out; \
		gtkwave pre_synth_sim.vcd;
	#fi

.PHONY: post_synth_sim
post_synth_sim:
	#if [ ! -f "$(POST_SYNTH_SIM_PATH)/post_synth_sim.vcd" ]; then \
	#	mkdir -p $(POST_SYNTH_SIM_PATH); \
		iverilog -o $(POST_SYNTH_SIM_PATH)/post_synth_sim.out -DPOST_SYNTH_SIM -DFUNCTIONAL -DUNIT_DELAY=#1 \
			$(MODULE_PATH)/testbench.v \
			-I $(INCLUDE_PATH) -I $(GLS_PATH) -I $(SYNTH_PATH)-I $(MACRO_PATH); \
		cd $(POST_SYNTH_SIM_PATH); ./post_synth_sim.out; \
		gtkwave post_synth_sim.vcd; \
	#fi

.PHONY: synth
synth: 
	#if [ ! -f "$(SYNTH_PATH)/vsdmemsoc.synth.v" ]; then \
		#mkdir -p $(SYNTH_PATH); \
		yosys -s scripts/yosys.ys | tee ./output/synth/synth.log; \
	#fi


.PHONY: sta 
sta: 
	#if [ ! -f "$(STA_PATH)/sta.log" ]; then \
		#mkdir -p $(STA_PATH); \
		../../OpenSTA/app/sta -threads max ./scripts/auto_sta.tcl | tee ./output/sta/sta.log; \
	#fi
.PHONY: sta_report 
sta_report:  
	./scripts/gen_html.tcl

.PHONY: sta_test	
sta_test: 
	
	../../OpenSTA/app/sta -threads max ./scripts/sta_init.tcl | tee ./output/sta/sta.log; \
	.PHONY: post_synth_sim
.PHONY: post_ol_sim	
post_ol_sim:
	#if [ ! -f "$(POST_SYNTH_SIM_PATH)/post_synth_sim.vcd" ]; then \
	#	mkdir -p $(POST_SYNTH_SIM_PATH); \
		iverilog -o $(POST_SYNTH_SIM_PATH)/post_ol_sim.out -DPOST_SYNTH_SIM_OL -DFUNCTIONAL -DUNIT_DELAY=#1 \
			$(MODULE_PATH)/testbench_ol.v \
			-I $(INCLUDE_PATH) -I $(GLS_PATH) -I $(SYNTH_PATH) -I $(MACRO_PATH); \
		cd $(POST_SYNTH_SIM_PATH); ./post_ol_sim.out; \
		gtkwave post_ol_sim.vcd; \
	#fi

