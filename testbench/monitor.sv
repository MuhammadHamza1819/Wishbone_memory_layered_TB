class monitor; 
   
  mailbox mon2scb;
  int repeat_count;
  virtual intf vif;
  
  function new(mailbox mon2scb, int repeat_count, virtual intf vif); 
    this.mon2scb = mon2scb;
    this.repeat_count = repeat_count; 
    this.vif = vif;
  endfunction

  task run(); 
    transaction trans = new(); 
    int ncount = 0;

    while(ncount < repeat_count) begin
      @(posedge vif.clk_i);    

      // **Write Transaction Monitoring**
      if (vif.stb_o && vif.cyc_o) begin 
        trans.adr_o  = vif.adr_o;
        trans.sel_o  = vif.sel_o;
        trans.we_o   = vif.we_o;
        
        if (vif.we_o) 
          trans.dat_o = vif.dat_o;

        wait(vif.ack_i == 1'b1);  // Wait for Slave Acknowledgment
        @(posedge vif.clk_i);     // Next cycle

        // **Read Transaction Monitoring**
        if (!vif.we_o) 
        trans.dat_i = vif.dat_i;

        trans.ack_i   = vif.ack_i;
        trans.stall_i = vif.stall_i;
        trans.err_i   = vif.err_i;
                
        mon2scb.put(trans); 
        trans.display("[Monitor]"); 

        wait(!vif.cyc_o && !vif.stb_o);  // Wait until cycle ends

        ncount++;
      end
    end  
  endtask  
endclass
