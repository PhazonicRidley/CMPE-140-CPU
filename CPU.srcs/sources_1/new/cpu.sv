`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/30/2024 11:43:08 AM
// Design Name: 
// Module Name: cpu
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


module cpu(
    input rst_n, clk,
    output logic [31:0] imem_addr,
    input [31:0] imem_insn,
    output logic [31:0] dmem_addr,
    inout logic [31:0] dmem_data,
    output logic dmem_wen // 1 = W, 0 = R
);
 
always @ (negedge rst_n) begin
    imem_addr = 0;
    dmem_addr = 0;
    dmem_wen = 0;
end

// Program Counter Register
// TODO: Propagate PC state to MEM stage for jumping.
logic [31:0] pc = 0;

// ********************************
// *            Fetch             *
// ********************************

logic if_id_out_clk;
logic [31:1] if_id_instruction;

fetch f(clk, pc, imem_insn, pc, imem_addr, if_id_instruction, if_id_out_clk);

// ********************************
// *            Decode            *
// ********************************
logic [31:0] d_instruction;
logic [4:0] d_rs1, d_rs2, d_rd;

logic id_ex_out_clk, id_ex_reg_write;
// TODO: Why does it say to extend imm up to 64 bits for a 32 bit CPU?

logic [31:0] id_ex_signed_imm, 
    id_ex_reg_read_data_one, id_ex_reg_read_data_two;

// control signals
// Ensure that mem_read and/or mem_write are ONLY set when theres a valid memory address.
// MemToReg -> is_data_mem
logic id_ex_branch, id_ex_mem_read, id_ex_is_data_mem;

// ALUSrc -> is_operand_imm
logic id_ex_mem_write, id_ex_is_operand_imm;
logic [3:0] id_ex_alu_op;

decode d(if_id_out_clk, d_instruction, d_rs1, d_rs2, d_rd, 
         id_ex_reg_read_data_one, id_ex_reg_read_data_two, 
         id_ex_signed_imm, id_ex_alu_op, 
         id_ex_branch, id_ex_mem_read, id_ex_is_data_mem, id_ex_mem_write, 
         id_ex_is_operand_imm, id_ex_reg_write, id_ex_out_clk);

logic [4:0] id_ex_rs1, id_ex_rs2, id_ex_rd;

// Happens with decode
always @ (posedge if_id_out_clk) begin
    d_instruction = if_id_instruction;

    id_ex_rs1 = d_rs1;
    id_ex_rs2 = d_rs2;
    id_ex_rd = d_rd;
end

// Propagate control signals maybe clean this up?


// ********************************
// *            Execute           *
// ********************************

// TODO: forwarding unit

logic ex_mem_out_clk, ex_mem_is_data_mem;
logic ex_mem_branch, ex_mem_mem_read, ex_mem_mem_write;
logic [4:0] ex_mem_rd;
logic [31:0] ex_mem_alu_result, 
    ex_mem_reg_read_data_one, ex_mem_reg_read_data_two;
logic ex_mem_reg_write;

// Propagate control signals maybe clean this up?
always @ (posedge id_ex_out_clk) begin
    ex_mem_mem_read = id_ex_mem_read;
    ex_mem_mem_write = id_ex_mem_write;
    ex_mem_branch = id_ex_branch;
    ex_mem_is_data_mem = id_ex_is_data_mem;

    ex_mem_rd = id_ex_rd;

    ex_mem_reg_read_data_one = id_ex_reg_read_data_one;
    ex_mem_reg_read_data_two = id_ex_reg_read_data_two;
    ex_mem_reg_write = id_ex_reg_write;
end

wire [31:0] alu_second_src;
// alu second src mux
assign alu_second_src = id_ex_is_operand_imm ? id_ex_signed_imm : id_ex_reg_read_data_two;
alu a(id_ex_out_clk, reg_read_data_one, 
      id_ex_alu_op, alu_second_src, 
      ex_mem_alu_result, ex_mem_out_clk);

// ********************************
// *        Memory Access         *
// ********************************
// MemToReg -> is_data_mem
logic [4:0] mem_wb_rd;
logic [31:0] mem_wb_read_data, mem_wb_alu_result;
logic mem_wb_out_clk, mem_wb_reg_write, mem_wb_is_data_mem, mem_wb_reg_write;
mem_access m(ex_mem_out_clk, ex_mem_mem_read, 
             ex_mem_mem_write, ex_mem_alu_result, ex_mem_reg_read_data_two,
             dmem_data, mem_wb_read_data,
             dmem_data, dmem_addr, 
             dmem_wen, mem_wb_out_clk);

always @ (posedge ex_mem_out_clk) begin
    mem_wb_rd = ex_mem_rd;
    mem_wb_alu_result = ex_mem_alu_result;
    mem_wb_is_data_mem = ex_mem_is_data_mem;
    mem_wb_reg_write = ex_mem_reg_write;
end

// ********************************
// *           Writeback          *
// ********************************

wire [31:0] wb_data;
assign wb_data = is_data_mem ? mem_wb_read_data : mem_wb_alu_result;
logic [31:0] reg_write_data;
write_back wb(mem_wb_out_clk, 
              wb_data, mem_wb_rd, 
              reg_write_data, mem_wb_reg_write);


// ********************************
// *           Registers          *
// ********************************

registers rf(mem_wb_reg_write, 
             d_rs1, d_rs2, mem_wb_rd, 
             reg_write_data, 
             id_ex_reg_read_data_one, 
             id_ex_reg_read_data_two);

endmodule
