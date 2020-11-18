package BlinkCounter;

	module mkBlinkCounter(Empty);

		Reg#(UInt#(25)) counter <- mkReg(0);

		rule count;
			counter <= counter +1;
		endrule

		rule blink (counter == 0);
			$display("Hello world");
		endrule
			

	endmodule

endpackage
