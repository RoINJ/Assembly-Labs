.model flat
.data
var1 DW 'QQ'
var2 DB 'some text'
var3 DB 'A'
.code
_main PROC

;1
MOV AX, var1 ;Word Register - Direct

;2
MOV BH, 'H' ;Bite Register - Immediate

;3
;MOV DS, AX ;Segment Register - Word Register

;4
MOV var2, BH ;Direct - Bite Register

;5
MOV CX, var1 ;Word Register - Direct

;6
MOV var3, BH ;Direct - Bite Register
_main ENDP
end _main