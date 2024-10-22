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

logic [31:0] f_instruction;
fetch f(pc, imem_insn, pc, imem_addr, f_instruction);

logic [31:0] if_id_instruction;
always @ (posedge clk) begin
    // TODO: reset and write enable
    if_id_instruction <= f_instruction;
end

// ********************************
// *            Decode            *
// ********************************
logic [4:0] d_rs1, d_rs2, d_rd;

// TODO: Why does it say to extend imm up to 64 bits for a 32 bit CPU?
logic [31:0] d_signed_imm, d_reg_read_data_one, d_reg_read_data_two;
logic d_branch, d_mem_read, d_mem_write, 
    d_mem_to_reg, d_is_operand_imm, d_reg_write;
logic [3:0] d_alu_op;
// Ensure that mem_read and/or mem_write are ONLY set when theres a valid memory address.
decode d(if_id_instruction, d_rs1, d_rs2, d_rd, 
         d_signed_imm, d_alu_op,
         d_branch, d_mem_read, d_mem_to_reg, d_mem_write, 
         d_is_operand_imm, d_reg_write);

logic id_ex_branch, id_ex_mem_read, id_ex_mem_to_reg;
// ALUSrc -> is_operand_imm
logic id_ex_mem_write, id_ex_is_operand_imm;
logic id_ex_reg_write;

logic [31:0] id_ex_signed_imm, id_ex_reg_read_data_one, id_ex_reg_read_data_two;
logic [3:0] id_ex_alu_op;
logic [4:0] id_ex_rd;

always @ (posedge clk) begin
    // Control Propagation
    id_ex_branch <= d_branch;
    id_ex_mem_read <= d_mem_read;
    id_ex_mem_write <= d_mem_write;
    id_ex_mem_to_reg <= d_mem_to_reg;
    id_ex_mem_write <= d_mem_write;
    id_ex_is_operand_imm <= d_is_operand_imm;
    id_ex_reg_write <= d_reg_write;

    // Data Propagation
    id_ex_reg_read_data_one <= d_reg_read_data_one;
    id_ex_reg_read_data_two <= d_reg_read_data_two;
    id_ex_rd <= d_rd;
    id_ex_signed_imm <= d_signed_imm;
end


// ********************************
// *            Execute           *
// ********************************

// TODO: forwarding unit

wire [31:0] x_alu_second_src;
logic [31:0] x_alu_result;

// alu second src mux
assign x_alu_second_src = id_ex_is_operand_imm ? id_ex_signed_imm : id_ex_reg_read_data_two;
alu a(reg_read_data_one, 
      id_ex_alu_op, x_alu_second_src, 
      x_alu_result);

logic ex_mem_mem_to_reg;
logic ex_mem_branch, ex_mem_mem_read, ex_mem_mem_write;
logic [4:0] ex_mem_rd;
logic [31:0] ex_mem_alu_result, ex_mem_reg_read_data_two;
logic ex_mem_reg_write;

always @ (posedge clk) begin
    // Control Propagation
    ex_mem_branch <= id_ex_branch;
    ex_mem_mem_read <= id_ex_mem_read;
    ex_mem_mem_write <= id_ex_mem_write;
    ex_mem_mem_to_reg <= id_ex_mem_to_reg;
    ex_mem_reg_write <= id_ex_reg_write;

    // Data Propagation
    ex_mem_alu_result <= x_alu_result;
    ex_mem_reg_read_data_two <= id_ex_reg_read_data_two;
    ex_mem_rd <= id_ex_rd;
end

// ********************************
// *        Memory Access         *
// ********************************

logic [31:0] m_read_data;

mem_access m(ex_mem_mem_read, 
             ex_mem_mem_write, 
             ex_mem_alu_result, ex_mem_reg_read_data_two,
             // dmem_data,
             m_read_data,
             dmem_addr, 
             dmem_wen);

logic mem_wb_reg_write, mem_wb_mem_to_reg;
logic [4:0] mem_wb_rd;
logic [31:0] mem_wb_read_data, mem_wb_alu_result;

always @ (posedge clk) begin
    // Control Propagation
    mem_wb_reg_write <= ex_mem_reg_write;
    mem_wb_mem_to_reg <= ex_mem_mem_to_reg;

    // Data Propagation
    mem_wb_read_data <= m_read_data;
    mem_wb_alu_result <= ex_mem_alu_result;
    mem_wb_rd <= ex_mem_rd;
end

// ********************************
// *           Writeback          *
// ********************************
logic w_reg_write;

wire [31:0] w_data;
assign w_data = mem_wb_mem_to_reg ? mem_wb_read_data : mem_wb_alu_result;
logic [31:0] reg_write_data;
write_back wb(w_data, mem_wb_reg_write, reg_write_data);

// ********************************
// *           Registers          *
// ********************************

registers rf(mem_wb_reg_write, 
             d_rs1, d_rs2, mem_wb_rd, 
             reg_write_data, 
             d_reg_read_data_one, 
             d_reg_read_data_two);

endmodule
