/// Author: Erin Wang
/// Email: erinwang@g.hmc.edu
/// Date: 09/13/2025

// keypad module takes row and column input from a keypad
// and outputs the corresponding 4-bit binary to the hexadecimal digit

module keypad(input		logic reset,
			  input		logic [3:0] row,
			  input		logic [3:0] col,
			  output	logic [3:0] key);
			  
			 
	always_comb begin
		if (row[0] & col[0]) 		key = 4'b0001;		// 1
		else if (row[0] & col[1])	key = 4'b0010;		// 2
		else if (row[0] & col[2])	key = 4'b0011;		// 3
		else if (row[0] & col[3])	key = 4'b1010;		// A
		else if (row[1] & col[0])	key = 4'b0100;		// 4
		else if (row[1] & col[1])	key = 4'b0101;		// 5
		else if (row[1] & col[2])	key = 4'b0110;		// 6
		else if (row[1] & col[3])	key = 4'b1011;		// B
		else if (row[2] & col[0])	key = 4'b0111;		// 7
		else if (row[2] & col[1])	key = 4'b1000;		// 8
		else if (row[2] & col[2])	key = 4'b1001;		// 9
		else if (row[2] & col[3])	key = 4'b1100;		// C
		else if (row[3] & col[0])	key = 4'b1110;		// E (*)
		else if (row[3] & col[1])	key = 4'b0000;		// 0
		else if (row[3] & col[2])	key = 4'b1111;		// F (#)
		else if (row[3] & col[3])	key = 4'b1101;		// D
		else						key = 4'b0000;
	end

endmodule