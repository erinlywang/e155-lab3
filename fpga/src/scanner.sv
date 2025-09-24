/// Author: Erin Wang
/// Email: erinwang@g.hmc.edu
/// Date: 09/23/2025

// scanner module takes a synchronized row input from a 4x4 keypad
// and outputs an asynchronized column output to send to the 4x4 keypad,
// and outputs what row has been pressed;

module scanner(input	logic clk,
			   input	logic reset,
			   input	logic debounced,
			   input	logic [3:0] row,
			   output	logic [3:0] col,
			   output	logic [3:0] pressed_row);
	
	typedef enum logic [3:0]  {SCANNED0, SCANNED1, SCANNED2, SCANNED3, PRESSED0, PRESSED1, PRESSED2, PRESSED3} statetype;
	statetype state, nextstate;

	logic pressed, scanrelease;
	assign pressed = |row;
	assign scanrelease = (debounced & (~pressed));
				 
	always_ff @(posedge clk) begin
		if (reset==0)		 begin
			state <= SCANNED0;
		end
		else				begin
			state <= nextstate;
		end
	end
	
	// next state 
	always_comb
		case (state)
			SCANNED0:	if (pressed)		nextstate = PRESSED0;
						else				nextstate = SCANNED1;
			SCANNED1: 	if (pressed)		nextstate = PRESSED1;
						else				nextstate = SCANNED2;
			SCANNED2: 	if (pressed)		nextstate = PRESSED2;
						else				nextstate = SCANNED3;
			SCANNED3:	if (pressed)		nextstate = PRESSED3;
						else				nextstate = SCANNED0;
			PRESSED0:	if	(scanrelease)		nextstate = SCANNED0;
						else				nextstate = state;
			PRESSED1:	if	(scanrelease)		nextstate = SCANNED0;
						else				nextstate = state;
			PRESSED2:	if	(scanrelease)		nextstate = SCANNED0;
						else				nextstate = state;
			PRESSED3:	if	(scanrelease)		nextstate = SCANNED0;
						else				nextstate = state;
			default:						nextstate = SCANNED0;
		endcase
	
	// output state logic
	always_comb
		case (state)
			SCANNED0:			begin
									col = 4'b0001;
									pressed_row = row;
								end
			SCANNED1:			begin
									col = 4'b0010;
									pressed_row = row;
								end
			SCANNED2:			begin
									col = 4'b0100;
									pressed_row = row;
								end
			SCANNED3:			begin
									col = 4'b1000;
									pressed_row = row;
								end
			PRESSED0:			begin
									col = 4'b0001;
									pressed_row = row;
								end
			PRESSED1:			begin
									col = 4'b0010;
									pressed_row = row;
								end
			PRESSED2:			begin
									col = 4'b0100;
									pressed_row = row;
								end
			PRESSED3:			begin
									col = 4'b1000;
									pressed_row = row;
								end
			default:			begin
									col = 4'b0000;
									pressed_row = 4'b0000;
								end
		endcase

endmodule
	