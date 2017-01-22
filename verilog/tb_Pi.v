`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: TU Darmstadt
// Engineer: Mahdi Enan
//
// Create Date:   10:44:35 01/18/2017
// Design Name:   Pi
// Module Name:   tb_Pi.v
// Project Name:  spongent
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: Pi
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module tb_Pi;

	// Inputs
	reg [31:0] in;
	reg clk;
	reg rst;

	// Outputs
	wire [8:0] out;

	// Instantiate the Unit Under Test (UUT)
	Pi_mod uut (
		.in(in), 
		.out(out), 
		.clk(clk),
		.rst(rst)
	);

	initial begin
		// Initialize Inputs
		in = 0;
		clk = 0;
		#5;
		rst = 1;
		#5;
		rst = 0;
		#5;
		while ( in < 10) begin
			#5;
			$display ("i = %d, Pi=%h", in, out);
			in = in + 1;
			#5;
		end
		
		in = 31'h000000FE;
		#5;
		$display("pi_in: %X, pi_out: %X", in, out);		
		in = 31'h000000FD;
		#5;
		$display("pi_in: %X, pi_out: %X", in, out);		
		in = 31'h00000100;
		#5;
		$display("pi_in: %X, pi_out: %X", in, out);
	end
	
	always begin
		#5 clk = !clk;
   end
endmodule

