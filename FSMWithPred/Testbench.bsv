package Testbench;

    import StmtFSM::*;

	module mkTestbench (Empty);

        Reg#(Int#(32)) counter <- mkReg(0);
        PulseWire pw_fsm <- mkPulseWire();
        Reg#(Int#(32)) ii <- mkRegU;
        
        rule count;
            if(counter == 100) begin
                counter <= 0;
                pw_fsm.send();
            end else counter <= counter + 1;
        endrule

		FSM fsm <- mkFSMWithPred(
            seq
                for(ii<=0; ii<20; ii<=ii+1) seq
                    $display("Loop Nr. %d at time %d", ii,$time);
                endseq
                $finish;
            endseq,
            pw_fsm
		);

        rule startit;
            fsm.start;
        endrule

	endmodule
endpackage
