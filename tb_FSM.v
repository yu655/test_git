`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/11/18 17:01:34
// Design Name: 
// Module Name: tb_FSM
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module tb_FSM(

    );
    
    
    reg state1_to_state2;
    reg state2_to_state3;
    reg state4_to_state1;
    
    wire [3:0] state;
    wire [7:0] o_data1;
    wire [7:0] o_data2;
    
    reg i_sel;
    reg i_sel_valid;
    reg clk;
    reg rst;        ////大系统发令枪
    
    
    
     FSM u_FSM
     (
          .state1_to_state2  (state1_to_state2)  ,
          .state2_to_state3  (state2_to_state3)  ,
          .state4_to_state1  (state4_to_state1)  ,
          .state             (state)             ,
          .o_data1           (o_data1)           ,
          .o_data2           (o_data2)           ,
          .i_sel             (i_sel)             ,
          .i_sel_valid       (i_sel_valid)       ,
          .clk               (clk)               ,
          .rst               (rst)
    );
    
    parameter clock_period = 10;
    
    always # (clock_period/2) clk = ~clk;
    
    initial
    begin
        clk = 1'b0;
        rst = 1'b1;
        state1_to_state2 = 1'b0;
        state2_to_state3 = 1'b0;
        state4_to_state1 = 1'b0;
        i_sel = 1'b0;
        i_sel_valid = 1'b0;
        
    # (4 *  clock_period) rst = 1'b0;
    # (10 * clock_period) i_sel = 1'b1;
                         i_sel_valid = 1'b1;
                         
    # (clock_period)     i_sel_valid = 1'b0;    ///可有可无
    # (4 *  clock_period) state1_to_state2 = 1'b1;
    # (clock_period)     state1_to_state2 = 1'b0;
    
    # (20 *  clock_period) state2_to_state3 = 1'b1;
    # (clock_period)       state2_to_state3 = 1'b0;
    
    # (50 * clock_period ) state4_to_state1 = 1'b1;
    # (clock_period)       state4_to_state1 = 1'b0;
      
    # 400 $finish;
    
    end
    
    
    
endmodule
