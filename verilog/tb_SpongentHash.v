`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
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

	reg [263:0]		data;
	wire [87:0]		hash;
	reg				clk;
	reg				rst;
	reg				en;
	wire				rdy;
	reg [31:0]  	databitlen;


	SpongentHash uut (
		.data_in(data), 
		.databitlen_in(databitlen),
		.clk(clk), 
		.rst(rst), 
		.en(en), 
		.rdy(rdy),
		.hash_out(hash)
	);


	initial begin
		databitlen = 0;
		data = 0;
		clk = 0;
		rst = 1;
		en = 0;
		
		#100;
		
		rst = 0;
		en = 1;
		
		data = "Hello WorldHello WorldZY";
		databitlen = 192;
		repeat(5000) begin
			#5;
		end
		
		if (rdy == 1) begin
			$display("hash %h", hash);
		end
	end

   always begin
		#5; clk = !clk;
   end
	
	always @ rdy begin
		if (rdy == 1) begin
			$display("hash %h", hash);
		end
	end
endmodule
