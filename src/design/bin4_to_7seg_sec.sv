module bin4_to_7seg_sec(
    input  logic [3:0] bin,
    output logic [6:0] seg
);
    logic A, B, C, D;

    always_comb begin
        A = bin[3];
        B = bin[2];
        C = bin[1];
        D = bin[0];

        // Segmento a
        seg[0] = ~(~D | ~A & B | B & C | A & ~B & ~C);

        // Segmento b
        seg[1] = ~(~B & ~C | ~B & ~D | ~A & ~C & ~D | ~A & C & D | A & ~C & D);

        // Segmento c
        seg[2] = ~(~A & B | A & ~B | ~C & D | ~A & ~C | ~A & D);

        // Segmento d
        seg[3] = ~(~B & C & D| B & ~C & D | B & C & ~D | A & ~C & ~D | ~A & ~B & ~D);

        // Segmento e
        seg[4] = ~(A & B | A & C | A & ~D | C  & ~D | ~B & ~D);

        // Segmento f
        seg[5] = ~(A & ~B | A & C | B & ~D | ~C & ~D | ~A & B & ~C);

        // Segmento g
        seg[6] = ~(A & ~B | A & D | ~B & C | C & ~D | ~A & B & ~C);
    end
endmodule