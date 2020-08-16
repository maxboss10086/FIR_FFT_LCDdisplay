onerror {exit -code 1}
vlib work
vlog -work work FIR_audio_lcd.vo
vlog -work work test2.vwf.vt
vsim -novopt -c -t 1ps -L cycloneive_ver -L altera_ver -L altera_mf_ver -L 220model_ver -L sgate work.test2_vlg_vec_tst -voptargs="+acc"
vcd file -direction FIR_audio_lcd.msim.vcd
vcd add -internal test2_vlg_vec_tst/*
vcd add -internal test2_vlg_vec_tst/i1/*
run -all
quit -f
