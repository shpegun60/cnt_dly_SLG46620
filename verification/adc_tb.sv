
`timescale 1ns / 100ps
import slg46620_cnt0_pkg::*;

interface signals_intf (input logic clk100Mhz, clk_100_delay, hardwareReset); // Define the interface
	logic [15:0] 	macrocell_clks;
	logic 		macrocell_sleep_state;
	
	logic macrocell_keep;
	
	logic macrocell_in;
	logic macrocell_out;
	
	logic macrocell_edge_detect_out;
	logic macrocell_resetin_timer;
	
endinterface: signals_intf
	
module top(

);


//***************************************************************************************************************************
// 								RESET/ CLK INIT
//***************************************************************************************************************************

parameter shortint delay	 = 5;
parameter shortint delay_clk = 3;
parameter shortint T = 20;                  // This is a number of clocking periods
parameter shortint rst_delay = T * delay;  // this is a reset delay which equal T clocks

logic clk = 0;   // CLOCK for the project
logic clk_delayed;   // CLOCK for the project
logic reset = 1; // RESET for the project

initial forever clk = #(delay) ~clk; // This is clocking frequency

assign #delay_clk clk_delayed = clk;
default clocking cb_clk100Mhz @(posedge clk); endclocking

task rst_genegate (shortint rst_length); // RESET task
	reset = 0;
	#rst_length;
	@(posedge clk);
	reset = 1;
endtask

initial begin: rst_gen
	reset_reg();
	#delay rst_genegate(rst_delay);
end: rst_gen  // RESET generating
//**************************************************************************************************************************
//               end
//***************************************************************************************************************************

signals_intf tb_intf(clk, clk_delayed, reset);

logic [31:0] r_cnt1 = '0;
logic [31:0] r_cnt2 = '0;
task reset_reg;
	tb_intf.macrocell_in <= '0;
	r_cnt1 <= '0;
	r_cnt2 <= '0;
	tb_intf.macrocell_resetin_timer <= '0;
	tb_intf.macrocell_keep <= '0;
endtask

/*
//--------------------------------------------------------------------------------------
//  DLY RISING EDGE TEST 
//--------------------------------------------------------------------------------------

assign tb_intf.macrocell_clks = {13'd0, tb_intf.clk_100_delay, tb_intf.macrocell_in ? tb_intf.clk100Mhz : 1'b1};
cnt_dly_macrocell SLG46620
(
	.i_clk_source_mux(4'd0),
	.i_clks(tb_intf.macrocell_clks),
	.i_reset_n(tb_intf.hardwareReset),

	.i_data_from_register(14'd2),
	
	.i_edge_reset_mode_select(Rising_Edge),
	.i_macrocell_function_select(DLY),
	
	.i_reset_set_mode(1'b0),
	
	//fsm mode
	.i_keep(1'b0),
	.i_up(1'b0),
	
	.i_in(tb_intf.macrocell_in),
	.o_out(tb_intf.macrocell_out)
);*/

/*
//--------------------------------------------------------------------------------------
//  DLY FALLING EDGE TEST 
//--------------------------------------------------------------------------------------

assign tb_intf.macrocell_clks = {13'd0, tb_intf.clk_100_delay, ((~tb_intf.macrocell_in) & tb_intf.macrocell_out) ? tb_intf.clk100Mhz : 1'b1};
cnt_dly_macrocell SLG46620
(
	.i_clk_source_mux(4'd0),
	.i_clks(tb_intf.macrocell_clks),
	.i_reset_n(tb_intf.hardwareReset),

	.i_data_from_register(14'd2),
	
	.i_edge_reset_mode_select(Falling_Edge),
	.i_macrocell_function_select(DLY),
	
	.i_reset_set_mode(1'b0),
	
	//fsm mode
	.i_keep(1'b0),
	.i_up(1'b0),
	
	.i_in(tb_intf.macrocell_in),
	.o_out(tb_intf.macrocell_out)
);
*/

//--------------------------------------------------------------------------------------
//  CNT TEST
//--------------------------------------------------------------------------------------
/*
assign tb_intf.macrocell_clks = {13'd0, ~tb_intf.clk100Mhz, tb_intf.macrocell_resetin_timer ? 1'b1 : tb_intf.clk_100_delay, tb_intf.clk100Mhz};

cnt_dly_macrocell SLG46620
(
	
	.i_clk_source_mux(4'd1),
	.i_clks(tb_intf.macrocell_clks),
	.i_reset_n(tb_intf.hardwareReset),

	.i_data_from_register(14'd6),
	
	.i_edge_reset_mode_select(Both_Edge_Reset),
	.i_macrocell_function_select(CNT),
	
	.i_reset_set_mode(1'b0),
	
	//fsm mode
	.i_keep(1'b0),
	.i_up(1'b0),
	
	
	.o_edge_detect_out(tb_intf.macrocell_edge_detect_out),
	.i_resetin_timer(tb_intf.macrocell_resetin_timer),
	
	.i_in(tb_intf.macrocell_in),
	.o_out(tb_intf.macrocell_out)
);
*/
//--------------------------------------------------------------------------------------
//  FSM TEST
//--------------------------------------------------------------------------------------

assign tb_intf.macrocell_clks = {13'd0, ~tb_intf.clk100Mhz, tb_intf.clk_100_delay, tb_intf.clk100Mhz};

cnt_dly_macrocell SLG46620
(
	.i_clk_source_mux(4'd1),
	.i_clks(tb_intf.macrocell_clks),
	.i_reset_n(tb_intf.hardwareReset),

	.i_data_from_register(14'h3ffb),
	
	.i_edge_reset_mode_select(Rising_Edge_Reset),
	.i_macrocell_function_select(CNT),
	
	
	.o_edge_detect_out(tb_intf.macrocell_edge_detect_out),
	.i_resetin_timer(tb_intf.macrocell_resetin_timer),
	.i_reset_set_mode(1'b0),
	
	//fsm mode
	.i_keep(tb_intf.macrocell_keep),
	.i_up(1'b1),
	
	.i_in(tb_intf.macrocell_in),
	.o_out(tb_intf.macrocell_out)
);


always_ff @(posedge tb_intf.clk100Mhz, negedge tb_intf.hardwareReset) begin
	if(~tb_intf.hardwareReset) begin
		tb_intf.macrocell_in <= 1'b0;
		r_cnt1 <= '0;
		r_cnt2 <= '0;
		tb_intf.macrocell_resetin_timer <= '0;
		tb_intf.macrocell_keep <= '0;
	end else begin
		r_cnt1 <= r_cnt1 + 1'b1;
		r_cnt2 <= r_cnt2 + 1'b1;
		
		if(r_cnt1 > 32'd0) begin
			r_cnt1 <= '0;
			tb_intf.macrocell_in <= ~tb_intf.macrocell_in;
			tb_intf.macrocell_keep <= ~tb_intf.macrocell_keep;
		end
		
		if(r_cnt2 > 32'd6) begin
			r_cnt2 <= '0;
			tb_intf.macrocell_resetin_timer <= ~tb_intf.macrocell_resetin_timer;
		end
		
	end
end


//**************************************************************************************************************
	
	
	
endmodule/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
