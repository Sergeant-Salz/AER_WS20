package FAST_filter;

import FIFO ::*;
import ClientServer ::*;
import Vector ::*;
import GetPut ::*;
import FAST_comp ::*;


interface FAST_filter#(numeric type total_size, numeric type connected_size);
    interface Put#(Tuple2#(GrayScale, Vector#(total_size, GrayScale)))  request;
    interface Get#(Bool)                                                response;
endinterface


module mkFilter#(Integer total_size, Integer connected_size) (FAST_filter#(total_size, connected_size)) 
    provisos(Max#(total_size,connected_size,total_size), Add#(connected_size, a__, total_size));

    // Going for parallel here, so we create total_size comparators
    Vector#(total_size, FAST_comp#(connected_size)) comps <- replicateM (mkComparator(connected_size));


    interface Put request;
        method Action put(Tuple2#(GrayScale, Vector#(total_size, GrayScale)) circle);
            match {.mid, .vec} = circle;
        
            // All possible continous subvectors of size connected need to be tested, and we have got one comparator for each
            for(Integer offset = 0; offset < total_size; offset = offset + 1)
                comps[offset].request.put(tuple2(mid, 
                    take(rotateBy(vec, fromInteger(offset)))
                    )
                );
        
        endmethod
    endinterface


    interface Get response;
        method ActionValue#(Bool) get();
            Bool foundEdge = False;

            for(Integer i = 0; i < total_size; i = i + 1) begin
                let resp <- comps[i].response.get;
                foundEdge = foundEdge || resp;
            end

                
            return foundEdge;
        endmethod
    endinterface

endmodule




endpackage