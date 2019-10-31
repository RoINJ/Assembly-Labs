.model flat
.data

varArray DB -50, -38, -19, -10, -3, 0, 3, 7, 9, 11, 15, 20, 22, 27, 28, 34, 39, 55, 89, 90, 3 dup (?)
varA DB -4
varB DB -11
varC DB 10

.code
_main PROC

MOV AL, varA
@repeat:
MOV ECX, 22
LEA EBX, varArray
@label: 
cmp AL, [EBX]
jge @NotSmaller

LEA EDX, varArray
add EDX, 22
inc CX
@label2:
MOV AH, [EDX]
MOV [EDX + 1], AH
dec EDX
loop @label2

MOV [EBX], AL
jmp @end
@NotSmaller:
inc EBX
loop @label
@end:
cmp AL, varC
je @theEnd
MOV AL, varB
MOV AH, varC
MOV varB, AH
jmp @repeat
@theEnd:

_main ENDP
end _main