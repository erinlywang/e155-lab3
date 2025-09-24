/// Author: Erin Wang
/// Email: erinwang@g.hmc.edu
/// Date: 09/23/2025

// tb_scanner module tests the scanner module 
// It applies a row and whether the previous input has been debounced
// and outputs the col to send power to as well as which row is pressed

// Modelsim-ASE requires a timescale directive
`timescale 1 ns / 1 ns

module tb_scanner(); 
    logic   clk, reset;
	logic	debounced;							// input 
    logic	[3:0] row;							// input
	logic	[3:0] col;							// output
    logic   [3:0] pressed_row;     // output

	//// Instantiate device under test (DUT). 
	// Inputs: s Outputs: sel, trans0, trans1
	scanner dut(clk, reset, debounced, row, col, pressed_row); 
	
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
		
		//// Check states SCANNED0-3 are visited when all rows are 0 and check output col reflects the state
		#1
		row = 4'b0;
		for (i = 0; i<=3; i++) begin
			$display("waiting for negedge");
			@(negedge clk);
			$display("negedge occured");
			#1 // State SCANNED
			assert (col == (4'b0001 << i)) else $display(" col = %b (%b expected)", col, (4'b0001 << i));
		end
		
		$display(" SCANNED state test finished");
		
		$display("Starting PRESSED test");
		
		// Test the scanrelease conditional that moves from PRESSED back to SCANNED
		for (i = 0; i<=3; i++) begin
			// Get to PRESSED state
			$display("Checking PRESSED %d state", i);
			wait(col==4'b0001<<i);
			#1
			row = 4'b0001;
			
			// Check we're in the PRESSED state (col does not change)
			@(posedge clk);
			#1
			assert (col == (4'b0001<<i)) else $display(" col = %b (%b expected)", col, (4'b0001<<i));
			assert (pressed_row == row) else $display(" pressed_row = %b (%b expected)", pressed_row, row);
			
			// Check even if other key in row is pressed we do not leave scanning
			#1
			row = 4'b0101;
			
			@(posedge clk);
			#1
			assert (col == (4'b0001<<i)) else $display(" col = %b (%b expected)", col, (4'b0001<<i));
			assert (pressed_row == row) else $display(" pressed_row = %b (%b expected)", pressed_row, row);
			
			
			// Apply debounced and released
			@(negedge clk);
			#1
			row = 4'b0000;
			debounced = 1;
			
			@(posedge clk);
			#1 // Check we're in the SCANNED state
			assert (pressed_row == row) else $display(" pressed_row = %b (%b expected)", pressed_row, row);
			
			#1 
			debounced = 0;
		end
				
		
		$finish;
	end 

endmodule
