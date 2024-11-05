`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/30/2024 11:43:08 AM
// Design Name: 
// Module Name: alu
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

// TODO: Branch flags, ALU is responsible for comparison!
parameter [3:0] add = 'bX000,
                slt = 'bX010,
                sltu = 'bX011,
                eor = 'bX100,
                bor = 'bX110,
                band = 'bX111,
                sll = 'b0001,
                srl = 'b0101,
                sra = 'b1101;

module alu(
    input logic signed [31:0] data_one, data_two,
    input logic [3:0] alu_op,
    output logic [31:0] result
);

always_comb begin
    casex (alu_op)
        add: result = data_one + data_two;
        slt: result = data_one < data_two;
        sltu: result = $unsigned(data_one) < $unsigned(data_two);
        eor: result = data_one ^ data_two;
        bor: result = data_one | data_two;
        band: result = data_one & data_two;
        sll: result = data_one << data_two;
        srl: result = data_one >> data_two;
        sra: result = data_one >>> data_two;
        default: result = -1;
    endcase
    
//    case(alu_op)
//        4'b0010 : begin //slti
//            result = data_one < data_two;
//        end
//        4'b0011 : begin //sltiu
//            result = data_one < data_two;
//        end
//        4'b0100 : begin //xori
//            result = data_one ^ data_two;
//        end
//        4'b0110 : begin //ori
//            result = data_one | data_two;
//        end
//        4'b0111 : begin //andi
//            result = data_one & data_two;
//        end
//        4'b0001 : begin //slli
//            result = data_one << data_two;
//        end
//        4'b0101 : begin //srai
//            result = data_one >>> data_two;
//        end
//        4'b1000 : begin //slri
//            result = data_one >> data_two;
//        end 
//        default : begin //addi
//            result = data_one + data_two;
//        end
//    endcase
end    
endmodule
