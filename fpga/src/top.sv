/// Author: Erin Wang
/// Email: erinwang@g.hmc.edu
/// Date: 09/23/2025

// top module takes input from a 4x4 keypad
// and outputs the most recent input on the right side of a dual common-anode 7-segment display,
// and outputs the last input on the left side of the same dual common-anode 7-segment display,
// If a key is held, it does not register any other key presses

module top( input	logic reset,
			input	logic [3:0] row,
			output	logic [3:0] col,
			output	logic [6:0] seg,
			output	logic  trans0, 
			output	logic  trans1,
			output	logic  led0);
			
	logic int_osc;
	logic [3:0] s;
	logic [3:0] sync_row, async_col;
	logic [3:0] pressed_row, debouncedrow, debouncedcol;
	logic [3:0] rowleft, rowright, colleft, colright;
	logic [3:0] right_switch, left_switch;
	logic debounced, released;
	logic counter_output;
	assign led0 = debounced;
		
	// Internal high-speed oscillator
	HSOSC #(.CLKHF_DIV(2'b01))
		  hf_osc (.CLKHFPU(1'b1), .CLKHFEN(1'b1), .CLKHF(int_osc));
	
	// Synchronize col and row
	synchronizer syncrow(int_osc, reset, row, sync_row);
	synchronizer synccol(int_osc, reset, async_col, col);
  
	// logic for checking if button is pressed
	scanner scan(int_osc, reset, debounced, sync_row, async_col, pressed_row);
	
	// logic for debouncing input from button press
	debouncer db(int_osc, reset, pressed_row, col, debouncedrow, debouncedcol, debounced);
	
	digit dg(int_osc, reset, debounced, debouncedrow, debouncedcol, rowleft, rowright, colleft, colright);
	
	// logic for decoding the switch for each digit
	keypad kpleft(reset, rowleft, colleft, left_switch);
	keypad kpright(reset, rowright, colright, right_switch);
			
	// logic for selecting input into sevseg and which segment to turn on

	mpx mpx(int_osc, reset, left_switch, right_switch, s, trans0, trans1);

	// logic for what digit to display	
	sevseg sevseg(s, seg);
endmodule
	