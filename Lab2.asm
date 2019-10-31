.model flat
.data
a DB 6
b DB 4
x DW -20
y DW ?

.code
_main PROC

; y = 2(a+b)x-x/(a+b)+(x^3)/5
; -400 -(-2) + (-1600) = -1998
MOV AL, a
add AL, b ;AL = 10
CBW
MOV BX, AX ;BX = 10 (a + b)
MOV CL, 2
imul CL ;AX = 20 2*(a+b)
imul x ;DX:AX = -400 2*(a+b)*x 
MOV y, AX ;y = -400 2*(a+b)*x

MOV AX, x
CWD
idiv BX ;AX = -2 x/(a+b)
sub y, AX ;y = -398 2(a+b)x-x/(a+b)

MOV AX, x
imul x ;DX:AX = 400 (x^2)
imul x ;DX:AX = -8000 (x^3)
MOV CX, 5
idiv CX ;AX = -1600 (x^3)/5
add y, AX ;y = -1998

_main ENDP
end _main