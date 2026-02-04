//This file contains the package for MIPS lite simulator
//**************************************** MIPS LITE SIMULATOR *************************************** 

`ifndef MIPS_LITE
`define MIPS_LITE

package Types;
parameter imm_size=16;
parameter op_code =6;
parameter register_num= 32;
parameter DATA = 32;
parameter add_width=32;
localparam reg_width = $clog2(register_num);
localparam mem_depth = 4096;
localparam  mem_width=8;
localparam instr_width=32;
localparam BPI= instr_width/mem_width;

int Instruction_Count;
int Arithmetic_Instr_Count;
int Logical_Instr_Count;
int Mem_Instr_Count;
int Branch_Instr_Count;
int clockCount;
int stalls;
int Data_Hazards;
int finalClockCount;

typedef union packed{
  
  struct packed {
    logic [reg_width-1:0] rs;
    logic [reg_width-1:0] rt;
    logic [reg_width-1:0] rd;
    logic[10:0] invalid;
  }R;
  
  struct packed{
    logic [reg_width-1:0] rs;
    logic [reg_width-1:0] rt;
    logic [imm_size-1:0] imm;
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
}Control;

//pipeline buffers
struct packed{
  logic [add_width-1:0] pc;
  Instruct instruction;  
}Fetch_Buffer;

struct packed{
  Instruct instruction;
  logic [DATA-1:0] readData1;
  logic [DATA-1:0] readData2;
  logic [DATA-1:0] immOut;
  logic [add_width-1:0] pc;
  Control cntrl;
  logic haltSignal;
  logic [reg_width-1:0] rd;
}Decode_Buffer;

struct packed {
  Instruct instruction;
  logic [DATA-1:0] aluOut;
  logic [add_width-1:0] branchAddress;
  logic [DATA-1:0] writeData;
  Control cntrl;
  logic branchTaken;
  logic haltSignal;
  logic [reg_width-1:0] rd;
}Execution_Buffer;

struct packed{
  Instruct instruction;
  logic [DATA-1:0] memDataOut;
  logic [DATA-1:0] writeBackData;
  Control cntrl;
  logic branchTaken;
  logic haltSignal;
  logic [reg_width-1:0] rd;

}Memory_Buffer;

struct packed{
Control cntrl;
}Cntrl_Buffer[2:0];

struct packed{
  logic [reg_width-1:0] rs1;
  logic [reg_width-1:0] rs2;
  logic [reg_width-1:0] rd;
 
} Read__Buffer[2:0];



task Total_Instruction_Count();
  Instruction_Count = Instruction_Count + 1;
endtask

task Arithmetic_Instruction_Count();
  Arithmetic_Instr_Count = Arithmetic_Instr_Count + 1;
endtask
task Logical_Instruction_Count();
  Logical_Instr_Count = Logical_Instr_Count + 1;
endtask

task Mem_Instruction_Count();
  Mem_Instr_Count = Mem_Instr_Count + 1;
endtask

task Branch_Instruction_Count();
  Branch_Instr_Count = Branch_Instr_Count + 1;
endtask


task hazardDetection(Read__Buffer,rd1,rd2);
  
endtask

endpackage
`endif
