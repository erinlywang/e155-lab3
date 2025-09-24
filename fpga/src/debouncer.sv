/// Author: Erin Wang
/// Email: erinwang@g.hmc.edu
/// Date: 09/23/2025

// debouncer module takes a synchronized row and synchronized column input from a 4x4 keypad
// and outputs when the pressed key has been debounced
// and outputs the row and column of the debounced key

module debouncer(input	logic clk,
				 input	logic reset,
				 input	logic [3:0] row,
				 input	logic [3:0] col,
				 output logic [3:0] debouncedrow, debouncedcol,
				 output logic debounced);
	
	typedef enum logic [2:0]  {S0, S1, S2} statetype;
	statetype state, nextstate;
	
	logic [23:0] nextcounter, counter;
	
	logic [3:0] last_pressed_row, last_pressed_col, pressed_row, pressed_col;
	logic pressed, rowcheck, released;
				 
	always_ff @(posedge clk) begin
		if (reset==0)	begin
			state <= S0;
			counter <= 24'b0;
			last_pressed_row <= 4'b0;
			last_pressed_col <= 4'b0;
		end
		else			begin
			state <= nextstate;
			counter <= nextcounter;
			last_pressed_row <= pressed_row;
			last_pressed_col <= pressed_col;
			
		end
	end
	
	// next state logic
	always_comb
		case (state)
			S0:	if (pressed)				begin
											nextstate = S1;
											nextcounter = 24'b0;
											pressed_row = row;
											pressed_col = col;
											end
				else						begin
											nextstate = state;
											nextcounter = 24'b0;
											pressed_row = row;
											pressed_col = col;
											end
			S1: if (debounced)				begin
											nextstate = S2;
											nextcounter = counter;
											pressed_row = last_pressed_row;
											pressed_col = last_pressed_col;
											end
				else						begin
											nextstate = state;
											nextcounter = counter + 24'b1;
											pressed_row = last_pressed_row;
											pressed_col = last_pressed_col;
											end
			S2:	if (released) 				begin
											nextstate = S0;
											nextcounter = 24'b0;
											pressed_row = last_pressed_row;
											pressed_col = last_pressed_col;
											end
				else						begin
											nextstate = state;
											nextcounter = counter;
											pressed_row = last_pressed_row;
											pressed_col = last_pressed_col;
											end
			default:						begin
											nextstate = S0;
											nextcounter = 24'b0;
											pressed_row = 24'b0;
											pressed_col = 24'b0;
											end
		endcase
	
	// output state logic
	assign debounced = (counter >= 24'd500000);
	assign pressed = |row;
	assign rowcheck = ((row & pressed_row) == last_pressed_row);
	assign released = (debounced & (~rowcheck));
	assign debouncedrow = pressed_row;
	assign debouncedcol = pressed_col;

endmodule
	