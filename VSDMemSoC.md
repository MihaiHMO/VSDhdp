# Physical implementation of VSDMemSoC

The project scope is to implement using Skywater sky130 PDK the RTL of [VSDMemSoc](https://github.com/vsdip/VSDMemSoC) witch contains a [Risc-V CPU](https://github.com/RISCV-MYTH-WORKSHOP/riscv_myth_workshop_nov22-MihaiHMO/settings) connected to a [open source SRAM](https://github.com/vsdip/vsdsram_sky130)  

## Functional diagram :  
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
## Commands

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
    

## CTS Design Constrains 

Inputs delays: min 0.5
Input transition 

|CLOCKS	|frequency	|duty_cycle	|min_rise_delay	|min_fall_delay	|max_rise_delay	|max_fall_delay	|min_rise_slew	|min_fall_slew	|max_rise_slew	|max_fall_slew	
|-	|-	|-	|-	|-	|-	|-	|-	|-	|-	|-										
|clk	|15	|50	|1	|1	|1	|1	|1	|1	|1	|1	
											
											
|INPUTS	|early_rise_delay |early_fall_delay	|late_rise_delay |late_fall_delay |early_rise_slew |early_fall_slew	|late_rise_slew	|late_fall_slew	|clocks |bussed	|bus width 
|- |-	|- |-	|- |-	|- |-	|- |-	|- |-  
|reset |0.5	|0.5 |1	|1 |0.5	|0.5 |1	|1 |clk	|no |										
|init_en |0.5 |0.5	|1	|1	|0.5 |0.5 |1 |1	|clk |no |  
|init_addr |0.5 |0.5 |1	|1 |0.5	|0.5 |1	|1 |clk	|yes |8  
|init_data |0.5	|0.5 |1	|1	|0.5 |0.5 |1 |1	|clk |yes |32  
																					
											
|OUTPUTS	|early_rise_delay	|early_fall_delay	|late_rise_delay	|late_fall_delay	|clocks	|load	|bussed	|bus width			
|-	|-	|-	|-	|-	|-	|-	|-	|-	 
|OUT	|0.5	|0.5	|1	|1	|clk	|1	|yes	|10	 	

