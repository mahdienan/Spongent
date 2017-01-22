`include "constants.vh"

module Pi_mod(in, out, clk, rst);

	input           	 clk;
	input					 rst;
	input  		[31:0] in;
	output reg 	[8:0] out;
	
	wire [8:0] out_comb = (in != `nBits-1) ?
									(in*`nBits/4)%(`nBits-1) :
									`nBits-1;

	always@(posedge clk)
	if (rst)
		out <= 0;
	else
		out <= out_comb;
		
endmodule
