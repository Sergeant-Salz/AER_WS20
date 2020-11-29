package Testbench;

import SimpleCounter ::*;
import StmtFSM::*;

module mkTestbench(Empty);
	
	SimpleCounter dut <- mkSimpleCounter;
	
	mkAutoFSM(
            seq
				$display("Starting FSM at %d", $time);
				dut.incr(100);
				dut.decr(50);
				action
					dut.decr(10);
					dut.incr(5);
				endaction
				dut.load(999);
				action
					dut.decr(99);
					dut.incr(10);
					dut.load(555);
				endaction
				noAction;
            endseq
		);

endmodule

endpackage
