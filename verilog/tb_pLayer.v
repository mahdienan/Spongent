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
	reg [7:0] state_in;
	reg [31:0] index;
	reg clk;
	reg rst;

	// Outputs
	wire [8:0] state_out;

	// Instantiate the Unit Under Test (UUT)
	pLayer uut (
		.state_in(state_in), 
		.state_out(state_out), 
		.index(index), 
		.clk(clk), 
		.rst(rst)
	);
	
	reg 			[7:0] state [0:32];
	integer i;

	initial begin
		// Initialize Inputs
		state_in = 0;
		index = 0;
		
		for (i=0; i<`nSBox; i=i+1) begin
			state[i] = i;
		end
		$display("input state: %h", state);
		
		clk = 0;
		rst = 1;
		rst = 0;
		
		// Wait 100 ns for global reset to finish
		#100;
		
		// Add stimulus here
		for (i=0; i<`nSBox; i=i+1) begin
			index <= i; #5;
			state_in <= state[index];
			//$display("state_in [%d]: %h", index, state[index]);
			//$display("state_out: %h", state_out);
		end
	end

   always begin
		#5; clk = !clk;
   end

endmodule

