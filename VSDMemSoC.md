# Table of content  
+ [Overview](#functional-diagram)  
+ [Make commands](#make-commands)  
+ [RTL and GLS synthesis](#rtl-and-gls-synthesis)   
+ [CTS Design Constrains and STA Analisys](#cts-design-constrains-and-sta-analisys)
+ [Physical design](#physical-design)


# Physical implementation of VSDMemSoC

The project scope is to implement using Skywater sky130 PDK the RTL of [VSDMemSoc](https://github.com/vsdip/VSDMemSoC) witch contains a [Risc-V CPU](https://github.com/RISCV-MYTH-WORKSHOP/riscv_myth_workshop_nov22-MihaiHMO/settings) connected to a [open source SRAM](https://github.com/vsdip/vsdsram_sky130)  

## Functional diagram   
![SoC Diagram](Imgs/SoC_struct.png)  

## Folder structure
```
├── gds                 # SRAM GDS Model.
├── gls_model           # SKY130 PDK Verilog files
├── include             # include files for SOC Modeling
├── lib                 # SKY130 Standard cells and SRAM lib files
├── module              # SOC Verilog files, beside rvmyth.v
├── output              # Output files Produced during runtime, including rvmyth.v file
|   ├── compiled_tlv
|   ├── synth
|   ├── pre_synth
|   ├── post_synth
|   ├── sta
├── scripts             # Scripts for: yosys
├── Makefile            # Makefile for executing steps during design flow
└── 

```
## Make Commands

- `clean` Removes the output Directory
- `tlv` Generates verilog files from tlv using sandpiper
- `pre_synth_sim` RTL Simulation using iverilog
- `synth` Synthesizes netlist using YOSYS, report can be fout in output/synth folder
- `post_synth_sim` GLS Simulation using iverilog
- `sta` STA Design constrains and reports

### tlv
The _rvmyth_ a 4 stage RV32I Risc-V core was originally designed in TLV langueage using Makerchip online IDE.  
A convertion from TLV to verilog is needed.    
Convertion of TLV to Verilog of **_rvmyth_** core : `sandpiper-saas -i module/rvmyth.tlv -o rvmyth.v --bestsv --noline -p verilog --outdir output/compiled_tlv`  
    - `-i` - <tlv-[m4]in-file >: TLV input file>  
    - `o` - < tlv-out-file >: SV ouput file  
    - `--bestsv` - Optimize the readability/maintainability of the generated SV, unconstrained by correlation w/ TLV source.  
    - `--noline` - Disable line directive in SV output  
    - `-p` - Project name, corresponding to project configuration directory (e.g. -p verilog). (default: default)   
    - `verilog`  
    - `--outdir` - A root directory for all produced files as a relative or absolute path  

## RTL and GLS synthesis

![](Imgs/VSDMemSoC_sims.png)
    

## CTS Design Constrains and STA Analisys

Inputs delays: min 0.5
Input transition 

|CLOCKS	|frequency	|duty_cycle	|min_rise_delay	|min_fall_delay	|max_rise_delay	|max_fall_delay	|min_rise_slew	|min_fall_slew	|max_rise_slew	|max_fall_slew	
|-	|-	|-	|-	|-	|-	|-	|-	|-	|-	|-										
|clk	|10	|50	|1	|1	|1	|1	|1	|1	|1	|1	
											
											
|INPUTS	|early_rise_delay |early_fall_delay	|late_rise_delay |late_fall_delay |early_rise_slew |early_fall_slew	|late_rise_slew	|late_fall_slew	|clocks |bussed	|bus width 
|- |-	|- |-	|- |-	|- |-	|- |-	|- |-  
|reset |0.5	|0.5 |1	|1 |0.5	|0.5 |1	|1 |clk	|no |										
|init_en |0.5 |0.5	|1	|1	|0.5 |0.5 |1 |1	|clk |no |  
|init_addr |0.5 |0.5 |1	|1 |0.5	|0.5 |1	|1 |clk	|yes |8  
|init_data |0.5	|0.5 |1	|1	|0.5 |0.5 |1 |1	|clk |yes |32  
																					
											
|OUTPUTS	|early_rise_delay	|early_fall_delay	|late_rise_delay	|late_fall_delay	|clocks	|load	|bussed	|bus width			
|-	|-	|-	|-	|-	|-	|-	|-	|-	 
|OUT	|0.5	|0.5	|1	|1	|clk	|1	|yes	|10	 	


**STA Analisys report**
![image](https://user-images.githubusercontent.com/49897923/212553703-93392db5-f498-46b5-b260-e0983da0b6d1.png)
`report_net -connections _33531_`   - check the fanout cells  
`replace_cell <instance> <name_new_cell>` -replace a specific instance cell buffers with bigger variants

Timing variation vs PVT for the same start/endpoint pair:
![image](https://user-images.githubusercontent.com/49897923/212549767-43a17763-48b4-4bac-9dd8-8ff48a7fe2cf.png)

### Physical Design 
**SRAM Cell**
![image](https://user-images.githubusercontent.com/49897923/214598184-0e8d4357-2f36-486c-8ae8-154f16363ed0.png)
Area: 205521.531 um^2 -> 0.2055mm^2
GDS File has no DRC.  
```
 # pdks/sky130A/libs.tech/openlane/sky130_fd_sc_hd/tracks.info  - used to check the grids used for each metal layer  
	met3 X 0.34 0.68
	met3 Y 0.34 0.68
	met4 X 0.46 0.92
	met4 Y 0.46 0.92
  # adjust magic grid display to check if the SRAM routed power lines and cell pins are on the grid   
    % grid 0.46um 0.34um 0.34um 0.46um
```

OpenLane version : 06b26813465d8745c2cdfe6605ac3233cef89dec  
Open_pdks: 327e268bdb7191fe07a28bd40eeac055bba9dffd  
OpenROAD: 4f1108b6f558718ed142cbb6c1f5ba20958195ca  

+ Design setup :
```
# go to OpenLane dir
$ sudo make mount

#create design
$ ./flow.tcl -design vsdmemsoc -init_design_config -add_to_designs

```
Config file:
```
{
    "DESIGN_NAME": "vsdmemsoc",
    "VERILOG_INCLUDE_DIRS": "dir::src/include",
    "VERILOG_FILES": ["dir::src/module/*.v", "dir::src/module/compiled_tlv/rvmyth.v"],
    "EXTRA_LEFS":"dir::src/lef/*.lef",
    "EXTRA_GDS_FILES": "dir::src/gds/*.gds",
    "EXTRA_LIBS": "dir::src/lib/sram_32_256_sky130A_TT_1p8V_25C.lib",
    "VERILOG_FILES_BLACKBOX": "dir::src/include/sram_32_256_sky130A.v",
    
    "CLOCK_PORT": "CLK",
    "CLOCK_PERIOD": 10.0,
        
    "VDD_NETS": "vccd1",
    "GND_NETS": "vssd1",

    "FP_PDN_MACRO_HOOKS": "vsdmemsoc.mem vccd1 vssd1 vccd1 vssd1",
    "BASE_SDC_FILE": "dir::src/sdc/vsdmemsoc_synth.sdc",
    "SYNTH_SIZING": 1,
    "SYNTH_FLAT_TOP": 1,
     
    "ROUTING_CORES": 4,

    "MAGIC_DRC_USE_GDS": false,
    "QUIT_ON_MAGIC_DRC": false,
    "RUN_KLAYOUT_XOR": false,
    "DESIGN_IS_CORE": true
}
```
+ Define SDC: 
Cap load extracted from ".lib" file  

At the beginning a synthesis strategy exploration can be done by open lane with : `$ ./flow.tcl -design vsdmemsoc -synt_explore`  
The output is an Area estimation and synthesized verilog file for diferent strategies:  

![image](https://user-images.githubusercontent.com/49897923/215674519-2e49741e-5a5c-4650-a8fa-d7406cf56e23.png)

+ Open design: `prep -design vsdmemsoc - tag RUNxxx [-overwrite]`  

+ Insert custom SRAM cells: 
```
set lefs [glob $::env(DESIGN_DIR)/src/lef/*.lef]
add_lefs -src $lefs

```
+ run_synthesis  
```
 $ run synthesis
 [STEP 1] Syntheis
 [STEP 2] Sta
 # check result netlist: runs/RUN_<date>_<time>/synthesis/<deisgn>.v
 # check synth-stat report:                    /reports/synthesis/synthesis.AREA_0.stat.rpt
 # check timing report:                        /logs/synthesis/synthesis.log; sta.log
```

Stats:  
	- Design area: 327295 u^2 100% utilization  
	- Flop ration: 0.178  
	- TNS: 0 ns   
	- WNS: 0 ns  
	- CLK Skew 0 ns  
	- Violantions : max slew , max fanout  
```
===========================================================================
 report_power
============================================================================
Group                  Internal  Switching    Leakage      Total
                          Power      Power      Power      Power (Watts)
----------------------------------------------------------------
Sequential             1.03e-02   5.86e-04   1.76e-08   1.09e-02  62.0%
Combinational          4.74e-03   1.95e-03   1.72e-05   6.70e-03  38.0%
Macro                  0.00e+00   0.00e+00   0.00e+00   0.00e+00   0.0%
Pad                    0.00e+00   0.00e+00   0.00e+00   0.00e+00   0.0%
----------------------------------------------------------------
Total                  1.51e-02   2.53e-03   1.73e-05   1.76e-02 100.0%
                          85.5%      14.4%       0.1%
```

Post synth STA can be done to optimize the timings by changing buffer type, fanout number etc. 
This can be done also outside openlane with a separate script.  
```
 $ sta pre_sta.conf
  # optimize synthesis to reduce setup violation
  % set ::env(SYNTH_STRATEGY) 1
  % set ::env(SYNTH_BUFFERING) 1
  % set ::env(SYNTH_SIZING) 1
  % set ::env(SYNTH_MAX_FANOUT) 4
  % set ::env(SYNTH_DRIVING_CELL) sky130_fd_sc_hd__inv_8
  % run synthesis
  % report_net -connections <net-name> => Driver-Pins/Load-Pins
  % replace <inst-name> <lib-cell-name>
  % report_checks -fields {net cap slew input_pins} -digits 4
  % write_verilog <design>_eco.v
```

+ run_floorplan  
This will do : floorplaning , IO placement , Power distribution  
```
[STEP 3] Floorplanning   -> /RUN_<date>_<time>/logs/floorplan/initial_fp.log
			    /RUN_<date>_<time>/reports/floorplan/initial_fp_core/die_area.rpt
[STEP 4] IO PLacement    -> /RUN_<date>_<time>/logs/floorplan/io.log
[STEP 5] Global Placement-> /RUN_<date>_<time>/logs/placement/global.log
[STEP 6] Macro Placement -> /RUN_<date>_<time>/logs/placement/basic_mp.log
[STEP 7] Tap/Decap cells -> /RUN_<date>_<time>/logs/floorplan/tap.log
[STEP 8] PDN             -> /RUN_<date>_<time>/logs/floorplan/PDN.log
# openlane/configurations/floorplan.tcl
  # FP_IO_MODE (same distribution length or nearnest)
  # FP_IO_VMETAL N (use metal N+1)
  # FP_IO_HMETAL M (use metal M+1)
                                 
  # Layout:                                /result/floorplan/<design>.def

  # Magic open DEF file
  $ magic -d XR -T sky130A.tech lef read .../tmp/merged.nom.lef def read .../results/floorplan/<design>.def
```
Stats:
	- Die area: 820.105 x 830.825 ->  
	- Design area: 327295 u^2 50% utilization 
	- Power : 1.99e-02 W
	- Flop ration: 0.178 
	- TNS: -7.54 ns   
	- WNS: 0.39 ns  
	- CLK Skew 0 ns  
	- Violantions : max slew , max fanout, max capacitacne for mem inputs and outputs  

![image](https://user-images.githubusercontent.com/49897923/215983088-cf9fc5bc-ddd7-45b9-8195-ab450f7eadc3.png)
+ run_placement  
```
[STEP 9] Global Placement                -> /RUN_<date>_<time>/logs/placement/global.log
[STEP 10] Placement Resizer/Optimization -> /RUN_<date>_<time>/logs/placement/resizerlog```
[STEP 11] detailed Placement             -> /RUN_<date>_<time>/logs/placement/detailed.log

# openlane/configurations/placement.tcl
  # Results in <design>/runs/RUN_<date>_<time>/results/placement/<>.def ; <>.nl.v; <>.pnl.v (power netlist)
  # Magic open DEF file
  $ magic -d XR -T sky130A.tech lef read .../tmp/merged.lef def read ..../results/placement/<design>.def
```
Stats:
	- Die area: 820.105 x 830.825 ->  
	- Design area: 335017 u^2 51% utilization  
	- Power : 1.95e-02 W
	- Flop ration: 0.178  
	- TNS: -1.66 ns   
	- WNS: -0.29 ns   
	- CLK Skew 0 ns  
	- Violantions : max slew , max fanout, max capacitacne for mem inputs and outputs  


+ run_cts 
```
[STEP 12] Clock tree Synthesis  -> /RUN_<date>_<time>/logs/cts/12-cts.log
  # generate <design>_synthesis_cts.v
  # ::env(CTS_ROOT_BUFFER) => sky130_fd_sc_hd__clkbuf_16 , clk buffer type
  # ::env(CTS_MAX_CAP) => CTS_ROOT_BUFFER output port load-cap 
```
Stats:
	- Die area: 820.105 x 830.825 ->  
	- Design area: 335860 u^2 51% utilization  
	- Power : 2.51e-02 W
	- Flop ration: 0.178  
	- TNS: 0 ns   
	- WNS: -0.41 ns   
	- CLK Skew 0.29 ns  
	- Violantions : max slew for mem inputs 
```
===========================================================================
 report_power
============================================================================
Group                  Internal  Switching    Leakage      Total
                          Power      Power      Power      Power (Watts)
----------------------------------------------------------------
Sequential             9.94e-03   1.17e-03   1.76e-08   1.11e-02  44.2%
Combinational          8.04e-03   5.98e-03   1.73e-05   1.40e-02  55.8%
Macro                  0.00e+00   0.00e+00   0.00e+00   0.00e+00   0.0%
Pad                    0.00e+00   0.00e+00   0.00e+00   0.00e+00   0.0%
----------------------------------------------------------------
Total                  1.80e-02   7.14e-03   1.73e-05   2.51e-02 100.0%
                          71.5%      28.4%       0.1%
```
A view after floorplan, placemnt and CTS
![image](https://user-images.githubusercontent.com/49897923/216033421-dfd9ad29-e823-47eb-872d-bd0e7751c8dd.png)


STA after CTS:  
```
  % openroad - this will use same env variable in openlane
    % read_lef .../merged.lef
    % read_def .../<design>.cts.lef
    % write_db <design>_cts.db     - this is used for timing anlisys after CTS
    % read_liberty -max $::env(LIB_MAX)
    % read_liberty -min $::env(LIB_MIN)
    % link_design <design-top>
    % read_sdc .../my_Base.sdc
    % set_propagated_clock [all_clocks]
    $ report_checks -path_delay min-max -format full_clock_expanded -digits 4
  # upper command produce false analysis from ff/ss analysis by tt synthesis
  ```
