INCLUDE \masm32\Irvine\Irvine32.inc
INCLUDE \masm32\Irvine\macros.inc

INCLUDELIB \masm32\Irvine\Irvine32.lib
includelib \masm32\Irvine\User32.lib
includelib \masm32\Irvine\Kernel32.lib

.DATA
x REAL8 5.83 ;res = 35.937
y REAL8 3.45 ;res = 35.937


numerador REAL8 ?
contador DWord 0
.code
main PROC
    finit   ; starts up the FPU
    call ShowFPUStack
    mov ebx, 10 ; Esto es la potencia a la que se va a elevar
    fld x
    fld x
    push ebx
    call eleva
    fst numerador
    call WriteFloat
    
    call Crlf

    exit	
main ENDP

; =============================== Procedimiento para elevar un número flotante a una potencia entera ===================================================
eleva PROC
; Recibe un flotante REAL8 y regresa la respuesta en el mismo formato. Comunicación a través del stack de ejecución de ida y del FPU de regreso 
; Receives: REAL8
; Returns: REAL8
; Requires: contador DWORD
;---------------------------------------------------------
    
    pop ecx ; Registro para regresar
    pop ebx ; Potencia a la que se eleva
    mov contador, 1
    .WHILE contador < ebx
        fmul ST(0), ST(1)
    inc contador
    .ENDW 
    push ecx
    RET
eleva ENDP


END main