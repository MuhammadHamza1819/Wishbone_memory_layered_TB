//-------------------------------------------------------------------------
//				www.verificationguide.com   testbench.sv
//-------------------------------------------------------------------------
//tbench_top or testbench top, this is the top most file, in which DUT(Design Under Test) and Verification environment are connected. 
//-------------------------------------------------------------------------

//including interfcae and testcase files
`include "interface.sv"

//-------------------------[NOTE]---------------------------------
//Particular testcase can be run by uncommenting, and commenting the rest
`include "random_test.sv"
// `include "directed_test.sv"
//----------------------------------------------------------------

module tbench_top;
  
  //clock and reset signal declaration
  bit clk_i;
  bit rst_i;
  
  //clock generation
  always #5 clk_i = ~clk_i;
  
  //reset Generation
  initial begin
    rst_i = 1;
    #5 rst_i =0;
  end
  
  
  //creatinng instance of interface, inorder to connect DUT and testcase
  intf i_intf(clk_i,rst_i);
  
  //Testcase instance, interface handle is passed to test as an argument
  test t1(i_intf);
  
  //DUT instance, interface signals are connected to the DUT ports
  
wb_slave_memory DUT(
  .rst_i(i_intf.rst_i),
  .clk_i(i_intf.clk_i),
  .adr_i(i_intf.adr_o),
  .dat_i(i_intf.dat_o),
  .dat_o(i_intf.dat_i),
  .sel_i(i_intf.sel_o),
  .we_i(i_intf.we_o),
  .stb_i(i_intf.stb_o),
  .ack_o(i_intf.ack_i),
  .err_o(i_intf.err_i),
  .stall_o(i_intf.stall_i),
  .cyc_i(i_intf.cyc_o)
);


    reg [DATA_WIDTH-1:0] register_value [0:REGISTER_NUM-1];


  //enabling the wave dump
  initial begin 
    $dumpfile("dump.vcd"); $dumpvars;
  end
endmodule