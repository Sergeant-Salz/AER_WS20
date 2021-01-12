package FAST_comp;

import FIFO ::*;
import ClientServer ::*;
import Vector ::*;
import GetPut ::*;

typedef 8 N;
typedef Bit#(N) GrayScale;
typedef 0 THRESHOLD;


interface FAST_comp#(numeric type size);
    interface Put#(Tuple2#(GrayScale, Vector#(size, GrayScale)))    request;
    interface Get#(Bool)                                            response;
endinterface


module mkComparator#(parameter Integer size) (FAST_comp#(size));

    FIFO #(Tuple2#(GrayScale, Vector#(size, GrayScale))) in_queue <- mkFIFO;
    FIFO #(Bool) out_queue <- mkFIFO;

    rule compute;
        Bool allGreaterThanMiddle = True;
        match {.middle, .other} = in_queue.first; in_queue.deq;

        for(Integer j = 0; j < size; j = j+1)
            allGreaterThanMiddle = allGreaterThanMiddle && (middle + fromInteger(valueOf(THRESHOLD))) < other[j];

        out_queue.enq(allGreaterThanMiddle);
    endrule

    interface Put request;
        method Action put(Tuple2#(GrayScale, Vector#(size, GrayScale)) pixels);
            in_queue.enq(pixels);
        endmethod
    endinterface


    interface Get response;
        method ActionValue#(Bool) get();
            let result = out_queue.first; out_queue.deq;
            return result;
        endmethod
    endinterface

endmodule




endpackage