package FAST_comp;

import FIFO ::*;
import ClientServer ::*;
import Vector ::*;
import GetPut ::*;

typedef Bit#(8) GrayScale;


module mkComparator#(parameter Integer size) (Server#(Tuple2#(GrayScale, Vector#(size, GrayScale)), Bool));

    FIFO #(Tuple2#(GrayScale, Vector#(size, GrayScale))) in_queue <- mkFIFO;
    FIFO #(Bool) out_queue <- mkFIFO;

    rule compute;
        Bool allGreaterThanMiddle = True;
        match {.middle, .other} = in_queue.first; in_queue.deq;

        for(Integer j = 0; j < size; j = j+1)
            allGreaterThanMiddle = allGreaterThanMiddle && middle < other[j];

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