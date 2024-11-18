`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/17/2024 10:12:22 AM
// Design Name: 
// Module Name: stall_handler
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

// TODO: Handle branch stalls (control hazards)
module stall_handler(
    input idex_mem_read,
    input [4:0] d_rs1, d_rs2, idex_rd,
    output logic pc_write, if_id_write, id_ex_write
);
    always_comb begin
        if (idex_mem_read && idex_rd != 0 && ((idex_rd == d_rs1) || (idex_rd == d_rs2))) begin
            pc_write = 0;
            if_id_write = 0;
            id_ex_write = 0;
        end
        
        else begin
            pc_write = 1;
            if_id_write = 1;
            id_ex_write = 1;
        end
    end
endmodule
