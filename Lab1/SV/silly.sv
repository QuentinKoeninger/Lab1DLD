module silly (input  logic a, b, cin, output logic y, cout);
   
  assign y = a ^ b ^ cin;
  assign cout = (a & b) | (a & cin) | (b & cin);
   
endmodule

// Top-level module
module sillyTest (input logic cin, [7:0]userInput, output logic [4:0]out);

  logic [2:0]c;

  silly bit0 (userInput[4], userInput[0], cin, out[0], c[0]);

  silly bit1 (userInput[5], userInput[1], c[0], out[1], c[1]);

  silly bit2 (userInput[6], userInput[2], c[1], out[2], c[2]);

  silly bit3 (userInput[4], userInput[0], c[2], out[3], out[4]);

endmodule

  
