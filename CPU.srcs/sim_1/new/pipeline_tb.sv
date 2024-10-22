`timescale 1ns / 1ps

module pipeline_tb();
    reg rst_n, clk;
    wire [31:0] dmem_data;
    logic [31:0] imem_addr, imem_insn, dmem_addr;
    logic dmem_wen;   
    
    // Debug outputs (if present in your CPU)
    wire [31:0] do_rd, xo_rd, mo_rd, wo_rd;
    
    // Instantiate CPU
    cpu processor(.*);
    
    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10ns period (100MHz)
    end
    
    // Test stimulus
    initial begin
        // Initialize signals
        rst_n = 0;
        imem_insn = 32'h00000013; // NOP instruction (addi x0, x0, 0)
        
        // Hold reset for a few cycles
        repeat(3) @(posedge clk);
        
        // Release reset
        rst_n = 1;
        
        // Run for some cycles
        repeat(20) @(posedge clk);
        
        // End simulation
        $display("Simulation complete");
        $finish;
    end
    
    // Optional: Monitor important signals
    initial begin
        $monitor("Time=%0t rst_n=%b imem_addr=%h imem_insn=%h", 
                 $time, rst_n, imem_addr, imem_insn);
    end
    
    // Optional: Create VCD dump file for waveform viewing
    initial begin
        $dumpfile("pipeline_tb.vcd");
        $dumpvars(0, pipeline_tb);
    end
    
endmodule