module bin4_to_7seg_anodo(
    input  logic [3:0] bin,     // Entrada binaria de 4 bits
    output logic [6:0] seg      // Salida a display: {a,b,c,d,e,f,g} para ánodo común
);
    // Asignar cada bit a una letra por claridad
    logic A = bin[3];//bit más significativo
    logic B = bin[2];
    logic C = bin[1];
    logic D = bin[0];//bit menos significativo

    // Segmento a
    assign seg[0] = ~(~D | ~A & B | B & C | A & ~B & ~C);

    // Segmento b
    assign seg[1] = ~(~B & ~C | ~B & ~D | ~A & ~C & ~D | ~A & C & D | A & ~C & D);

    // Segmento c
    assign seg[2] = ~(~A & B | A & ~B | ~C & D | ~A & ~C | ~A & D);

    // Segmento d
    assign seg[3] = ~(~B & C & D| B & ~C & D | B & C & ~D | A & ~C & ~D | ~A & ~B & ~D);

    // Segmento e
    assign seg[4] = ~(A & B | A & C | A & ~D | C  & ~D | ~B & ~D);

    // Segmento f
    assign seg[5] = ~(A & ~B | A & C | B & ~D | ~C & ~D | ~A & B & ~C);

    // Segmento g
    assign seg[6] = ~(A & ~B | A & D | ~B & C | C & ~D | ~A & B & ~C);

endmodule