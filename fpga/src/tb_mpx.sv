/// Author: Erin Wang
/// Email: erinwang@g.hmc.edu
/// Date: 09/23/2025

// tb_mpx module tests the top module 
// It applies inputs to mpx module and checks if outputs are as expected through assert statements 

// Modelsim-ASE requires a timescale directive
`timescale 1 ns / 1 ns

module tb_mpx(); 
    logic   clk, reset; 
    logic	[3:0] s0, s1;
    logic   [3:0] s;           // output
    logic   trans0, trans1;  // output
	
	logic [7:0] i;

	//// Instantiate device under test (DUT). 
	// Inputs: s Outputs: sel, trans0, trans1
	mpx dut(clk, reset, s0, s1, s, trans0, trans1); 

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
		
		//// Check each s output from before counter_output goes high
		for (i = 8'b00000000; i <= 8'b11111111; i++) begin
			#1
			s0 = i[3:0];
			s1 = i[7:4];
			#1
			assert (s == s0) else $display(" s = %b (%b expected)", s, s0);
			assert (trans0 == 0) else $display(" trans0 = %b (0 expected)", trans0);	
			assert (trans1 == 1) else $display(" trans1 = %b (1 expected)", trans1);
		end	
			
		/// Wait 2000000 time units (200000 cycles)
		#20000000
		for (i = 8'b00000000; i <= 8'b11111111; i++) begin
			#1
			s0 = i[3:0];
			s1 = i[7:4];
			#1
			assert (s == s1) else $display(" s = %b (%b expected)", s, s1);
			assert (trans0 == 1) else $display(" trans0 = %b (1 expected)", trans0);	
			assert (trans1 == 0) else $display(" trans1 = %b (0 expected)", trans1);
		end	
		$finish;
	end 

endmodule
