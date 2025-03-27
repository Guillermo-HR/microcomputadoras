processor 16f877 ; Selecciona el microcontrolador
include <p16f877.inc> ; Incluye el archivo de definiciones del microcontrolador

org 0 ; Direccion de inicio del programa
goto INICIO ; Salta a la etiqueta INICIO
org 5 ; Direccion de interrupcion

INICIO: ; Etiqueta de inicio del programa
    bsf STATUS,RP0 ; Selecciona el banco 1
    bcf STATUS,RP1 ; Selecciona el banco 1
    movlw h'06' 
    movwf ADCON1 ; Configura los pines como digitales
    movlw b'00000111'
    movwf TRISA ; Configura el puerto A como entrada y salida
    clrf TRISB ; Configura el puerto B como salida
    clrf TRISC ; Configura el puerto C como salida
    bcf STATUS,RP0 ; Selecciona el banco 0
    clrf PORTB ; Limpia el puerto B
    clrf PORTC ; Limpia el puerto C

SWITCH: ; Etiqueta de inicio del bucle
    movf PORTA,W ; Lee el puerto A
    andlw b'00000111'
    xorlw h'00' ; Compara con 0
    btfsc STATUS,Z ; Si no es 0 ignorar la siguiente linea
    call APAGAR ; Ir a la etiqueta APAGAR
    movf PORTA,W
    andlw b'00000111'
    xorlw h'01' ; Compara con 1
    btfsc STATUS,Z ; Si no es 1 ignorar la siguiente linea
    call CASO_001 ; Ir a la etiqueta CASO_001
    movf PORTA,W
    andlw b'00000111'
    xorlw h'02' ; Compara con 2
    btfsc STATUS,Z ; Si no es 2 ignorar la siguiente linea
    call CASO_010 ; Ir a la etiqueta CASO_010
    movf PORTA,W
    andlw b'00000111'
    xorlw h'04' ; Compara con 4
    btfsc STATUS,Z ; Si no es 4 ignorar la siguiente linea
    call CASO_100 ; Ir a la etiqueta CASO_100
    goto SWITCH ; Vuelve a la etiqueta SWITCH 

APAGAR: ; Etiqueta de apagado
    clrf PORTB ; Limpia el puerto B
    clrf PORTC ; Limpia el puerto C
    return ; Regresa

CASO_001: ; Etiqueta de caso 001
    clrf PORTB ; Limpia el puerto B
    clrf PORTC ; Limpia el puerto C
    bsf PORTC,0 ; Enciende el bit 0 del puerto C
    bsf PORTC,1 ; Enciende el bit 1 del puerto C
    bsf PORTB,0 ; Enciende el bit 0 del puerto B
    bsf PORTB,3 ; Enciende el bit 3 del puerto B
    return ; Regresa

CASO_010: ; Etiqueta de caso 010
    clrf PORTB ; Limpia el puerto B
    clrf PORTC ; Limpia el puerto C
    bsf PORTC,0 ; Enciende el bit 0 del puerto C
    bsf PORTC,1 ; Enciende el bit 1 del puerto C
    bsf PORTB,0 ; Enciende el bit 0 del puerto B
    bsf PORTB,2 ; Enciende el bit 2 del puerto B
    return ; Regresa

CASO_100: ; Etiqueta de caso 100
    clrf PORTB ; Limpia el puerto B
    clrf PORTC ; Limpia el puerto C
    bsf PORTC,0 ; Enciende el bit 0 del puerto C
    bsf PORTC,1 ; Enciende el bit 1 del puerto C
    bsf PORTB,1 ; Enciende el bit 1 del puerto B
    bsf PORTB,2 ; Enciende el bit 2 del puerto B
    return ; Regresa

end ; Fin del programa