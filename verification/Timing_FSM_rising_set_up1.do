onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /top/SLG46620/i_clk_source_mux
add wave -noupdate /top/SLG46620/i_clks
add wave -noupdate /top/SLG46620/i_reset_n
add wave -noupdate /top/SLG46620/i_data_from_register
add wave -noupdate /top/SLG46620/i_edge_reset_mode_select
add wave -noupdate /top/SLG46620/i_macrocell_function_select
add wave -noupdate /top/SLG46620/o_edge_detect_out
add wave -noupdate /top/SLG46620/i_resetin_timer
add wave -noupdate /top/SLG46620/i_reset_set_mode
add wave -noupdate /top/SLG46620/i_keep
add wave -noupdate /top/SLG46620/i_up
add wave -noupdate /top/SLG46620/i_in
add wave -noupdate /top/SLG46620/o_out
add wave -noupdate /top/SLG46620/clk
add wave -noupdate /top/SLG46620/is_DLY_mode
add wave -noupdate /top/SLG46620/is_CNT_mode
add wave -noupdate /top/SLG46620/is_Edge_Detect_mode
add wave -noupdate /top/SLG46620/is_Wake_Sleep_Ratio_Control_mode
add wave -noupdate -radix unsigned /top/SLG46620/r_counter
add wave -noupdate /top/SLG46620/delay_mode_cnt_reset
add wave -noupdate /top/SLG46620/delay_mode_cnt_allow
add wave -noupdate /top/SLG46620/delay_mode_out
add wave -noupdate /top/SLG46620/reset_counter_mode
add wave -noupdate /top/SLG46620/cnt_mode_out
add wave -noupdate /top/SLG46620/main_counter_reset
add wave -noupdate /top/SLG46620/load_counter_during_reset
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {99695922 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 355
configure wave -valuecolwidth 117
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {99668628 ps} {99852720 ps}
