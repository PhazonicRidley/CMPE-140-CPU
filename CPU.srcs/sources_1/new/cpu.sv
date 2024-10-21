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

// TODO: pipeline registers
// Clocks and other state will be "handed back" by each submodule
logic [31:0] pc = 0;

// Register file
logic [4:0] rs1, rs2, rd;
logic [31:0] reg_read_data_one, reg_read_data_two, reg_write_data;
logic reg_write_en;
registers rf(write_en, rs1, rs2, rd, reg_write_data, reg_read_data_one, reg_read_data_two);

// fetch internal state
logic f_out_clk;
logic [31:1] instruction;
fetch f(clk, pc, imem_insn, pc, imem_addr, instruction, f_out_clk);

// Decode internal state
logic d_out_clk, TEMP_reg_write; // reg_write will be managed by the pipeline MEM/WB reg
// TODO: Why does it say to extend imm up to 64 bits for a 32 bit CPU?
logic [31:0] signed_imm;

// control signals
// Ensure that mem_read and/or mem_write are ONLY set when theres a valid memory address.
logic branch, mem_read, is_data_mem, mem_write, is_operand_imm, to_write_back;
logic [15:0] alu_op;
decode d(f_out_clk, instruction, rs1, rs2, rd, 
         reg_read_data_one, reg_read_data_two, 
         signed_imm, branch, mem_read, is_data_mem, 
         mem_write, is_operand_imm, TEMP_reg_write, d_clk_out, alu_op);

// Execute (ALU) internal state

logic x_clk_out;
logic [31:0] alu_result;
wire [31:0] alu_second_src;
// alu second src mux
assign alu_second_src = is_operand_imm ? signed_imm : reg_read_data_two;
alu a(d_out_clk, reg_read_data_one, alu_second_src, alu_result, x_clk_out);

// Memory Access internal state
logic m_clk_out;
mem_access m(x_clk_out, mem_read, mem_write, alu_result, dmem_data, dmem_addr, dmem_wen, m_clk_out);

// Writeback
wire [31:0] wb_data;
assign wb_data = is_data_mem ? dmem_data : alu_result;

always @ (posedge clk) begin
    // fetch (1 CC)
    // decode (1 CC)
    // Execute ( N CCs) (Called by decoder, decoder will then "hand back" the clock
    // TODO: ask what "memory access" means, how is that different from execute? (eg load/store)
    // Update registers (1 CC), including pc
end

endmodule
