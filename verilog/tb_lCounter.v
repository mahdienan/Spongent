`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: TU Darmstadt
// Engineer: Mahdi Enan
//
// Create Date:   10:05:08 01/18/2017
// Design Name:   lCounter
// Module Name:   /home/cie/Xilinx/projects/spongent/tb_lCounter.v
// Project Name:  spongent
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: lCounter
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module tb_lCounter;

	// Inputs
	reg [15:0] lfsr;

	// Outputs
	wire [15:0] out;

	// Instantiate the Unit Under Test (UUT)
	lCounter uut (
		.lfsr(lfsr), 
		.out(out)
	);

	initial begin
		// Initialize Inputs
		lfsr = 16'b0000000000000000;

		// Wait 100 ns for global reset to finish
		#100;
		
		while (lfsr < 16'b1111111111111111)
		begin
			$display ("lfsr=%d, (hex): %h", lfsr, out);
			#1;
			lfsr = lfsr + 1;
			#1;
		end
	end
      
endmodule

