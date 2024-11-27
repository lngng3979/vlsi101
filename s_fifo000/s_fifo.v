`define WIDTH 8
`define DEPTH 8
`define CWIDTH 3
module sFIFO
(
    output reg[`WIDTH -1 : 0] Data_out,
    output fifoisfull, fifoisempty,
    input wire[`WIDTH -1 :0] Data_in,
    input i_wreq, i_rreq,
    input clk, reset_n
)
;
reg [`CWIDTH -1 :0] read_ptr , write_ptr; //pointers (addresses) for
                                           //reading or writting
reg [`CWIDTH : 0] ptr_diff; //gap between ptr
reg [`CWIDTH -1 :0] mem [`DEPTH]; //mem array

assign fifoisempty = (ptr_diff == 0)      ? 1'b1 : 1'b0;
assign fifoisfull  = (ptr_diff == `DEPTH) ? 1'b1 : 1'b0;

always@(posedge clk , negedge reset_n) begin
    if (!reset_n)
    begin
    Data_out <=0;
    read_ptr <=0;
    write_ptr <=0;
    ptr_diff <=0;

    end
    else begin
    if (i_rreq && !fifoisempty) begin
        Data_out <= mem[read_ptr];
        read_ptr <= read_ptr +1;
        ptr_diff <= ptr_diff -1;

    end
    if (i_wreq && !fifoisfull)begin
    mem[write_ptr]<=Data_in;
   write_ptr<=write_ptr +1;
   ptr_diff <= ptr_diff +1;
    end

end
end
endmodule