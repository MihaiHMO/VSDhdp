# Physical implementation of VSDMemSoC

The project scope is to implement using Skywater sky1300 PDK the RTL of [VSDMemSoc](https://github.com/vsdip/VSDMemSoC) witch contains a [Risc-V CPU](https://github.com/RISCV-MYTH-WORKSHOP/riscv_myth_workshop_nov22-MihaiHMO/settings) connected to a [open source SRAM](https://github.com/vsdip/vsdsram_sky130)


Convertion of TLV to Verilog :'sandpiper-saas -i rvmythhmo.tlv -o rvmythmo.v --bestsv --noline -p verilog --outdir tbd'
- '-i' <tlv-[m4]in-file>: TLV input file>
- 'o' <tlv-out-file> SV ouput file
- '--bestsv' - Optimize the readability/maintainability of the generated SV, unconstrained by correlation w/ TLV source.
- '--noline' - Disable `line directive in SV output
- '-p' - Project name, corresponding to project configuration directory (e.g. -p verilog). (default: default)   
- 'verilog' 
- '--outdir   - A root directory for all produced files as a relative or absolute path
  
  
 RTL simulation: `iverilog testbench.v -I ../include/ vsdmemsoc.v controller.v rvmyth.v sram_32_256_sky130A.v clk_gate.v  -o pre_synth.out'

