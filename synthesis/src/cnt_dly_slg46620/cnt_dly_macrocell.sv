import slg46620_cnt0_pkg::*;
/*
dataseet is:
https://www.dialog-semiconductor.com/sites/default/files/slg46620r115_10282019.pdf

CNT/DLY2/FSM0 interpretation by Shpegun60
Simulation: QuestaSim x64 ver2020.1
Needed simulation libraries: altera_primitives (build: $projectSource/verification/altera_primitives)
*/

module cnt_dly_macrocell #(parameter BIT_WIDTH = 14)(
	// main registers--------------------------------------
	input logic [3:0] 	i_clk_source_mux, 	//reg<1791:1788> CNT/DLY2/FSM0 Clock Source Select
	input logic [15:0] 	i_clks,				// clk bus
	input logic			i_reset_n, // not defined in datasheet reset (recomended POR)

	
	input logic [(BIT_WIDTH - 1):0] i_data_from_register, //reg<1787:1774> CNT2 14bits data From Register
	
	input logic [1:0] 	i_edge_reset_mode_select,    //reg<1793:1792> DLY2 Edge Mode Select or CNT2 Reset Mode Select
	input logic [1:0] 	i_macrocell_function_select, //reg<1795:1794> CNT/DLY2/FSM0 Macrocell Function Select
	
	// input logic [1:0] i_fsm_source_select // reg<1797:1796> FSM0 Input data Source Select (does not make sense in this realization)

	// for cnt mode --------------------
	output logic o_edge_detect_out, //EDGE DETECT OUT on timing diagram (see datasheet Page 128 of 212)
	input logic i_resetin_timer, // RESETIN on timing diagram (see datasheet Page 128 of 212)
	
	input i_reset_set_mode, // 0 ==> reset; 1==> set  reg<1798>  CNT2 Value Control
	
	//fsm mode
	input logic i_keep, // KEEP on timing diagram (see datasheet Page 129 of 212)
	input logic i_up, // UP on timing diagram (see datasheet Page 129 of 212)
	
	// main out & in-------------------
	input logic i_in,  // IN on Figure 77. CNT/DLY2/FSM0 Page 123 of 212
	output logic o_out // Counter_end on Figure 77. CNT/DLY2/FSM0 Page 123 of 212
);

// clk mux ------------------------------------
logic clk;
assign clk = i_clks[i_clk_source_mux];
//--------------------------------------------

// help wires -------------------
logic is_DLY_mode, is_CNT_mode, is_Edge_Detect_mode, is_Wake_Sleep_Ratio_Control_mode;
assign is_DLY_mode 								= (i_macrocell_function_select == DLY);
assign is_CNT_mode 								= (i_macrocell_function_select == CNT);
assign is_Edge_Detect_mode 						= (i_macrocell_function_select == Edge_Detect);
assign is_Wake_Sleep_Ratio_Control_mode 		= (i_macrocell_function_select == Wake_Sleep_Ratio_Control);

logic [(BIT_WIDTH - 1):0] r_counter = '0; // main global counter

//***********************************************************************************************************************************************
// Delay Mode OPERATIONS
//***********************************************************************************************************************************************

logic delay_mode_cnt_reset;
logic delay_mode_cnt_allow;
logic delay_mode_out;

//assign o_out = delay_mode_out; // only for test !!!!!!!!!!!!!!

dly_mode #(.BIT_WIDTH(BIT_WIDTH)) dly_mode_inst
(
	.i_clk(clk),
	.i_reset_n(i_reset_n),
	
	.i_data_from_register(i_data_from_register),
	.i_edge_reset_mode_select(i_edge_reset_mode_select),
	
	.i_counter(r_counter),
	.o_cnt_allow(delay_mode_cnt_allow),
	.o_cnt_reset(delay_mode_cnt_reset),
	.i_in(i_in),
	.o_out(delay_mode_out) //output from delay mode logic (this pin must be connection to o_out in a case when [i_macrocell_function_select == DLY])
);

//***********************************************************************************************************************************************
// Counter Mode OPERATIONS
//***********************************************************************************************************************************************

logic reset_counter_mode;
logic cnt_mode_out;

//assign o_out = cnt_mode_out; // only for test !!!!!!!!!!!!!!

cnt_fsm_mode #(.BIT_WIDTH(BIT_WIDTH)) cnt_mode_inst
(
	.i_clk(clk),
	.i_reset_n(i_reset_n),
	
	.i_edge_reset_mode_select(i_edge_reset_mode_select),
	
	.o_edge_detect_out(o_edge_detect_out),
	.i_resetin_timer(i_resetin_timer),
	
	.i_up(i_up),
	
	.i_counter(r_counter),
	.o_cnt_reset(reset_counter_mode),
	.o_out(cnt_mode_out) //output from counter mode logic (this pin must be connection to o_out in a case when [i_macrocell_function_select == CNT])
);


//***********************************************************************************************************************************************
// MAIN X - BIT COUNTER 
//***********************************************************************************************************************************************
logic main_counter_reset;

always_comb begin
	if(is_DLY_mode) begin
		main_counter_reset <= delay_mode_cnt_reset;
	end else begin
		main_counter_reset <= reset_counter_mode;
	end
end


// load data to counter if is_CNT_mode after reset without another clk
logic load_counter_during_reset;
dff load_counter_dff (.d(1'b0), .clk(~clk), .clrn(i_reset_n & is_CNT_mode & (i_edge_reset_mode_select != High_level_Reset)), .prn(main_counter_reset), .q(load_counter_during_reset));

// proceed main counter
always_ff @(posedge clk, negedge main_counter_reset) begin
	if(~main_counter_reset) begin
		r_counter <= i_reset_set_mode ? (load_counter_during_reset ? (i_up ? (i_data_from_register + 1'b1) : (i_data_from_register - 1'b1)) : i_data_from_register) : (load_counter_during_reset ? i_data_from_register : '0);
	end else begin
		if(is_DLY_mode) begin
			r_counter <= delay_mode_cnt_allow ? (r_counter + 1'b1) : '0;
		end else begin
			if(i_up) begin
				r_counter <= i_keep ? r_counter : (r_counter + 1'b1);
			end else begin
				r_counter <= (r_counter == '0) ? i_data_from_register : (i_keep ? r_counter : (r_counter - 1'b1));
			end
		end
	end
end

//***********************************************************************************************************************************************
// MODE WIRE PARSING
//***********************************************************************************************************************************************

always_comb begin
	if(is_DLY_mode) begin
		o_out <= delay_mode_out;
	end else if(is_CNT_mode) begin
		o_out <= cnt_mode_out;
	end else if(is_Edge_Detect_mode) begin
		o_out <= o_edge_detect_out;
	end else begin
		o_out <= 1'b0;
	end
end

endmodule
