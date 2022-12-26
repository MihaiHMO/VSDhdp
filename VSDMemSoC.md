# Physical implementation of VSDMemSoC

The project scope is to implement using Skywater sky130 PDK the RTL of [VSDMemSoc](https://github.com/vsdip/VSDMemSoC) witch contains a [Risc-V CPU](https://github.com/RISCV-MYTH-WORKSHOP/riscv_myth_workshop_nov22-MihaiHMO/settings) connected to a [open source SRAM](https://github.com/vsdip/vsdsram_sky130)  

## Functional diagram :  
![SoC Diagram](Imgs/SoC_struct.png)  

### Folder structure
```
├── gds                 # SRAM GDS Model.
├── gls_model           # SKY130 PDK Verilog files
├── include             # include files for SOC Modeling
├── lib                 # SKY130 Standard cells and SRAM lib files
├── module              # SOC Verilog files, beside rvmyth.v
├── output              # Output files Produced during runtime, including rvmyth.v file
├── scripts             # Scripts for: yosys
├── Makefile            # Makefile for executing steps during design flow
└── README.md

```
## Commands

- `clean` Removes the output Directory
- `tlv` Generates verilog files from tlv using sandpiper
- `pre_synth_sim` RTL Simulation using iverilog
- `synth` Synthesizes netlist using YOSYS
- `post_synth_sim` GLS Simulation using iverilog

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


![](Imgs/VSDMemSoC_sims.png)
    
```  
=== vsdmemsoc ===

   Number of wires:              10184
   Number of wire bits:          12453
   Number of public wires:       10184
   Number of public wire bits:   12453
   Number of memories:               0
   Number of memory bits:            0
   Number of processes:              0
   Number of cells:              12343
     sky130_fd_sc_hd__a2111oi_0     29
     sky130_fd_sc_hd__a211oi_1      68
     sky130_fd_sc_hd__a21boi_0      22
     sky130_fd_sc_hd__a21o_2         8
     sky130_fd_sc_hd__a21oi_1     1791
     sky130_fd_sc_hd__a221oi_1     286
     sky130_fd_sc_hd__a22o_2        39
     sky130_fd_sc_hd__a22oi_1      541
     sky130_fd_sc_hd__a2bb2oi_1      1
     sky130_fd_sc_hd__a311oi_1      13
     sky130_fd_sc_hd__a31o_2         5
     sky130_fd_sc_hd__a31oi_1      205
     sky130_fd_sc_hd__a32o_1         5
     sky130_fd_sc_hd__a32oi_1        1
     sky130_fd_sc_hd__a41oi_1        6
     sky130_fd_sc_hd__and2_2        13
     sky130_fd_sc_hd__and3_2         5
     sky130_fd_sc_hd__clkinv_1    1197
     sky130_fd_sc_hd__dfxtp_1     2080
     sky130_fd_sc_hd__lpflow_inputiso0p_1      2
     sky130_fd_sc_hd__mux2i_1       11
     sky130_fd_sc_hd__nand2_1     1545
     sky130_fd_sc_hd__nand3_1      604
     sky130_fd_sc_hd__nand3b_1       4
     sky130_fd_sc_hd__nand4_1      241
     sky130_fd_sc_hd__nor2_1       979
     sky130_fd_sc_hd__nor3_1       100
     sky130_fd_sc_hd__nor3b_1        2
     sky130_fd_sc_hd__nor4_1        49
     sky130_fd_sc_hd__nor4b_1        1
     sky130_fd_sc_hd__o2111ai_1     15
     sky130_fd_sc_hd__o211ai_1     124
     sky130_fd_sc_hd__o21a_1        18
     sky130_fd_sc_hd__o21ai_0     1832
     sky130_fd_sc_hd__o21bai_1      49
     sky130_fd_sc_hd__o221a_2        2
     sky130_fd_sc_hd__o221ai_1      22
     sky130_fd_sc_hd__o22a_2         1
     sky130_fd_sc_hd__o22ai_1      273
     sky130_fd_sc_hd__o311a_2        1
     sky130_fd_sc_hd__o311ai_0       7
     sky130_fd_sc_hd__o31ai_1       16
     sky130_fd_sc_hd__o32a_2         1
     sky130_fd_sc_hd__o32ai_1        3
     sky130_fd_sc_hd__o41ai_1       13
     sky130_fd_sc_hd__or2_2         32
     sky130_fd_sc_hd__or4_2          1
     sky130_fd_sc_hd__xnor2_1       24
     sky130_fd_sc_hd__xor2_1        55
     sram_32_256_sky130A             1


```
