INCLUDE \masm32\Irvine\Irvine32.inc
INCLUDE \masm32\Irvine\macros.inc

INCLUDELIB \masm32\Irvine\Irvine32.lib
includelib \masm32\Irvine\User32.lib
includelib \masm32\Irvine\Kernel32.lib

.DATA
primera DWORD 00000014h
segunda DWORD 4C3B2800h
grande QWORD ?
denominador REAL8 ?

.CODE
main PROC
    finit
    mov 0, segunda

    
    exit	
main ENDP

END main
