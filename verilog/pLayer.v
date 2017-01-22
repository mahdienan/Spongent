`include "constants.vh"

module pLayer(state_in, state_out, index, clk, rst);

   input 				clk;
   input 				rst;
	input			[31:0]index;
	input  		[7:0]	state_in;
	output reg 	[8:0]	state_out;
	
	wire			[7:0] out_comb;
	reg			[7:0] out_async;
	reg 			[8:0] permute [0:32];
	integer k;
	
	initial begin
		for (k=0; k<`nSBox; k=k+1)
			permute[k] = 0;
	end
	
	reg  [8:0] x, y;
	reg [31:0] j, PermutedBitNo;
	
	wire [8:0] pi_out_field [7:0][32:0];
	
	genvar itr_i;
	genvar itr_j;
	generate begin
		for (itr_i = 0; itr_i<`nSBox; itr_i=itr_i+1) begin : Pi_i
			for (itr_j = 0; itr_j<8; 		itr_j=itr_j+1) begin : Pi_j
				Pi_mod pi(.in ((itr_i<<3)+itr_j), .out (pi_out_field[itr_j][itr_i]), .clk (clk), .rst (rst));
			end
		end
	end endgenerate
	
	always @ (*) begin
		for (j=0; j<8; j=j+1) begin
			x = (state_in>>j) & 8'b00000001;
			PermutedBitNo = pi_out_field[j][index];
			$display("in: %h, pi_out: %h", (index<<3)+j, pi_out_field[j][index]);
			//$display("pi_in: %h, pi_out: %h", (index<<3)+j, pi_out_field[j]);
			y = PermutedBitNo>>3;
			permute[y] = permute[y] ^ (x << (PermutedBitNo - 8*y));
			//$display("bla: x:%d, PBN:%d, %h", x, PermutedBitNo, (x << (PermutedBitNo - (y<<3))));
		end
	end
	
	always @ (posedge clk) begin
		if (rst) begin
			state_out <= 0;
		end else begin
			state_out <= permute[y];
		end
	end

endmodule
