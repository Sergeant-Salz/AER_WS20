package SimpleFIFO;

import Vector ::*;
import FIFO ::*;

interface SFIFO;
    method Action put(Int#(16) e);
    method ActionValue#(Int#(16)) get();
endinterface


module mkSimpleFIFO(SFIFO);

    Vector#(16, Reg#(Int#(16))) storage <- replicateM(mkRegU);
    Reg#(UInt#(4)) head <- mkReg(0);
    Reg#(UInt#(4)) tail <- mkReg(0);
    Reg#(Bool) full <- mkReg(False);


    method Action put(Int#(16) e) if (!full);
        storage[head] <= e;
        // If head and tail are the same value, that could either mean full or empty
        // so we need to remember the fact that the FIFO is full, not empty
        if(head == (tail - 1))
            full <= True;
        // Increment the head pointer by one modulo 16 (by tuncating to 4 bits)
        head <= truncate(head + 1);
    endmethod

    method ActionValue#(Int#(16)) get() if (head != tail || full);
        tail <= tail + 1;
        let value = storage[tail];
        // No if needed, as it doesnt hurt to aleways set full to false, and safes hardware
        full <= False;
        return value;
    endmethod

endmodule


module mkBenchmarkFIFO(SFIFO);

    FIFO::FIFO#(Int#(16)) fifo <- mkSizedFIFO(16);

    method Action put(Int#(16) e);
        fifo.enq(e);
    endmethod

    method ActionValue#(Int#(16)) get(); 
        let value = fifo.first();
        fifo.deq();
        return value;
    endmethod

endmodule

endpackage