//////////////////////////////////////////////////////////////////////////////////
// Company: TU Darmstadt
// Engineer: Florian Beyer
// 
// Create Date:    17:38:52 02/23/2017 
// Design Name: 
// Module Name:    Absorb
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: This is the absorb module of Spongent. It represents the absorbing
// phase of the hash function. If the improvements I mentioned in SpongentHash.v are
// made, absorb needs to be changed too. As input it then just needs the counter,
// the ram address of the actual block and en enable signal.
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
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
	reg	[15:0]		permute_IV_in;
	reg	[263:0]		permute_state_in;
	reg					permute_rst;
	
	wire  [263:0]		permute_state_out;
	wire	[15:0]		permute_IV_out;
	wire					permute_out_rdy;
		
	Permute permute_instance (
			.state_in(permute_state_in),
			.IV_in(permute_IV_in),
			.state_out(permute_state_out),
			.IV_out(permute_IV_out),
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
			
			// initialize temp_state here, if Absorb is enabled
			if (temp_state == 0) begin
				temp_state = state_in;
			end
			
			// Call Permute
			if (wr_en) begin
				wr_en = 0;
				permute_IV_in = IV;
				permute_state_in = temp_state;
				permute_enable = 1;
			end
			
			// If Permute finished its computation, reenter it for 135 rounds.
			// After the last round set Absorbs output ready.
			if (permute_out_rdy) begin
				temp_state = permute_state_out;
				IV = permute_IV_out;
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