/// Author: Erin Wang
/// Email: eringwang@g.hmc.edu
/// Date: 09/08/2025

// tb_sync module tests the synchronizer module 
// It applies inputs to mpx module and checks if outputs are as expected through assert statements 

// Modelsim-ASE requires a timescale directive
`timescale 1 ns / 1 ns

module tb_sync(); 
    logic   clk, reset; 
    logic	[3:0] async_signal;
    logic   [3:0] sync_signal;           // output

	//// Instantiate device under test (DUT). 
	// Inputs: s Outputs: sel, trans0, trans1
	synchronizer dut(clk, reset, async_signal, sync_signal); 

	//// Generate clock at 24 MHz
	always begin 
		clk=1; #5;  
		clk=0; #5; 
	end 

	//// Start of test.  
	initial begin 
		//// Pulse reset for 22 time units(2.2 cycles) so the reset signal falls after a clk edge. 
		reset=0; #22;  
		reset=1; 
		
		@(posedge clk);
		#1
		async_signal = 4'b1111;
		
		repeat (5) @(posedge clk);
		#1
		assert (sync_signal == async_signal) else $display(" sync_signal = %b (%b expected)", sync_signal, async_signal);

		$finish;
	end 

endmodule