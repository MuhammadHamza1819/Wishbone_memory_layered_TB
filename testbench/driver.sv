//-------------------------------------------------------------------------
//						www.verificationguide.com
//-------------------------------------------------------------------------
//gets the packet from generator and drive the transaction paket items into interface (interface is connected to DUT, so the items driven into interface signal will get driven in to DUT) 

class driver;
  
  //used to count the number of transactions
  int no_transactions;
  
  //creating virtual interface handle
  virtual intf vif;
  
  //creating mailbox handle
  mailbox gen2driv;
  
  //constructor
  function new(virtual intf vif, mailbox gen2driv);
    //getting the interface
    this.vif = vif;
    //getting the mailbox handles from  environment 
    this.gen2driv = gen2driv;
  endfunction
  
  //Reset task, Reset the Interface signals to default/initial values
  task reset;
    wait(vif.rst_i);
    
    $display("[ DRIVER ] ----- Reset Started -----");
    
    vif.adr_o <= 0;
    vif.dat_o <= 0;
    vif.sel_o <= 0;
    vif.we_o  <= 0;
    vif.stb_o <= 0;
    vif.cyc_o <= 0;

    wait(!vif.rst_i);
    $display("[ DRIVER ] ----- Reset Ended   -----");
  endtask
task run;
    forever begin
        transaction trans;
        gen2driv.get(trans);   // Transaction queue se data lena

        // ------------------ WRITE Transaction ------------------
        @(posedge vif.clk_i);
        vif.adr_o <= trans.adr_o; // Address set
        vif.dat_o <= trans.dat_o; // Data set
        vif.we_o  <= 1'b1;        // Write mode
        vif.sel_o <= trans.sel_o; // Select signal
        vif.stb_o <= 1'b1;        // Transaction valid
        vif.cyc_o <= 1'b1;        // Cycle start

        // Wait for ACK from Slave
      wait(vif.ack_i == 1'b1);  

        @(posedge vif.clk_i); // Latch data on ACK

        // Deassert signals after write
        vif.stb_o <= 1'b0;
        vif.cyc_o <= 1'b0;
        vif.we_o <= 1'b0;

        @(posedge vif.clk_i); // **WAIT ONE EXTRA CYCLE before read**

        // ------------------ READ Transaction ------------------
        @(posedge vif.clk_i);
        vif.adr_o <= trans.adr_o; // Address set
        vif.sel_o <= trans.sel_o; // Select signal
        vif.we_o  <= 1'b0;        // Read mode
        vif.stb_o <= 1'b1;        // Transaction valid
        vif.cyc_o <= 1'b1;        // Cycle start

        // Wait for ACK from Slave (Handle Wait States)
      wait(vif.ack_i == 1'b1);

        @(posedge vif.clk_i); // Latch Read Data

        // Read response from SLAVE
        trans.dat_i   = vif.dat_i;
        trans.ack_i   = vif.ack_i;
        trans.err_i   = vif.err_i;
        trans.stall_i = vif.stall_i;

        // Deassert signals after read
        vif.stb_o <= 1'b0;
        vif.cyc_o <= 1'b0;

        @(posedge vif.clk_i);
        trans.display("[ Driver ]");
        no_transactions++;
    end
endtask
  
endclass
  


  
  

