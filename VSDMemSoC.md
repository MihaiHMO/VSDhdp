# Physical implementation of VSDMemSoC

The project scope is to implement using Skywater sky130 PDK the RTL of [VSDMemSoc](https://github.com/vsdip/VSDMemSoC) witch contains a [Risc-V CPU](https://github.com/RISCV-MYTH-WORKSHOP/riscv_myth_workshop_nov22-MihaiHMO/settings) connected to a [open source SRAM](https://github.com/vsdip/vsdsram_sky130)


- Convertion of TLV to Verilog : `sandpiper-saas -i module/rvmyth.tlv -o rvmyth.v --bestsv --noline -p verilog --outdir output/compiled_tlv`
    - '-i' <tlv-[m4]in-file>: TLV input file>
    - 'o' <tlv-out-file> SV ouput file
    - '--bestsv' - Optimize the readability/maintainability of the generated SV, unconstrained by correlation w/ TLV source.
    - '--noline' - Disable `line directive in SV output
    - '-p' - Project name, corresponding to project configuration directory (e.g. -p verilog). (default: default)   
    - 'verilog' 
    - '--outdir   - A root directory for all produced files as a relative or absolute path
  
  
- RTL simulation: `iverilog testbench.v -I ../include/ vsdmemsoc.v controller.v rvmyth.v sram_32_256_sky130A.v clk_gate.v  -o pre_synth_sim.out -DPRE_SYNTH_SIM`
  -`iverilog -o output/pre_synth_sim/pre_synth_sim.out -DPRE_SYNTH_SIM  module/testbench.v -I include -I module -I output/compiled_tlv;`    
  `cd output/pre_synth_sim; ./pre_synth_sim.out;`

- GLS simulation: `iverilog ../sky130_gls_model/primitives.v ../sky130_gls_model/sky130_fd_sc_hd.v sram_32_256_sky130A.v testbench.v -I ../include/ vsdmemsoc.synth.v -o post_synth.out -DPOST_SYNTH_SIM -DFUNCTIONAL -DUNIT_DELAY=#1`
  - 'iverilog -o output/post_synth_sim/post_synth_sim.out -DPOST_SYNTH_SIM -DFUNCTIONAL -DUNIT_DELAY=#1 module/testbench.v -I include -I module -I sky130_gls_model/ -I output/synth`
- `yosys -s /VSDMemSoC/src/script/yosys.ys | tee ../output/synth/synth.log`

Yosys Sript :
```
read_verilog -I./include ./module/vsdmemsoc.v
read_verilog -I./include ./module/controller.v
read_verilog -I./include ./module/clk_gate.v
read_verilog -I./include ./module/rvmyth.v
read_liberty -lib ./lib/sky130_fd_sc_hd__tt_025C_1v80.lib
read_liberty -lib ./lib/sram_32_256_sky130A_TT_1p8V_25C.lib
synth -top vsdmemsoc
dfflibmap -liberty ./lib/sky130_fd_sc_hd__tt_025C_1v80.lib
opt
abc -liberty ./lib/sky130_fd_sc_hd__tt_025C_1v80.lib -script +strash;scorr;ifraig;retime;{D};strash;dch,-f;map,-M,1,{D}
flatten
setundef -zero
clean -purge
rename -enumerate
stat
write_verilog -noattr ../output/vsdmemsoc.synth.v
```
  
  === vsdmemsoc ===

   Number of wires:              10173
   Number of wire bits:          12442
   Number of public wires:       10173
   Number of public wire bits:   12442
   Number of memories:               0
   Number of memory bits:            0
   Number of processes:              0
   Number of cells:              12332
     sky130_fd_sc_hd__a2111oi_0     28
     sky130_fd_sc_hd__a211oi_1      33
     sky130_fd_sc_hd__a21boi_0      25
     sky130_fd_sc_hd__a21o_2         8
     sky130_fd_sc_hd__a21oi_1     1760
     sky130_fd_sc_hd__a221oi_1     289
     sky130_fd_sc_hd__a22o_2        39
     sky130_fd_sc_hd__a22oi_1      546
     sky130_fd_sc_hd__a311oi_1      15
     sky130_fd_sc_hd__a31o_2         2
     sky130_fd_sc_hd__a31oi_1      258
     sky130_fd_sc_hd__a32o_1         5
     sky130_fd_sc_hd__a32oi_1        2
     sky130_fd_sc_hd__a41oi_1        7
     sky130_fd_sc_hd__and2_2        13
     sky130_fd_sc_hd__and3_2         7
     sky130_fd_sc_hd__clkinv_1    1187
     sky130_fd_sc_hd__dfxtp_1     2080
     sky130_fd_sc_hd__mux2i_1       11
     sky130_fd_sc_hd__nand2_1     1551
     sky130_fd_sc_hd__nand3_1      611
     sky130_fd_sc_hd__nand3b_1       3
     sky130_fd_sc_hd__nand4_1      242
     sky130_fd_sc_hd__nor2_1       939
     sky130_fd_sc_hd__nor3_1        99
     sky130_fd_sc_hd__nor3b_1        3
     sky130_fd_sc_hd__nor4_1        44
     sky130_fd_sc_hd__nor4b_1        1
     sky130_fd_sc_hd__o2111ai_1     16
     sky130_fd_sc_hd__o211ai_1     121
     sky130_fd_sc_hd__o21a_1        19
     sky130_fd_sc_hd__o21ai_0     1876
     sky130_fd_sc_hd__o21bai_1      50
     sky130_fd_sc_hd__o221a_2        2
     sky130_fd_sc_hd__o221ai_1      26
     sky130_fd_sc_hd__o22a_2         1
     sky130_fd_sc_hd__o22ai_1      257
     sky130_fd_sc_hd__o311a_2        1
     sky130_fd_sc_hd__o311ai_0       7
     sky130_fd_sc_hd__o31ai_1       17
     sky130_fd_sc_hd__o32a_2         1
     sky130_fd_sc_hd__o32ai_1        4
     sky130_fd_sc_hd__o41ai_1       13
     sky130_fd_sc_hd__or2_2         32
     sky130_fd_sc_hd__or4_2          1
     sky130_fd_sc_hd__xnor2_1       26
     sky130_fd_sc_hd__xor2_1        53
     sram_32_256_sky130A             1
