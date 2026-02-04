`include "mipspkg.sv"

module InstrFetch(clk,rst, halt_signal, hazard_detected,branch_addr, branch_taken, pc_added4,instruction,pc);
  import TYPES::*;
  
  input logic clk;
  input logic rst;
  input logic halt_signal;
  input logic [addr_width-1:0] branch_addr;
  input logic branch_taken;
  input logic hazard_detected;
  output Instruct instruction;
  output logic [addr_width-1:0] pc;
  output logic [addr_width-1:0] pc_added4;
  
  logic [addr_width-1:0] mux_branching_o;
  logic [addr_width-1:0] pcNext; 
  logic invalid_addr;
  logic [mem_width-1:0] instructMem [mem_depth-1:0];
  
  parameter FILENAME = "ece586_sample_trace.txt";
  
  assign {invalid_addr,pc_added4} = pc + 32'h4;
  assign mux_branching_o = (branch_taken) ? branch_addr : pc_added4;

  initial 
    begin
      logic [instr_width-1:0] tempMem [(mem_depth/BPI)-1:0];
      $readmemh(FILENAME,tempMem);
      instructMem ={>>mem_width{tempMem}};
  end

  always_ff@(posedge clk, posedge rst)
    begin
      if(rst)
        pc <= 0;
      else if(hazard_detected!='1 && halt_signal!='1)
        pc <= mux_branching_o;
  end

  
  generate
    always_comb begin
      if (pc[$clog2(BPI)-1:0]==0) begin
        instruction = {>>mem_width{instructMem[pc +: BPI]}};
      end
      else begin
        instruction = 'hDEADBEEF;
      end
    end
  endgenerate  
  
endmodule
