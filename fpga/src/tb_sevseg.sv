/// Author: Erin Wang
/// Email: erinwang@g.hmc.edu
/// Date: 09/09/2025

// tb_sevseg module tests the sevensegment module 
// It applies inputs to sevensegment module and checks if outputs are as expected. 
// User provides patterns of inputs & desired outputs called testvectors. 

module tb_sevseg(); 
    logic   clk, reset; 
    
    logic   [3:0] s;                 // input
    logic   [6:0] seg, segexpected;  // output
    
    logic [31:0] vectornum, errors; 
    logic [10:0]  testvectors[10000:0]; 

	//// Instantiate device under test (DUT). 
	// Inputs: s Outputs: seg
	sevseg dut(s, seg); 

	//// Generate clock. 
	always begin 
		clk=1; #5;  
		clk=0; #5; 
	end 

	//// Start of test.  
	initial begin 
		$readmemb("./sevseg.tv", testvectors); 
		vectornum=0;  
		errors=0; 
		//// Pulse reset for 22 time units(2.2 cycles) so the reset signal falls after a clk edge. 
		reset=1; #22;  
		reset=0; 
	end 

	//// Apply test vectors on rising edge of clk. 
	always @(posedge clk) begin 
		#1; 
		{s, segexpected} = testvectors[vectornum]; 
	end


	//// Check results on falling edge of clk. 
	always @(negedge clk) 
		if (~reset) begin 
			if (seg !== segexpected) begin 
				$display("Error: inputs = %b", {s}); 
				$display(" outputs = %b (%b expected)", seg, segexpected); 
				errors = errors + 1; 
			end 
			vectornum = vectornum + 1; 
			if (testvectors[vectornum] === 11'bx) begin 
				$display("%d tests completed with %d errors", vectornum, errors); 
				$stop; 
			end 
		end 
endmodule