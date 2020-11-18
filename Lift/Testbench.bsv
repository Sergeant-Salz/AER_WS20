package Testbench;

	import Lift :: *;

	module mkTb(Empty);
	
		Ifc_Lift lift <- mkLift;
		Reg#(int) count <- mkReg(0);
		Reg#(int) testStage <- mkReg(0);
	
		rule liftRise (testStage == 0);
			lift.requestFloor(5);
			testStage <= 1;
			$display("Starting stage 0");
		endrule


		rule lifFall (testStage == 1);
			lift.requestFloor(2);
			testStage <= 2;
			$display("Starting stage 1");
		endrule

		rule incCount;
			count <= count + 1;
			
			if(count == 15) $finish(0);
		endrule


		rule log;
			$display("Stage %0d and floor %0d", count, lift.getFloor());
		endrule

	endmodule: mkTb
endpackage: Testbench
