`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/11/18 16:34:33
// Design Name: 
// Module Name: FSM
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
////state1: output state = 1;  /// 配置sel信号
///state2:  output data1 = 0-9循环，或者10-20循环，取决于sel，output state = 2
///state3： output data2 = 0-20， output state 3,结束后跳转state4
///state4： output state = 4   ///结束，等待信号复位至state1。
////////////////

module FSM(
    input state1_to_state2,
    input state2_to_state3,
    input state4_to_state1,
    output [3:0] state,
    output [7:0] o_data1,
    output [7:0] o_data2,
    
    input i_sel,
    input i_sel_valid,
    
    input clk,
    input rst         ////大系统发令枪

    );
    ///////////////////状态机范例程序////////////////////////////////////
    
    localparam STATE1 = 4'b0000;
    localparam STATE2 = 4'b0001;
    localparam STATE3 = 4'b0010;
    localparam STATE4 = 4'b0100;
    
    wire [3:0] state_nxt;
    wire [3:0] state_r;
    wire state_ena;
    
    wire isstate1 = (state_r == STATE1);
    wire isstate2 = (state_r == STATE2);
    wire isstate3 = (state_r == STATE3);
    wire isstate4 = (state_r == STATE4);
    
    wire state1_2_state2 = isstate1 & state1_to_state2;
    wire state2_2_state3 = isstate2 & state2_to_state3;
    wire state3_2_state4 = isstate3 & (counter2_r == 8'd20);
    wire state4_2_state1 = isstate4 & state4_to_state1;
    
    assign state_ena = state1_2_state2 | state2_2_state3 | state3_2_state4 | state4_2_state1;
    assign state_nxt = ( {4{state1_2_state2}} &  STATE2 ) | ( {4{state2_2_state3}} &  STATE3 ) |( {4{state3_2_state4}} &  STATE4 ) |( {4{state4_2_state1}} &  STATE1 );
    
    sirv_gnrl_dfflr # (
4) state_reg ( state_ena , state_nxt , state_r , clk , rst);
    
    ////////寄存器 sel信号//////////////////////////////////////////////////////////////
    
    wire sel_nxt;
    wire sel_r;
    wire sel_ena;
    
    assign sel_nxt = i_sel;
    assign sel_ena = isstate1 & i_sel_valid;
    sirv_gnrl_dfflr # (1) sel_reg ( sel_ena , sel_nxt , sel_r , clk , rst);
   
    
    ////////////////////////////////////////////////////////////////////////////////
    ///////////////计数器范例程序 /////////////////////////////////////////////////
    ///////////////////////////////////////////////////////////////////////////////
    ////////counter1 ////////////////////////////////////////////////////////////
    wire [7:0] counter1_pre_nxt;
    wire [7:0] counter1_pre_r;
    wire  counter1_pre_ena;
    
    assign counter1_pre_ena = isstate2;
    assign counter1_pre_nxt = (counter1_pre_r == 8'd9) ? 8'd0 : (counter1_pre_r + 8'd1);
    sirv_gnrl_dfflr # (8) counter1_pre_reg ( counter1_pre_ena , counter1_pre_nxt , counter1_pre_r , clk , rst);
    
    ////////count2//////////////////////////////////////////////////////////////
    
    wire [7:0] counter2_nxt;
    wire [7:0] counter2_r;
    wire  counter2_ena;
    
    assign counter2_ena = isstate3;
    assign counter2_nxt = (counter2_r == 8'd20) ? 8'd0 : (counter2_r + 8'd1);
    sirv_gnrl_dfflr # (8) counter2_reg ( counter2_ena , counter2_nxt , counter2_r , clk , rst);
    
    //////////////////////////////////////////////////////////////////////////////////
    ////////////////output //////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////////
    assign state = state_r;
    assign o_data1 = {8{isstate2}} & (sel_r ? (counter1_pre_r+ 8'd10) : counter1_pre_r );
    assign o_data2 = {8{isstate3}} & counter2_r;
    
    
    
endmodule
