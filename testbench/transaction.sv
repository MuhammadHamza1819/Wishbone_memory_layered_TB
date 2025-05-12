`define ADDR_WIDTH = 4;
`define DATA_WIDTH = 32;
`define GRANULE = 8;
`define REGISTER_NUM = 16;
`define SEL_WIDTH = DATA_WIDTH / GRANULE;


class transaction;
  
  randc bit [ADDR_WIDTH-1:0] adr_o;	
  randc bit[DATA_WIDTH-1:0] dat_o;
  randc bit [SEL_WIDTH-1:0]  sel_o;
  
  bit      [DATA_WIDTH-1:0] dat_i;
  bit ack_i;
  bit err_i;
  bit stall_i;
  bit we_o;
  bit cyc_o;
//  virtual intf vif;

  function void display(string name);
    $display("-------------------------");
    $display("- %s ",name);
    $display("-------------------------");
    $display("-Write_enable = %b",we_o);
    $display("- data_out from master = %h, address = %0d",dat_o, adr_o); 
    $display("- byte_selector = %b",sel_o);
	
    $display("- recived data = %h", dat_i);
//     $display("- ack_from_slave = %0d", ack_);

    $display("-------------------------");

  endfunction  
  
endclass