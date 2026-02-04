`include "mipspkg.sv"

module MemAccess(clk,rst,instruction, address, data_write, wb_data, cntrl, memory_data_o, write_back_data, instrMem );
  import TYPES::*;
  input logic clk;
  input logic rst;
  input Instruct instruction;
  input logic[addr_width-1 :0 ] address;
  input CTRL cntrl;
  input logic[DATA-1:0] data_write;
  input logic [DATA-1:0]wb_data;
  output logic[DATA-1:0] memory_data_o;
  output Instruct instrMem;
  output logic [DATA-1:0] write_back_data;

  parameter FILENAME = "ece586_sample_trace.txt";
  
  logic [DATA-1:0] dataOut;
  logic [mem_width-1:0] dataMem [mem_depth-1:0];
  logic [7:0] data [3:0];
  logic [instr_width-1:0] tempMem [(mem_depth/BPI)-1:0];

  initial 
    begin
      $readmemh(FILENAME,tempMem);
  end

  always_ff@(posedge clk)
    begin
      if(rst)
        begin
          for (int i=0; i< mem_depth ;i++);
          begin
            dataMem ={>>mem_width{tempMem}};
          end
      end
        
      if(cntrl.memWriteEnable)
        begin
        dataMem[address +: BPI] <= data;
          memWriteStatus[address]='1;
      end
  end

  always_comb
    begin
      {>>mem_width{data[0 +: BPI]}} = data_write;
  end

  always_comb
    begin
      dataOut = {>>mem_width{dataMem[address +: BPI]}};
  end  
  
  assign instrMem = instruction;
  assign write_back_data = wb_data;
  assign memory_data_o = dataOut;
   
endmodule 
