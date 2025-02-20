processor 16f877 ; Define el micro que vamos a utilizar 
include <p16f877.inc> ; Incluir biblioteca 

K equ H'26' ; Declarar que se va a utilizar el registro H'26' y se el asigna el nombre K 
L equ H'27' ; Declarar que se va a utilizar el registro H'27' y se el asigna el nombre L 

org 0 ; Reinicia la direccion de inicio 
goto inicio ; Ir a la subrutina inicio 
org 5 ; Asignar direccion de inicio del programa 

inicio: ; Inicio subrutina inicio 
  movlw h'05' ; Asignar al registro W el valor h'05' 
  addwf K,0 ; Sumar al registro W el valor en el registro K y dejarlo en W 
  movwf L ; Copiar el valor del registro W al registro L 
  goto inicio ; Ir a la subrutina inicio 

end ; Fin del programa 