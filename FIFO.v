module FIFO_final(clk, datain, reset, r_en, w_en, dataout, empty, full, count );
input clk;
input reset;
input [7:0]datain;
input r_en;
input w_en;

output [7:0]dataout;
output empty;
output full;
output count; 

//parameter MEMORY_DEPTH = 5;
reg [3:0]count;
reg [7:0]memory[7:0];
reg [2:0]wr_p, rd_p;
reg full, empty;
reg [7:0]dataout;

// reading data out from the FIFO
always @( posedge clk or posedge reset)
begin
   if( reset )
   begin
      dataout <= 0;
      [7:0]memory[7:0] = '{8'h0,8'h0,8'h0,8'h0,8'h0,8'h0,8'h0,8'h0}; 
   end
   else
   begin
      if( r_en && !empty )
         dataout <= memory[rd_p];

      else
         dataout <= dataout;

   end
end

//writing data in the FIFO
always @(posedge clk)
begin
   if( w_en && !full )
      memory[wr_p] <= datain;

   else
      memory[wr_p] <= memory[wr_p];
end



//pointer increment system
always @ (posedge clk or posedge reset)
begin 
	if(reset)
	begin
		wr_p <= 0;
		rd_p <= 0;
	end
	else
	begin
		if(!full && w_en)
		wr_p <= wr_p+1;
		else
		wr_p <= wr_p;
			
		if(!empty && r_en)
		rd_p <= rd_p+1;
		else
		rd_p <= rd_p;
	end
end

// code for counting
always @(posedge clk or posedge reset)
begin
   if( reset )
       count <= 0;

   else if( (!full && w_en) && ( !empty && r_en ) )
       count <= count;

   else if( !full && w_en )
       count <= count + 1;

   else if( !empty && r_en )
       count <= count - 1;
   else
      count <= count;
end

//for full and empty
always @(count)
begin
if(count==0)
  empty = 1 ;
  else
  empty = 0;

  if(count==8)
   full = 1;
   else
   full = 0;
end

endmodule
