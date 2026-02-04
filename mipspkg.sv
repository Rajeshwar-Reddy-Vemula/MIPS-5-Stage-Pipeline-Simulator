//This file contains the package for MIPS lite simulator
//**************************************** MIPS LITE SIMULATOR *************************************** 

`ifndef MIPS_LITE
`define MIPS_LITE

package TYPES;

parameter IMM_SIZE=16;
parameter op_code =6;
parameter reg_num= 32;
parameter DATA = 32;
parameter addr_width=32;

localparam reg_width = $clog2(reg_num);
localparam mem_depth = 4096;
localparam  mem_width=8;
localparam instr_width=32;
localparam BPI= instr_width/mem_width;

int Total_Instr_Count;
int Arithmetic_Instr_Count;
int Logical_Instr_Count;
int Mem_Instr_Count;
int Branch_Instr_Count;
int Clock_Count;
int stalls;
int Data_Hazards;

logic [mem_depth-1:0] memWriteStatus;
int Final_Clock_Count;

typedef union packed{
  
  struct packed {
    logic [reg_width-1:0] rs;
    logic [reg_width-1:0] rt;
    logic [reg_width-1:0] rd;
    logic[10:0] unused;
  }R;
  
  struct packed{
    logic [reg_width-1:0] rs;
    logic [reg_width-1:0] rt;
    logic [IMM_SIZE-1:0] imm;
  }I;

}instruction;

typedef struct packed{
  logic[op_code-1:0] op_code;
  instruction Type;
}Instruct;


typedef struct packed{
  logic memWriteEnable;
  logic regWrite;
  logic writeBack;
  logic wbMux;
  logic rs2;
  logic jump;
  logic [2:0] aluop;
}CTRL;


struct packed{
  logic [addr_width-1:0] pc;
  Instruct instruction;  
}Fetch_Buffer;

struct packed{
  Instruct instruction;
  logic [DATA-1:0] readData1;
  logic [DATA-1:0] readData2;
  logic [DATA-1:0] immOut;
  logic [addr_width-1:0] pc;
  CTRL cntrl;
  logic haltSignal;
  logic Forward_1;
  logic Forward_2;
  logic Mem_Forward_1;
  logic Mem_Forward_2;
  logic wb_Forward_1;
  logic wb_Forward_2;
}Decode_Buffer;

struct packed {
  logic [DATA-1:0] aluOut;
  logic [addr_width-1:0] Branch_Address;
  logic [DATA-1:0] writeData;
  CTRL cntrl;
  logic is_taken;
  logic haltSignal;

}Execution_Buffer;

struct packed{
  logic [DATA-1:0] memDataOut;
  logic [DATA-1:0] writeBackData;
  CTRL cntrl;
  logic is_taken;
  logic haltSignal;

}Mem_Buffer;

struct packed{
CTRL cntrl;
}Cntrl_Buffer[2:0];

struct packed{
  logic [reg_width-1:0] rs1;
  logic [reg_width-1:0] rs2;
  logic [reg_width-1:0] rd;
 
} Read_Buffer[2:0];

struct packed{
 Instruct instruction;
}Instr_Buffer[2:0];

task Count_Instruction();
  Total_Instr_Count = Total_Instr_Count + 1;
endtask

task Count_Arithmetic_Instruction();
  Arithmetic_Instr_Count = Arithmetic_Instr_Count + 1;
endtask

task Count_Logical_Instruction();
  Logical_Instr_Count = Logical_Instr_Count + 1;
endtask

task Count_Memory_Instruction();
  Mem_Instr_Count = Mem_Instr_Count + 1;
endtask

task Count_Branch_Instruction();
  Branch_Instr_Count = Branch_Instr_Count + 1;
endtask


endpackage
`endif