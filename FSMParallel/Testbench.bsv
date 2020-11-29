package Testbench;

	import StmtFSM::*;

	module mkTestbench (Empty);

		Reg#(Bool) flag <- mkReg(False);

		mkAutoFSM(
            seq
                par
                    seq
                        action $display("Start message from seq block 1 at:", $time); endaction
                        delay(100);
                        flag <= True;
                    endseq
                    seq
                        repeat(10) $display("Message from seq block 2 at:", $time);
                    endseq
                endpar
                $display("End time is:", $time);
            endseq
		);

	endmodule
endpackage
