package SimpleCounter;

	interface SimpleCounter;
		method Action incr(UInt#(32) v);
		method Action decr(UInt#(32) v);
		method Action load(UInt#(32) v);
		method UInt#(32) counterValue();
	endinterface

	module mkSimpleCounter(SimpleCounter);
		
		RWire#(UInt#(32)) cur_inc 	 <- mkRWire;
		RWire#(UInt#(32)) cur_dec 	 <- mkRWire;
		RWire#(UInt#(32)) cur_load 	 <- mkRWire;
		Reg#(UInt#(32)) counter <- mkReg(0);
		
		rule proccess;
			if(cur_load.wget matches tagged Valid .l)
				counter <= l;
			else if(cur_inc.wget matches tagged Valid .i &&& cur_dec.wget matches tagged Valid .d)
				counter <= counter + i - d;
			else if (cur_inc.wget matches tagged Valid .i)
				counter <= counter + i;
			else if (cur_dec.wget matches tagged Valid .d)
				counter <= counter - d;
		endrule
		
		rule output_rule;
			$display("Counter value is: %d", counter);
		endrule
		
		method Action incr(UInt#(32) inc);
			cur_inc.wset(inc);
		endmethod

		method Action decr(UInt#(32) dec);
			cur_dec.wset(dec);
		endmethod

		method Action load(UInt#(32) val);
			cur_load.wset(val);
		endmethod
		
		method UInt#(32) counterValue();
			return counter;
		endmethod

	endmodule

endpackage
