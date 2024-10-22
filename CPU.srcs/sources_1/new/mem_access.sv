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
    input mem_read, mem_write,
    input [31:0] addr, write_data,
    //inout logic [31:0] dmem_data,
    output logic [31:0] read_data,
    output logic [31:0] dmem_addr,
    output logic dmem_wen
 );
/*always @ (posedge clk) begin
    if (mem_read && !mem_write) begin
        // Address dmem_addr and get data   
        dmem_addr <= addr;
        dmem_wen <= 0;
        read_data <= dmem_data;
    end
    else if (!mem_read && mem_write) begin
        dmem_addr <= addr;
        dmem_wen <= 1;
        dmem_data <= write_data;
        read_data <= 0;
    end
end */

endmodule
