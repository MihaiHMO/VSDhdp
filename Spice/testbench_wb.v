`timescale 1ns / 1ps
`include "vsdmemsoc2.v"
`include "primitives.v"
`include "sky130_sram_1kbyte_1rw1r_32x256_8.v"
`include "sky130_fd_sc_hd.v"


module vsdmemsoc_tb;
	// Inputs

	supply0 vgnd;
	supply1 vpwr;

	reg ext_clk, reset;
	reg wb_clk_i;
    	reg wb_rst_i;
    	reg wbs_stb_i;
    	reg wbs_cyc_i;
    	reg wbs_we_i;
    	reg [3:0] wbs_sel_i;
    	reg [31:0] wbs_dat_i;
    	reg [7:0] wbs_adr_i;
	// Outputs
	wire [9:0] OUT;
	wire [31:0] wbs_dat_o;
	wire wbs_ack_o;

	// Other Signals
	integer i;
	wire [31:0] ROM = 
		i == 32'h0 ? {12'b1, 5'd0, 3'b000, 5'd9, 7'b0010011} :
		i == 32'h1 ? {12'b101011, 5'd0, 3'b000, 5'd10, 7'b0010011} :
		i == 32'h2 ? {12'b0, 5'd0, 3'b000, 5'd11, 7'b0010011} :
		i == 32'h3 ? {12'b0, 5'd0, 3'b000, 5'd17, 7'b0010011} :
		i == 32'h4 ? {7'b0000000, 5'd11, 5'd17, 3'b000, 5'd17, 7'b0110011} :
		i == 32'h5 ? {12'b1, 5'd11, 3'b000, 5'd11, 7'b0010011} :
		i == 32'h6 ? {1'b1, 6'b111111, 5'd10, 5'd11, 3'b001, 4'b1100, 1'b1, 7'b1100011} :
		i == 32'h7 ? {7'b0000000, 5'd11, 5'd17, 3'b000, 5'd17, 7'b0110011} :
		i == 32'h8 ? {7'b0100000, 5'd11, 5'd17, 3'b000, 5'd17, 7'b0110011} :
		i == 32'h9 ? {7'b0100000, 5'd9, 5'd11, 3'b000, 5'd11, 7'b0110011} :
		i == 32'hA ? {1'b1, 6'b111111, 5'd9, 5'd11, 3'b001, 4'b1100, 1'b1, 7'b1100011} :
		i == 32'hB ? {7'b0100000, 5'd11, 5'd17, 3'b000, 5'd17, 7'b0110011} :
		i == 32'hC ? {1'b1, 6'b111111, 5'd0, 5'd0, 3'b000, 4'b0000, 1'b1, 7'b1100011} :
	                 32'd0 ;

    // Instantiate the Unit Under Test (UUT)
	vsdmemsoc uut (
		.OUT(OUT),
		.ext_clk(ext_clk),
	`ifdef USE_POWER_PINS
		.vccd1(vgnd),
		.vssd1(vpwr),
	`endif
	       .ext_rst(reset),
	       .wb_clk_i(wb_clk_i),
	       .wb_rst_i(wb_rst_i),
	       .wbs_stb_i(wbs_stb_i),
	       .wbs_cyc_i(wbs_cyc_i),
	       .wbs_we_i(wbs_we_i),
	       .wbs_sel_i(wbs_sel_i),
 	       .wbs_dat_i(wbs_dat_i),
 	       .wbs_adr_i(wbs_adr_i),
   	       .wbs_ack_o(wbs_ack_o),
    	       .wbs_dat_o(wbs_dat_o)
	); 

	always @(posedge wb_clk_i) begin
		if (i < 32'd16) begin   // upload instructions in memory
			i <= i + 32'd1;

			reset <= 1'b1;
  	  		wb_rst_i<= 1'b0;
    			wbs_stb_i<= 1'b1;
    			wbs_cyc_i<= 1'b1;
    			wbs_we_i<= 1'b1;
    			wbs_sel_i<= 4'b1111;

			wbs_adr_i <= i;
			wbs_dat_i <= ROM;
		end
		else if (i < 32'd20) begin // intermediate state 
			i <= i + 32'd1;
  	  		wb_rst_i<= 1'b1;
    			wbs_stb_i<= 1'b0;
    			wbs_cyc_i<= 1'b0;
    			wbs_we_i<= 1'b0;
    			wbs_sel_i<= 4'b0000;

		end
		else if (i < 32'd40) begin // wb read from memory
			i <= i + 32'd1;
  	  		wb_rst_i<= 1'b0;
    			wbs_stb_i<= 1'b1;
    			wbs_cyc_i<= 1'b1;
    			wbs_we_i<= 1'b0;
    			wbs_sel_i<= 4'b0000;
    			wbs_adr_i <= i-32'd20;

		end
		else if (i < 32'd50) begin // intermediate state 
			i <= i + 32'd1;
			reset <= 1'b1;
  	  		wb_rst_i<= 1'b1;
    			wbs_stb_i<= 1'b0;
    			wbs_cyc_i<= 1'b0;
    			wbs_we_i<= 1'b0;
    			wbs_sel_i<= 4'b0000;
    		end
		else begin                 // run program (core not reset , wb in reset)
			reset <= 1'b0;
                        wb_rst_i<= 1'b1;
    			wbs_stb_i<= 1'b0;
    			wbs_cyc_i<= 1'b0;
    			wbs_we_i<= 1'b0;
    			wbs_sel_i<= 4'b0000;
		end
	end

	initial begin

    	$dumpfile("signals.vcd");
    	$dumpvars(0, vsdmemsoc_tb);

		i = 0;
                ext_clk = 0;
		reset = 0;
		wb_clk_i= 0;
  	  	wb_rst_i= 0;
    		wbs_stb_i= 0;
    		wbs_cyc_i= 0;
    		wbs_we_i= 0;
    		wbs_sel_i = 4'b0;

        #5000 $finish;
    end
        always #5 wb_clk_i = ~wb_clk_i;
	always #6 ext_clk = ~ext_clk;

endmodule
