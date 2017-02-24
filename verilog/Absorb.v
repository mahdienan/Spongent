
module Absorb(state_in, state_out, clk, rst, en, rdy);
	
	input		 [263:0]	state_in;
	input					rst;
	input 				clk;
	input					en;
	
	output reg[263:0]	state_out;
	output reg			rdy;
	
	reg 					wr_en;
	reg	[15:0]		IV, INV_IV;
	reg	[31:0]		iteration;
	reg	[263:0]		temp_state;
	
	reg					permute_enable;
	reg	[15:0]		permute_IV_in, permute_INV_IV_in;
	reg	[263:0]		permute_state_in;
	reg					permute_rst;
	
	wire  [263:0]		permute_state_out;
	wire	[15:0]		permute_IV_out, permute_INV_IV_out;
	wire					permute_out_rdy;
		
	Permute permute_instance (
			.state_in(permute_state_in),
			.IV_in(permute_IV_in),
			.INV_IV_in(permute_INV_IV_in),
			.state_out(permute_state_out),
			.IV_out(permute_IV_out),
			.INV_IV_out(permute_INV_IV_out),
			.clk(clk),
			.rst(permute_rst),
			.en(permute_enable),
			.rdy(permute_out_rdy)
	);
	
	always @ (posedge clk or posedge rst) begin
	
		if (rst) begin
			permute_rst = rst;
			state_out = 0;
			temp_state = 0;
			permute_state_in = 0;
			permute_enable = 0;
			IV = 16'hc6;
			INV_IV = 16'h0;
			wr_en = 1;
			rdy = 0;
			iteration = 0;
		end else if (en) begin
			permute_rst = 0;
			if (temp_state == 0) begin
				temp_state = state_in;
			end 
			
			if (wr_en) begin
				wr_en = 0;
				permute_IV_in = IV;
				permute_INV_IV_in = INV_IV;
				permute_state_in = temp_state;
				permute_enable = 1;
			end
		
			if (permute_out_rdy) begin
				temp_state = permute_state_out;
				IV = permute_IV_out;
				INV_IV = permute_INV_IV_out;
				iteration = iteration + 1;
				
				if (iteration === 135) begin
					state_out = permute_state_out;
					rdy = 1;
				end else begin
					wr_en = 1;
					// reset nested modules
					permute_rst = 1;
					rdy = 0;
				end
			end else begin
				rdy = 0;
			end
		end
	end 
	
endmodule