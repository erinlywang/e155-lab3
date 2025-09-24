/// Author: Erin Wang
/// Email: eringwang@g.hmc.edu
/// Date: 09/20/2025

// tb_debouncer module tests the debouncer module 
// It applies a row and whether the previous input has been debounced
// and outputs the col to send power to as well as which row is pressed

// Modelsim-ASE requires a timescale directive
`timescale 1 ns / 1 ns

module tb_debouncer(); 
    logic   clk, reset;
    logic	[3:0] row;							// input
	logic	[3:0] col;							// output
    logic   [3:0] debouncedrow, debouncedcol;   // output
	logic	debounced;							// output 

	//// Instantiate device under test (DUT). 
	// Inputs: s Outputs: sel, trans0, trans1
	debouncer dut(clk, reset, row, col, debouncedrow, debouncedcol, debounced); 
	
	logic [3:0] i;

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
		
		//// TEST STATE 1
		// Check pressed_row and pressed_col get the current row when moving into S1
		#1
		row = 4'b0001;
		col = 4'b0001;
		
		@(negedge clk);
		#1
		assert (debouncedrow == 4'b0001) else $display(" debouncedrow = %b (%b expected)", debouncedrow, 4'b0001);
		assert (debouncedcol == 4'b0001) else $display(" debouncedrcol = %b (%b expected)", debouncedcol, 4'b0001);
		
		// Press another row's button at the same time while the first one is held and check to see that the output row is the one in memory 
		@(posedge clk);
		#1
		row = 4'b0101;
		col = 4'b0001;
		
		@(posedge clk);
		#1
		assert (debouncedrow == 4'b0001) else $display(" debouncedrow = %b (%b expected)", debouncedrow, 4'b0001);
		assert (debouncedcol == 4'b0001) else $display(" debouncedrcol = %b (%b expected)", debouncedcol, 4'b0001);
		
		
		/// TEST STATE 2
		// wait for counter to reach 50 ms
		wait (debounced == 1'b1);
		
		// enter S2, no outputs should change
		@(posedge clk);
		#1
		assert (debouncedrow == 4'b0001) else $display(" debouncedrow = %b (%b expected)", debouncedrow, 4'b0001);
		assert (debouncedcol == 4'b0001) else $display(" debouncedrcol = %b (%b expected)", debouncedcol, 4'b0001);
		assert (debounced == 1'b1) else $display(" debounced = %b (%b expected)", debounced, 1'b1);
			
		// Press another row's button at the same time while the first one is held and check to see that the output row is the one in memory 
		@(posedge clk);
		#1
		row = 4'b0011;
		col = 4'b0001;
		
		@(posedge clk);
		#1
		assert (debouncedrow == 4'b0001) else $display(" debouncedrow = %b (%b expected)", debouncedrow, 4'b0001);
		assert (debouncedcol == 4'b0001) else $display(" debouncedrcol = %b (%b expected)", debouncedcol, 4'b0001);
		
		// Take finger off key and thus move to STATE 0
		@(negedge clk);
		#1
		row = 4'b0;
		
		@(negedge clk);
		#1
		assert (debouncedrow == 4'b0000) else $display(" debouncedrow = %b (%b expected)", debouncedrow, 4'b0000);
		assert (debouncedcol == 4'b0001) else $display(" debouncedrcol = %b (%b expected)", debouncedcol, 4'b0001);
		assert (debounced == 1'b0) else $display(" debounced = %b (%b expected)", debounced, 1'b0);
		
		// press new key
		#1 
		row = 4'b1000;
		col = 4'b1000;
		
		// Check from STATE 0 we still register new keys
		
		@(posedge clk);
		#1
		assert (debouncedrow == 4'b1000) else $display(" debouncedrow = %b (%b expected)", debouncedrow, 4'b1000);
		assert (debouncedcol == 4'b1000) else $display(" debouncedrcol = %b (%b expected)", debouncedcol, 4'b1000);
		assert (debounced == 1'b0) else $display(" debounced = %b (%b expected)", debounced, 1'b0);
		
		$finish;
	end 

endmodule