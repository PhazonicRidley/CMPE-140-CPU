`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/22/2024 04:47:11 PM
// Design Name: 
// Module Name: rom_reader_tb
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


module rom_reader_tb();

    reg clk;
    reg [31:0] imem_insn;
    logic [31:0] pc_out, data, imem_addr;
    
    rom_reader rr(.*);
    always begin
        clk = ~clk;
        #20;
     end
     
     initial begin
        clk = 0;
        imem_addr = 0;
        
     end
    
    rom #( .addr_width (32), .data_width (32), .init_file ("addi_hazards.dat") )
    imem(.addr(imem_addr), .data(imem_insn));
endmodule
