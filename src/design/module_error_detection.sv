module module_error_detection(
  
    input  logic [2:0] parity_original,  // Bits de paridad originales
    input  logic [2:0] parity_error,     // Bits de paridad recibidos
    output logic [2:0] sindrome         // Síndrome de error (posición del bit erróneo)
);

    // Cálculo del síndrome de error
    assign sindrome = parity_original ^ parity_error;
    
endmodule
