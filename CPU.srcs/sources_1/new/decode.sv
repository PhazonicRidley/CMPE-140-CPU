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


parameter [6:0] i_type_ld = 'h3,
                i_type_alu = 'h13,
                i_type_jal = 'h67,
                r_type = 'h33,
                s_type = 'h23;


module decode(
    input [31:0] instruction,
    output logic [4:0] rs1, rs2, rd,
    output logic signed [31:0] signed_imm,
    output logic branch, mem_read, mem_to_reg, mem_write, is_operand_imm, reg_write,
    output logic [3:0] alu_op
    );
    
    logic [6:0] opcode, func7;
    logic [2:0]  func3;
    logic [11:0] imm;
    logic msb_alu_op;
    

    
    always_comb begin
        opcode = instruction[6:0];
        rd = instruction[11:7];
        func3 = instruction[14:12];
        func7 = instruction[31:25];
        rs1 = instruction[19:15];
        rs2 = instruction[24:20];
        imm = instruction[31:20];
        msb_alu_op = 0;
        signed_imm = { {20{imm[11]}},imm };
        
        case (opcode) 
            i_type_alu: begin
                if (func3 == 'b1 || func3 == 'b101) msb_alu_op = func7[5]; 
                branch = 0;
                mem_read = 0;
                mem_to_reg = 0;
                mem_write = 0;
                is_operand_imm = 1;
                reg_write = 1;
                alu_op = {msb_alu_op, func3};
            
            end
            
            i_type_ld: begin
                branch = 0;
                mem_read = 1'b1;
                mem_to_reg = 1'b1;
                mem_write = 0;
                is_operand_imm = 1'b1;
                reg_write = 1'b1;
                alu_op = {1'b0, func3}; // set MSB to 0, variable reused for buf size
                signed_imm = {{20{instruction[31]}}, instruction[31:20]};
            end
            
            s_type: begin
                branch = 0;
                mem_read = 0;
                mem_to_reg = 0;
                mem_write = 1'b1;
                is_operand_imm = 1'b1;
                reg_write = 0;
                alu_op = {1'b0, func3}; // set MSB to 0, variable reused for buf size
                signed_imm = {{20{instruction[31]}}, instruction[31:25], instruction[11:7]};
            end
            
            r_type: begin
                msb_alu_op = func7[5];
                branch = 0;
                mem_read = 0;
                mem_to_reg = 0;
                mem_write = 0;
                is_operand_imm = 0;
                reg_write = 1;
                alu_op = {msb_alu_op, func3};
                signed_imm = -1;
            end
            
            default: begin
                branch = 1'b0;
                mem_read = 1'b0;
                mem_to_reg = 1'b0;
                mem_write = 1'b0;
                is_operand_imm = 1'b0;
                reg_write = 1'b0;
                alu_op = 4'b1111; //no operator assigned with this
                signed_imm = 0;
            end 
        endcase  

    end
endmodule
