module module_error_detection(
    input  logic [6:0] word_rx,           // Código Hamming recibido
    output logic [2:0] sindrome,         // Síndrome de error
    output logic [2:0] error_pos        // Posición del error (0 si no hay error)
);

  // Bits de paridad recalculados
  logic c0_calc, c1_calc, c2_calc;

  // Calcular los bits de paridad del código recibido
  assign c0_calc = word_rx[0] ^ word_rx[2] ^ word_rx[4] ^ word_rx[6];
  assign c1_calc = word_rx[1] ^ word_rx[2] ^ word_rx[5] ^ word_rx[6];
  assign c2_calc = word_rx[3] ^ word_rx[4] ^ word_rx[5] ^ word_rx[6];

  // Calcular el síndrome
  assign sindrome = {c2_calc, c1_calc, c0_calc}; // s4 s2 s1

  // Convertir el síndrome a la posición del error (binario a decimal)
  assign error_pos = (sindrome == 3'b000) ? 4'd0 : {1'b0, sindrome}; // Si es 0, no hay error

endmodule
