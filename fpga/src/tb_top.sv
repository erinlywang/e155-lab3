/// Author: Erin Wang
/// Email: erinwang@g.hmc.edu
/// Date: 09/23/2025

// tb_top module tests the top module 
// It applies inputs to top module and checks if outputs are as expected through assert statements 

// Modelsim-ASE requires a timescale directive
`timescale 1 ns / 1 ns

module tb_top(); 
    logic   clk, reset; 
    
    logic   [3:0] row;
	logic	[3:0] col;                 // output
    logic   [6:0] seg;   // output
	logic	trans0, trans1; //output
	logic	led0;


	//// Instantiate device under test (DUT). 
	// Inputs: s Outputs: led, seg
	top dut(reset, row, col, seg, trans0, trans1, led0); 

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
		
		#1000 // wait for HSOSC to fire
		
		// CHECK KEY 1
		$display("Checking Key 1");
		wait(col==4'b0001);
		#1
		row = 4'b0001;
		
		wait(led0==1'b1); // debounced
		@(posedge trans0); // mpx counter_output hits high	
		// Check 
		@(posedge clk);
		#1
		assert (seg == 7'b1111001) else $display(" seg = %b (%b expected)", seg, 7'b1111001);
			
		// Check even if other key in row is pressed we do not leave scanning
		$display("Checking when pressing other key");
		#1
		row = 4'b0101;
			
		@(posedge clk);
		#1
		assert (seg == 7'b1111001) else $display(" seg = %b (%b expected)", seg, 7'b1111001);
			
		// Release key and segment should not change
		#1
		row = 4'b0000;
		
		@(posedge clk);
		$display("Checking key release");
		#1
		assert (seg == 7'b1111001) else $display(" seg = %b (%b expected)", seg, 7'b1111001);
		
		
		// CHECK KEY 2
		$display("Checking Key 2");
		wait(col==4'b0010);
		#1
		row = 4'b0001;
		
		wait(led0==1'b1); // debounced
		@(posedge trans0); // mpx counter_output hits high	
		// Check 
		@(posedge clk);
		#1
		assert (seg == 7'b0100100) else $display(" seg = %b (%b expected)", seg, 7'b0100100);
			
		// Check even if other key in row is pressed we do not leave scanning
		$display("Checking when pressing other key");
		#1
		row = 4'b0101;
			
		@(posedge clk);
		#1
		assert (seg == 7'b0100100) else $display(" seg = %b (%b expected)", seg, 7'b0100100);
			
		// Release key and segment should not change
		#1
		row = 4'b0000;
		
		@(posedge clk);
		$display("Checking key release");
		#1
		assert (seg == 7'b0100100) else $display(" seg = %b (%b expected)", seg, 7'b0100100);
		
		// CHECK KEY 3
		$display("Checking Key 3");
		wait(col==4'b0100);
		#1
		row = 4'b0001;
		
		wait(led0==1'b1); // debounced
		@(posedge trans0); // mpx counter_output hits high	
		// Check 
		@(posedge clk);
		#1
		assert (seg == 7'b0110000) else $display(" seg = %b (%b expected)", seg, 7'b0110000);
			
		// Check even if other key in row is pressed we do not leave scanning
		$display("Checking when pressing other key");
		#1
		row = 4'b0101;
			
		@(posedge clk);
		#1
		assert (seg == 7'b0110000) else $display(" seg = %b (%b expected)", seg, 7'b0110000);
			
		// Release key and segment should not change
		#1
		row = 4'b0000;
		
		@(posedge clk);
		$display("Checking key release");
		#1
		assert (seg == 7'b0110000) else $display(" seg = %b (%b expected)", seg, 7'b0110000);		
		
		// CHECK KEY A
		$display("Checking Key A");
		wait(col==4'b1000);
		#1
		row = 4'b0001;
		
		wait(led0==1'b1); // debounced
		@(posedge trans0); // mpx counter_output hits high	
		// Check 
		@(posedge clk);
		#1
		assert (seg == 7'b0001000) else $display(" seg = %b (%b expected)", seg, 7'b0001000);
			
		// Check even if other key in row is pressed we do not leave scanning
		$display("Checking when pressing other key");
		#1
		row = 4'b0101;
			
		@(posedge clk);
		#1
		assert (seg == 7'b0001000) else $display(" seg = %b (%b expected)", seg, 7'b0001000);
			
		// Release key and segment should not change
		#1
		row = 4'b0000;
		
		@(posedge clk);
		$display("Checking key release");
		#1
		assert (seg == 7'b0001000) else $display(" seg = %b (%b expected)", seg, 7'b0001000);
			
			
		// CHECK KEY 4
		$display("Checking Key 4");
		wait(col==4'b0001);
		#1
		row = 4'b0010;
		
		wait(led0==1'b1); // debounced
		@(posedge trans0); // mpx counter_output hits high	
		// Check 
		@(posedge clk);
		#1
		assert (seg == 7'b0011001) else $display(" seg = %b (%b expected)", seg, 7'b0011001);
			
		// Check even if other key in row is pressed we do not leave scanning
		$display("Checking when pressing other key");
		#1
		row = 4'b0101;
			
		@(posedge clk);
		#1
		assert (seg == 7'b0011001) else $display(" seg = %b (%b expected)", seg, 7'b0011001);
			
		// Release key and segment should not change
		#1
		row = 4'b0000;
		
		@(posedge clk);
		$display("Checking key release");
		#1
		assert (seg == 7'b0011001) else $display(" seg = %b (%b expected)", seg, 7'b0011001);
		
		
		// CHECK KEY 5
		$display("Checking Key 5");
		wait(col==4'b0010);
		#1
		row = 4'b0010;
		
		wait(led0==1'b1); // debounced
		@(posedge trans0); // mpx counter_output hits high	
		// Check 
		@(posedge clk);
		#1
		assert (seg == 7'b0010010) else $display(" seg = %b (%b expected)", seg, 7'b0010010);
			
		// Check even if other key in row is pressed we do not leave scanning
		$display("Checking when pressing other key");
		#1
		row = 4'b0101;
			
		@(posedge clk);
		#1
		assert (seg == 7'b0010010) else $display(" seg = %b (%b expected)", seg, 7'b0010010);
			
		// Release key and segment should not change
		#1
		row = 4'b0000;
		
		@(posedge clk);
		$display("Checking key release");
		#1
		assert (seg == 7'b0010010) else $display(" seg = %b (%b expected)", seg, 7'b0010010);
		
		// CHECK KEY 6
		$display("Checking Key 6");
		wait(col==4'b0100);
		#1
		row = 4'b0010;
		
		wait(led0==1'b1); // debounced
		@(posedge trans0); // mpx counter_output hits high	
		// Check 
		@(posedge clk);
		#1
		assert (seg == 7'b0000010) else $display(" seg = %b (%b expected)", seg, 7'b0000010);
			
		// Check even if other key in row is pressed we do not leave scanning
		$display("Checking when pressing other key");
		#1
		row = 4'b0101;
			
		@(posedge clk);
		#1
		assert (seg == 7'b0000010) else $display(" seg = %b (%b expected)", seg, 7'b0000010);
			
		// Release key and segment should not change
		#1
		row = 4'b0000;
		
		@(posedge clk);
		$display("Checking key release");
		#1
		assert (seg == 7'b0000010) else $display(" seg = %b (%b expected)", seg, 7'b0000010);		
		
		// CHECK KEY B
		$display("Checking Key B");
		wait(col==4'b1000);
		#1
		row = 4'b0010;
		
		wait(led0==1'b1); // debounced
		@(posedge trans0); // mpx counter_output hits high	
		// Check 
		@(posedge clk);
		#1
		assert (seg == 7'b0000011) else $display(" seg = %b (%b expected)", seg, 7'b0000011);
			
		// Check even if other key in row is pressed we do not leave scanning
		$display("Checking when pressing other key");
		#1
		row = 4'b0101;
			
		@(posedge clk);
		#1
		assert (seg == 7'b0000011) else $display(" seg = %b (%b expected)", seg, 7'b0000011);
			
		// Release key and segment should not change
		#1
		row = 4'b0000;
		
		@(posedge clk);
		$display("Checking key release");
		#1
		assert (seg == 7'b0000011) else $display(" seg = %b (%b expected)", seg, 7'b0000011);	

		
		
		// CHECK KEY 7
		$display("Checking Key 7");
		wait(col==4'b0001);
		#1
		row = 4'b0100;
		
		wait(led0==1'b1); // debounced
		@(posedge trans0); // mpx counter_output hits high	
		// Check 
		@(posedge clk);
		#1
		assert (seg == 7'b1111000) else $display(" seg = %b (%b expected)", seg, 7'b1111000);
			
		// Check even if other key in row is pressed we do not leave scanning
		$display("Checking when pressing other key");
		#1
		row = 4'b0101;
			
		@(posedge clk);
		#1
		assert (seg == 7'b1111000) else $display(" seg = %b (%b expected)", seg, 7'b1111000);
			
		// Release key and segment should not change
		#1
		row = 4'b0000;
		
		@(posedge clk);
		$display("Checking key release");
		#1
		assert (seg == 7'b1111000) else $display(" seg = %b (%b expected)", seg, 7'b1111000);
		
		
		// CHECK KEY 8
		$display("Checking Key 8");
		wait(col==4'b0010);
		#1
		row = 4'b0100;
		
		wait(led0==1'b1); // debounced
		@(posedge trans0); // mpx counter_output hits high	
		// Check 
		@(posedge clk);
		#1
		assert (seg == 7'b0000000) else $display(" seg = %b (%b expected)", seg, 7'b0000000);
			
		// Check even if other key in row is pressed we do not leave scanning
		$display("Checking when pressing other key");
		#1
		row = 4'b0101;
			
		@(posedge clk);
		#1
		assert (seg == 7'b0000000) else $display(" seg = %b (%b expected)", seg, 7'b0000000);
			
		// Release key and segment should not change
		#1
		row = 4'b0000;
		
		@(posedge clk);
		$display("Checking key release");
		#1
		assert (seg == 7'b0000000) else $display(" seg = %b (%b expected)", seg, 7'b0000000);
		
		// CHECK KEY 9
		$display("Checking Key 9");
		wait(col==4'b0100);
		#1
		row = 4'b0100;
		
		wait(led0==1'b1); // debounced
		@(posedge trans0); // mpx counter_output hits high	
		// Check 
		@(posedge clk);
		#1
		assert (seg == 7'b0011000) else $display(" seg = %b (%b expected)", seg, 7'b0011000);
			
		// Check even if other key in row is pressed we do not leave scanning
		$display("Checking when pressing other key");
		#1
		row = 4'b0101;
			
		@(posedge clk);
		#1
		assert (seg == 7'b0011000) else $display(" seg = %b (%b expected)", seg, 7'b0011000);
			
		// Release key and segment should not change
		#1
		row = 4'b0000;
		
		@(posedge clk);
		$display("Checking key release");
		#1
		assert (seg == 7'b0011000) else $display(" seg = %b (%b expected)", seg, 7'b0011000);		
		
		// CHECK KEY C
		$display("Checking Key c");
		wait(col==4'b1000);
		#1
		row = 4'b0100;
		
		wait(led0==1'b1); // debounced
		@(posedge trans0); // mpx counter_output hits high	
		// Check 
		@(posedge clk);
		#1
		assert (seg == 7'b1000110) else $display(" seg = %b (%b expected)", seg, 7'b1000110);
			
		// Check even if other key in row is pressed we do not leave scanning
		$display("Checking when pressing other key");
		#1
		row = 4'b0101;
			
		@(posedge clk);
		#1
		assert (seg == 7'b1000110) else $display(" seg = %b (%b expected)", seg, 7'b1000110);
			
		// Release key and segment should not change
		#1
		row = 4'b0000;
		
		@(posedge clk);
		$display("Checking key release");
		#1
		assert (seg == 7'b1000110) else $display(" seg = %b (%b expected)", seg, 7'b1000110);	
		
		
		// CHECK KEY E
		$display("Checking Key E");
		wait(col==4'b0001);
		#1
		row = 4'b1000;
		
		wait(led0==1'b1); // debounced
		@(posedge trans0); // mpx counter_output hits high	
		// Check 
		@(posedge clk);
		#1
		assert (seg == 7'b0000110) else $display(" seg = %b (%b expected)", seg, 7'b0000110);
			
		// Check even if other key in row is pressed we do not leave scanning
		$display("Checking when pressing other key");
		#1
		row = 4'b0101;
			
		@(posedge clk);
		#1
		assert (seg == 7'b0000110) else $display(" seg = %b (%b expected)", seg, 7'b0000110);
			
		// Release key and segment should not change
		#1
		row = 4'b0000;
		
		@(posedge clk);
		$display("Checking key release");
		#1
		assert (seg == 7'b0000110) else $display(" seg = %b (%b expected)", seg, 7'b0000110);
		
		
		// CHECK KEY 0
		$display("Checking Key 0");
		wait(col==4'b0010);
		#1
		row = 4'b1000;
		
		wait(led0==1'b1); // debounced
		@(posedge trans0); // mpx counter_output hits high	
		// Check 
		@(posedge clk);
		#1
		assert (seg == 7'b1000000) else $display(" seg = %b (%b expected)", seg, 7'b1000000);
			
		// Check even if other key in row is pressed we do not leave scanning
		$display("Checking when pressing other key");
		#1
		row = 4'b0101;
			
		@(posedge clk);
		#1
		assert (seg == 7'b1000000) else $display(" seg = %b (%b expected)", seg, 7'b1000000);
			
		// Release key and segment should not change
		#1
		row = 4'b0000;
		
		@(posedge clk);
		$display("Checking key release");
		#1
		assert (seg == 7'b1000000) else $display(" seg = %b (%b expected)", seg, 7'b1000000);
		
		// CHECK KEY F
		$display("Checking Key F");
		wait(col==4'b0100);
		#1
		row = 4'b1000;
		
		wait(led0==1'b1); // debounced
		@(posedge trans0); // mpx counter_output hits high	
		// Check 
		@(posedge clk);
		#1
		assert (seg == 7'b0001110) else $display(" seg = %b (%b expected)", seg, 7'b0001110);
			
		// Check even if other key in row is pressed we do not leave scanning
		$display("Checking when pressing other key");
		#1
		row = 4'b0101;
			
		@(posedge clk);
		#1
		assert (seg == 7'b0001110) else $display(" seg = %b (%b expected)", seg, 7'b0001110);
			
		// Release key and segment should not change
		#1
		row = 4'b0000;
		
		@(posedge clk);
		$display("Checking key release");
		#1
		assert (seg == 7'b0001110) else $display(" seg = %b (%b expected)", seg, 7'b0001110);		
		
		// CHECK KEY D
		$display("Checking Key D");
		wait(col==4'b1000);
		#1
		row = 4'b1000;
		
		wait(led0==1'b1); // debounced
		@(posedge trans0); // mpx counter_output hits high	
		// Check 
		@(posedge clk);
		#1
		assert (seg == 7'b0100001) else $display(" seg = %b (%b expected)", seg, 7'b0100001);
			
		// Check even if other key in row is pressed we do not leave scanning
		$display("Checking when pressing other key");
		#1
		row = 4'b0101;
			
		@(posedge clk);
		#1
		assert (seg == 7'b0100001) else $display(" seg = %b (%b expected)", seg, 7'b0100001);
			
		// Release key and segment should not change
		#1
		row = 4'b0000;
		
		@(posedge clk);
		$display("Checking key release");
		#1
		assert (seg == 7'b0100001) else $display(" seg = %b (%b expected)", seg, 7'b0100001);	
			
		$finish;
	end 

endmodule
