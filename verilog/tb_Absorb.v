`timescale 1ns / 1ps
`include "constants.vh"

module tb_Absorb;

	reg	[263:0]	state_in;
	reg				clk;
	reg				rst;
	reg				en;
	
	reg	[175:0]	data;
	
	wire	[263:0]	state_out;
	wire				rdy;

	Absorb uut (
		.state_in(state_in),
		.state_out(state_out),
		.clk(clk),
		.rst(rst),
		.en(en),
		.rdy(rdy)
	);

	integer i;
	integer databitlen;
	integer counter;
	initial begin
		databitlen = 176;
		data = "Hello WorldHello World";
		counter = 0;
		
		state_in = 0;
		clk = 0;
		rst = 1;
		en = 0;
		
		#100;
		
		rst = 0;
		$display("[INITIALIZING]");
//		for (i=0; i<`nSBox; i=i+1) begin
//			state_in = state_in | i<<(i*8);
//		end

		state_in = 0;
		en = 1;
		
		while (databitlen >= `rate) begin
						
			$display("counter %d", counter);
			for (i = 0; i < `R_SizeInBytes*8; i = i+8) begin
				state_in[i+:8] = state_in[i+:8] ^ data[databitlen - (i+8) +:8];
				$display("data: %d %h", databitlen - (i+8), data[databitlen - (i+8) +:8]);
			end
			
			$display("state in: %h", state_in);
			$display("data: %h", data);
			
			repeat(70*135) begin
				#5;
			end
			
			if (rdy) begin
				state_in = state_out;
				$display("state_out: %h", state_out);
				counter = counter + 1;
				databitlen = databitlen - `rate;
			end
		end		
	end

   always begin
		#5; clk = !clk;
   end
	
	always @ (rdy) begin
		if (rdy == 1) begin
			state_in = state_out;
			$display("state_out: %h", state_out);
		end
	end

endmodule
