`include "mipspkg.sv"

module InstrFetch(clock,rst, halt_detected, hazard_detected,branch_addr, is_taken, pc_added4,instruction,pc);
  import Types::*;
  
  input logic clock;
  input logic rst;
  input logic halt_detected;
  input logic [add_width-1:0] branch_addr;
  input logic is_taken;
  input logic hazard_detected;
  output Instruct instruction;
  output logic [add_width-1:0] pc;
  output logic [add_width-1:0] pc_added4;
  
  logic [add_width-1:0] mux_branching_o;
  logic invalid_addr;
  
  parameter FILENAME = "final_proj_trace.txt";
  
  
  logic [mem_width-1:0] instructMem [mem_depth-1:0];
  
   always_comb
   begin
   {invalid_addr,pc_added4} = pc + 32'h4;
   mux_branching_o = (is_taken) ? branch_addr : pc_added4;
   end

  initial begin
    
      logic [instr_width-1:0] tempMem [(mem_depth/BPI)-1:0];
      $readmemh(FILENAME,tempMem);
      instructMem ={>>mem_width{tempMem}};
    
  end
	
  always_ff@(posedge clock or posedge rst)
    begin
      if(rst)
        pc <= 0;
      else if(hazard_detected!= 1 && halt_detected!= 1)
        pc <= mux_branching_o;
    end
 
  generate
    always_comb begin
      if (pc[$clog2(BPI)-1:0]==0 && !is_taken) begin
        instruction = {>>mem_width{instructMem[pc +: BPI]}};
      end
      else begin
        instruction = 'hDEADBEEF;
      end
    end
  endgenerate
  
endmodule
