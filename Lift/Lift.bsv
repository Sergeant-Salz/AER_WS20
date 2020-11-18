package Lift;
interface Ifc_Lift;
	method UInt#(8)		getFloor();
	method Action		requestFloor(UInt#(8) floor);
endinterface


module mkLift(Ifc_Lift);
	
	Reg#(UInt#(8)) state <- mkReg(0);
	Reg#(UInt#(8)) requested <- mkRegU;
	Reg#(Bool) buisy <- mkReg(False);

	rule goUp (buisy && (requested > state));
		state <= state + 1;
	endrule


	rule done (buisy && (requested == state));
		buisy <= False;
	endrule

	
	rule goDown (buisy && (requested < state));
		state <= state - 1;
	endrule
	
	
	method Action requestFloor (UInt#(8) floor) if (!buisy);
		buisy <= True;
		requested <= floor;
	endmethod


	method UInt#(8) getFloor();
		return state;
	endmethod

endmodule: mkLift
endpackage: Lift
