import slg46620_cnt0_pkg::*;

module dly_mode #(parameter BIT_WIDTH = 14)
(
	input logic			i_reset_n,
	input logic 		i_clk,
	input logic [(BIT_WIDTH - 1):0] i_data_from_register,
	input logic [1:0] 	i_edge_reset_mode_select,
	
	input logic  [(BIT_WIDTH - 1):0] i_counter,
	output logic 	o_cnt_reset,
	output logic 	o_cnt_allow,
	input logic 	i_in,
	output logic 	o_out //output from delay mode logic (this pin must be connection to o_out in a case when [i_macrocell_function_select == DLY])
);

//***********************************************************************************************************************************************
// Delay Mode OPERATIONS
//***********************************************************************************************************************************************

// help wires -------------------
logic is_Both_Mode, is_Faling_Mode, is_Rising_Mode;
assign is_Both_Mode 	= (i_edge_reset_mode_select == Both_Edge); // is impossible in low power supply mode, must be one reference CLK
assign is_Faling_Mode 	= (i_edge_reset_mode_select == Falling_Edge);
assign is_Rising_Mode 	= (i_edge_reset_mode_select == Rising_Edge);
// ----------------------------

logic [1:0] w_in_edges; // [0] ==> posedge; [1] ==> negedge;

// combination logic of reset 
always_comb begin
	if(is_Rising_Mode) begin
		o_cnt_reset <= i_reset_n & i_in;
	end else begin
		o_cnt_reset <= i_reset_n & (~i_in);
	end
end

//// input posedge & negedge detector ---------------------
logic r_edge_detector;
dff in_edge_detector (.d(i_in), .clk(i_clk), .clrn(is_Rising_Mode ? o_cnt_reset : i_reset_n), .prn(is_Faling_Mode ? (~i_in) : 1'b1), .q(r_edge_detector)); // D - latch (needed altera_primitives library for simulation)
assign w_in_edges[0] = (~r_edge_detector) & i_in; // posedge detection for i_in
assign w_in_edges[1] = r_edge_detector & (~i_in); // negedge detection for i_in
//----------------------------------------------------


// allows output -------------------------------------------------
logic out_allow = 1'b0;
assign o_out = is_Rising_Mode ? (out_allow ? i_in : 1'b0) : (out_allow ? 1'b1 : i_in);
// ------------------------------------------------------------------------------

logic r_flag_was_edge = 1'b0;

always_ff @(posedge i_clk, negedge o_cnt_reset) begin
	if(~o_cnt_reset) begin
		out_allow <= is_Faling_Mode;
		r_flag_was_edge <= 1'b0;
	end else begin
		r_flag_was_edge <= w_in_edges[is_Faling_Mode] ? 1'b1 : r_flag_was_edge; // latching edge
		out_allow <= (i_counter == i_data_from_register) ? is_Rising_Mode : out_allow; // output driving for dly mode
	end
end

assign o_cnt_allow = (r_flag_was_edge | w_in_edges[is_Faling_Mode]); // if was edge counting timer

endmodule
