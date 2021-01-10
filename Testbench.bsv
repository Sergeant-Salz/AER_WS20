package Testbench;

import BlueCheck ::*;
import FAST_comp ::*;
import ClientServer ::*;
import Vector ::*;
import GetPut ::*;
import StmtFSM   :: *;

module [BlueCheck] mkCheckCOMP ();

  /* Implmentation instance */
  Server#(Tuple2#(GrayScale, Vector#(12, GrayScale)), Bool) dut <- mkComparator(12);
  /* This function allows us to make assertions in the properties */
  Ensure ensure <- getEnsure;

  function Bool edgeDetect(GrayScale mid, Vector#(12, GrayScale) vec);
    Bool isEdge = True;
    for(Integer i = 0; i < 12; i = i + 1) 
      isEdge = isEdge && mid < vec[i];

    return isEdge;
  endfunction

  function Stmt correct(GrayScale mid, Vector#(12, GrayScale) vec) =
    seq
      dut.request.put(tuple2(mid, vec));
      action
        Bool result <- dut.response.get;
        ensure(edgeDetect(mid, vec) == result);
      endaction
    endseq;

  prop("checkEdgeDetect", correct);

endmodule

module [Module] mkTestbench ();
  blueCheck(mkCheckCOMP);
endmodule

endpackage
