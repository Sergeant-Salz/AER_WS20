package Testbench;

import SimpleAlu ::*;

module mkTestbench(Empty);
	
	SimpleAlu dut <- mkSimpleAlu;
	IntPow dut2 <- mkIntPow;
	Reg#(Int#(8)) state <- mkReg(0);
	Reg#(Int#(32)) in_a <- mkReg(10);
	Reg#(Int#(32)) in_b <- mkReg(2);

	Reg#(Int#(32)) base_in <- mkReg(2);
	Reg#(Int#(4)) exp_in <- mkReg(3);

	rule count;
		state <= state + 1;
	endrule	

	rule s0 (state == 0);
			dut.setupCalculation(Mul, in_a, in_b);
			dut2.setValues(tuple2(base_in, exp_in));
	endrule

  rule s1 (state == 1);
      dut.setupCalculation(Div, in_a, in_b);
  endrule

  rule s2 (state == 2);
      dut.setupCalculation(Add, in_a, in_b);
  endrule

  rule s3 (state == 3);
      dut.setupCalculation(Sub, in_a, in_b);
  endrule

  rule s4 (state == 4);
      dut.setupCalculation(And, in_a, in_b);
  endrule

  rule s5 (state == 6);
      dut.setupCalculation(Or, in_a, in_b);
  endrule

	rule print1;
		let res = dut.getResult();
		$display("Result is %0d!", res);
	endrule

	rule print2;
		let res = dut2.getResult();
		$display("Exponent result is %0d", res);
	endrule


	rule finish (state == 10);
		$finish();
	endrule

endmodule



endpackage
