`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/21/2024 09:45:19 AM
// Design Name: 
// Module Name: forwarding
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


module forwarding(
    input logic [4:0] idex_rs1, idex_rs2,
    input logic [4:0] exmem_rd,
    input logic [4:0] memwb_rd,
    output logic [1:0] fwda, fwdb //forwarding outs
);

always_comb begin
    fwda = 2'b00;
    fwdb = 2'b00;

    if(exmem_rd == idex_rs1 && exmem_rd != 0) begin
        fwda = 2'b10;
    end
    else if(memwb_rd == idex_rs1 && memwb_rd != 0) begin
        fwda = 2'b01;
    end
    if(exmem_rd == idex_rs2 && exmem_rd != 0) begin
        fwdb = 2'b10;
    end
    else if(memwb_rd == idex_rs2 && memwb_rd != 0) begin
        fwdb = 2'b01;
    end
end
endmodule
