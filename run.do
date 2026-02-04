vlib work
vlog mipspkg.sv
vlog design.sv
vlog testbench.sv
#vlog instructionFetch.sv
#vlog memStage.sv

vsim work.top

run -all
