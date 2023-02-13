`timescale 1ns / 1ps
`ifdef PRE_SYNTH_SIM
   `include "vsdmemsoc.v"
   `include "controller.v"
   `include "rvmyth.v"
   `include "sky130_sram_1kbyte_1rw1r_32x256_8.v"
   `include "clk_gate.v"
`elsif POST_SYNTH_SIM
   `include "vsdmemsoc.synth.v"
   `include "primitives.v"
   `include "sky130_sram_1kbyte_1rw1r_32x256_8.v"
   `include "sky130_fd_sc_hd.v"
`elsif POST_ROUTE_SIM
    `include "primitives.v"
    `include "sky130_fd_sc_hd.v"
    `include "sky130_sram_1kbyte_1rw1r_32x256_8.v"
`endif

module vsdmemsoc_tb;
	// Inputs

	supply0 vgnd;
	supply1 vpwr;

	reg CLK, reset;
	reg init_en;
	reg [7:0] init_addr;
	reg [31:0] init_data;

	// Outputs
	wire [9:0] OUT;

	// Other Signals
	integer i;
	wire [31:0] ROM = 
		i == 32'h0 ? {7'b0000000, 5'd0, 5'd0,  3'b000, 5'd10, 7'b0110011} :  		// ADD, r10, r0, r0 - Initialize x10 (a0) to 0.  (rd, rs1, rs2)            
		i == 32'h1 ? {7'b0000000, 5'd0, 5'd10, 3'b000, 5'd14, 7'b0110011} :   	     	// ADD, r14, r10, r0 - Initialize sum register a4(x14) with 0x0  
		i == 32'h2 ? {12'b1010, 5'd10, 3'b000, 5'd12, 7'b0010011} :  			// ADDI, r12, r10, 1010 - Store count of 10 in register a2(x12). (rd, rs1, imm)
		i == 32'h3 ? {7'b0000000,  5'd0, 5'd10, 3'b000, 5'd13, 7'b0110011} :  		// ADD, r13, r10, r0 - Initialize intermediate sum register a3(x13) with 0
		i == 32'h4 ? {7'b0000000, 5'd14, 5'd13, 3'b000, 5'd14, 7'b0110011} :  		// ADD, r14, r13, r14 - Incremental addition 
		i == 32'h5 ? {12'b1, 5'd13, 3'b000, 5'd13, 7'b0010011} :  			// ADDI, r13, r13, 1 - Increment intermediate register by 1 (rd, rs1, imm)
		i == 32'h6 ? {1'b1, 6'b111111, 5'd12, 5'd13, 3'b100, 4'b1100, 1'b1, 7'b1100011} :  // BLT, r13, r12, 1111111111000 - If a3(x13) is less than a2(x12), branch to label named <loop> (rs1, rs2, imm-dec8184) 
		i == 32'h7 ? {7'b0000000, 5'd0, 5'd14, 3'b000,5'd10, 7'b0110011} :     		// ADD, r10, r14, r0 - Store final result to register a0(x10)so that it can be read by main program
		i == 32'h8 ? {7'b0000000, 5'd10, 5'd0, 3'b010,5'b00100, 7'b0100011} :  		// SW, r0, r10, 100 - store (word)the (x10) final result value to byte address 16 (imm+x0)) (rs1, rs2, imm - dec4)
		i == 32'h9 ? {12'b100, 5'd0, 3'b010,5'd17, 7'b0000011} :               		// LW, r17, r0, 100 - then load it into x17(a7). (rs1, rs2, imm -dec 4) ):
	                 32'd0 ;

    // Instantiate the Unit Under Test (UUT)
	vsdmemsoc uut (
		.OUT(OUT),
		.CLK(CLK),
	`ifdef USE_POWER_PINS
		.vccd1(vgnd),
		.vssd1(vpwr),
	`endif
		.reset(reset),
		.init_en(init_en),
		.init_addr(init_addr),
		.init_data(init_data)
	);

	always @(posedge CLK) begin
		if (i < 32'd16) begin
			i <= i + 32'd1;

			reset <= 1'b1;
			init_en <= 1'b1;
			init_addr <= i;
			init_data <= ROM;
		end
		else if (i < 32'd20) begin
			i <= i + 32'd1;
			init_en <= 1'b0;
		end
		else begin
			reset <= 1'b0;
		end
	end

	initial begin
`ifdef PRE_SYNTH_SIM
    	$dumpfile("pre_synth_sim.vcd");
`elsif POST_ROUTE_SIM
    	$dumpfile("post_route_sim.vcd");
`elsif POST_SYNTH_SIM
    	$dumpfile("post_synth_sim.vcd");
`endif
    	$dumpvars(0, vsdmemsoc_tb);

		i = 0;
                CLK = 0;
		reset = 0;

        #5000 $finish;
    end
    
	always #5 CLK = ~CLK;

endmodule
