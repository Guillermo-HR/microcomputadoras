; Encabezado
INCLUDE <P16F877A.INC>

; Definiciones
    ; Retardo
valor1  equ h'21'		
valor2  equ h'22'		
valor3  equ h'23'
cte1     equ d'56'    ; Ajustado para ~500 ms
cte2     equ d'56'    ; Ajustado para ~500 ms
cte3     equ d'55'    ; Ajustado para ~500 ms
    ; Contadores
contadorU equ h'24'    ; Registro para el contador de unidades (0x00 a 0x09)
contadorD equ h'25'    ; Registro para el contador de decenas (0x00 a 0x09)

__CONFIG _FOSC_XT & _WDTE_OFF & _PWRTE_ON & _CP_OFF  ; Configuraci�n del oscilador

; Inicio del programa
ORG 00H

; Configurar I/O
BCF STATUS, IRP   
BCF STATUS, RP1   ; Selecciona el banco 1
BSF STATUS, RP0   ; Selecciona el banco 1

BSF TRISA, 0      ; RA0 como entrada
MOVLW 0x06        ; Configura todos los pines de PORTA como digitales
MOVWF ADCON1
CLRF TRISD        ; PORTD como salida
CLRF TRISB        ; PORTB como salida

BCF STATUS, RP0   ; Selecciona el banco 0

; Inicializar variables
CLRF contadorU     ; Inicializa el contador de unidades en 0
CLRF contadorD     ; Inicializa el contador de decenas en 0

INICIO
    CALL MOSTRAR    ; Muestra el valor del contador
    BTFSS PORTA, 0    ; Si RA0 = 1, cuenta ascendente; si RA0 = 0, descendente
    GOTO DESCENDENTE

ASCENDENTE
    INCF contadorU, F  ; Incrementa el contador de unidades
    MOVLW 0x0A        ; Verifica si contador alcanz� 0x0A (desborde de 9)
    SUBWF contadorU, W
    BTFSC STATUS, Z   ; Si contador = 0x0A, reinicia a 0
    GOTO AUMENTAR_D
    GOTO INICIO

AUMENTAR_D
    CLRF contadorU    ; Reinicia el contador de unidades
    INCF contadorD, F  ; Incrementa el contador de decenas
    MOVLW 0x0A        ; Verifica si contador alcanz� 0x0A (desborde de 9)
    SUBWF contadorD, W
    BTFSC STATUS, Z   ; Si contadord = 0x0A, reinicia a 0
    CLRF contadorD
    GOTO INICIO

DESCENDENTE
    DECF contadorU, F  ; Decrementa el contador de unidades
    MOVLW 0xFF        ; Verifica si contador alcanz� 0xFF (desborde de 0)
    SUBWF contadorU, W
    BTFSC STATUS, Z   ; Si contador = 0xFF, reinicia a 9
    GOTO DISMINUIR_D
    GOTO INICIO

DISMINUIR_D
    MOVLW 0X09        ; Verifica si contador alcanz� 0xFF (desborde de 0)
    MOVWF contadorU    ; Si contador = 0xFF, reinicia a 9
    DECF contadorD, F  ; Decrementa el contador de decenas
    MOVLW 0xFF        ; Verifica si contador alcanz� 0xFF (desborde de 0)
    SUBWF contadorD, W
    BTFSS STATUS, Z   ; Si contador = 0xFF, reinicia a 9
    GOTO INICIO
    MOVLW 0X09        ; Verifica si contador alcanz� 0xFF (desborde de 0)
    MOVWF contadorD    ; Si contador = 0xFF, reinicia a 9
    GOTO INICIO

MOSTRAR
    MOVF contadorD, W  ; Mueve el valor del contador a W
    CALL CONVERTIR   ; Convierte el valor a BCD
    MOVWF PORTD      ; Muestra el valor en el display
    MOVF contadorU, W  ; Mueve el valor del contador a W
    CALL CONVERTIR   ; Convierte el valor a BCD
    MOVWF PORTB      ; Muestra el valor en el display
    CALL RETARDO     ; Espera 250 ms
    RETURN

CONVERTIR
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

RETARDO
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
END