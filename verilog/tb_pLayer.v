`timescale 1ns / 1ps
`include "constants.vh"
////////////////////////////////////////////////////////////////////////////////
// Company: TU Darmstadt
// Engineer: Mahdi Enan
//
// Create Date:   09:55:48 01/21/2017
// Design Name:   pLayer
// Module Name:   tb_pLayer.v
// Project Name:  spongent
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: pLayer
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module tb_pLayer;

	// Inputs
	reg [263:0] state_in;
	reg clk;
	reg rst;

	// Outputs
	wire [263:0] 	state_out;
	wire				out_rdy;
	
	// Instantiate the Unit Under Test (UUT)
	pLayer uut (
		.state_in(state_in), 
		.state_out(state_out),
		.clk(clk), 
		.rst(rst),
		.out_rdy(out_rdy)
	);
	
	integer i;
	initial begin
		// Initialize Inputs
		state_in = 0;
		clk = 0;
		rst = 1;
		
		// Wait 100 ns for global reset to finish
		#100;
		rst = 0;
		// Add stimulus here
		$display("[INITIALIZING]");
		for (i=0; i<`nSBox; i=i+1) begin
			state_in = state_in | i<<(i*8);
		end
		$display("state in: %h", state_in);
		
		repeat (66)
			#5;

		if (out_rdy) begin
			$display("state out: %h", state_out);
		end
	end

   always begin
		#5; clk = !clk;
   end

endmodule
