`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: TU Darmstadt
// Engineer: Florian Beyer
// 
// Create Date:    17:38:52 02/23/2017 
// Design Name: 
// Module Name:    tb_SpongentHash 
// Project Name: 
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
module tb_SpongentHash;

	wire [87:0]		hash;
	reg  [87:0]		reference_hash;
	reg				clk;
	reg				rst;
	reg				en;
	wire				rdy;


	SpongentHash uut (
		.clk(clk), 
		.rst(rst), 
		.en(en), 
		.rdy(rdy),
		.hash_out(hash)
	);


	initial begin
		clk = 0;
		rst = 1;
		en = 0;
		// Set reference Hash value, to test if the result is right.
		// Hash for "Hello WorldHello World ZY"
		// reference_hash = 88'ha9b5344ec2f458323a1acc;

		// Hash for "Spongent is a lightweight Hashfunction"
		reference_hash = 88'h06846ff7186c0cfa5dfd32;
		#100;
		
		rst = 0;
		en = 1;
	end

   always begin
		#5; clk = !clk;
   end
	
	always @ rdy begin
		if (rdy == 1) begin
			$display("hash %h", hash);
			if (hash === reference_hash) begin
				$display("SUCCESS");
			end
		end
	end
endmodule