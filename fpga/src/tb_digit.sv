/// Author: Erin Wang
/// Email: erinwang@g.hmc.edu
/// Date: 09/20/2025

// tb_digit module tests the digit module 
// It tests that the outputs do not update in NOUPDATE state,
// that when debounced input is high, the right digit gets the new value
// and the left digit gets the old right digit value,
// and that this update only happens once when debounced is high

// Modelsim-ASE requires a timescale directive
`timescale 1 ns / 1 ns

module tb_digit(); 
    logic   clk, reset;
	logic	debounced;							// input 
    logic	[3:0] debouncedrow;							// input
	logic	[3:0] debouncedcol;							// output
    logic   [3:0] rowleft, rowright, colleft, colright;     // output

	//// Instantiate device under test (DUT). 
	// Inputs: s Outputs: sel, trans0, trans1
	digit dut(clk, reset, debounced, debouncedrow, debouncedcol, rowleft, rowright, colleft, colright); 
	
	logic [3:0] i;

	//// Generate clock 
	always begin 
		clk=1; #5;  
		clk=0; #5; 
	end 

	//// Start of test.  
	initial begin 
		//// Pulse reset for 22 time units(2.2 cycles) so the reset signal falls after a clk edge. 
		reset=0; #22;  
		reset=1; 
		
		/// TEST 1: Checking states after beginning at a reset
		
		// Test NOUPDATE state after reset
		#1
		assert (rowleft == 4'b0) else $display(" rowleft = %b (%b expected)", rowleft, 4'b0);
		assert (rowright == 4'b0) else $display(" rowleft = %b (%b expected)", rowright, 4'b0);
		assert (colleft == 4'b0) else $display(" rowleft = %b (%b expected)", colleft, 4'b0);
		assert (colright == 4'b0) else $display(" rowleft = %b (%b expected)", colright, 4'b0);
		
		// Test for when debounced is high, only right digit should get new value
		@(negedge clk);
		#1
		debounced = 1;
		debouncedrow = 4'b0001;
		debouncedcol = 4'b0001;
		
		#10 // UPDATE state wait to finish
		
		@(negedge clk);
		#1
		assert (rowleft == 4'b0) else $display(" rowleft = %b (%b expected)", rowleft, 4'b0);
		assert (rowright == 4'b0001) else $display(" rowright = %b (%b expected)", rowright, 4'b0001);
		assert (colleft == 4'b0) else $display(" colleft = %b (%b expected)", colleft, 4'b0);
		assert (colright == 4'b0001) else $display(" colleft = %b (%b expected)", colright, 4'b0001);
		
		// Check that the values don't get overwritten again (after move to FINISHEDUPDATE)
		@(negedge clk);
		#1
		assert (rowleft == 4'b0) else $display(" rowleft = %b (%b expected)", rowleft, 4'b0);
		assert (rowright == 4'b0001) else $display(" rowleft = %b (%b expected)", rowright, 4'b0001);
		assert (colleft == 4'b0) else $display(" rowleft = %b (%b expected)", colleft, 4'b0);
		assert (colright == 4'b0001) else $display(" rowleft = %b (%b expected)", colright, 4'b0001);
		
		// return to NOUPDATE at next cycle
		#1
		debounced = 0;
		
		$display("TEST 1 FINISHED MOVING TO TEST 2");
		
		/// TEST 2: Check the left digit gets the right digit after another button update
		
		// In NOUPDATE state check digits haven't changed from previous test
		@(posedge clk);
		#1
		assert (rowleft == 4'b0) else $display(" rowleft = %b (%b expected)", rowleft, 4'b0);
		assert (rowright == 4'b0001) else $display(" rowleft = %b (%b expected)", rowright, 4'b0001);
		assert (colleft == 4'b0) else $display(" rowleft = %b (%b expected)", colleft, 4'b0);
		assert (colright == 4'b0001) else $display(" rowleft = %b (%b expected)", colright, 4'b0001);
		
		// Test for when debounced is high, right digit gets new value and left gets right digit's old value
		@(negedge clk);
		#1
		debounced = 1;
		debouncedrow = 4'b0010;
		debouncedcol = 4'b0010;
		
		#10 // UPDATE state wait to finish
		
		@(negedge clk);
		#1
		assert (rowleft == 4'b0001) else $display(" rowleft = %b (%b expected)", rowleft, 4'b0001);
		assert (rowright == 4'b0010) else $display(" rowleft = %b (%b expected)", rowright, 4'b0010);
		assert (colleft == 4'b0001) else $display(" rowleft = %b (%b expected)", colleft, 4'b0001);
		assert (colright == 4'b0010) else $display(" rowleft = %b (%b expected)", colright, 4'b0010);
		
		// Check that the values don't get overwritten again (move to FINISHEDUPDATE)
		@(negedge clk);
		#1
		assert (rowleft == 4'b0001) else $display(" rowleft = %b (%b expected)", rowleft, 4'b0001);
		assert (rowright == 4'b0010) else $display(" rowleft = %b (%b expected)", rowright, 4'b0010);
		assert (colleft == 4'b0001) else $display(" rowleft = %b (%b expected)", colleft, 4'b0001);
		assert (colright == 4'b0010) else $display(" rowleft = %b (%b expected)", colright, 4'b0010);
		
		$finish;
	end 

endmodule