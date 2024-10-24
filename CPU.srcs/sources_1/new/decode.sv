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

//Basic Test Pass
module decode(
    input [31:0] instruction,
    output logic [4:0] rs1, rs2, rd,
  //  output logic [31:0] reg_data_one, reg_data_two,
    output logic signed [31:0] signed_imm,
    output logic branch, mem_read, mem_to_reg, mem_write, is_operand_imm, reg_write,
    output logic [3:0] alu_op
    );
    
    reg [6:0] opcode;
    reg [2:0]  func3;
    reg [11:0] imm;
    
    always_comb begin
        opcode = instruction[6:0];
        rd = instruction[11:7];
        func3 = instruction[14:12];
        rs1 = instruction[19:15];
        rs2 = instruction[24:20];
        imm = instruction[31:20];
        signed_imm = { {20{imm[11]}},imm };
        case (opcode) 
        7'b0010011: begin
            branch = 1'b0;
            mem_read = 1'b0;
            mem_to_reg = 1'b0;
            mem_write = 1'b0;
            is_operand_imm = 1'b1;
            reg_write = 1'b1;
            //func3 to alu_op assignment
            case (func3)
                3'b010  : alu_op = 4'b0010; //slti
                3'b011  : alu_op = 4'b0011; //sltiu
                3'b100  : alu_op = 4'b0100; //xori
                3'b110  : alu_op = 4'b0110; //ori
                3'b111  : alu_op = 4'b0111; //andi
                3'b001  : alu_op = 4'b0001; //slli
                3'b101  : begin
                    if (imm[11:5] == 7'b0100000) begin
                        alu_op = 4'b0101;
                    end
                    else begin
                        alu_op = 4'b1000;
                    end
                end 
                default : alu_op = 4'b0000;
            endcase 
        end
        default: begin
            branch = 1'b0;
            mem_read = 1'b0;
            mem_to_reg = 1'b0;
            mem_write = 1'b0;
            is_operand_imm = 1'b1;
            reg_write = 1'b0;
            alu_op = 4'b1111; //no operator assigned with this
        end 
        endcase
//        reg_data_one = rs1;
//        reg_data_two = rs2;      
    end
endmodule
