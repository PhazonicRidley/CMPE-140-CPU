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


module mem_access(
    input clk, 
    input logic mem_read, mem_write,
    input logic [31:0] alu_result,
    output logic [31:0] dmem_addr,
    output logic dmem_wen,
    output logic clk_out
 );
always @ (posedge clk) begin
    if (mem_read && !mem_write) begin
        // Address dmem_addr and get data
        dmem_addr = alu_result;
        dmem_wen = 0;
    end
    else if (!mem_read && mem_write) begin
        dmem_addr = alu_result;
        dmem_wen = 1;
    end
end
endmodule
