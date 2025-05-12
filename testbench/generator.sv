//-------------------------------------------------
//  www.verificationguide.com
//-------------------------------------------------
`include "transaction.sv"

class generator;
  
transaction trans;
  
  int  repeat_count;
  
  mailbox gen2driv;
  mailbox gen2scb;
  
  event ended;
  
  function new(mailbox gen2driv, mailbox gen2scb);
    
    this.gen2driv = gen2driv;
    this.gen2scb = gen2scb;
    
  endfunction
      
  task main();
    repeat(repeat_count) begin
    trans = new();
    if( !trans.randomize() ) $fatal("Gen:: trans randomization 			failed");
//       trans.adr_o = 10'd10;
//       trans.dat_o = 32'haabb_ccdd;
//       trans.sel_o = 4'b1111;
      trans.display("[ Generator ]");

      gen2driv.put(trans);
      gen2scb.put(trans);
    end
    -> ended; //triggering indicatesthe end of generation
  endtask
 

endclass