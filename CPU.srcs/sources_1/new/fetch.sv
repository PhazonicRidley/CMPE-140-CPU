`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/30/2024 11:43:08 AM
// Design Name: 
// Module Name: fetch
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


module fetch(
    input clk,
    input [31:0] pc, imem_insn,
    output logic [31:0] new_pc, imem_addr,
    output logic [31:0] instruction,
    output logic out_clk
    );
        
    always @(posedge clk) begin
        imem_addr <= pc; //set address to pc
        instruction <= imem_insn;
        new_pc <= pc + 4; //increment pc 4
    end 
    always @(posedge clk or negedge clk) begin
        out_clk <= clk;
    end   
endmodule
