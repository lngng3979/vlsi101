module sfifo

#(parameter WIDTH = 8;
  parameter DEPTH = 1024;
  parameter CWIDTH = 10;
)

(
    //INPUT SIGNAL

input wire clk;
input wire resetn;
input wire [`WIDTH - 1 : 0] wdata;
input wire i_wreq;
input wire i_rreq; //list of core input

//OUTPUT SIGNAL

output reg o_wready;
output reg o_rready;
output reg [`WIDTH -1 : 0] rdata;
output reg fifo_isfull;
output reg fifo_isempty; //list of core output

);
 
reg [`CWIDTH :0] counter ; //indicate number of data in fifo

reg [(`CWIDTH -1) :0] rd_ptr; //current read pointer
reg [(`CWIDTH -1) :0] wr_ptr; //current write pointer

wire [(`WIDTH -1) :0] data_out; //data comes in the fifo
wire [(`WIDTH -1) :0] data_in; //data comes out the fifo

//INSTANTIATE MEMORY 

reg [(`WIDTH -1 ): 0] fifo_data [0 : (`DEPTH -1)];

//wire read = i_rreq;
//wire write = i_wreq;

assign data_out = rdata;
assign data_in = wdata;

always @(posedge clk or negedge resetn) begin
    if (!resetn) begin

    counter<=1'b0;
    rd_ptr <=1'b0;
    wr_ptr <=1'b0;

    end

    else begin
         if(i_wreq && !fifo_isfull)
         wr_ptr <= wr_ptr + 1   ;

         if (i_rreq && !fifo_isempty)
         rd_ptr <= rd_ptr + 1   ;

         if (i_rreq && i_wreq && !fifo_isempty )
         counter <= counter- 1  ;

         else if ( &&  && !fifo_isfull)
         counter <= counter +1  ;
    end
    end 

//fifoisempty signal 

always @(posedge clk or negedge resetn) begin
  
  if (!resetn) begin 
      fifo_isempty <= 1'b1;
  end

  else begin
     if (fifo_isempty && i_wreq )
          fifo_isempty <= 1'b0;
      
     if (fifo_isempty && i_wreq && i_wreq)
          fifo_isempty <= 1'b1;
       end
end

//fifo is full signal 
 always @(posedge clk or negedge resetn) begin
 if (!resetn) begin 
 fifo_isfull <= 1'b0;
 end
 else begin if ( fifo_isfull && i_rreq)
       fifo_isfull <= 1'b0;
            if ( fifo_isfull && i_wreq && i_rreq)
      fifo_isfull <= 1'b1;
 end 
 end

//o_wready 

always@(posedge clk or negedge resetn) begin
        if (!resetn)
        begin
        o_wready <=1'b1;
        end
        else begin
        if (fifo_isfull && i_rreq )
            o_wready <= 1'b1;
        if (fifo_isfull  && i_rreq && i_rreq )
            o_wready <= 1'b0;
        end
end

//o_rready

always@(posedge clk or negedge resetn) begin
if (!resetn)
begin
o_rready <= 1'b0;
end
else begin
if (fifo_isempty && i_wreq)
o_rready <=1'b0;
if (fifo_isempty && i_wreq && i_rreq)
o_rready <=1'b1;
end
end

always@(posedge clk , negedge resetn) begin
if (!resetn) begin
data_out <=1'b0;
counter  <=1'b0;
wr_ptr   <=1'b0;
rd_ptr   <=1'b0;
end


else 
begin
 if (i_rreq && o_rready) 
 begin 
  data_out <= fifo_data[rd_ptr];
  rd_ptr   <= rd_ptr + 1;
  counter  <= counter -1;
 end
if (i_wreq && o_wready)
begin
 data_in <= fifo_data[wr_ptr];
 wr_ptr <= wr_ptr +1;
 counter <= counter +1;
end
end
end

endmodule