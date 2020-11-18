package SimpleAlu;

	import FIFOF :: * ;

	typedef enum{Mul, Div, Add, Sub, And, Or, Pow} AluOps deriving (Eq, Bits);

	interface SimpleAlu;
		method Action setupCalculation(AluOps op, Int#(32) a, Int#(32) b);
		method ActionValue#(Int#(32)) getResult();
	endinterface

	interface IntPow;
		method Action setValues(Tuple2#(Int#(32), Int#(4)) values);
		method ActionValue#(Int#(32)) getResult();
	endinterface


	module mkSimpleAlu(SimpleAlu);
		FIFOF#(Int#(32)) in_a <- mkFIFOF;
		FIFOF#(Int#(32)) in_b <- mkFIFOF;
		
		FIFOF#(Int#(32)) out <- mkFIFOF;
		FIFOF#(AluOps) op_in <- mkFIFOF;

		Reg#(Bool) working <- mkReg(False);

		IntPow expo_comp <- mkIntPow;
	
		rule calc (working == False);
			let op = op_in.first; op_in.deq;
			let a = in_a.first; in_a.deq;
			let b = in_b.first; in_b.deq;
			
			if(op != Pow) begin
				Int#(32) out_temp;
				case (op)
					Mul : out_temp = a * b;
					Div : out_temp = a / b;
					Add : out_temp = a + b;
					Sub : out_temp = a - b;
					And : out_temp = a & b;
					Or : out_temp = a | b;
					default : out_temp = a + b;
				endcase

				out.enq(truncate(out_temp));
			end else begin
				working <= True;
				expo_comp.setValues(tuple2(a, truncate(b)));
			end

		endrule

		rule propagate_pow_res;
			let t_out <- expo_comp.getResult();
			out.enq(t_out);
			working <= False;
		endrule

		method Action setupCalculation(AluOps op, Int#(32) a, Int#(32) b);
			in_a.enq(a);
			in_b.enq(b);
			op_in.enq(op);
		endmethod

		method ActionValue#(Int#(32)) getResult();
			let out_tmp = out.first; out.deq;
			return out_tmp;
		endmethod

	endmodule

	module mkIntPow(IntPow);
		FIFOF#(Tuple2#(Int#(32),Int#(4))) inp <- mkFIFOF;
		FIFOF#(Int#(32)) outp <- mkFIFOF;
		Reg#(Int#(32)) base <- mkRegU;
		Reg#(Int#(32)) acc <- mkRegU;
		Reg#(Int#(4)) exp <- mkRegU;
		Reg#(Bool) working <- mkReg(False);


		rule calc (working == True && exp != 1);
			acc <= truncate(acc * base);
			exp <= exp - 1;
		endrule


		rule finish (working == True && exp == 1);
			working <= False;
			outp.enq(truncate(acc * base));
		endrule


		rule start (working == False);
			working <= True;
			acc <= 1;
			match{.tbase, .texp} = inp.first; inp.deq;
			base <= tbase;
			exp <= texp;
		endrule


		method Action setValues(Tuple2#(Int#(32), Int#(4)) values);
			inp.enq(values);
		endmethod


		method ActionValue#(Int#(32)) getResult;
			let out = outp.first; outp.deq;
			return out;
		endmethod

	endmodule

endpackage
