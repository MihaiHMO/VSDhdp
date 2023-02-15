
module vsdmemsoc (
`ifdef USE_POWER_PINS
    inout vccd1,	// User area 1 1.8V supply
    inout vssd1,	// User area 1 digital ground
`endif
    output [9:0] OUT,
    input ext_clk,
    input ext_reset,
    //input init_en,          internal (mem_wr)
    //input [7:0] init_addr,   replaced by wbs_adr_i
    //input [31:0] init_data,  replaced by wbs_dat_i
    input wb_clk_i,
    input wb_rst_i,
    input wbs_stb_i,
    input wbs_cyc_i,
    input wbs_we_i,
    input [3:0] wbs_sel_i,
    input [31:0] wbs_dat_i,
    input [31:0] wbs_adr_i,
    output reg wbs_ack_o,
    output reg[31:0] wbs_dat_o,
	
);
    wire        sel_source;  // signal active when wisbone controlls the sram 
    wire        mem_wr;      //   write_enable signal for sram  
    wire [7:0]  mem_addr;    //   address bus for sram
    wire [31:0] imem_data;   //   sram dout data connection to cpu (instruction mem)
    wire [7:0]  imem_addr;   //   sram address connection from cpu (instruction mem)
    wire mem_clk;            //   sram clk (from system or wisbon)
	assign sel_source = wbs_cyc_i && wbs_stb_i &&  wb_rst_i && !wbs_ack_o;
	assign mem_clk = sel_source ? ext_clk : wb_clk_i  
    assign mem_wr   = sel_source ? wbs_we_i : 1'b1;  
    assign mem_addr = sel_source ? wbs_adr_i : imem_addr;



   always @(posedge wb_clk_i or posedge wb_rst_i) begin
        if (wb_rst_i) begin
            
            wbs_dat_o   <=0;
            wbs_ack_o   <=0;

        end else if (sel_source && wbs_we_i )
		begin // write
              // write to sram
            init_data <=  wbs_sel_i[0]?  wbs_dat_i : imem_data;
            wbs_ack_o <= 1;
        end else if (sel_source && !wbs_we_i) begin // read 
            wbs_dat_o <= imem_data
            wbs_ack_o <= 1;
        end else begin 
            wbs_ack_o <= 0;
            wbs_dat_o <= 0;
        end
    end
   
 
    rvmyth core (
        .OUT(OUT),
        .CLK(CLK),
        .reset(reset),

        .imem_addr(imem_addr),
        .imem_data(imem_data)
    );
	   sky130_sram_1kbyte_1rw1r_32x256_8 mem (
`ifdef USE_POWER_PINS
        .vccd1(vccd1),	// User area 1 1.8V supply
        .vssd1(vssd1),	// User area 1 digital ground
`endif
        // Port 0: RW
        .clk0(mem_clk),
        .csb0(1'b0),
        .web0(mem_wr),
        .wmask0(4'b1111),
        .addr0(mem_addr),
        .din0(init_data),
        .dout0(imem_data),
        
        // Port 1: R
        .clk1(mem_clk),
        .csb1(1'b1),
        .addr1(mem_addr),
        .dout1()
    );
endmodule
