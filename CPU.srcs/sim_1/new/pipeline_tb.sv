`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/21/2024 03:43:33 PM
// Design Name: 
// Module Name: pipeline_tb
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


module pipeline_tb();
    reg rst_n, clk;
    wire [31:0] dmem_data;
    logic [31:0] imem_addr, imem_insn, dmem_addr;
    logic dmem_wen;
    
    logic [31:0] do_rd, xo_rd, mo_rd, wo_rd;
   
    
    cpu processor(.*);
    
    always begin
        #10;
        imem_insn = imem_insn + 1;
        clk = ~clk;
    end
    
    initial begin
        imem_insn = 0;
        clk = 0;
    end
endmodule
