`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/20/2024 03:31:19 AM
// Design Name: 
// Module Name: mem_access
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

// rewrite
module mem_access(
    input mem_read, mem_write,
    input [3:0] buf_size,
    input [31:0] address, write_data,
    inout logic [31:0] dmem_data,
    output logic dmem_wen,
    output logic [3:0] byte_en,
    output logic [31:0] dmem_addr, read_data
 );
 
 logic [31:0] src, mem_data_out;
 logic mem_access = 0;
 
 always_comb begin
    unique case ({mem_read, mem_write})
        2'b10: begin
            src = dmem_data;
            dmem_wen = 0;
        end
        2'b01: begin
            src = write_data;
            dmem_wen = 1;
        end
        default: dmem_wen = 0;
    endcase
    
    mem_access = mem_read ^ mem_write;
    if (mem_access) begin
        dmem_addr = address;
        case (buf_size)
            0: begin byte_en = 4'b0001; mem_data_out = { {24{src[7]}}, src[7:0]}; end
            1: begin byte_en = 4'b0011; mem_data_out = { {16{src[15]}}, src[15:0]}; end
            2: begin byte_en = 4'b1111; mem_data_out = src; end
            4: begin byte_en = 4'b0001; mem_data_out = { {24{1'b0}}, src[7:0]}; end
            5: begin byte_en = 4'b0011; mem_data_out = { {16{1'b0}}, src[15:0]}; end
            default: byte_en = 0;
        endcase
     end else begin
        dmem_wen = 0;
        dmem_addr = 'bZ;
        byte_en = 0;
     end
 end
 
 assign read_data = (mem_read) ? mem_data_out : 'x;
 assign dmem_data = (mem_write) ? mem_data_out : 'z;

endmodule
