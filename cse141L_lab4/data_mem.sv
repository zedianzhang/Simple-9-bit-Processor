module data_mem(
  input              clk,
  input              reset,
  input [7:0]        DataAddress,
  input              ReadMem,
  input              WriteMem,
  input [7:0]        DataIn,
  output logic[7:0]  DataOut);

  logic [7:0] Core[256];

  always_comb           // combinational read logic
    if(ReadMem) begin
      DataOut = Core[DataAddress];
	  $display("Memory read M[%d] = %d",DataAddress,DataOut);
    end else
      DataOut = 'bZ;

  always_ff @ (posedge clk)		 // writes are sequential
    if(reset) begin
// you may initialize your memory w/ constants, if you wish
      for(int i=0;i<256;i++)
	    Core[i] <= 0;	 //    likewise
	end
    else if(WriteMem) begin
      Core[DataAddress] <= DataIn;
	  $display("Memory write M[%d] = %d",DataAddress,DataIn);
    end

endmodule
