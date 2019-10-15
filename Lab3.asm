.model flat
.data
varA DB -5
varB DB -4
varC DB 10

absAplusB DB ?
varY DW ?

.code
_main PROC

MOV AL, varA
add AL, varB
@abs:
neg AL
js @abs
MOV absAplusB, AL

CMP AL,varC
je @equals ;Если они равны
jg @bigger ;Больше
jl @smaller ;Меньше
	
@equals:
add absAplusB, 2
MOV AL, absAplusB
CBW
MOV BX, AX ;BX = |a+b| + 2
MOV AL, varA
imul varB ;AX = a * b
MOV CX, AX ;CX = a * b
MOV AL, varC
CBW ;AX = c
imul CX ;DX:AX = a * b * c
idiv BX ;AX = (a * b * c)/(|a+b| + 2)
jmp @endif

@bigger:
MOV AL, varA
CMP AL, varB
jge @label11
MOV AL, varB
@label11:
CMP AL, varC
jge @label12
MOV AL, varC
@label12:
CBW
jmp @endif

@smaller:
MOV AL, varA
CMP AL, varB
jle @label21
MOV AL, varB
@label21:
CMP AL, varC
jle @label22
MOV AL, varC
@label22:
CBW
jmp @endif

@endif:
MOV varY, AX

_main ENDP
end _main