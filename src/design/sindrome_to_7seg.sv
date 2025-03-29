module sindrome_to_7seg (
    input logic [2:0] sin,
    output logic [6:0] seg);

   logic A, B, C;

    always_comb begin 
        A= sin[2];
        B= sin[1];
        C= sin[0];

        // Segmento a
        seg[0] = ~(A & C | ~A & ~C | B);

        // Segmento b
        seg[1] = ~(~A | B & C | ~B & ~C);

        // Segmento c
        seg[2] = ~(A | ~B | C);

        // Segmento d
        seg[3] = ~(~A & B | ~A & ~C | B & ~C | A & ~B & C);

        // Segmento e
        seg[4] = ~(~A & ~C | B & ~C);

        // Segmento f
        seg[5] = ~(A & ~B | A & ~C | ~B & ~C);

        // Segmento g
        seg[6] = ~(A & ~B | ~A & B | A & ~C);
    end

endmodule