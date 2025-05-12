`define ADDR_WIDTH  4;
`define DATA_WIDTH  32;
`define GRANULE  8;
`define REGISTER_NUM  16;
`define SEL_WIDTH  DATA_WIDTH / GRANULE;

interface intf(input logic clk_i, rst_i);

  logic [ADDR_WIDTH-1:0] adr_o;       ///  master  to slave address
  logic [DATA_WIDTH-1:0] dat_i;       /// master recive from slave
  logic [DATA_WIDTH-1:0] dat_o;       //  master out data to slave
  logic  [SEL_WIDTH-1:0] sel_o;
  logic we_o;
  logic stb_o;
  logic ack_i;
  logic err_i;
  logic stall_i;
  logic cyc_o;
  


endinterface 