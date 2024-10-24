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
    output logic dmem_wen, // 1 = W, 0 = R
    output [31:0] reg_write_data,
    output [4:0] rd_out
);
 
//always @ (negedge rst_n) begin
    // TODO
//end

// Program Counter Register
// TODO: Propagate PC state to MEM stage for jumping.
logic [31:0] new_pc, pc = 0;

// ********************************
// *            Fetch             *
// ********************************

logic [31:0] f_instruction;
fetch f(pc, imem_insn, new_pc, imem_addr, f_instruction);

always @ (posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        pc <= 32'b0; // Reset PC to 0
    end else begin
        pc <= new_pc; // Update PC to the new PC generated by fetch
    end
end

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
      //  d_reg_read_data_one, d_reg_read_data_two,
         d_signed_imm, d_branch, d_mem_read, 
         d_mem_to_reg, d_mem_write, 
         d_is_operand_imm, d_reg_write, d_alu_op);

logic id_ex_branch, id_ex_mem_read, id_ex_mem_to_reg;
// ALUSrc -> is_operand_imm
logic id_ex_mem_write, id_ex_is_operand_imm;
logic id_ex_reg_write;

logic [31:0] id_ex_signed_imm, id_ex_reg_read_data_one, id_ex_reg_read_data_two;
logic [3:0] id_ex_alu_op;
logic [4:0] id_ex_rs1, id_ex_rs2, id_ex_rd;

always @ (posedge clk) begin
    // Control Propagation
    id_ex_branch <= d_branch;
    id_ex_mem_read <= d_mem_read;
    id_ex_mem_write <= d_mem_write;
    id_ex_mem_to_reg <= d_mem_to_reg;
    id_ex_mem_write <= d_mem_write;
    id_ex_is_operand_imm <= d_is_operand_imm;
    id_ex_reg_write <= d_reg_write;
    id_ex_alu_op <= d_alu_op;

    // Data Propagation
//    id_ex_reg_read_data_one <= d_reg_read_data_one;
//    id_ex_reg_read_data_two <= d_reg_read_data_two;
    id_ex_rs1 <= d_rs1;
    id_ex_rs2 <= d_rs2;
    id_ex_rd <= d_rd;
    id_ex_signed_imm <= d_signed_imm;
end



// ********************************
// *            Execute           *
// ********************************

logic [1:0] forward_a, forward_b;
logic [31:0] x_alu_second_src;
logic [31:0] x_alu_first_src;
logic [31:0] x_reg_src;
logic [31:0] ex_mem_alu_result, ex_mem_reg_read_data_two;

// TODO: restructure declarations
logic [4:0] mem_wb_rd; 
logic [31:0] wb_reg_write_data;
logic [4:0] ex_mem_rd;


forwarding fwd(id_ex_rs1, id_ex_rs2, ex_mem_rd, mem_wb_rd, forward_a, forward_b);

// TODO: forwarding unit

always_comb begin
    // First source mux
    case (forward_a)
        2'b10   : x_alu_first_src = ex_mem_alu_result;
        2'b01   : x_alu_first_src = wb_reg_write_data;
        default : x_alu_first_src = id_ex_reg_read_data_one;
    endcase

    // Second source mux
    case (forward_b)
        2'b10   : x_reg_src = ex_mem_alu_result;
        2'b01   : x_reg_src = wb_reg_write_data;
        default : x_reg_src = id_ex_reg_read_data_two;
    endcase
end

assign x_alu_second_src = id_ex_is_operand_imm ? id_ex_signed_imm : x_reg_src;

logic [31:0] x_alu_result;

// alu second src mux
//assign x_alu_second_src = id_ex_is_operand_imm ? id_ex_signed_imm : id_ex_reg_read_data_two;
alu a(x_alu_first_src, x_alu_second_src,
      id_ex_alu_op, x_alu_result);

logic ex_mem_mem_to_reg;
logic ex_mem_branch, ex_mem_mem_read, ex_mem_mem_write;
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

write_back wb(mem_wb_read_data, mem_wb_alu_result, mem_wb_mem_to_reg, wb_reg_write_data);
// assign dmem_data = wb_reg_write_data;
assign reg_write_data = wb_reg_write_data;
assign rd_out = mem_wb_rd;

// ********************************
// *           Registers          *
// ********************************

registers rf(clk, mem_wb_reg_write, 
             id_ex_rs1, id_ex_rs1, mem_wb_rd, 
             wb_reg_write_data, 
             id_ex_reg_read_data_one, 
             id_ex_reg_read_data_two);

endmodule
