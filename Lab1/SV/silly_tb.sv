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
    
	#0   bits[7:0] = 8'b0000_0000;	
	#0   carryIn = 1'b0;
	#0	 correctBits = 5'b0_0000;
	#0	 Error = currentBits != correctBits;


	#20   bits[7:0] = 8'b0000_0001;	
	#0   carryIn = 1'b0;

	#20   bits[7:0] = 8'b0000_0010;	
	#0   carryIn = 1'b0;


	
     end

	initial
	 begin
		for (i=0; i < 128; i=i+1)
			begin
			// Put vectors before beginning of clk
			@(posedge clk)
				begin
					bits[7:4] = $random;
					bits[3:0] = $random;
					carryIn = $random;
				end
			@(negedge clk)
				begin
					$fdisplay(desc3, "%h %h || %h | %h | %b\n", bits[7:4], bits[3:0], currentBits, currentBits, (currentBits == currentBits));
				end
			end // @(negedge clk)
		end

   
endmodule
