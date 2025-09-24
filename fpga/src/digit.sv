/// Author: Erin Wang
/// Email: erinwang@g.hmc.edu
/// Date: 09/23/2025

// digit module takes a debounced row and debounced col input
// and uses a flop to give the most recent row/col pair to a 'right' assigned row and col
// and gives the last row/col pair to a 'left' assigned row and col

module digit(input	logic clk,
				 input	logic reset,
				 input  logic debounced,
				 input	logic [3:0] debouncedrow,
				 input	logic [3:0] debouncedcol,
				 output logic [3:0] rowleft, rowright, colleft, colright);
		
		typedef enum logic [1:0]  {NOUPDATE, UPDATE, FINISHEDUPDATE} statetype;
		statetype state, nextstate;
		
		logic [3:0] nextrowleft, nextrowright, nextcolleft, nextcolright;
		
		always_ff @(posedge clk) begin
			if (reset==0)	begin
				state <= NOUPDATE;
				rowleft <= 4'b0;
				rowright <= 4'b0;
				colleft <= 4'b0;
				colright <= 4'b0;
			end
			else			begin
				state <= nextstate;
				rowleft <= nextrowleft;
				rowright <= nextrowright;
				colleft <= nextcolleft;
				colright <= nextcolright;
			end
		end
		
		// next state logic
		always_comb
			case (state)
				NOUPDATE:	if (debounced)				begin
														nextstate = UPDATE;
														nextrowleft = rowleft;
														nextcolleft = colleft;
														nextrowright = rowright;
														nextcolright = colright;
														end
							else						begin
														nextstate = state;
														nextrowleft = rowleft;
														nextcolleft = colleft;
														nextrowright = rowright;
														nextcolright = colright;
														end
				UPDATE: 								begin
														nextstate = FINISHEDUPDATE;
														nextrowleft = rowright;
														nextcolleft = colright;
														nextrowright = debouncedrow;
														nextcolright = debouncedcol;
														end
				FINISHEDUPDATE: if (~debounced)			begin
														nextstate = NOUPDATE;
														nextrowleft = rowleft;
														nextcolleft = colleft;
														nextrowright = rowright;
														nextcolright = colright;
														end
								else					begin
														nextstate = state;
														nextrowleft = rowleft;
														nextcolleft = colleft;
														nextrowright = rowright;
														nextcolright = colright;
														end
					
				default:								begin
														nextstate = state;
														nextrowleft = rowleft;
														nextcolleft = colleft;
														nextrowright = rowright;
														nextcolright = colright;
														end
			endcase
endmodule