`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/20/2024 01:29:24 AM
// Design Name: 
// Module Name: write_back
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


module write_back(
    input [31:0] mem_data, reg_data,
    input mem_to_reg,
    output logic [31:0] write_out
 );
    assign write_out = mem_to_reg ? mem_data : reg_data;
endmodule
