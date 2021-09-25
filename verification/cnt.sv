import slg46620_cnt0_pkg::*;

module cnt_fsm_mode #(parameter BIT_WIDTH = 14)
(
	input logic 		i_clk,
	input logic			i_reset_n,
	
	input logic [1:0] 	i_edge_reset_mode_select,
	
	// cnt mode
	output logic o_edge_detect_out,
	input logic i_resetin_timer,
	
	//fsm mode
	input i_up,
	
	input logic  [(BIT_WIDTH - 1):0] i_counter,
	output logic 	o_cnt_reset,
	output logic 	o_out //output from counter mode logic (this pin must be connection to o_out in a case when [i_macrocell_function_select == CNT])
);

localparam logic[(BIT_WIDTH - 1) : 0] MAX_VALUE = '1;

//***********************************************************************************************************************************************
// Counter Mode OPERATIONS
//***********************************************************************************************************************************************

// reset counter mode logic-------------------------------------------------
logic [1:0] w_reset_edges; // [0] ==> posedge; [1] ==> negedge;


logic edge_detector_reset;
dff reset_edge_detector (.d(i_resetin_timer), .clk(i_clk), .clrn(i_reset_n), .prn(1'b1), .q(edge_detector_reset)); // D - latch (needed altera_primitives library for simulation)
assign w_reset_edges[0] = (~edge_detector_reset) & i_resetin_timer; // posedge detection fot resetin
assign w_reset_edges[1] = edge_detector_reset & (~i_resetin_timer); // negedge detection fot resetin


logic reset_counter_mode;
assign reset_counter_mode = i_reset_n & ~o_edge_detect_out;

always_comb begin
	
	unique case(i_edge_reset_mode_select)
		
		Both_Edge_Reset: begin
			o_edge_detect_out <= w_reset_edges[0] | w_reset_edges[1];
		end
		
		Falling_Edge_Reset: begin
			o_edge_detect_out <= w_reset_edges[1];
		end
		
		Rising_Edge_Reset: begin
			o_edge_detect_out <= w_reset_edges[0];
		end
		
		High_level_Reset: begin
			o_edge_detect_out <= i_resetin_timer;
		end
		
	endcase
end

//----------------------------------------------------
assign o_out = (i_counter == '0);//i_up ? (i_counter == MAX_VALUE) : (i_counter == '0);

assign o_cnt_reset = reset_counter_mode;

endmodule
