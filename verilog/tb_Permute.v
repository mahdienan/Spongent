`timescale 1ns / 1ps
`include "constants.vh"
////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   14:54:14 01/28/2017
// Design Name:   Permute
// Module Name:   
// Project Name:  spongent
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: Permute
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module tb_Permute;

	// Inputs
	reg [263:0] state_in;
	reg [15:0] IV_in, INV_IV_in;
	reg clk;
	reg rst;
	reg en;

	reg [31:0] index;

	// Outputs
	wire [263:0] state_out;
	wire [15:0] IV_out, INV_IV_out;
	wire rdy;

	// Instantiate the Unit Under Test (UUT)
	Permute uut (
		.state_in(state_in), 
		.IV_in(IV_in),
		.INV_IV_in(INV_IV_in),
		.state_out(state_out),
		.IV_out(IV_out),
		.INV_IV_out(INV_IV_out),
		.clk(clk), 
		.rst(rst),
		.en(en),
		.index(index),
		.rdy(rdy)
	);
	
	integer i;
	initial begin
		// Initialize Inputs
		index = 0;
		state_in = 0;
		clk = 0;
		rst = 1;
		en = 0;
		//#5 rst = 0;
		// Wait 100 ns for global reset to finish
		#100;
		// Add stimulus here
		rst = 0;
		IV_in = 16'hc6;
		INV_IV_in = 16'h0;
		$display("[INITIALIZING]");
		for (i=0; i<`nSBox; i=i+1) begin
			state_in = state_in | i<<(i*8);
		end
		$display("state in: %h", state_in);
		en = 1;
		repeat (70) begin // takes 70 cycles (optimizable?)
			#5;
		end
		en = 0;
		if (rdy) begin
			$display("state_out: %h", state_out);
		end
		
	end

   always begin
		#5; clk = !clk;
   end

endmodule

