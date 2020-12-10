package Testbench;

import BlueCheck ::*;
import SimpleFIFO ::*;

module [BlueCheck] mkCheckFIFO ();
  /* Specification instance */
  SFIFO goldenFIFO <- mkBenchmarkFIFO();

  /* Implmentation instance */
  SFIFO simpleFIFO <- mkSimpleFIFO();

  equiv("put" , goldenFIFO.put , simpleFIFO.put);
  equiv("get" , goldenFIFO.get , simpleFIFO.get);
endmodule

module [Module] mkTestbench ();
  blueCheck(mkCheckFIFO);
endmodule

endpackage
