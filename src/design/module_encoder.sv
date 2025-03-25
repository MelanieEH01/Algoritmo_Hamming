module module_encoder(

    input logic [3:0] swi_input,       // Bits de datos (i0, i1, i2, i3) 
    output logic [2:0] parity_orig     // Bits de la palabra codificada (con paridad)

    );

    logic c0, c1, c2;                   // Declaración de los bits de paridad según la nomenclatura vista en clase
    
    // Cálculo de los bits de paridad
    assign c0 = swi_input[3] ^ swi_input[1] ^ swi_input[0]; // c0 = i3 ⊕ i1 ⊕ i0
    assign c1 = swi_input[3] ^ swi_input[2] ^ swi_input[0]; // c1 = i3 ⊕ i2 ⊕ i0
    assign c2 = swi_input[3] ^ swi_input[2] ^ swi_input[1]; // c2 = i3 ⊕ i2 ⊕ i1

    assign parity_orig = {c2, c1, c0};
    
    // Ensamblaje de la palabra codificada con el orden visto en clase
    logic [6:0] encoded_word;
    assign encoded_word = {swi_input[3], swi_input[2], swi_input[1], c2, swi_input[0], c1, c0};


endmodule