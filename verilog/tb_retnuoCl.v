`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: TU Darmstadt
// Engineer: Mahdi Enan
//
// Create Date:   10:06:06 01/18/2017
// Design Name:   retnuoCl
// Module Name:   /home/cie/Xilinx/projects/spongent/tb_retnuoCl.v
// Project Name:  spongent
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: retnuoCl
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module tb_retnuoCl;

	// Inputs
	reg [15:0] lfsr;

	// Outputs
	wire [15:0] out;

	// Instantiate the Unit Under Test (UUT)
	retnuoCl uut (
		.lfsr(lfsr), 
		.out(out)
	);

	initial begin
		// Initialize Inputs
		lfsr = 16'b0000000000000000;
		$display("set lsfr to : %d", lfsr);
		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		while (lfsr < 16'b1111111111111111)
		begin
			$display ("lfsr=%d, out=%b, (hex): %h", lfsr, out, out);
			#1;
			lfsr = lfsr + 1;
			#1;
		end
	end
      
endmodule

