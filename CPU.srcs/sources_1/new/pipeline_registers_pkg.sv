`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/16/2024 01:44:14 PM
// Design Name: 
// Module Name: pipeline_registers
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


package pipeline_registers_pkg;
    logic [31:0] test;
    
    
// ********************************
// *       Fetch -> Decode         *
// ********************************
logic [31:0] if_id_instruction;

// ********************************
// *       Decode -> Execute      *
// ********************************

logic id_ex_branch, id_ex_mem_read, id_ex_mem_to_reg;
// ALUSrc -> is_operand_imm
logic id_ex_mem_write, id_ex_is_operand_imm;
logic id_ex_reg_write;

logic [31:0] id_ex_signed_imm, id_ex_reg_read_data_one, id_ex_reg_read_data_two;
logic [3:0] id_ex_alu_op;
logic [4:0] id_ex_rs1, id_ex_rs2, id_ex_rd;

// ********************************
// *   Execute -> Memory Access   *
// ********************************
logic [4:0] ex_mem_rd;
logic ex_mem_mem_to_reg;
logic ex_mem_branch, ex_mem_mem_read, ex_mem_mem_write;
logic ex_mem_reg_write;
logic [31:0] ex_mem_alu_result, ex_mem_reg_read_data_two;



// ********************************
// *   Memory Access -> Writeback *
// ********************************
logic [4:0] mem_wb_rd;
logic mem_wb_reg_write, mem_wb_mem_to_reg;
logic [31:0] mem_wb_read_data, mem_wb_alu_result;

// ********************************
// *           Writeback          *
// ********************************
logic [31:0] wb_reg_write_data;

endpackage
