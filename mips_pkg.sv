`ifndef MIPS_LITE
`define MIPS_LITE

package mips_pkg;
parameter IMM_SIZE=16;//
parameter op_code =6;
parameter reg_num= 32;//
parameter DATA = 32;
parameter adddr_width=32;//

localparam reg_width = $clog2(reg_num);//
localparam memdepth = 4096;
localparam  memwidth=8;
localparam instr_width=32;
localparam BPI= instr_width/memwidth; 


int InstructionCount;//
int ArithmeticInstrCount;//
int LogicalInstrCount;//
int MemoryInstrCount;//
int BranchInstrCount;//


logic [memdepth-1:0] MemWriteStatus;//

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

}Instruction;

typedef struct packed{
  logic[op_code-1:0] op_code;
  Instruction Type;
}Instr; //

typedef struct packed{
  logic MemWriteEnable;//
  logic RegWriteEnable;//
  logic WriteBack;//
  logic WBMux;//
  logic srcReg2;//
  logic jump;
  logic [2:0] ALU_op;
}CTRL;

task CountInstruction();//
  InstructionCount = InstructionCount + 1;
endtask

task CountArithmeticInstruction();//
  ArithmeticInstrCount = ArithmeticInstrCount + 1;
endtask

task CountLogicalInstruction();//
  LogicalInstrCount = LogicalInstrCount + 1;
endtask

task CountMemoryInstruction();//
  MemoryInstrCount = MemoryInstrCount + 1;
endtask

task CountBranchInstruction();//
  BranchInstrCount = BranchInstrCount + 1;
endtask


endpackage


`endif
