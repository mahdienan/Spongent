`timescale 1ns / 1ps
`include "constants.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company: TU Darmstadt
// Engineer: Florian Beyer
// 
// Create Date:    17:06:57 02/23/2017 
// Design Name: 
// Module Name:    SpongentHash 
// Project Name: 	 spongent
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module SpongentHash(data_in, databitlen_in, clk, rst, en, rdy, hash_out);

	input [263:0]	data_in;
	input [ 31:0]	databitlen_in;
	input				rst;
	input				clk;
	input				en;
	
	output reg			rdy;
	output reg [87:0]	hash_out;
	
	reg	[263:0]		state;
	reg	[263:0]		data;
	reg	[ 87:0]		hash;
	reg	[ 31:0]		i, databitlen;
	reg					wr_en;
	reg	[263:0]		absorb_state_in;
	reg					absorb_enable;
	reg					absorb_rst;
	
	wire					absorb_out_rdy;
	wire	[263:0]		absorb_state_out;

	Absorb absorb_instance (
		.state_in(absorb_state_in),
		.state_out(absorb_state_out),
		.clk(clk),
		.rst(absorb_rst),
		.en(absorb_enable),
		.rdy(absorb_out_rdy)
	);


	always @ (posedge clk or posedge rst) begin
		if (rst) begin
			rdy = 0;			
			state = 0;
			data = 0;
			wr_en = 1;
			absorb_rst = rst;
			absorb_state_in = 0;
			absorb_enable = 0;
			databitlen = 0;
			hash = 0;
		end else if (en) begin
			absorb_rst = 0;			
				
			if (wr_en) begin
				wr_en = 0;
				// At the first entry after rst, databitlen and data have to be initialized.
				if (databitlen == 0 && data == 0) begin
					databitlen = databitlen_in;
					data = data_in;
					
					// Pad data. Add 0x80 + necessary zeros at the end. And increase databitlen to the actual value.
					if (databitlen % 88 != 0) begin
						data = data << (88-databitlen%88);
						data[80-databitlen%88+:8] = 16'h80;
						databitlen = databitlen + (88-databitlen%88);
					end
					
				end 
				
				// Call Absorb for every block of data with length `R_SizeInBytes. 
				// The padding before ensures, that databitlen % rate(88) = 0;
				if (databitlen >= `rate) begin
					// XOR (^) the last 11 bytes of state with the actual datablock.
					for (i = 0; i < `R_SizeInBytes*8; i = i+8) begin
						state[i+:8] = state[i+:8] ^ data[databitlen - (i+8) +:8];
					end
					absorb_state_in = state;
					absorb_enable = 1;
					
				end else begin
					for (i = 0; i < `R_SizeInBytes*8; i = i+8) begin
						hash[i+:8] = hash[i+:8] ^ state[i +:8];
					end
					hash_out = hash;
					rdy = 1;
				end
				
			end

			// If output of absorb is ready, save it´s state and reset absorb.
			// Then enable the computation in SpongentHash again (wr_en=1).
			if (absorb_out_rdy) begin
				state = absorb_state_out;
				absorb_rst = 1;

				if (databitlen > 0) begin
					databitlen = databitlen - `rate;
					wr_en = 1;
				end				
			end
		end
	end

endmodule
