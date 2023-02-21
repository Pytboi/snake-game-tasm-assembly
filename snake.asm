IDEAL
MODEL small
STACK 256

DATASEG
snake_x dw 20 dup (24,24,36,48,60,72,84,96,108,120,132,144,156,168,180,192,204,216,228,240)
snake_y dw 20 dup (100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100)
stam dw 70 ;to fix a weird p problem, has no use
colors dw 79,70,79,70,79,70,79,70,79,70,79,70,79,70,79,70,79,70,79,70,79,70,79,70,79,70,79,70,79,70
SNAKE_LENGTH dw 6h
apple_x dw 0
apple_y dw 0
snake_max_length dw 20
in_bool dw 0
dir db 'w'
ate_bool db 0
game_over_message db "GAME OVER. heheheha",13,10,"To play again, press any key. to quit, press Q$"
CODESEG
proc graphic_mode
    push ax
    mov ah, 00h
    mov al, 13h
    int 10h
    pop ax
    ret
endp
proc set_background
    push ax
    push bx

    mov ah, 0Bh
    mov bh, 00h
    mov bl, 0Fh
    int 10h

    pop bx
    pop ax
    ret
endp
proc paint_pix
	push ax
	push bx
;assum cx = x, dx = y, al = color
	mov bh,0h
	mov ah,0ch
	int 10h
	pop bx
	pop ax
	ret
endp
proc square13;pushed color, x and then y
	push bp
	mov bp,sp
	push ax
	push bx
	push cx
	push dx
	push si
	push di
	mov si,13*13
	mov dx,[bp+4]
	mov bx,dx
	add bx,7
	mov cx,[bp+6]
	sub cx,6
	sub dx,6
	mov ax,[bp+8]
draw_loop_square:;print a square size 13 givn a point (x,y)
	call paint_pix
	inc dx
	cmp dx,bx
	je conti_square
	dec si
	jmp draw_loop_square
conti_square:
	push bx
	sub bx,13
	mov dx,bx
	pop bx
	inc cx
	dec si
	cmp si,0
	jne draw_loop_square
	pop bp
	pop di
	pop si
	pop bx
	pop cx
	pop bx
	pop ax
	ret 6
endp
proc get_dir
	push ax
	mov ax,1
	int 16h
	mov [dir],al
	cmp [dir], 'q'
	jne enddir
	mov ax, 4c00h
	int 21h
enddir:	
	pop ax
	ret
endp
proc draw_snake
	push ax
	push cx
	push si
	mov ax,[SNAKE_LENGTH]
	mov cx,2
	mul cx
	dec ax
	dec ax
	mov cx,ax
	push [SNAKE_LENGTH]
	mov [SNAKE_LENGTH],ax
	
print_loop_snake:
	push cx
	mov si,SNAKE_LENGTH
	sub si,cx
	push [colors+si]
	push [snake_x+si]
	push [snake_y+si]
	call square13
	pop cx
	loop print_loop_snake
	mov si,[SNAKE_LENGTH]
	push 16
	push [snake_x+si]
	push [snake_y+si]
	call square13
	pop [SNAKE_LENGTH]
	pop si
	pop cx
	pop ax
	ret 6
endp
proc update_snake
	push ax
	push cx
	push si
	call get_dir
	cmp [dir],'w'
	je up
	cmp [dir],'s'
	je down
	cmp [dir],'a'
	je left
;right
	call move_right
	jmp end_update
left:
	call move_left
	jmp end_update
down:
	call move_down
	jmp end_update
up:
	call move_up
end_update:
	pop si
	pop cx
	pop ax
	ret
endp
proc move_right
	push ax
	push bx
	push cx
	push si
	push dx
	mov cx,[SNAKE_LENGTH]
	push [snake_y]
	push [snake_x]
	add [snake_x],13
	pop bx
	pop dx
	dec cx
update_snake_right_loope:
	push dx
	mov si,[SNAKE_LENGTH]
	sub si,cx
	mov ax,si
	mov si,2
	mul si
	mov si,ax
	pop dx
	push [snake_y+si]
	mov [snake_y+si],dx
	pop dx
	push [snake_x+si]
	mov [snake_x+si],bx
	pop bx
	loop update_snake_right_loope
	pop dx
	pop si
	pop cx
	pop bx
	pop ax
	ret 
endp
proc move_left
	push ax
	push bx
	push cx
	push si
	push dx
	mov cx,[SNAKE_LENGTH]
	push [snake_y]
	push [snake_x]
	sub [snake_x],13
	pop bx
	pop dx
	dec cx
update_snake_left_loope:
	push dx
	mov si,[SNAKE_LENGTH]
	sub si,cx
	mov ax,si
	mov si,2
	mul si
	mov si,ax
	pop dx
	push [snake_y+si]
	mov [snake_y+si],dx
	pop dx
	push [snake_x+si]
	mov [snake_x+si],bx
	pop bx
	loop update_snake_left_loope
	pop dx
	pop si
	pop cx
	pop bx
	pop ax
	ret 
endp
proc move_down
	push ax
	push bx
	push cx
	push si
	push dx
	mov cx,[SNAKE_LENGTH]
	push [snake_x]
	push [snake_y]
	add [snake_y],13
	pop bx
	pop dx
	dec cx
update_snake_down_loope:
	push dx
	mov si,[SNAKE_LENGTH]
	sub si,cx
	mov ax,si
	mov si,2
	mul si
	mov si,ax
	pop dx
	push [snake_x+si]
	mov [snake_x+si],dx
	pop dx
	push [snake_y+si]
	mov [snake_y+si],bx
	pop bx
	loop update_snake_down_loope
	pop dx
	pop si
	pop cx
	pop bx
	pop ax
	ret
endp
proc move_up
	push ax
	push bx
	push cx
	push si
	push dx
	mov cx,[SNAKE_LENGTH]
	push [snake_x]
	push [snake_y]
	sub [snake_y],13
	pop bx
	pop dx
	dec cx
update_snake_up_loope:
	push dx
	mov si,[SNAKE_LENGTH]
	sub si,cx
	mov ax,si
	mov si,2
	mul si
	mov si,ax
	pop dx
	push [snake_x+si]
	mov [snake_x+si],dx
	pop dx
	push [snake_y+si]
	mov [snake_y+si],bx
	pop bx
	loop update_snake_up_loope
	pop dx
	pop si
	pop cx
	pop bx
	pop ax
	ret
endp
proc generate_random_position ; to place the apple in a random point on the map
	push ax
	push dx
	push cx
	push bx
  ; Seed the random number generator
	mov ah, 2Ch
	int 21h
	mov cl, al
	mov ch, ah
	xor ah, ah
	mov al, cl
	mul ch
	add ax, dx
	mov cx, ax
  
; Generate random X and Y position
	mov ax, cx
	xor dx, dx
	mov bx,39
	div bx
	cmp al,12
	jle continu1
	add al,12
continu1:	
	xor ah,ah
	mov [apple_x], ax
	mov ax, cx
	xor dx, dx
	mov bx,24
	div bx
	cmp al,12
	jle conti2
	add al,12
conti2:	
	xor ah,ah
	mov [apple_y], ax
	push 40
	push [word ptr apple_x]
	push [word ptr apple_y]
	call square13
	pop bx
	pop cx
	pop dx
	pop ax
	ret
endp
proc check_snake_hit
	push ax
	push bx
	push cx
	push dx
	push si
	cmp [snake_x],5
	jle died
	cmp [snake_x],314
	jge died
	cmp [snake_y],5
	jle died
	cmp [snake_y],194
	jge died
	jmp check_hit_itself
died:
	call game_over
check_hit_itself:
	mov cx,[SNAKE_LENGTH]
	dec cx
hitself:
	mov si,[SNAKE_LENGTH]
	sub si,cx
	mov ax,si
	mov si,2
	mul si
	mov si,ax
	mov ax,[snake_x]
	cmp [snake_x+si],ax
	jne conti_check_hit
	mov ax,[snake_y]
	cmp [snake_y+si],ax
	jne conti_check_hit
	call game_over
conti_check_hit:
	loop hitself
;check ate apple
	mov bx,[apple_x]
	mov ax,[snake_x]
	sub ax,7
	mov cx,13
apple_x_loop:
	cmp ax,bx
	je apple_y_test
	inc ax
	loop apple_x_loop
	jmp end_check
apple_y_test:
	mov bx,[apple_y]
	mov ax,[snake_y]
	sub ax,7
	mov cx,13
apple_y_loop:
	cmp ax,bx
	je ate_apple
	inc ax
	loop apple_y_loop
	jmp end_check
ate_apple:
	inc [SNAKE_LENGTH]
	call generate_random_position
end_check:
	pop si
	pop dx
	pop cx
	pop bx
	pop ax
	ret
endp
proc game_over
	mov ah,0
	mov al,2
	int 10h
; Display game over message
	mov ah, 9
	mov dx, offset game_over_message
	int 21h
; Wait for user to press a key
    mov ah, 00h
    int 16h
	cmp al, 'q'
	jne start
	mov ax, 4c00h
	int 21h
endp
start:
    mov ax, @data
    mov ds, ax	
	;not bad, to fix!
	call graphic_mode
	call generate_random_position
game_loop:	
	call update_snake
	call draw_snake
	call check_snake_hit
	jmp game_loop
exit:
    mov ax, 4C00h
    int 21h
END start
