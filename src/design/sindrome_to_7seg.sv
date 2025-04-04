module sindrome_to_7seg(
    input  logic [2:0] sin,   // Síndrome de 3 bits
    output logic [6:0] seg    // Segmentos (activo en bajo)
);
    
    // Mapeo de síndrome a 7 segmentos (común cát - 0 activa el segmento)
    assign seg = (sin == 3'b000) ? 7'b1000000 : // 0
                 (sin == 3'b001) ? 7'b1111001 : // 1
                 (sin == 3'b010) ? 7'b0100100 : // 2
                 (sin == 3'b011) ? 7'b0110000 : // 3
                 (sin == 3'b100) ? 7'b0011001 : // 4
                 (sin == 3'b101) ? 7'b0010010 : // 5
                 (sin == 3'b110) ? 7'b0000010 : // 6
                 (sin == 3'b111) ? 7'b1111000 : // 7
                7'b1111111;  // default: segmentos apagados

endmodule