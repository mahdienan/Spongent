`timescale 1ns / 1ps
`include "constants.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company: TU Darmstadt
// Engineer: Mahdi Enan
// 
// Create Date:    15:37:20 01/22/2017 
// Design Name: 
// Module Name:    Permute 
// Project Name: spongent
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
module Permute(state_in, IV_in, INV_IV_in, state_out, IV_out, INV_IV_out, clk, rst, en, rdy);
	input		[263:0]	state_in;	// input  of 33 iterations
	input		[ 15:0]	IV_in;
	input		[ 15:0]	INV_IV_in;
	input					rst;
	input					clk;
	input					en;
	output reg[263:0] state_out;	// output of 33 iterations
	output reg[ 15:0]	IV_out;
	output reg[ 15:0]	INV_IV_out;
	output reg			rdy;
	
	reg	[  15:0] i;
	reg 	[ 263:0]	tmp_state;
	reg 	[2048:0]	sBoxLayer;
	reg 				wr_en;
	

	wire  [  15:0] lCounter_out, retnuoCl_out;
	lCounter lCounter_instance(.lfsr(IV_in), .out(lCounter_out));
	retnuoCl retnuoCl_instance(.lfsr(IV_in), .out(retnuoCl_out));
	
	reg				pLayer_enable;
	reg	[ 263:0]	pLayer_state_in;
	wire	[ 263:0]	pLayer_state_out;
	wire				pLayer_out_rdy;
	pLayer pLayer_instance (.clk(clk), 
									.rst(rst),
									.state_in(pLayer_state_in), 
									.state_out(pLayer_state_out), 
									.out_rdy(pLayer_out_rdy),
									.en(pLayer_enable)
									);

	initial begin
		`INIT_SBOX_LAYER;
	end

	integer j;
	always @ (posedge clk or posedge rst) begin
		if (rst) begin
			state_out = 0;
			tmp_state = 0;
			pLayer_state_in = 0;
			pLayer_enable = 0;
			wr_en = 1;
			rdy = 0;
		end else begin
			IV_out = 0;
			INV_IV_out = 0;
			state_out = 0;
			tmp_state = state_in;
			tmp_state[ 7:0] = tmp_state[ 7:0] ^ (IV_in & 16'hff);
			tmp_state[15:8] = tmp_state[15:8] ^ ((IV_in >> 8) & 16'hff);
			INV_IV_out = retnuoCl_out;
			
			tmp_state[(`nSBox*8)-1:(`nSBox*8)-1-7] = tmp_state[(`nSBox*8)-1:(`nSBox*8)-1-7] ^ (INV_IV_out >> 8) & 8'hff;
			tmp_state[(`nSBox*8)-8:(`nSBox*8)-1-15] = tmp_state[(`nSBox*8)-8:(`nSBox*8)-1-15] ^ INV_IV_out & 8'hff;
			IV_out = lCounter_out;
			
			for (j=0; j<`nSBox*8; j=j+8) begin
				tmp_state[j+:8] = sBoxLayer[(tmp_state[j+:8]*8)+:8];
			end
			if (wr_en) begin
				wr_en = 0;
				pLayer_state_in = tmp_state;
				pLayer_enable = 1;
			end
			
			if (pLayer_out_rdy) begin
				state_out = pLayer_state_out;
				rdy = 1;
			end else begin
				rdy = 0;
			end
		end
	end
	
endmodule
