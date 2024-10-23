`timescale 1ns / 1ps

module rom_reader(
    input clk,
    input [31:0] imem_insn,
    output logic [31:0] pc_out, data, imem_addr
);

logic [31:0] pc = 0;
always @ (posedge clk) begin
   imem_addr <= pc;
   pc_out <= pc;
   data <= imem_insn;
   pc <= pc + 4;
end

endmodule
