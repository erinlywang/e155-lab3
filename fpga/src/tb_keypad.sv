/// Author: Erin Wang
/// Email: erinwang@g.hmc.edu
/// Date: 09/20/2025

// tb_keypad module tests the keypad module 
// It applies a row and a column
// and outputs what the corresponding key on the keypad is
// It assumes that only one key is registered at a time

// Modelsim-ASE requires a timescale directive
`timescale 1 ns / 1 ns

module tb_keypad(); 
    logic   clk, reset;							// input 
    logic	[3:0] row;							// input
	logic	[3:0] col;							// output
    logic   [3:0] key;     // output

	//// Instantiate device under test (DUT). 
	// Inputs: s Outputs: sel, trans0, trans1
	keypad dut(reset, row, col, key); 

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
		
		// Check 1	
		#1
		row = 4'b0001;
		col = 4'b0001;
		#1
		assert (key == 4'b0001) else $display(" key = %b (%b expected)", key, 4'b0001);
		
		// Check 2
		#1
		row = 4'b0001;
		col = 4'b0010;
		#1
		assert (key == 4'b0010) else $display(" key = %b (%b expected)", key, 4'b0010);
			
		// Check 3
		#1
		row = 4'b0001;
		col = 4'b0100;
		#1
		assert (key == 4'b0011) else $display(" key = %b (%b expected)", key, 4'b0011);
			
		// Check A
		#1
		row = 4'b0001;
		col = 4'b1000;
		#1
		assert (key == 4'b1010) else $display(" key = %b (%b expected)", key, 4'b1010);
			
		// Check 4
		#1
		row = 4'b0010;
		col = 4'b0001;
		#1
		assert (key == 4'b0100) else $display(" key = %b (%b expected)", key, 4'b0100);
			
		// Check 5
		#1
		row = 4'b0010;
		col = 4'b0010;
		#1
		assert (key == 4'b0101) else $display(" key = %b (%b expected)", key, 4'b0101);
		
		// Check 6
		#1
		row = 4'b0010;
		col = 4'b0100;
		#1
		assert (key == 4'b0110) else $display(" key = %b (%b expected)", key, 4'b0110);
		
		// Check B
		#1
		row = 4'b0010;
		col = 4'b1000;
		#1
		assert (key == 4'b1011) else $display(" key = %b (%b expected)", key, 4'b1011);
		
		// Check 7
		#1
		row = 4'b0100;
		col = 4'b0001;
		#1
		assert (key == 4'b0111) else $display(" key = %b (%b expected)", key, 4'b0111);
			
		// Check 8
		#1
		row = 4'b0100;
		col = 4'b0010;
		#1
		assert (key == 4'b1000) else $display(" key = %b (%b expected)", key, 4'b1000);
			
		// Check 9
		#1
		row = 4'b0100;
		col = 4'b0100;
		#1
		assert (key == 4'b1001) else $display(" key = %b (%b expected)", key, 4'b1001);
		
		// Check C
		#1
		row = 4'b0100;
		col = 4'b1000;
		#1
		assert (key == 4'b1100) else $display(" key = %b (%b expected)", key, 4'b1100);
			
		// Check E (*)
		#1
		row = 4'b1000;
		col = 4'b0001;
		#1
		assert (key == 4'b1110) else $display(" key = %b (%b expected)", key, 4'b1110);
		
		// Check 0
		#1
		row = 4'b1000;
		col = 4'b0010;
		#1
		assert (key == 4'b0000) else $display(" key = %b (%b expected)", key, 4'b0000);
			
		// Check F (#)
		#1
		row = 4'b1000;
		col = 4'b0100;
		#1
		assert (key == 4'b1111) else $display(" key = %b (%b expected)", key, 4'b1111);
		
		// Check D
		#1
		row = 4'b1000;
		col = 4'b1000;
		#1
		assert (key == 4'b1101) else $display(" key = %b (%b expected)", key, 4'b1101);
		$finish;
	end 
	
endmodule

