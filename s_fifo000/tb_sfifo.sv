`timescale 1ns/1ps
module tb_FIFO();
parameter WIDTH = 8;
parameter DEPTH = 8; //1024
parameter CDEPTH = 3;  //10

wire [WIDTH -1 :0] Data_out;
wire fifoisfull, fifoisempty ;
reg [WIDTH -1 : 0] Data_in;
reg i_rreq, i_wreq,clk, reset_n;
wire [11:0] mem0 ,mem1, mem2, mem3, mem4, mem5, mem6,
mem7;

assign mem0 = M1.mem[0];
assign mem1 = M1.mem[1];
assign mem2 = M1.mem[2];
assign mem3 = M1.mem[3];
assign mem4 = M1.mem[4];
assign mem5 = M1.mem[5];
assign mem6 = M1.mem[6];
assign mem7 = M1.mem[7];

sFIFO M1(Data_out, fifoisempty, fifoisfull, Data_in, i_rreq, i_wreq, clk, reset_n);

always begin
clk =0;
forever #5 clk =~clk ;
end
initial #1500 $stop;
initial begin
#10 reset_n= 0;
#40 reset_n = 1;
#420 reset_n = 0;
#460 reset_n =1;
end
initial
fork
#80 Data_in =3 ;
forever #10 Data_in = Data_in +1;
join

initial fork
#80 i_wreq =1 ;
#480 i_wreq = 0;

#250 i_rreq = 1;
#350 i_rreq =0;

#420 i_wreq =1;
#480 i_wreq =0;
join
initial begin
$dumpfile("tb_sfifo.vcd");
$dumpvars();
#1500 $finish;
end

endmodule