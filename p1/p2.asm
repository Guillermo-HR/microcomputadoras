processor 16f877 ; Define el micro que vamos a utilizar 
include <p16f877.inc> ; Incluir biblioteca 

K equ H'26' ; Declarar que se va a utilizar el registro H'26' y se el asigna el nombre K 
J equ H'27' ; Declarar que se va a utilizar el registro H'27' y se el asigna el nombre J 
C1 equ H'28' ; Declarar que se va a utilizar el registro H'28' y se el asigna el nombre C1
R1 equ H'29' ; Declarar que se va a utilizar el registro H'26' y se el asigna el nombre R1

org 0 ; Reinicia la direccion de inicio 
goto inicio ; Ir a la subrutina inicio 
org 5 ; Asignar direccion de inicio del programa 

inicio: ; Inicio subrutina inicio 
  movf K,0 ; Copiar el valor del registro K al registro W 
  addwf J,0 ; Sumar al registro W el valor de J y guardar el resultado en W 
  movwf R1 ; Copiar el resultado de la suma al registro R1 
  btfsc STATUS,C ; Verificar si hubo acarreo en la suma. Si hubo 
  goto ponuno ; Ir a la subrutina ponuno (solo si el bit 0 de STATUS es 1) 
  clrf C1 ; Asigna 0 al registro C1 
  goto inicio ; Ir a la subrutina inicio 

ponuno: ; Inicio subrutina ponuno 
  movlw H'01' ; Asigna H'01' al registro W 
  movwf C1 ; Copia el valor del registro W al registro C1 
  goto inicio ; ir a la subrutina inicio 

End ; Fin del programa 