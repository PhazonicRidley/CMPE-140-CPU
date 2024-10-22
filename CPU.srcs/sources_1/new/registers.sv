`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/20/2024 01:45:09 AM
// Design Name: 
// Module Name: registers
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

module registers(
    input logic clk,
    input logic write_en,
    input logic [4:0] rs1,
    input logic [4:0] rs2,
    input logic [4:0] rd,
    input logic [31:0] write_data,
    output logic [31:0] read_data_one,
    output logic [31:0] read_data_two
);

    logic [31:0] registers[32];
    always_ff @ (posedge clk) begin
        if (write_en && rd != 0) registers[rd] <= write_data;
    end
    
    always_comb begin
        read_data_one = registers[rs1];
        read_data_two = registers[rs2];
       /* if (write_en && rd != 0) begin
            if (rs1 == rd) read_data_one = write_data;
            if (rs2 == rd) read_data_two = write
        end */
    end

endmodule
