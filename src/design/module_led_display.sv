module module_led_display(
    
    input  logic [3:0] data_corr,         // Palabra corregida del subsistema de corrección
    output logic [3:0] led               // Salidas a los LEDs de la FPGA

    );
    
    assign led[3] = ~data_corr[3];
    assign led[2] = ~data_corr[2];
    assign led[1] = ~data_corr[1];
    assign led[0] = ~data_corr[0];

endmodule