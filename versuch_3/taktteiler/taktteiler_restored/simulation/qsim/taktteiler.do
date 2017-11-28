onerror {quit -f}
vlib work
vlog -work work taktteiler.vo
vlog -work work taktteiler.vt
vsim -novopt -c -t 1ps -L cycloneii_ver -L altera_ver -L altera_mf_ver -L 220model_ver -L sgate work.taktteiler_vlg_vec_tst
vcd file -direction taktteiler.msim.vcd
vcd add -internal taktteiler_vlg_vec_tst/*
vcd add -internal taktteiler_vlg_vec_tst/i1/*
add wave /*
run -all
