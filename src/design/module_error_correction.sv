module module_error_correction(
    input  logic [6:0] word_rx,        // Palabra recibida (posiblemente con error)
    input  logic [2:0] error_pos,     // Posición del bit erróneo (1-7), 0 si no hay error
    output logic [6:0] word_corr,    // Palabra corregida
    output logic [3:0] data_corr    // Palabra corregida

);
    // Corrección del bit
    assign word_corr = (error_pos != 0) ? word_rx ^ (1 << (error_pos - 1)) : word_rx;

    assign data_corr = {word_corr[6], word_corr[5], word_corr[4], word_corr[2]};

endmodule
