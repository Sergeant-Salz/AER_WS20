package Testbench;

import BlueCheck :: *;

module [BlueCheck] mkArithSpec ();
  function Bool addComm(Int#(4) x, Int#(4) y) =
    x + y == y + x;

  function Bool addAssoc(Int#(4) x, Int#(4) y, Int#(4) z) =
    x + (y + z) == (x + y) + z;

  function Bool subComm(Int#(4) x, Int#(4) y) =
	x - y == y - x;
	

	function Bool multComm(Int#(4) x, Int#(4) y) =
		x * y == y * x;

  prop("addComm"  , addComm);
  prop("addAssoc" , addAssoc);
  prop("multComm" , multComm);
  prop("subComm" , subComm);
endmodule

module [Module] mkTestbench ();
  blueCheck(mkArithSpec);
endmodule


endpackage
