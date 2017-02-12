`include "constants.vh"

module pLayer(state_in, state_out, index, clk, rst);

   input 						clk;
   input 						rst;
	input				[31:0]	index;
	input  			[263:0]	state_in;
	
	output 	reg	[263:0]	state_out;

	wire				[7:0]		out_comb;
	reg 				[7:0] 	permute [0:32];
	
	integer k;
	initial begin
		for (k=0; k<`nSBox; k=k+1)
			permute[k] = 0;
	end
	
	reg  [7:0] x, y;
	reg [31:0] j, PermutedBitNo;
	
	wire [8:0] pi_out_field [8:0][32:0];
	
	wire [31:0] idx;
	index_counter idx_counter (.clk(clk), .rst(rst), .count(idx));

	genvar itr_i, itr_j;
	generate begin
		for (itr_i = 0; itr_i<`nSBox; itr_i=itr_i+1) begin : Pi_i
			for (itr_j = 0; itr_j<8; itr_j=itr_j+1) begin : Pi_j
				Pi_mod pi(.in ((itr_i<<3)+itr_j), .out (pi_out_field[itr_j][itr_i]), .clk (clk), .rst (rst));
			end
		end
	end endgenerate
	
	always @ (*) begin
		if (rst) begin
			state_out = 0;
		end else begin
			for (j=0; j<8; j=j+1) begin
				x = (state_in[(index*8)+:8]>>j) & 264'b1; //TODO use index_counter instead of index
				PermutedBitNo = pi_out_field[j][index];
				y = PermutedBitNo>>3;
				permute[y] = permute[y] ^ (x << (PermutedBitNo - 8*y));
				state_out = state_out | permute[y] << (y*8);
			end
		end
		end
	
endmodule

module index_counter(
  input  wire clk,
  input  wire rst,
  output reg [31:0] count
);

always@(posedge clk or posedge rst)
  if(rst) begin
    count <= 0;
		 end
  else begin
	count <= count + 1;

	end
endmodule
