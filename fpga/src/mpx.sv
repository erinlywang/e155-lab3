/// Author: Erin Wang
/// Email: erinwang@g.hmc.edu
/// Date: 09/23/2025

// mpx module takes a a clk and reset input
// and outputs a select logic for the multiplexer logic to choose switch inputs
// and outputs for turning the transistors (digits on the 7-seg module) ON/OFF

module mpx( input	clk,
			input	reset,
			input	logic [3:0] in0,
			input	logic [3:0] in1,
			output	logic [3:0] switch,
			output	logic trans0,
			output	logic trans1);
	logic [23:0] counter;
	logic counter_output;
	
	// Counter
	always_ff @(posedge clk) begin
		if (reset==0)		begin
			counter <= 24'b0;
			counter_output <= 1'b0;
		end
		else if (counter == 24'd200000)	begin
			counter <= 24'b0;
			counter_output <= ~counter_output;
		end
		else				counter <= counter + 24'b1;
	end
	
	assign switch = counter_output ? in1:in0;
	assign trans0 =  counter_output;
	assign trans1 = ~counter_output;
	
endmodule
