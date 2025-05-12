
`include "generator.sv"
`include "driver.sv"
`include "monitor.sv"
`include "scoreboard.sv"

class environment;
  
  int repeatcount = 2;
  generator gen;
  driver driv;
  monitor mon;
  scoreboard scb;
  mailbox gen2driv;
  mailbox mon2scb;
  mailbox gen2scb;
  virtual intf vif;

  function new(virtual intf vif);
    this.vif = vif;
    gen2driv = new();
    mon2scb = new();
    gen2scb = new();
    gen = new(gen2driv, gen2scb);
    driv = new(vif, gen2driv);
    mon = new(mon2scb, repeatcount, vif);
    scb = new(gen2scb, mon2scb, repeatcount);
  endfunction

  task pre_test();
    driv.reset();
  endtask

  task test();
    fork
      gen.main();
      driv.run();
      mon.run();
      scb.run();
    join_any
  endtask

  task post_test();
    wait(gen.ended.triggered);
    wait(gen.repeat_count == driv.no_transactions);
  endtask

  task run();
    pre_test();
    test();
    post_test();
    $finish;
  endtask
endclass
