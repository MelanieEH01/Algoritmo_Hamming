module top_module(

    input  logic [3:0] swi_word_tx,  // 4 conmutadores para palabra de referencia
    input  logic [6:0] swi_word_rx,     // 7 conmutadores para palabra con posible error
    output logic [3:0] final_word   

);

    logic [2:0] parity_o;  //paridad de la palabra transmitida         
    logic [2:0] sindrome;  //síndrome de error                
    logic [2:0] error_p;  //posición del error           
    logic [6:0] word_c;  //palabra corregida        
    logic [3:0] data_c; //bits de datos de palabra corregida 
    logic [6:0] seg; // Salida a los 7 segmentos         

    // Subsistema de lectura y codificación de la palabra transmitida
    module_encoder encoder_inst(
        .swi_input(swi_word_tx),    
        .parity_orig(parity_o)      
    );

    // Subsistema verificador de paridad y detector de error
    module_error_detection error_detection_inst(
        .word_rx(swi_word_rx),  
        .sindrome(sindrome),                    
        .error_pos(error_p)          
    );

    // Subsistema de corrección de error sobre la palabra recibida
    module_error_correction error_correction_inst(
        .word_rx(swi_word_rx),
        .error_pos(error_p),       
        .word_corr(word_c),  
        .data_corr(data_c)      
    );

    // Subsistema de despliegue de palabra corregida en LEDs
    module_led_display led_display_inst(
        .data_corr(data_c),   
        .led(final_word)              // Salida a los LEDs negada para que enciendan en la FPGA
    );
    //Módulo de despliegue de síndrome en 7 segmentos
    module_sindrome_to_7seg sindrome_to_7seg_inst(
        .sin(sindrome), 
        .seg(seg) 
    );
    //Módulo de despliegue de palabra corregida en 7 segmentos
    module_bin4_to_7seg_sec bin4_to_7seg_sec_inst(
        .bin(data_c), 
        .seg(seg) 
    );

endmodule