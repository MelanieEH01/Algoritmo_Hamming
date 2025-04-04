# Introducción a diseño digital en HDL
### Estudiantes:
-Yohel Alas Gómez

-Melanie Espinoza Hernández

## 1. Abreviaturas y definiciones
- **FPGA**: Field Programmable Gate Arrays

## 2. Referencias
[0] David Harris y Sarah Harris. *Digital Design and Computer Architecture. RISC-V Edition.* Morgan Kaufmann, 2022. ISBN: 978-0-12-820064-3

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
```
#### 2. Parámetros


#### 3. Entradas y salidas:
- `switch_input[3:0]`: Se configura la entrada desde interruptores (dip switch), donde switch_input[0] corresponde al bit menos significativo (MSB) y switch_input[3] al más significativo.
- `salida_o`: descripción de la salida
- : 
parity_original[2:0]: Contiene los bits de paridad calculados, donde parity_original[0] corresponde al bit c0, parity_original[1] al bit c1 y parity_original[2] al bit c2.

#### 4. Criterios de diseño
Diagramas, texto explicativo...

#### 5. Testbench
Descripción y resultados de las pruebas hechas

### Otros modulos
- agregar informacion siguiendo el ejemplo anterior.


## 4. Consumo de recursos

## 5. Problemas encontrados durante el proyecto

## Apendices:
### Apendice 1:
texto, imágen, etc
