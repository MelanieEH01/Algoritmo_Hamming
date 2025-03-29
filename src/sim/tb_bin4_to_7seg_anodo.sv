module tb_bin4_to_7seg_anodo;
    logic [3:0] bin;
    logic [6:0] seg;

    bin4_to_7seg_sec dut (
        .bin(bin),
        .seg(seg)
    );

    initial begin
        $display("BIN | {a,b,c,d,e,f,g}");
        $display("----+-----------------");
        for (int i = 0; i < 16; i++) begin
            bin = i;
            #1;
            $display(" %1h  | {%0b,%0b,%0b,%0b,%0b,%0b,%0b}",
                     bin, seg[0], seg[1], seg[2], seg[3], seg[4], seg[5], seg[6]);
        end
        $finish;
    end
endmodule