INCLUDE <P16F877A.INC>

valor1  equ h'21'		
valor2  equ h'22'		
valor3  equ h'23'
contador equ h'24'    ; Registro para el contador (0x00 a 0x0F)
cte1     equ d'56'    ; Ajustado para ~500 ms
cte2     equ d'56'    ; Ajustado para ~500 ms
cte3     equ d'55'    ; Ajustado para ~500 ms

__CONFIG _FOSC_XT & _WDTE_OFF & _PWRTE_ON & _CP_OFF  ; Configuraci�n del oscilador

ORG 00H

BCF STATUS, IRP
BCF STATUS, RP1
BSF STATUS, RP0 

BSF TRISA, 0      ; RA0 como entrada
MOVLW 0x06        ; Configura todos los pines de PORTA como digitales
MOVWF ADCON1
CLRF TRISB        ; PORTB como salida

BCF STATUS, RP0

CLRF contador     ; Inicializa el contador en 0

INICIO
    CALL MOSTRAR    ; Muestra el valor del contador
    BTFSS PORTA, 0    ; Si RA0 = 1, cuenta ascendente; si RA0 = 0, descendente
    GOTO DESCENDER
ASCENDER
    INCF contador, F  ; Incrementa el contador
    MOVLW 0x10        ; Verifica si contador alcanz� 0x10 (desborde de F)
    SUBWF contador, W
    BTFSC STATUS, Z   ; Si contador = 0x10, reinicia a 0
    CLRF contador
    GOTO INICIO

DESCENDER
    MOVF contador, F  ; Verifica si contador es 0
    BTFSC STATUS, Z   ; Si es 0, desborda a F
    GOTO SET_F
    DECF contador, F  ; Decrementa el contador
    GOTO INICIO
SET_F
    MOVLW 0x0F        ; Si desborda de 0, va a F
    MOVWF contador
    GOTO INICIO

MOSTRAR
    CALL CONVERTIR    ; Convierte el valor del contador a 7 segmentos
    MOVWF PORTB       ; Muestra en PORTB
    CALL retardo      ; Retardo para visualizaci�n
    RETURN

retardo
    movlw cte1
    movwf valor1
tres
    movlw cte2
    movwf valor2
dos
    movlw cte3
    movwf valor3
uno
    decfsz valor3
    goto uno
    decfsz valor2
    goto dos
    decfsz valor1
    goto tres
    return

CONVERTIR
    MOVF contador, W  ; Carga el valor del contador en W
    ADDWF PCL, F      ; Salta a la tabla seg�n el valor del contador
    RETLW B'10111111' ; 0
    RETLW B'10000110' ; 1
    RETLW B'11011011' ; 2
    RETLW B'11001111' ; 3
    RETLW B'11100110' ; 4
    RETLW B'11101101' ; 5
    RETLW B'11111100' ; 6
    RETLW B'10000111' ; 7
    RETLW B'11111111' ; 8
    RETLW B'11100111' ; 9
    RETLW B'11110111' ; A
    RETLW B'11111100' ; B
    RETLW B'10111001' ; C
    RETLW B'11011110' ; D
    RETLW B'11111001' ; E
    RETLW B'11110001' ; F

END