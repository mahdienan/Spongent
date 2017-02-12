`include "constants.vh"

module pLayer(state_in, state_out, clk, rst, out_rdy);

   input 						clk;
   input 						rst;
	input  			[263:0]	state_in;
	
	output 	reg	[263:0]	state_out;
	output	reg				out_rdy;

	wire				[7:0]		out_comb;
	reg 				[7:0] 	permute [0:32];
	
	reg	[263:0]	state_comb;
	
	reg  [7:0] x, y;
	reg [31:0] j, PermutedBitNo;
	
	wire [8:0] pi_out_field [8:0][32:0];

	reg [31:0] idx;

	integer k;
	initial begin
		for (k=0; k<`nSBox; k=k+1)
			permute[k] = 0;
	end
	
	genvar itr_i, itr_j;
	generate begin
		for (itr_i = 0; itr_i<`nSBox; itr_i=itr_i+1) begin : Pi_i
			for (itr_j = 0; itr_j<8; itr_j=itr_j+1) begin : Pi_j
				Pi_mod pi(.in ((itr_i<<3)+itr_j), .out (pi_out_field[itr_j][itr_i]), .clk (clk), .rst (rst));
			end
		end
	end endgenerate
	
	always @ (posedge clk or posedge rst) begin
		if (rst) begin
			state_out = 0;
			state_comb = 0;
			idx = 0;
			out_rdy = 0;
		end else begin
			for (j=0; j<8; j=j+1) begin
				x = (state_in[(idx*8)+:8]>>j) & 264'b1;
				PermutedBitNo = pi_out_field[j][idx];
				y = PermutedBitNo>>3;
				permute[y] = permute[y] ^ (x << (PermutedBitNo - 8*y));
				state_comb = state_comb | permute[y] << (y*8);
			end
			if (idx==32) begin
				state_out = state_comb;
				out_rdy = 1'b1;
			end
			idx = idx + 1;
		end
		end
	
endmodule