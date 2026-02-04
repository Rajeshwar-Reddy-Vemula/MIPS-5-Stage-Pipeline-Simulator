`include "mips_pkg.sv"
module MemAccess(clk, reset, address, write_data, WB_data, cntrl, memory_data_o, write_back_data );
  import mips_pkg::*;
  input logic clk;
  input logic reset;
  input logic[adddr_width-1 :0 ] address;
  input CTRL cntrl;
  input logic[DATA-1:0] write_data;
  input logic [DATA-1:0] WB_data;
  output logic[DATA-1:0] memory_data_o;
  
  logic [DATA-1:0] data_o;
  output logic [DATA-1:0] write_back_data;
  
  parameter FILE_NAME = "final_proj_trace.txt";
    
  logic [memwidth-1:0] data_memory [memdepth-1:0];
  
  logic [7:0] data [3:0];
  logic [instr_width-1:0] temp_memory [(memdepth/BPI)-1:0];
  
  assign write_back_data = WB_data;
  assign memory_data_o = data_o;
  
   initial 
    begin
      $readmemh(FILE_NAME,temp_memory);
      
    end

    always_comb
    begin
      {>>memwidth{data[0 +: BPI]}} = write_data;
    end

    always_ff@(posedge clk)
    begin
      if(reset)
        begin
          for (int i=0; i< memdepth ;i++);
          begin
            data_memory ={>>memwidth{temp_memory}};
          end
          
        end
        
      if(cntrl.MemWriteEnable)
        begin
        data_memory[address +: BPI] <= data;
          MemWriteStatus[address]='1;
        end
        
    end

    always_comb
    begin
      data_o = {>>memwidth{data_memory[address +: BPI]}};
    end
endmodule 
