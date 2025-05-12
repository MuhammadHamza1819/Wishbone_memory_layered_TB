class scoreboard;
  mailbox mon2scb, gen2scb;
  int repeat_count;
  
  function new(mailbox gen2scb, mailbox mon2scb, int repeat_count);
    this.gen2scb = gen2scb;
    this.mon2scb = mon2scb;
    this.repeat_count = repeat_count;
  endfunction
  
  task run();
    transaction t_fromgen, t_frommon;
    int ncount = 0, nsuccess = 0, nfails = 0;
    
    while (ncount < repeat_count) begin
      gen2scb.get(t_fromgen);
      mon2scb.get(t_frommon);
      
      if (t_fromgen.dat_o != t_frommon.dat_i) begin
        nfails++;
        $display("[ Scoreboard ] Mismatch: Expected = %h, Received = %h", t_fromgen.dat_o, t_frommon.dat_i);
      end else begin
        nsuccess++;
      end
      
      ncount++;
    end
    
    $display("Total Success = %0d, Total Failures = %0d", nsuccess, nfails);
  endtask
endclass

