PROCESSOR 16F877 ; Encabezado para trabajar con procesador 16F877 
INCLUDE <P16F877.INC> 
ORG 0 ; Establecemos el punto de inicio en la dirección 0 
GOTO INICIO ; Se dirige a la etiqueta INICIO 
ORG 5 

INICIO: 
  BSF STATUS, RP0 ; Activa el bit RP0 del registro STATUS para ir al banco de registros 1 
  BCF STATUS, RP1 ; Limpia el bit RP1 del registro STATUS para asegurar que nos encontramos en el banco de registros 1 MOVLW 06H ; Cargamos el valor hexadecimal 0x06 (6 decimal) en el registro W 
  MOVWF ADCON1 ; Pasa el contenido de W al registro ADCON1, que configura el puerto ya sea como analógico o digital. El valor 6 lo vuelve digital 
  MOVLW H'FF' ; Cargamos el valor 0xFF hexadecimal en el registro W 
  MOVWF TRISA ; Configuramos al puerto A como una entrada 
  CLRF TRISB ; Configuramos al puerto B como una salida 
  CLRF TRISC ; Configuramos al puerto B como una salida 
  BCF STATUS,RP0 ; Cambiamos al banco de registros 0 

SWITCH: ; Etiqueta de proceso de puerto A para redireccionar a cada subproceso de los motores 
  MOVF PORTA,0 ; Pasamos el valor del puerto A al registro W 
  XORLW H'00' ; Realiza una operación XOR lógica con 0, básicamente no hace nada, ya que XOR con 0 no cambia el valor 
  BTFSC STATUS,Z ; Salta a la siguiente instrucción si se tiene un cero es decir z vale uno 
    GOTO PASO0 ; Se dirige al proceso “PASO0” 
  MOVF PORTA,0 ; Verifica el estado del bit 0 del puerto A 
  XORLW H'01' ; Realiza un XOR lógico con 1 
  BTFSC STATUS,Z ; Salta a la siguiente instrucción si se tiene un cero es decir z vale uno. Es decir si se selecciona el bit 1: 
    GOTO PASO1 ; Se dirige al proceso PASO1 
  MOVF PORTA,0 ; Verifica el estado del bit 0 del puerto A 
  XORLW H'02' ; Realiza un XOR lógico con 1 
  BTFSC STATUS,Z ; Salta a la siguiente instrucción si se tiene un cero es decir z vale uno. Es decir si se selecciona el bit 1: 
    GOTO PASO2 ; Se dirige al proceso PASO2 
  MOVF PORTA,0 ; Verifica el estado del bit 0 del puerto A 
  XORLW H'03' ; Realiza un XOR lógico con 3 
  BTFSC STATUS,Z ; Salta a la siguiente instrucción si se tiene un cero es decir z vale uno. Es decir si se selecciona el bit 1: 
    GOTO PASO3 ; Se dirige al proceso PASO3 
  MOVF PORTA,0 ; Verifica el estado del bit 0 del puerto A 
  XORLW H'04' ; Realiza un XOR lógico con 4 
  BTFSC STATUS,Z ; Salta a la siguiente instrucción si se tiene un cero es decir z vale uno. Es decir si se selecciona el bit 1: 
    GOTO PASO4 ; Se dirige al proceso PASO4 
  MOVF PORTA,0 ; Verifica el estado del bit 0 del puerto A 
  XORLW H'05' ; Realiza un XOR lógico con 5 
  BTFSC STATUS,Z ; Salta a la siguiente instrucción si se tiene un cero es decir z vale uno. Es decir si se selecciona el bit 1: 
    GOTO PASO5 ; Se dirige al proceso PASO5 
  MOVF PORTA,0 ; Verifica el estado del bit 0 del puerto A 
  XORLW H'06' ; Realiza un XOR lógico con 6 
  BTFSC STATUS,Z ; Salta a la siguiente instrucción si se tiene un cero es decir z vale uno. Es decir si se selecciona el bit 1: 
    GOTO PASO6 ; Se dirige al proceso PASO6 
  MOVF PORTA,0 ; Verifica el estado del bit 0 del puerto A 
  XORLW H'07' ; Realiza un XOR lógico con 7 
  BTFSC STATUS,Z ; Salta a la siguiente instrucción si se tiene un cero es decir z vale uno. Es decir si se selecciona el bit 1: 
    GOTO PASO7 ; Se dirige al proceso PASO6 
    GOTO SWITCH ; Se dirige al proceso SWITCH 
 
PASO0: 
  CLRF PORTC ; Apagamos el puerto C 
  CLRF PORTB ; Apagamos el puerto B 
  GOTO SWITCH ; Dirigimos al proceso SWITCH (switch) 

PASO1: 
  BSF PORTC,2 ; Activamos motor derecho 
  BCF PORTC,1 ; No activamos motor izquierdo 
  MOVLW B'00001000' ; Siguiendo la configuración de la tarjeta, pasamos al registro W el valor en binario 8, para indicar giro en sentido horario 
  MOVWF PORTB ; Pasamos el contenido en el registro W al puerto B 
  GOTO SWITCH ; Nos vamos a la etiqueta SWITCH 

PASO2: 
  BSF PORTC,2 ; Activamos motor derecho 
  BCF PORTC,1 ; No activamos motor izquierdo 
  MOVLW B'00000100' ; Siguiendo la configuración de la tarjeta, pasamos al registro W el valor en binario 4, para indicar giro en sentido horario 
  MOVWF PORTB ; Pasamos el contenido en el registro W al puerto B 
  GOTO SWITCH ; Nos vamos a la etiqueta SWITCH 

PASO3: 
  BSF PORTC,1 ; Activamos motor izquierdo 
  BCF PORTC,2 ; No activamos motor derecho 
  MOVLW B'00000010' ; Siguiendo la configuración de la tarjeta, pasamos al registro W el valor en binario 2, para indicar giro en sentido antihorario 
  MOVWF PORTB ; Pasamos el contenido en el registro W al puerto B 
  GOTO SWITCH ; Nos vamos a la etiqueta SWITCH 

PASO4: 
  BSF PORTC,1 ; Activamos motor izquierdo 
  BCF PORTC,2 ; No activamos motor derecho 
  MOVLW B'00000001' ; Siguiendo la configuración de la tarjeta, pasamos al registro W el valor en binario 1, para indicar giro en sentido horario 
  MOVWF PORTB ; Pasamos el contenido en el registro W al puerto B 
  GOTO SWITCH ; Nos vamos a la etiqueta SWITCH 

PASO5: 
  BSF PORTC,1 ; Activamos motor izquierdo 
  BSF PORTC,2 ; Activamos motor derecho 
  MOVLW B'00001010' ; Siguiendo la configuración de la tarjeta, pasamos al registro W el valor en binario 10, para indicar giros en sentido horario con los 1s 
  MOVWF PORTB ; Pasamos el contenido en el registro W al puerto B 
  GOTO SWITCH ; Nos vamos a la etiqueta SWITCH 

PASO6: 
  BSF PORTC,1 ; Activamos motor izquierdo 
  BSF PORTC,2 ; Activamos motor derecho 
  MOVLW B'00001001' ; Siguiendo la configuración de la tarjeta, pasamos al registro W el valor en binario 10, para indicar giros en sentido antihorario con los 1s 
  MOVWF PORTB ; Pasamos el contenido en el registro W al puerto B 
  GOTO SWITCH ; Nos vamos a la etiqueta SWITCH 

PASO7: 
  BSF PORTC,1 ; Activamos motor izquierdo 
  BSF PORTC,2 ; Activamos motor derecho 
  MOVLW B'00000110' ; Siguiendo la configuración de la tarjeta, pasamos al registro W el valor en binario 10, para indicar giros en sentido antihorario en motor izquierdo y giros horario en el derecho 
  MOVWF PORTB ; Pasamos el contenido en el registro W al puerto B 
  GOTO SWITCH ; Nos vamos a la etiqueta SWITCH 

END ; Fin del programa 