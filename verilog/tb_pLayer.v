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
	reg [31:0] index;
	reg clk;
	reg rst;

	// Outputs
	wire [263:0] state_out;
	
	reg [31:0] ticks;

	// Instantiate the Unit Under Test (UUT)
	pLayer uut (
		.state_in(state_in), 
		.state_out(state_out),
		.index(index), 
		.clk(clk), 
		.rst(rst)
	);
	
	integer i;
	initial begin
		// Initialize Inputs
		state_in = 0;
		index = 0;
		clk = 0;
		rst = 1;
		
		ticks = 0;
		
		
		// Wait 100 ns for global reset to finish
		#100;
		rst = 0;
		// Add stimulus here
		$display("[INITIALIZING]");
		for (i=0; i<`nSBox; i=i+1) begin
			state_in = state_in | i<<(i*8);
		end
		$display("state in: %h", state_in);
		
		for (i=0; i<`nSBox; i=i+1) begin
			index <= i;
			ticks = ticks + 1;
			#5; //$display("tick");
			
		end
		$display("state out: %h", state_out);
		$display("calculation took %d ticks.", ticks);
	end

   always begin
		#5; clk = !clk;
   end

endmodule

