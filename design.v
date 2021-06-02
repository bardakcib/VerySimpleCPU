`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:28:59 12/06/2020 
// Design Name: 
// Module Name:    design 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module VerySimpleCpu(clk,rst,data_fromRAM,wrEn,addr_toRAM,data_toRAM);

parameter SIZE  = 14;

input clk,rst;
input wire [31:0] data_fromRAM;
output reg wrEn;
output reg [SIZE-1:0] addr_toRAM;
output reg [31:0] data_toRAM;

//////////////////////////
// write your design here

//////////////////////////
reg [3:0] state_current, state_next;
reg[SIZE-1:0] pc_current , pc_next ; //program counter
reg[31:0] iw_current , iw_next ;		//intruction word
reg[31:0] r1_current , r1_next ;
reg[31:0] r2_current , r2_next;

always@(posedge clk)begin 
			if(rst)begin
					state_current <= 0; 
					pc_current <= 14'b0 ; 
					iw_current <= 32'b0 ; 
					r1_current <= 32'b0 ; 
					r2_current <= 32'b0 ;
			end 
			else begin
					state_current <= state_next ; 
					pc_current  	<= pc_next ;
					iw_current  	<= iw_next ; 
					r1_current 		<= r1_next ;
					r2_current 		<= r2_next ;
			end
end

			always@(*)begin
						state_next = state_current ; 
						pc_next  =  pc_current ; 
						iw_next =   iw_current  ; 
						r1_next =  r1_current ; 
						r2_next = r2_current ;
						wrEn = 0;
						addr_toRAM = 0;
						data_toRAM = 0; 
						
						case(state_current)
									
							0:begin
									pc_next = 0;
									iw_next = 0;
									r1_next = 0;
									r2_next = 0;
									state_next = 1; 
							end
							1:begin
									addr_toRAM = pc_current ;
									state_next = 2;
							end 
							2:begin
									iw_next = data_fromRAM; 
									case(data_fromRAM[31:28])
												//Add Instruction. from vscpu-add from moodle
												//unsigned add
												{3'b000,1'b0}:begin 
															addr_toRAM = data_fromRAM[27:14];
															state_next = 3;
												end
												//ADDi Instruction
												//unsigned add, immediate
												{3'b000,1'b1}: begin 
												addr_toRAM = data_fromRAM[27:14];
												state_next = 5;
												end
												//NAND Instruction
												//bitwise NAND
												{3'b001,1'b0}: begin 
													addr_toRAM = data_fromRAM[27:14];
													state_next = 3;
												end
												//NANDi Instruction
												//bitwise NAND, immediate
												{3'b001,1'b1}: begin 
													addr_toRAM = data_fromRAM[27:14];
													state_next = 5;
												end
												//SRL Instruction
												//shift right/left
												{3'b010,1'b0}: begin 
													addr_toRAM = data_fromRAM[27:14];
													state_next = 3;
												end
												//CPi Instruction
												//shift right/left, immediate
												{3'b100,1'b1}: begin 
													addr_toRAM = data_fromRAM[27:14];
													r1_next = data_fromRAM[13:0];
													state_next = 5;
												end
												//SRLi Instruction
												//((//
												{3'b010,1'b1}: begin 
													addr_toRAM = data_fromRAM[27:14];
													state_next = 5;
												end
												//LT Instruction
												//compare and set
												{3'b011,1'b0}: begin
													addr_toRAM = data_fromRAM[27:14];
													state_next = 3;
												end
												//LTi Instruction
												//compare and set, immediate
												{3'b011,1'b1}: begin 
													addr_toRAM = data_fromRAM[27:14];
													state_next = 5;
												end
												//MUL Instruction
												//unsigned multiply
												{3'b111,1'b0}: begin 
													addr_toRAM = data_fromRAM[27:14];
													state_next = 3;
												end
												//MULi Instruction
												//unsigned multiply, immediate
												{3'b111,1'b1}: begin 
													addr_toRAM = data_fromRAM[27:14];
													state_next = 5;
												end
												
												//data transfer intructions
												//CP Instruction
												//copy data
												{3'b100,1'b0}: begin 
													addr_toRAM = data_fromRAM[13:0];
													state_next = 5;
												end				
												//CPi Instruction   //NO NEED FOR STEP 4
												//copy data immediate
												{3'b100,1'b1}: begin 
													wrEn = 1;
													addr_toRAM = iw_current[27:14];
													data_toRAM = iw_current[13:0];
													pc_next = pc_current + 1'b1;
													state_next = 1;
												end
												//CPI Instruction
												//copy data indirect
												{3'b101,1'b0}: begin 
													addr_toRAM = data_fromRAM[13:0];
													state_next = 4;
												end
												//CPIi Instruction
												//copy data indirect
												{3'b101,1'b1}: begin 
													addr_toRAM = data_fromRAM[27:14];
													state_next = 3;
												end
												
												//program control instructions
												//BZJ Instruction
												//branch on zero
												{3'b110,1'b0}: begin 
													addr_toRAM = data_fromRAM[27:14];
													state_next = 3;
												end
												//BZJi Instruction
												//unconditional branch
												{3'b110,1'b1}: begin 
													addr_toRAM = data_fromRAM[27:14];
													state_next = 5;
												end
												default:begin
														pc_next = pc_current ; 
														state_next = 1;
												end 
									endcase
								end 
								3:begin
											r1_next = data_fromRAM ; 
											addr_toRAM = iw_current[13:0]; 
											state_next = 5;
								end 
								4:begin
											addr_toRAM=data_fromRAM;
											state_next = 5;
								end	
								5:begin
											case(iw_current[31:28])
												//ADD
												{3'b000,1'b0}: begin
													wrEn = 1;
													addr_toRAM = iw_current[27:14];
													data_toRAM = data_fromRAM + r1_current;
													pc_next = pc_current + 1'b1;
													state_next = 1;
												end
												//ADDi
												{3'b000,1'b1}: begin 
													wrEn = 1;
													addr_toRAM = iw_current[27:14];
													data_toRAM = data_fromRAM + iw_current[13:0];
													pc_next = pc_current + 1'b1;
													state_next = 1;
												end
												//NAND
												{3'b001,1'b0}: begin 
													wrEn = 1;
													addr_toRAM = iw_current[27:14];
													data_toRAM = ~(data_fromRAM & r1_current);
													pc_next = pc_current + 1'b1;
													state_next = 1;
												end
												//NANDi
												{3'b001,1'b1}: begin 
													wrEn = 1;
													addr_toRAM = iw_current[27:14];
													data_toRAM = ~(data_fromRAM & iw_current[13:0]);
													pc_next = pc_current + 1'b1;
													state_next = 1;
												end
												//SRL
												{3'b010,1'b0}: begin 
													wrEn = 1;
													addr_toRAM = iw_current[27:14];
													data_toRAM = (data_fromRAM < 14'd32) ? (r1_current >> data_fromRAM) : (r1_current << (data_fromRAM - 14'd32));
													pc_next = pc_current + 1'b1;
													state_next = 1;
												end
												//SRLi
												{3'b010,1'b1}: begin 
													wrEn = 1;
													addr_toRAM = iw_current[27:14];
													data_toRAM = (iw_current[13:0] < 14'd32) ? (data_fromRAM >> iw_current[13:0]) : (data_fromRAM << (iw_current[13:0] - 14'd32)); 
													pc_next = pc_current + 1'b1;
													state_next = 1;
												end
												//LT
												{3'b011,1'b0}: begin
													wrEn = 1;
													addr_toRAM = iw_current[27:14];
													data_toRAM = (r1_current < data_fromRAM) ? 1 : 0; 
													pc_next = pc_current + 1'b1;
													state_next = 1;
												end
												//LTi
												{3'b011,1'b1}: begin 
													wrEn = 1;
													addr_toRAM = iw_current[27:14];
													data_toRAM = (data_fromRAM < iw_current[13:0]) ? 1 : 0; 
													pc_next = pc_current + 1'b1;
													state_next = 1;
												end
												//MUL
												{3'b111,1'b0}: begin 
													wrEn = 1;
													addr_toRAM = iw_current[27:14];
													data_toRAM = data_fromRAM * r1_current;
													pc_next = pc_current + 1'b1;
													state_next = 1;
												end
												//MULi
												{3'b111,1'b1}: begin
													wrEn = 1;
													addr_toRAM = iw_current[27:14];
													data_toRAM = data_fromRAM * iw_current[13:0];
													pc_next = pc_current + 1'b1;
													state_next = 1;
												end		
												//CP
												{3'b100,1'b0}: begin
													wrEn = 1;
													addr_toRAM = iw_current[27:14];
													data_toRAM = data_fromRAM;
													pc_next = pc_current + 1'b1;
													state_next = 1;
												end
												//CPI
												{3'b101,1'b0}: begin 
													wrEn = 1;
													addr_toRAM = iw_current[27:14];
													data_toRAM = data_fromRAM;
													pc_next = pc_current + 1'b1;
													state_next = 1;
												end
												//CPi
												{3'b100,1'b1}: begin
													wrEn = 1;
													addr_toRAM = iw_current[27:14];
													data_toRAM = r1_current;
													pc_next = pc_current + 1'b1;
													state_next = 1;
												end
												//CPIi
												{3'b101,1'b1}: begin 
													wrEn = 1;
													addr_toRAM = r1_current;
													data_toRAM = data_fromRAM;
													pc_next = pc_current + 1'b1;
													state_next = 1;
												end
												//BZJ
												{3'b110,1'b0}: begin 
													pc_next = (data_fromRAM == 0) ? r1_current : (pc_current + 1'b1); 
													state_next = 1;
												end
												//BZJi
												{3'b110,1'b1}: begin
													pc_next = 	iw_current[13:0] + data_fromRAM;
													state_next = 1;
												end
									endcase 
							end
				endcase
		end		
endmodule
