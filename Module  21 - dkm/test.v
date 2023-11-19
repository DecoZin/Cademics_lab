`timescale 1 ns / 100 ps

module test;
 
  // nets and variables
  reg        CLK             ;
  reg        RST             ;
  reg        LOAD_COINS      ;
  reg        LOAD_CANS       ;
  reg  [7:0] NICKELS         ;
  reg  [7:0] DIMES           ;
  reg  [7:0] CANS            ;
  reg        NICKEL_IN       ;
  reg        DIME_IN         ;
  reg        QUARTER_IN      ;
  wire       EMPTY           ;
  wire       DISPENSE        ;
  wire       NICKEL_OUT      ;
  wire       DIME_OUT        ;
  wire       TWO_DIME_OUT    ;
  wire       USE_EXACT       ;

  // instance of drink machine
  dkm
  dkm_inst
  (
    CLK             ,
    RST             ,
    LOAD_COINS      ,
    LOAD_CANS       ,
    NICKELS         ,
    DIMES           ,
    CANS            ,
    NICKEL_IN       ,
    DIME_IN         ,
    QUARTER_IN      ,
    EMPTY           ,
    DISPENSE        ,
    NICKEL_OUT      ,
    DIME_OUT        ,
    TWO_DIME_OUT    ,
    USE_EXACT        
  );


  task reset;
    begin
      @(negedge CLK);
      RST        <= 1 ;
      LOAD_COINS <= 0 ;
      LOAD_CANS  <= 0 ;
      NICKEL_IN  <= 0 ;
      DIME_IN    <= 0 ;
      QUARTER_IN <= 0 ;
      @(negedge CLK);
      RST        <= 0 ;
    end
  endtask

  task add_coins;
    input integer nickels  ;
    input integer dimes    ;
    begin
      @(negedge CLK);
      NICKELS    <= nickels ;
      DIMES      <= dimes   ;
      LOAD_COINS <= 1       ;
      @(negedge CLK);
      LOAD_COINS <= 0       ;
    end
  endtask

  task add_cans;
    input integer cans ;
    begin
      @(negedge CLK);
      CANS      <= cans    ;
      LOAD_CANS <= 1       ;
      @(negedge CLK);
      LOAD_CANS <= 0       ;
    end
  endtask

  task insert_nickel;
    begin
      @(negedge CLK);
      NICKEL_IN <= 1 ;
      @(negedge CLK);
      NICKEL_IN <= 0 ;
    end
  endtask

  task insert_dime;
    begin
      @(negedge CLK);
      DIME_IN <= 1 ;
      @(negedge CLK);
      DIME_IN <= 0 ;
    end
  endtask

  task insert_quarter;
    begin
      @(negedge CLK);
      QUARTER_IN <= 1 ;
      @(negedge CLK);
      QUARTER_IN <= 0 ;
    end
  endtask

  task expect;
    input  expect_empty        ;
    input  expect_dispense     ;
    input  expect_nickel_out   ;
    input  expect_dime_out     ;
    input  expect_two_dime_out ;
    input  expect_use_exact    ;
    if ( EMPTY        !== expect_empty
      || DISPENSE     !== expect_dispense
      || NICKEL_OUT   !== expect_nickel_out
      || DIME_OUT     !== expect_dime_out
      || TWO_DIME_OUT !== expect_two_dime_out
      || USE_EXACT    !== expect_use_exact )
      begin
      //TODO: ADD THE INSTRUCTED CODE HERE
      $display("Test Failed:"); 
      if (EMPTY        !== expect_empty       ) $display("EMPTY Failed:       \n	 Expect EMPTY: %b        \n	 EMPTY: %b"       , expect_empty       , EMPTY       );
			if (DISPENSE     !== expect_dispense    ) $display("DISPENSE Failed:    \n	 Expect DISPENSE: %b     \n	 DISPENSE: %b"    , expect_dispense    , DISPENSE    );
			if (NICKEL_OUT   !== expect_nickel_out  ) $display("NICKEL_OUT Failed:  \n	 Expect NICKEL_OUT: %b   \n	 NICKEL_OUT: %b"  , expect_nickel_out   , NICKEL_OUT );
			if (DIME_OUT     !== expect_dime_out    ) $display("DIME_OUT Failed:    \n	 Expect DIME_OUT: %b     \n	 DIME_OUT: %b"    , expect_dime_out    , DIME_OUT    );
			if (TWO_DIME_OUT !== expect_two_dime_out) $display("TWO_DIME_OUT Failed:\n	 Expect TWO_DIME_OUT: %b \n	 TWO_DIME_OUT: %b", expect_two_dime_out, TWO_DIME_OUT);
			if (USE_EXACT    !== expect_use_exact   ) $display("USE_EXACT Failed:   \n	 Expect USE_EXACT: %b    \n	 USE_EXACT: %b"   , expect_use_exact   , USE_EXACT   );
			$display("Time: %t", $realtime);
			$finish;
      end
  endtask

  // clock
  initial repeat (62) begin CLK=1; #0.5; CLK=0; #0.5; end
  
  //Monitor
  initial
		begin: MONITOR
			integer monitor_file;
			monitor_file = $fopen("monitor.txt");
			$timeformat(-9, 1, "", 4);
			$fmonitor(monitor_file, "Time: %t - RST: %b | LOAD_COINS: %b | LOAD_CANS: %b | NICKELS: %h | DIMES: %h | CANS: %h | NICKEL_IN: %b | DIME_IN: %b | QUARTER_IN: %b | EMPTY: %b | DISPENSE: %b | NICKEL_OUT: %b | DIME_OUT: %b | TWO_DIME_OUT: %b | USE_EXACT: %b",
								$realtime, RST, LOAD_COINS, LOAD_CANS, NICKELS, DIMES, CANS, NICKEL_IN, DIME_IN, QUARTER_IN, EMPTY, DISPENSE, NICKEL_OUT, DIME_OUT, TWO_DIME_OUT, USE_EXACT);
			$dumpfile();
			$dumpvars(1, dkm_inst, dkm_inst.count_cans, dkm_inst.count_nickels, dkm_inst.count_dimes, dkm_inst.count_deposit);
			$dumpports(dkm_inst);
		end

  initial
    begin : TEST
      integer interactive;
      $display ("CANS 1 ;  COINS 0,0 ;  INSERT 0,0,2"); // 50
      reset;           expect (1, 0, 0, 0, 0, 1); // EMPTY, USE_EXACT
      add_cans(1);     expect (0, 0, 0, 0, 0, 1); // USE_EXACT
      insert_quarter;  expect (0, 0, 0, 0, 0, 1); // USE_EXACT
      insert_quarter;  expect (1, 1, 0, 0, 0, 1); // EMPTY, DISPENSE, USE_EXACT
      $display ("CANS 1 ;  COINS 1,2 ;  INSERT 0,3,1"); // 55
      reset;           expect (1, 0, 0, 0, 0, 1); // EMPTY, USE_EXACT
      add_cans(1);     expect (0, 0, 0, 0, 0, 1); // USE_EXACT
      add_coins(1,2);  expect (0, 0, 0, 0, 0, 0);
      insert_dime;     expect (0, 0, 0, 0, 0, 0);
      insert_dime;     expect (0, 0, 0, 0, 0, 0);
      insert_dime;     expect (0, 0, 0, 0, 0, 0);
      insert_quarter;  expect (1, 1, 1, 0, 0, 1); // EMPTY, DISPENSE, NICKEL_OUT, USE_EXACT
      $display ("CANS 1 ;  COINS 1,2 ;  INSERT 0,1,2"); // 60
      reset;           expect (1, 0, 0, 0, 0, 1); // EMPTY, USE_EXACT
      add_cans(1);     expect (0, 0, 0, 0, 0, 1); // USE_EXACT
      add_coins(1,2);  expect (0, 0, 0, 0, 0, 0);
      insert_dime;     expect (0, 0, 0, 0, 0, 0);
      insert_quarter;  expect (0, 0, 0, 0, 0, 0);
      insert_quarter;  expect (1, 1, 0, 1, 0, 1); // EMPTY, DISPENSE, DIME_OUT, USE_EXACT
      $display ("CANS 1 ;  COINS 2,3 ;  INSERT 1,1,2"); // 65
      reset;           expect (1, 0, 0, 0, 0, 1); // EMPTY, USE_EXACT
      add_cans(1);     expect (0, 0, 0, 0, 0, 1); // USE_EXACT
      add_coins(2,3);  expect (0, 0, 0, 0, 0, 0);
      insert_nickel;   expect (0, 0, 0, 0, 0, 0);
      insert_dime;     expect (0, 0, 0, 0, 0, 0);
      insert_quarter;  expect (0, 0, 0, 0, 0, 0);
      insert_quarter;  expect (1, 1, 1, 1, 0, 0); // EMPTY, DISPENSE, NICKEL_OUT, DIME_OUT
      $display ("CANS 1 ;  COINS 1,4 ;  INSERT 1,1,2"); // 70
      reset;           expect (1, 0, 0, 0, 0, 1); // EMPTY, USE_EXACT
      add_cans(1);     expect (0, 0, 0, 0, 0, 1); // USE_EXACT
      add_coins(1,4);  expect (0, 0, 0, 0, 0, 0);
      insert_dime;     expect (0, 0, 0, 0, 0, 0);
      insert_dime;     expect (0, 0, 0, 0, 0, 0);
      insert_quarter;  expect (0, 0, 0, 0, 0, 0);
      insert_quarter;  expect (1, 1, 0, 0, 1, 0); // EMPTY, DISPENSE, TWO_DIME_OUT
      if ($test$plusargs("INTERACTIVE"))
        begin : INTERACTIVE
          integer interactive, error_code;
          reg [7:0] character; reg [1:81*8] line;
          add_cans(42);
          add_coins(42,86);
          if ($value$plusargs("INTERACTIVE=%d",interactive))
            while (interactive)
              begin
                $fwrite (32'h8000_0001,"Insert coin [n,d,q] : ");
                character = $fgetc (32'h8000_0000);
                error_code = $fgets (line,32'h8000_0000); // discard remainder
                case (character)
                  "n" : insert_nickel;
                  "d" : insert_dime;
                  "q" : insert_quarter;
                  default : interactive = 0;
                endcase
                if (interactive && DISPENSE)
                  $fdisplay (32'h8000_0001, "Enjoy your drink! Change back is %0d nickel%s and %0d dime%s and the machine is %s",
                             (NICKEL_OUT?1:0), (NICKEL_OUT?"":"s"),
                             (TWO_DIME_OUT?2:DIME_OUT?1:0),(DIME_OUT?"":"s"),
                             (EMPTY?"empty":"not empty"));
              end
        end // INTERACTIVE
      $display("Test Passed!");
      $finish;
    end

endmodule