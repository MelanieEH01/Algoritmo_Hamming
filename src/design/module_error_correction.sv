module module_error_correction(
    input  logic [6:0] switch_error,        // Palabra recibida (posiblemente con error)
    input  logic [2:0] sindrome,          // Síndrome de error
    output logic [3:0] data_corrected     // Datos de la palabra corregida
);
    // Extraer los bits de datos sin corregir
    logic i0, i1, i2, i3;
    assign i0 = switch_error[2];  // Bit i0
    assign i1 = switch_error[4];  // Bit i1
    assign i2 = switch_error[5];  // Bit i2
    assign i3 = switch_error[6];  // Bit i3
    
    // Generación de señales para detectar cada síndrome específico
    // Usando compuertas AND y NOT para las comparaciones
    
    // Detección de síndrome 011 (i0 error)
    logic sindrome_i0;
    assign sindrome_i0 = ~sindrome[2] & sindrome[1] & sindrome[0];
    
    // Detección de síndrome 101 (i1 error)
    logic sindrome_i1;
    assign sindrome_i1 = sindrome[2] & ~sindrome[1] & sindrome[0];
    
    // Detección de síndrome 110 (i2 error)
    logic sindrome_i2;
    assign sindrome_i2 = sindrome[2] & sindrome[1] & ~sindrome[0];
    
    // Detección de síndrome 111 (i3 error)
    logic sindrome_i3;
    assign sindrome_i3 = sindrome[2] & sindrome[1] & sindrome[0];
    
    // Corrección de cada bit usando compuertas XOR
    // Si sindrome_ix es 1, el bit se invierte; si es 0, queda igual
    
    // Corrección de i0
    logic i0_corrected;
    assign i0_corrected = i0 ^ sindrome_i0;
    
    // Corrección de i1
    logic i1_corrected;
    assign i1_corrected = i1 ^ sindrome_i1;
    
    // Corrección de i2
    logic i2_corrected;
    assign i2_corrected = i2 ^ sindrome_i2;
    
    // Corrección de i3
    logic i3_corrected;
    assign i3_corrected = i3 ^ sindrome_i3;
    
    // Combinar los bits corregidos en la salida
    assign data_corrected = {i3_corrected, i2_corrected, i1_corrected, i0_corrected};
    
endmodule