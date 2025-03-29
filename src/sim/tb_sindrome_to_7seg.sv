module tb_sindrome_to_7seg;
    logic [2:0] sin;
    logic [6:0] seg;

    sindrome_to_7seg dut (
        .sin(sin),
        .seg(seg)
    );

    initial begin
        $display("Sindrome | {a,b,c,d,e,f,g}");
        $display("----+-----------------");
        for (int i = 0; i < 8; i++) begin
            sin = i;
            #1;
            $display(" %1h  | {%0b,%0b,%0b,%0b,%0b,%0b,%0b}",
                     sin, seg[0], seg[1], seg[2], seg[3], seg[4], seg[5], seg[6]);
        end
        $finish;
    end
endmodule