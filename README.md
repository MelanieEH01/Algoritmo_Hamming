# Introducción a diseño digital en HDL
### Estudiantes:
-Yohel Alas Gómez

-Melanie Espinoza Hernández

## 1. Abreviaturas y definiciones
- **FPGA**: Field Programmable Gate Arrays
- **MSB**: Most Significant Bit
- **LSB**: Least Significant Bit

## 2. Referencias
[1] David Harris y Sarah Harris. *Digital Design and Computer Architecture. RISC-V Edition.* Morgan Kaufmann, 2022. ISBN: 978-0-12-820064-3

## 3. Desarrollo

### 3.0 Descripción general del sistema
El sistema implementado consiste una detección y corrección de errores basado en el código Hamming(7,4), diseñado para proteger transmisiones de datos de 4 bits. El sistema consta de varios módulos que trabajan en conjunto para codificar, detectar y corregir errores de un solo bit, así como para visualizar el resultado. El flujo de trabajo comienza con la codificación de la palabra original de 4 bits, añadiendo 3 bits de paridad. Luego, se simula la transmisión y posible corrupción de datos mediante interruptores. El sistema detecta cualquier discrepancia calculando el síndrome del error, localiza y corrige el bit afectado, y finalmente muestra tanto la palabra corregida en LEDs de la FPGA como el síndrome y la palabra corregida en displays de 7 segmentos.

### 3.1 Módulo 1
#### 3.1.1. module_encoder
```SystemVerilog
module module_encoder(

    input logic [3:0] switch_input,         // Entrada de 4 bits desde interruptores
    output logic [2:0] parity_original     // Salida de 3 bits con información de paridad

    );

    logic i0, i1, i2, i3;
    assign {i3, i2, i1, i0} = switch_input;

    // Cálculo de los bits de paridad usando operación XOR
    // Declaración de los bits de paridad según la nomenclatura vista en clase

    logic c0, c1, c2;
    assign c0 = i3 ^ i1 ^ i0; // c0 = i3 ⊕ i1 ⊕ i0
    assign c1 = i3 ^ i2 ^ i0; // c1 = i3 ⊕ i2 ⊕ i0
    assign c2 = i3 ^ i2 ^ i1; // c2 = i3 ⊕ i2 ⊕ i1
   
    // Construcción de la palabra codificada de 7 bits con datos y paridad
    logic [6:0] encoded_word;
    assign encoded_word = {i3,i2,i1,c2,i0,c1,c0};

    // Verificación de paridad: XOR entre los bits de datos y sus bits de paridad
    logic c0_calc, c1_calc, c2_calc;

    assign c0_calc = i3 ^ i1 ^ i0 ^ c0;
    assign c1_calc = i3 ^ i2 ^ i0 ^ c1;
    assign c2_calc = i3 ^ i2 ^ i1 ^ c2;
   
    assign parity_original = {c2_calc, c1_calc, c0_calc};

endmodule
```
#### 3.1.2. Parámetros

No se definen parámetros para este módulo.

#### 3.1.3 Entradas y salidas:
- `switch_input[3:0]`: Se configura la entrada desde interruptores (dip switch), donde switch_input[0] corresponde al LSB y switch_input[3] al MSB.
- `parity_original[2:0]`: Contiene los bits de paridad calculados, donde parity_original[0] corresponde al bit c0, parity_original[1] al bit c1 y parity_original[2] al bit c2.

#### 3.1.4 Descripción de la lógica:
Se implementa un codificador que genera bits de paridad para detección de errores. Extrae los 4 bits de datos de entrada, calcula tres bits de paridad mediante XOR entre bits específicos, construye la palabra codificada de 7 bits y verifica la paridad mediante XOR entre datos y bits de paridad, produciendo como salida los bits de paridad original.

#### 3.1.5. Criterios de diseño
![module_encoder](https://github.com/MelanieEH01/Images_README/blob/db9f83d1e0962d2d328390ba1755ff41acee7fe2/Proyecto_1/module_encoder.png)


### 3.2 Módulo 2
#### 3.2.1. module_decoder
```SystemVerilog
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
```
#### 3.2.2. Parámetros

No se definen parámetros para este módulo.

#### 3.2.3 Entradas y salidas:
- `switch_error[6:0]`: Entrada de la palabra recibida con posible error, donde switch_error[0] corresponde al LSB (c0) y switch_error[6] MSB (i3).
- `parity_error[2:0]`: Contiene los bits de paridad recalculados a partir de la palabra recibida, siguiendo el mismo orden que parity_original.

#### 3.2.4 Descripción de la lógica:
Este módulo recalcula los bits de paridad a partir de una palabra de 7 bits ingresada potencialmente con error. Calcula tres bits de paridad mediante operaciones XOR de ciertos bits de la palabra recibida, siguiendo el patrón de código Hamming para verificación de paridad.

#### 3.2.5. Criterios de diseño
![module_decoder] ()




#### 5. Testbench
Descripción y resultados de las pruebas hechas

### Otros modulos
- agregar informacion siguiendo el ejemplo anterior.


## 4. Consumo de recursos

## 5. Problemas encontrados durante el proyecto

## Apendices:
### Apendice 1:
texto, imágen, etc
