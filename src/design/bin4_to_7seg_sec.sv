module bin4_to_7seg_sec(
    input  logic [3:0] data_corrected,   // 4 bits de datos corregidos
    output logic [6:0] seg              // Segmentos (activo en bajo)
);
    
    // Mapeo de 4 bits a 7 segmentos (común cátod - 0 activa el segmento)
    assign seg = (data_corrected == 4'b0000) ? 7'b1000000 : // 0
                 (data_corrected == 4'b0001) ? 7'b1111001 : // 1
                 (data_corrected == 4'b0010) ? 7'b0100100 : // 2
                 (data_corrected == 4'b0011) ? 7'b0110000 : // 3
                 (data_corrected == 4'b0100) ? 7'b0011001 : // 4
                 (data_corrected == 4'b0101) ? 7'b0010010 : // 5
                 (data_corrected == 4'b0110) ? 7'b0000010 : // 6
                 (data_corrected == 4'b0111) ? 7'b1111000 : // 7
                 (data_corrected == 4'b1000) ? 7'b0000000 : // 8
                 (data_corrected == 4'b1001) ? 7'b0010000 : // 9
                 (data_corrected == 4'b1010) ? 7'b0001000 : // A
                 (data_corrected == 4'b1011) ? 7'b0000011 : // b
                 (data_corrected == 4'b1100) ? 7'b1000110 : // C
                 (data_corrected == 4'b1101) ? 7'b0100001 : // d
                 (data_corrected == 4'b1110) ? 7'b0000110 : // E
                 (data_corrected == 4'b1111) ? 7'b0001110 : // F
                 7'b1111111;  // default: Todos apagados

endmodule