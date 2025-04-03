module module_decoder(
    
    input logic [6:0] switch_error,       // 7 bits con posible error
    output logic [2:0] parity_error     // 3 bits de paridad recalculados

    );

    logic c0_err, c1_err, c2_err;	//Cálculo de paridades

    // Calcular los bits de paridad del código recibido
    assign c0_err = switch_error[6] ^ switch_error[4] ^ switch_error[2] ^ switch_error[0];
    assign c1_err = switch_error[6] ^ switch_error[5] ^ switch_error[2] ^ switch_error[1];
    assign c2_err = switch_error[6] ^ switch_error[5] ^ switch_error[4] ^ switch_error[3];

    // Extracción de los bits de paridad de la palabra recibida
    assign parity_error = {c2_err, c1_err, c0_err};  // c2, c1, c0

    
endmodule