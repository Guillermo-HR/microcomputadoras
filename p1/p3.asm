processor 16f877 ; Define el micro que vamos a utilizar 
include <p16f877.inc> ; Incluir biblioteca 
J equ H'26' ; Declarar que se va a utilizar el registro H'26' y se el asigna el nombre J
Cont equ H'27' ; Declarar que se va a utilizar el registro H'27' y se el asigna el nombre Cont

org 0 ; Reinicia la direccion de inicio 
goto inicio ; Ir a la subrutina inicio 
org 5 ; Asignar direccion de inicio del programa

inicio: ; Inicio subrutina inicio 
  movlw H'01' ; Asignar al registro W el valor h'01' primer valor de la secuencia  
  movwf J ; Copiar el valor del registro W al registro J
  movlw H'07' ; Asignar al registro W el valor h'07' tamaño de la secuencia
  movwf Cont ; Copiar el valor del registro W al registro Cont

corrimiento: ; Inicio subrutina corrimiento
  rlf J,1 ; Hacer corrimiento a la izquierda de 1 bit el valor del registro J
  decf Cont,1 ; Decrementar en 1 el valor del registro Cont
  btfss STATUS, Z ; Valida la bandera Z (bandera de cero). Si el bit es 1 se salta 1 instruccion, si es 0 ejecuta la instruccion que sigue 
  goto corrimiento ; Ir a la subrutina corrimiento
  goto inicio ; Ir a la subrutina inicio

end ; Fin del programa