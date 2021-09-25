onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /top/SLG46620/i_clk_source_mux
add wave -noupdate /top/SLG46620/i_clks
add wave -noupdate /top/SLG46620/i_reset_n
add wave -noupdate /top/SLG46620/i_data_from_register
add wave -noupdate /top/SLG46620/i_edge_reset_mode_select
add wave -noupdate /top/SLG46620/i_macrocell_function_select
add wave -noupdate /top/SLG46620/o_sleep_state
add wave -noupdate /top/SLG46620/i_in
add wave -noupdate /top/SLG46620/o_out
add wave -noupdate /top/SLG46620/clk
add wave -noupdate /top/SLG46620/is_Both_Mode
add wave -noupdate /top/SLG46620/is_Faling_Mode
add wave -noupdate /top/SLG46620/is_Rising_Mode
add wave -noupdate /top/SLG46620/w_edges
add wave -noupdate /top/SLG46620/delay_mode_reset
add wave -noupdate /top/SLG46620/r_edge_detector
add wave -noupdate /top/SLG46620/r_internal_delay_out
add wave -noupdate /top/SLG46620/r_internal_delay_out_allow
add wave -noupdate /top/SLG46620/r_counter
add wave -noupdate /top/SLG46620/r_flag_was_edge
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {999709800 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 373
configure wave -valuecolwidth 100
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
WaveRestoreZoom {999527800 ps} {999805400 ps}
