/// Author: Erin Wang
/// Email: erinwang@g.hmc.edu
/// Date: 09/23/2025

// synchronizer module takes an asynchronous input
// and outputs a synchronized signal
// with 4 flops to match with the 4 scanning states of the scanner module

module synchronizer(input	logic clk,
					input	logic reset,
					input 	logic [3:0] async_signal,
					output 	logic [3:0] sync_signal);
		
		logic [3:0] signal_ff, signal_ff1, signal_ff2, signal_ff3;
					
		always_ff @(posedge clk) begin
			if (reset==0) 	begin
				sync_signal <= 4'b0;
				signal_ff <= 4'b0;
				signal_ff2 <= 4'b0;
				signal_ff3 <= 4'b0;
				end
			else 			begin
				signal_ff <= async_signal;
				signal_ff2 <= signal_ff;
				signal_ff3 <= signal_ff2;
				sync_signal <= signal_ff3;
			end
		end
endmodule