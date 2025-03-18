; Programa para PIC16F877A
; Controla LEDs en PORTB seg�n switches en PORTA (RA0-RA3)

    list p=16F877A
    #include <p16F877A.inc>

    __CONFIG _FOSC_XT & _WDTE_OFF & _PWRTE_ON & _CP_OFF

; Variables
CBLOCK 0x20
    DELAY1      ; Para retardos
    DELAY2      ; Para retardos
    CONTADOR    ; Contador binario
    SECUENCIA   ; Secuencia personalizada
ENDC

; Inicio
    ORG 0x00
    goto INICIO

INICIO
    bsf STATUS, RP0     ; Banco 1
    movlw 0xFF          ; PORTA como entrada
    movwf TRISA
    clrf TRISB          ; PORTB como salida
    movlw 0x06          ; Configura PORTA como digital (desactiva ADC)
    movwf ADCON1
    bcf STATUS, RP0     ; Banco 0
    clrf PORTB          ; Apaga LEDs al inicio

; Bucle principal
MAIN
    movf PORTA, W       ; Lee PORTA
    andlw 0x0F          ; M�scara para RA0-RA3
    sublw 0x00          ; Compara con 0x00
    btfsc STATUS, Z
    goto CASO_0         ; Funci�n 0: Parpadeo 1 Hz
    movf PORTA, W
    andlw 0x0F
    sublw 0x01          ; Compara con 0x01
    btfsc STATUS, Z
    goto CASO_1         ; Funci�n 1: Contador binario
    movf PORTA, W
    andlw 0x0F
    sublw 0x02          ; Compara con 0x02
    btfsc STATUS, Z
    goto CASO_2         ; Funci�n 2: Secuencia personalizada
    movf PORTA, W
    andlw 0x0F
    sublw 0x03          ; Compara con 0x03
    btfsc STATUS, Z
    goto CASO_3         ; Funci�n 3: Corrimiento de dos LEDs
    goto MAIN           ; Vuelve a leer

; Caso 0: Parpadeo a 1 Hz (500 ms ON, 500 ms OFF)
CASO_0
    movlw 0xFF          ; Enciende todos los LEDs W=FF
    movwf PORTB;  PORTB=W
    call RETARDO_500MS
    clrf PORTB          ; Apaga todos los LEDs
    call RETARDO_500MS
    goto MAIN

; Caso 1: Contador binario de 0 a 15
CASO_1
    clrf CONTADOR
CONT_LOOP
    movf CONTADOR, W
    movwf PORTB         ; Muestra contador en LEDs
    call RETARDO_500MS
    incf CONTADOR, F
    movf CONTADOR, W
    sublw 0x10          ; Hasta 15
    btfss STATUS, Z
    goto CONT_LOOP
    goto MAIN

; Caso 2: Secuencia de un LED desplaz�ndose
CASO_2
    clrf PORTB
    bsf PORTB,3
    bsf PORTB,4
    call RETARDO_750MS
    clrf PORTB
    bsf PORTB,2
    bsf PORTB,5
    call RETARDO_750MS
    clrf PORTB
    bsf PORTB,1
    bsf PORTB,6
    call RETARDO_750MS
    clrf PORTB
    bsf PORTB,0
    bsf PORTB,7
    call RETARDO_750MS

    goto MAIN

; Caso 3: Corrimiento de dos LEDs a la derecha
CASO_3
    movlw 0x01          ; Inicia con LED0
    movwf SECUENCIA
SEC_LOOP
    rlf SECUENCIA, F    ; Desplaza a la izquierda
    call RETARDO_750MS
    movf SECUENCIA, W
    movwf PORTB
    btfss SECUENCIA, 7
    goto SEC_LOOP
    goto MAIN

; Rutinas de retardo (4 MHz)
RETARDO_100MS
    movlw 0x05
    movwf DELAY1
R100_LOOP1
    movlw 0xFF
    movwf DELAY2
R100_LOOP2
    decfsz DELAY2, F
    goto R100_LOOP2
    decfsz DELAY1, F
    goto R100_LOOP1
    return

RETARDO_500MS
    movlw 0x19
    movwf DELAY1
R500_LOOP1
    movlw 0xFF
    movwf DELAY2
R500_LOOP2
    decfsz DELAY2, F
    goto R500_LOOP2
    decfsz DELAY1, F
    goto R500_LOOP1
    return

RETARDO_750MS
    movlw 0x23
    movwf DELAY1
R750_LOOP1
    movlw 0xFF
    movwf DELAY2
R750_LOOP2
    decfsz DELAY2, F
    goto R750_LOOP2
    decfsz DELAY1, F
    goto R750_LOOP1
    return

    END