# Table of content  
- [Overview](#functional-diagram)  
- [Make commands](#make-commands)  
- [RTL and GLS synthesis](#rtl-and-gls-synthesis)  
- [CTS Design Constrains and STA Analisys](#cts-design-constrains-and-sta-analisys)  

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
file:///home/mihaih/Pictures/Screenshots/Screenshot%20from%202023-01-25%2017-02-20.png![image](https://user-images.githubusercontent.com/49897923/214598184-0e8d4357-2f36-486c-8ae8-154f16363ed0.png)
Area: 205521.531 um^2 -> 0.2055mm^2

OpenLane version : 
Open_pdks: 327e268bdb7191fe07a28bd40eeac055bba9dffd
Setup design :
```

prep -design vsdmemsoc 
```
Config file:
```
{
    "DESIGN_NAME": "vsdmemsoc"
    "VERILOG_FILES": "dir::src/vsdmemsoc.v",
    "CLOCK_PORT": "clk",
    "CLOCK_NET": "clk",
    "GLB_RESIZER_TIMING_OPTIMIZATIONS": true,
    "CLOCK_PERIOD": 10,
    "EXTRA_LEF":"dir::src/*.lef",
    "pdk::sky130*": {
        "SYNTH_MAX_FANOUT": 6,
        "FP_CORE_UTIL": 35,
        "scl::sky130_fd_sc_ms": {
            "FP_CORE_UTIL": 30
        }
    },
    
    "LIB_SYNTH": "dir::src/sky130_fd_sc_hd__typical.lib", 
    "LIB_FASTEST": "dir::src/sky130_fd_sc_hd__fast.lib",
    "LIB_SLOWEST": "dir::src/sky130_fd_sc_hd__slow.lib",
    "LIB_TYPICAL": "dir::src/sky130_fd_sc_hd__typical.lib"  
}
```
Define SDC: 
Cap load extracted from ".lib" file

Insert custom cells 
```
set lefs [glob $::env(DESIGN_DIR)/src/*.lef]
add_lefs -src $lefs

```
run_synthesis 
Check die area, flop ration, slack, tns , wns

run_florplan

run_placement
