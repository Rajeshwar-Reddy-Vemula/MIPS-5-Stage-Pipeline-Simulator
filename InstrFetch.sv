`include "mips_pkg.sv"
module InstrFetch(clk, reset, branch_addr, is_taken, pc_plus_4, instruction, pc);
import mips_pkg::*;
  
input logic clk;
input logic reset;
input logic [adddr_width-1:0] branch_addr;
input logic is_taken;
  
output Instr instruction;
output logic [adddr_width-1:0] pc;
logic [adddr_width-1:0] mux_branch_op;
output logic [adddr_width-1:0] pc_plus_4;
logic invalid_addr;
parameter FILE_NAME = "final_proj_trace.txt";


logic [memwidth-1:0] memory_instruction [memdepth-1:0];

assign mux_branch_op = (is_taken) ? branch_addr : pc_plus_4;
  
assign {invalid_addr, pc_plus_4} = pc + 32'h4;

initial 
	begin
	logic [instr_width-1:0] temp_memory [(memdepth/BPI)-1:0];
	$readmemh(FILE_NAME,temp_memory);
	memory_instruction ={>>memwidth{temp_memory}};
	$display("%p",memory_instruction);
	end
generate
	always_comb begin
      	if (pc[$clog2(BPI) - 1 : 0] == '0) 
      	begin
        instruction = {>>memwidth{memory_instruction[ pc +: BPI]}};
      	end
      	else 
      	begin
        instruction = 'hFEEDDEAD;
      	end
    	end
endgenerate

 
always_ff@(posedge clk, posedge reset)
    	begin
      	if(reset)
        pc <= 0;
      	else
       	pc <= mux_branch_op;
    	end

final
 	begin 
    	$display("%p",memory_instruction);
  	end
endmodule







