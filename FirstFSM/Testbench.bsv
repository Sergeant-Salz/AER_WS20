package Testbench;

	import StmtFSM::*;

	module mkTestbench (Empty);

		Reg#(Int#(32)) count <- mkReg(0);

		mkAutoFSM(
			seq
				repeat (100) noAction;
				$display("Hello, World: %d", count);
			endseq
		);
	
		rule tick;

			count <= count + 1;
		endrule

	endmodule
endpackage
