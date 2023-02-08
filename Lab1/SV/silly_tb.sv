`timescale 1ns / 1ps
module tb ();

   logic    [7:0]bits;
   logic 	carryIn;
   logic    clk;
   logic    [4:0]correctBits;
   logic	[4:0]currentBits;
   logic 	Error;
   integer desc3;
   integer handle3;
   integer i;
   
  // instantiate device under test
   sillyTest dut (carryIn, bits, currentBits);
 ////////////////////////////////////////////////////////////////////
   // 20 ns clock
   initial 
    	begin	
		clk = 1'b1;
		forever #10 clk = ~clk;
    end

	initial
	 begin
		handle3 = $fopen("rca.out");
		desc3 = handle3;
		#1250 $finish;
	 end




	initial
	 begin
		for (i=0; i < 150; i=i+1)
			begin
			// Put vectors before beginning of clk
			@(posedge clk)
				begin
					bits[7:4] = $random;
					bits[3:0] = $random;
					carryIn = $random;
					correctBits = bits[7:4] + bits[3:0] + carryIn;
				end
			@(negedge clk)
				begin
					$fdisplay(desc3, "%h %h %h || %h | %h | %b\n", bits[7:4], bits[3:0], carryIn, currentBits, correctBits, (currentBits == correctBits));
				end
			end // @(negedge clk)
		end

   
endmodule
