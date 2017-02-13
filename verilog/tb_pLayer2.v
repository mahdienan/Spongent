`timescale 1ns / 1ps
`include "constants.vh"
////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   17:53:33 02/08/2017
// Design Name:   pLayer
// Module Name:   tb_pLayer2.v
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

module tb_pLayer2;

	// Inputs
	reg [263:0] state_in;
	reg [31:0] index;
	reg clk;
	reg rst;
	reg enable;

	// Outputs
	wire [263:0] state_out;
	wire output_rdy;
	
	reg 			[7:0] state [0:32];

	// Instantiate the Unit Under Test (UUT)
	pLayer uut (
		.state_in(state_in), 
		.state_out(state_out), 
		.index(index), 
		.clk(clk), 
		.rst(rst), 
		.enable(enable), 
		.output_rdy(output_rdy)
	);
	
	reg  	[263:0]	temp_state_in;
	
	integer i;
	initial begin
		// Initialize Inputs
		state_in = 0;
		index = 0;
		clk = 0;
		rst = 0;
		enable = 0;

		for (i=0; i<`nSBox; i=i+1) begin
			state [i] = i;
		end
		for (i=0; i < `nSBox ; i = i+1) begin
        	temp_state_in[((`nSBox-1)*8)-(8*i) +: 8] = i;
		end
		$display("input state: %h", state);
		
		// Wait 100 ns for global reset to finish
		#100;
		enable = 1;
		state_in = temp_state_in;
		$display("out: %h", state_out);

		#5;
		$display("out: %h", state_out);
		#5;
		$display("out: %h", state_out);
		
		// Add stimulus here

	end
	
	always begin
		#5; clk = !clk;
	end
      
endmodule

