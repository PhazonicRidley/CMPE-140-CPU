`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/30/2024 11:43:08 AM
// Design Name: 
// Module Name: alu
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

// TODO: Branch flags, ALU is responsible for comparison!
module alu(
    input logic [31:0] data_one, data_two,
    input logic [3:0] alu_op,
    output logic [31:0] result
);

always_comb begin
    if(alu_op == 4'b0) begin
        result = data_one + data_two; //alu result (for addi only for now)
    end
end    
endmodule
