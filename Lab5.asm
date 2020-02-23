    .386
    .model flat, stdcall
    option casemap :none

	include ..\include\windows.inc
    include ..\include\kernel32.inc
    includelib ..\lib\kernel32.lib

.const
	MsgStart db "Enter your sentense", 10, 13
	MsgExit db 10, 13, "Press Enter for exit", 10, 13
	SPACEANDDOT db " ."
.data
	hConsoleIn dd ?
	hConsoleOut dd ?
	
	NumberOfCharsRead dd ?		
	NumberOfCharsWritten dd ?

	Buffer db 250 dup (0)
	Result db 250 dup (0)
	ResultLen dd 0
	LastPosition dd 0

	OneWord db 8 dup (?)
	OneWordLen dd ?

.code

initialize proc near
	invoke AllocConsole

	invoke GetStdHandle, STD_INPUT_HANDLE
	mov hConsoleIn, EAX	

	invoke GetStdHandle, STD_OUTPUT_HANDLE
	mov hConsoleOut, EAX

	ret
initialize endp

prepareForFoundingSpace proc near
	MOV EBX, LastPosition
	MOV ECX, NumberOfCharsRead
	SUB ECX, EBX

	MOV OneWordLen, ECX

	lea EDI, [Buffer + EBX]
	MOV AL, ' '
	ret
prepareForFoundingSpace endp

afterFoundingSpace proc near
	SUB OneWordLen, ECX
	DEC OneWordLen
	MOV ECX, OneWordLen
	ADD LastPosition, ECX
	ret
afterFoundingSpace endp

findWord proc near
	call prepareForFoundingSpace
	repne SCASB
	call afterFoundingSpace
	INC LastPosition

	lea ESI, [Buffer + EBX]
	lea EDI, OneWord

	MOV ECX, OneWordLen
	rep MOVSB
	PUSH OneWordLen

	call prepareForFoundingSpace
	repe SCASB
	call afterFoundingSpace

	POP OneWordLen
	ret
findWord endp

checkWord proc near
	MOV ECX, OneWordLen

	CMP ECX, 1
	je @Alphabet

	DEC ECX
	lea EAX, [OneWord]

	@LOOP:
	MOV BL, [EAX]
	CMP BL, [EAX + 1]
	jg @notAlphabet
	inc EAX
	LOOP @LOOP

	@Alphabet:
	MOV ECX, OneWordLen
	lea ESI, OneWord
	MOV EBX, ResultLen
	lea EDI, [Result + EBX]
	ADD ResultLen, ECX
	rep MOVSB
	MOV ECX, ResultLen
	MOV [Result + ECX], ' '
	INC ResultLen

	@notAlphabet:
	ret
checkWord endp

start:
	
	call initialize
	
	invoke WriteConsoleA, hConsoleOut, ADDR MsgStart, SIZEOF MsgStart, ADDR NumberOfCharsWritten, 0
	
	invoke ReadConsoleA, hConsoleIn, ADDR Buffer, 250, ADDR NumberOfCharsRead, 0

	lea ESI, SPACEANDDOT
	MOV EAX, NumberOfCharsRead
	DEC NumberOfCharsRead
	SUB EAX, 3
	lea EDI, [Buffer + EAX]
	MOV ECX, 2
	rep MOVSB
	
	
	@mainLoop:
	MOV EBX, LastPosition
	CMP [Buffer + EBX], '.'
	je @COMPLETE

	call findWord
	call checkWord
	
	jmp @mainLoop
	

	@COMPLETE:
	;Result
	invoke WriteConsoleA, hConsoleOut, ADDR Result, SIZEOF Result, ADDR NumberOfCharsWritten, 0
	;Exit
	invoke WriteConsoleA, hConsoleOut, ADDR MsgExit, SIZEOF MsgExit, ADDR NumberOfCharsWritten, 0
	invoke ReadConsoleA, hConsoleIn, ADDR Buffer, 1, ADDR NumberOfCharsRead, 0
	invoke ExitProcess, 0
	
end start