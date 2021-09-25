/******************************************************************************************************************/
package slg46620_cnt0_pkg;
	
	// CNT/DLY_X Clock Source Select------------------------------------------
	parameter logic[3:0] CK_RCOSC 						= 4'b0000;
	parameter logic[3:0] CK_RCOSC_DIV4 					= 4'b0001;
	parameter logic[3:0] CK_RCOSC_DIV12 				= 4'b0010;
	parameter logic[3:0] CK_RCOSC_DIV24 				= 4'b0011;
	parameter logic[3:0] CK_RCOSC_DIV64 				= 4'b0100;
	parameter logic[3:0] CNT_END1 						= 4'b0101;
	parameter logic[3:0] Matrix0_out72 					= 4'b0110;
	parameter logic[3:0] Matrix0_out72_divide_by_8 		= 4'b0111;
	parameter logic[3:0] CK_RINGOSC 					= 4'b1000;
	parameter logic[3:0] Matrix0_out83_SPI_SCLK			= 4'b1001;
	parameter logic[3:0] CK_LFOSC						= 4'b1010;
	parameter logic[3:0] CK_FSM_DIV256					= 4'b1011;
	parameter logic[3:0] CK_PWM 						= 4'b1100;
	parameter logic[3:0] Reserved1 						= 4'b1101;
	parameter logic[3:0] Reserved2 						= 4'b1110;
	parameter logic[3:0] Reserved3 						= 4'b1111;
	
	
	//DLY_X Edge Mode Select or CNT_X Reset Mode Select------------------------
	//<If DLY Mode>
	parameter logic[1:0] Both_Edge 			= 2'b00; // not implemented
	parameter logic[1:0] Falling_Edge 		= 2'b01;
	parameter logic[1:0] Rising_Edge 		= 2'b10;
	parameter logic[1:0] None			 	= 2'b11;
	
	//<If CNTReset Mode>
	parameter logic[1:0] Both_Edge_Reset 			= 2'b00;
	parameter logic[1:0] Falling_Edge_Reset 		= 2'b01;
	parameter logic[1:0] Rising_Edge_Reset 			= 2'b10;
	parameter logic[1:0] High_level_Reset 			= 2'b11;
	
	
	//CNT/DLY_X Macrocell Function Select ------------------------
	parameter logic[1:0] DLY 								= 2'b00;
	parameter logic[1:0] CNT 								= 2'b01;
	parameter logic[1:0] Edge_Detect 						= 2'b10;
	parameter logic[1:0] Wake_Sleep_Ratio_Control 			= 2'b11; // not understand which functtion do this mode ??????/
	
	
	//Wake Sleep Output State When WS Oscillator is Power Down ------------------------
	parameter logic Power_Down_Mode 		= 1'b0;
	parameter logic Normal_operation_State 	= 1'b1;
	
endpackage: slg46620_cnt0_pkg
/******************************************************************************************************************/
