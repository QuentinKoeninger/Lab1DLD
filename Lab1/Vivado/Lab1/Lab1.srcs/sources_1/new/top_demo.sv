`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/15/2021 06:40:11 PM
// Design Name: 
// Module Name: top_demo
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module silly (input  logic a, b, cin, output logic y, cout);
   
  assign y = a ^ b ^ cin;
  assign cout = (a & b) | (a & cin) | (b & cin);
   
endmodule

module sillyTest (input logic cin, [7:0]userInput, output logic [4:0]out);

  logic [2:0]c;

  silly bit0 (userInput[4], userInput[0], cin, out[0], c[0]);

  silly bit1 (userInput[5], userInput[1], c[0], out[1], c[1]);

  silly bit2 (userInput[6], userInput[2], c[1], out[2], c[2]);

  silly bit3 (userInput[7], userInput[3], c[2], out[3], out[4]);

endmodule

module top_demo
(
  // input
  input  logic [7:0] sw,
  input  logic [3:0] btn,
  input  logic       sysclk_125mhz,
  input  logic       rst,
  // output  
  output logic [7:0] led,
  output logic sseg_ca,
  output logic sseg_cb,
  output logic sseg_cc,
  output logic sseg_cd,
  output logic sseg_ce,
  output logic sseg_cf,
  output logic sseg_cg,
  output logic sseg_dp,
  output logic [3:0] sseg_an
);

  logic [16:0] CURRENT_COUNT;
  logic [16:0] NEXT_COUNT;
  logic        smol_clk;
  logic [4:0] inst1out;
  logic [4:0] checkOut;
  
  // Place TicTacToe instantiation here
  sillyTest inst1 (btn[0], sw[7:0], inst1out[4:0]);
  assign checkOut[4:0] = sw[3:0] + sw[7:4] + btn[0];
  
  // 7-segment display
  segment_driver driver(
  .clk(smol_clk),
  .rst(btn[3]),
  .digit0(inst1out[3:0]),
  .digit1(inst1out[4]),
  .digit2(checkOut[3:0]),
  .digit3(checkOut[4]),
  .decimals({1'b0, btn[2:0]}),
  .segment_cathodes({sseg_dp, sseg_cg, sseg_cf, sseg_ce, sseg_cd, sseg_cc, sseg_cb, sseg_ca}),
  .digit_anodes(sseg_an)
  );

// Register logic storing clock counts
  always@(posedge sysclk_125mhz)
  begin
    if(btn[3])
      CURRENT_COUNT = 17'h00000;
    else
      CURRENT_COUNT = NEXT_COUNT;
  end
  
  // Increment logic
  assign NEXT_COUNT = CURRENT_COUNT == 17'd100000 ? 17'h00000 : CURRENT_COUNT + 1;

  // Creation of smaller clock signal from counters
  assign smol_clk = CURRENT_COUNT == 17'd100000 ? 1'b1 : 1'b0;

endmodule
