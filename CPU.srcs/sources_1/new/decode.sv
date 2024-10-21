`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/30/2024 11:43:08 AM
// Design Name: 
// Module Name: decode
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

// ALUSrc -> is_operand_imm
module decode(
    input clk,
    input [31:0] instruction,
    output logic [4:0] rs1, rs2, rd,
    output logic [31:0] reg_data_one, reg_data_two,
    output logic signed [31:0] signed_imm,
    output logic [15:0] alu_op,
    output logic branch, mem_read, mem_to_reg, mem_write, is_operand_imm, reg_write, clk_out
    );
endmodule
