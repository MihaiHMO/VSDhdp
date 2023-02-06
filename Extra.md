SDC Commands:
- Link
- compile_ultra
- report_timing -to <out_port_name>
- report_timing -from <in_port_name>
- report_timing -from <in_port_name> -to <out_port_name>
- all_fanout -endpoints_only -from  <in_port_name> will list all the pins of gates or flops in the path on of <in_port_name>  

RUN folder 
├── cmds.log  
├── config_in.tcl  
├── config.tcl  
├── logs  
│   ├── cts  
│   ├── eco  
│   ├── floorplan  
│   │   ├── 3-initial_fp.log  
│   │   ├── 4-io.log  
│   │   ├── 7-tap.log  
│   │   └── 8-pdn.log  
│   ├── placement  
│   │   ├── 10-resizer.log
│   │   ├── 11-detailed.log
│   │   ├── 5-global.log
│   │   ├── 6-basic_mp.log
│   │   └── 9-global.log  
│   ├── routing  
│   ├── signoff  
│   └── synthesis  
│       ├── 1-synthesis.log  
│       └── 2-sta.log  
├── openlane.log  
├── OPENLANE_VERSION   
├── PDK_SOURCES  
├── reports  
│   ├── cts  
│   ├── eco  
│   ├── floorplan  
│   │   ├── 3-initial_fp_core_area.rpt  
│   │   └── 3-initial_fp_die_area.rpt  
│   ├── placement  
│   ├── routing  
│   ├── signoff  
│   └── synthesis  
│       ├── 1-synthesis.AREA_0.chk.rpt  
│       ├── 1-synthesis.AREA_0.stat.rpt  
│       ├── 1-synthesis_dff.stat  
│       └── 1-synthesis_pre.stat  
├── results  
│   ├── cts  
│   ├── eco  
│   ├── floorplan  
│   │   ├── vsdmemsoc.def  
│   │   └── vsdmemsoc.odb  
│   ├── placement  
│   │   ├── vsdmemsoc.def  
│   │   ├── vsdmemsoc.nl.v  
│   │   ├── vsdmemsoc.odb  
│   │   └── vsdmemsoc.pnl.v  
│   ├── routing  
│   ├── signoff  
│   └── synthesis  
│       ├── vsdmemsoc.sdf  
│       └── vsdmemsoc.v  
├── runtime.yaml  
├── tmp  
│   ├── cts  
│   │   ├── cts.lib  
│   │   └── cts.lib.exclude.list  
│   ├── dimensions.txt  
│   ├── eco  
│   ├── floorplan  
│   │   ├── 3-initial_fp.def  
│   │   ├── 3-initial_fp.odb  
│   │   ├── 3-initial_fp.sdc  
│   │   ├── 4-io.def  
│   │   ├── 4-io.odb  
│   │   ├── 8-pdn.def  
│   │   └── 8-pdn.odb  
│   ├── layers.list  
│   ├── merged.max.lef  
│   ├── merged.min.lef  
│   ├── merged.nom.lef  
│   ├── placement  
│   │   ├── 10-resizer.def  
│   │   ├── 10-resizer.nl.v  
│   │   ├── 10-resizer.odb 
│   │   ├── 10-resizer.pnl.v  
│   │   ├── 10-resizer.sdc
│   │   ├── 5-global.def 
│   │   ├── 5-global.odb 
│   │   ├── 6-macros_placed.def 
│   │   ├── 6-macros_placed.odb  
│   │   ├── 9-global.def 
│   │   └── 9-global.odb 
│   ├── routing 
│   │   └── config.tracks 
│   ├── signoff  
│   └── synthesis  
│       ├── 1-sky130_fd_sc_hd__tt_025C_1v80.no_pg.lib  
│       ├── 1-trimmed.no_pg.lib
│       ├── hierarchy.dot 
│       ├── merged.lib  
│       ├── post_techmap.dot  
│       ├── resizer_sky130_fd_sc_hd__tt_025C_1v80.lib  
│       ├── synthesis.sdc  
│       ├── trimmed.lib  
│       └── trimmed.lib.exclude.list  
└── warnings.log  


*************** OpenRAM ****************

 git clone https://github.com/VLSIDA/OpenRAM.git
 git checkout dev
 cd OpenLane
 pip install -r requirements.txt
 make library 
 cd OpenLane/docker/
 make build
 export OPENRAM_HOME="$HOME/OpenRAM/compiler"
 export OPENRAM_TECH="$HOME/OpenRAM/technology"
 export PYTHONPATH=$OPENRAM_HOME
 make pdk
 make install
 export $PDK_ROOT=$OPENRAM_HOME
 
 

 

 
