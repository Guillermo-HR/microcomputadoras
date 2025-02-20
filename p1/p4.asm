processor 16f877 ; Define el micro que vamos a utilizar 
include <p16f877.inc> ; Incluir biblioteca 

K equ H'26' ; Declarar que se va a utilizar el registro H'26' y se el asigna el nombre K
Cont equ H'27' ; Declarar que se va a utilizar el registro H'27' y se el asigna el nombre Cont

inicio: ; Inicio subrutina inicio
  movlw d'00' ; Asignar al registro W el valor 0
  movwf K ; Copiar el valor del registro W al registro K
  movlw d'20' ; Asignar al registro W el valor 20
  movwf Cont ; Copiar el valor del registro W al registro Cont

incremento: ; Inicio subrutina incremento
  incf K,1 ; Incrementar en 1 el valor del registro K
  decf Cont,1 ; Decrementar en 1 el valor del registro Cont
  btfss STATUS,Z ; Valida si el resultado de la operacion es 0 
  goto incremento ; Ir a la subrutina incremento
  goto inicio ; Ir a la subrutina inicio

END ; Fin del programa