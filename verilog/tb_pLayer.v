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
	reg en;

	// Outputs
	wire [263:0] 	state_out;
	wire				out_rdy;
	
	// Instantiate the Unit Under Test (UUT)
	pLayer uut (
		.state_in(state_in), 
		.state_out(state_out),
		.clk(clk), 
		.rst(rst),
		.en(en),
		.out_rdy(out_rdy)
	);
	
	//integer i;
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
		en = 1;

		state_in = 264'h20d6d3dcd9d5d8dad7dfd4d1d2d0dbdddee6e3ece9e5e8eae7efe4e1e2e0ebed94;
		$display("state in: %h", state_in);
		repeat (66)
			#5;

		if (out_rdy) begin
			$display("state out: %h", state_out);
		end
		
		rst = 1; en = 0;
		#5;
		en = 1; rst = 0;
		state_in = 264'ha8365886353658867333568863335688ca2ed1e22f3856833e55353353dd2d22a5;

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
