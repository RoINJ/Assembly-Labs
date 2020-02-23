TITLE lab_4_real
.386

dseg segment para public 'data'
    arr_k db 0,0,0,1,1,0,1,0,1,1,1,1,0,0,1,0,1,1,1,0
dseg ends

sseg segment para stack 'stack'
    dw 64 DUP(?)
sseg ends

cseg segment para public 'code'
    _main proc far
    assume ds:dseg, cs:cseg, ss:sseg
    push ds
    sub ax, ax
    push ax
    ;main proc starts here
    ;using ax for current amount
    ;using dx for max amount
    mov cx, 20
    xor dx, dx
    lea bx, arr_k
    arr_loop:
        push ax
        mov al, [bx]
        cmp al, 1
            je increment
        pop ax
        xor ax, ax
        jmp end_inc
        increment:
        pop ax
        inc ax
        cmp ax, dx
            jle end_inc
        inc dx
        end_inc:
        inc bx
    loop arr_loop
    ret
    _main endp
cseg ends
    end _main