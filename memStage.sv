`include "mipspkg.sv"

module MemAccess(clock,rst,address, writeData, wbData, cntrl, memDataOut, writeBackData );
  import Types::*;
  input logic clock;
  input logic rst;
  input logic[add_width-1 :0 ] address;
  input Control cntrl;
  input logic[DATA-1:0] writeData;
  input logic [DATA-1:0]wbData;
  output logic[DATA-1:0] memDataOut;
  output logic [DATA-1:0] writeBackData;
  
  parameter FILENAME = "final_proj_trace.txt";
  
  logic [DATA-1:0] dataOut;
  logic [mem_width-1:0] dataMem [mem_depth-1:0];
  logic [7:0] data [3:0];
  logic [instr_width-1:0] tempMem [(mem_depth/BPI)-1:0];

  always_comb
  begin
  writeBackData = wbData;
  memDataOut = dataOut;
  end
	
  initial begin
      $readmemh(FILENAME,tempMem);
  end

  always_ff@(posedge clock)
    begin
		if(rst)
			begin
				for (int i=0; i< mem_depth ;i++);
				begin
					dataMem ={>>mem_width{tempMem}};
				end
		end
        
		if(cntrl.memWriteEnable)
			dataMem[address +: BPI] <= data;
    end
	
	
	
	assign  {>>mem_width{data[0 +: BPI]}} = writeData;  
    
	
    
	assign	dataOut = {>>mem_width{dataMem[address +: BPI]}};
     
   
endmodule 
