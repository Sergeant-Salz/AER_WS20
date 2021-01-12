package Testbench;

import BlueCheck ::*;
import FAST_comp ::*;
import ClientServer ::*;
import Vector ::*;
import GetPut ::*;
import StmtFSM   :: *;
import FAST_filter ::*;

// Fast comperator reference implementation
function Bool comp(GrayScale mid, Vector#(12, GrayScale) vec);
  Bool isEdge = True;
  for(Integer i = 0; i < 12; i = i + 1) 
    isEdge = isEdge && mid < vec[i];

  return isEdge;
endfunction

// Fast filter reference implementation
function Bool filter(GrayScale mid, Vector#(16, GrayScale) vec);
  Bool edgeFound = False;
  // Iterate over all possible connected components
  for(Integer offset = 0; offset < 16; offset = offset + 1) begin
    Vector#(12, GrayScale) sub = take(rotateBy(vec, fromInteger(offset)));  
    edgeFound = edgeFound || comp(mid, sub);
  end
  return edgeFound;
endfunction


module [BlueCheck] mkCheckCOMP ();
  /* Implmentation instance */
  FAST_comp#(12) dut <- mkComparator(12);
  /* This function allows us to make assertions in the properties */
  Ensure ensure <- getEnsure;

  function Stmt correct(GrayScale mid, Vector#(12, GrayScale) vec) =
    seq
      dut.request.put(tuple2(mid, vec));
      action
        Bool result <- dut.response.get;
        ensure(comp(mid, vec) == result);
      endaction
    endseq;

  prop("checkComp", correct);

endmodule

module [BlueCheck] mkCheckFILTER ();

  /* Implmentation instance */
  FAST_filter#(16,12) dut <- mkFilter(16,12);
  /* This function allows us to make assertions in the properties */
  Ensure ensure <- getEnsure;

  function Stmt correct(GrayScale mid, Vector#(16, GrayScale) vec) =
    seq
      dut.request.put(tuple2(mid, vec));
      action
        Bool result <- dut.response.get;
        ensure(filter(mid, vec) == result);
      endaction
    endseq;

  prop("checkFilter", correct);

endmodule

module [Module] mkTestbench ();
  blueCheck(mkCheckCOMP);
  blueCheck(mkCheckFILTER);
endmodule

endpackage
