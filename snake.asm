IDEAL
MODEL small
STACK 256

DATASEG
snake_x dw 600 dup (24,24,36,48,60,72,84,96,108,120,132,144,156,168,180,192,204,216,228,240)
snake_y dw 600 dup (100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100)
stam dw 70 ;to fix a weird p problem, has no use
colors dw 79,70,79,70,79,70,79,70,79,70,79,70,79,70,79,70,79,70,79,70,79,70,79,70,79,70,79,70,79,70,79,70,79,70,79,70,79,70,79,70,79,70,79,70,79,70,79,70,79,70,79,70,79,70,79,70,79,70,79,70
SNAKE_LENGTH dw 6h
apple_x dw 0
apple_y dw 0
prev_apple_x dw 0
prev_apple_y dw 0
snake_max_length dw 20
in_bool dw 0
dir db 'd'
ate_bool db 0
game_over_message db 10,13,10,13,10,13,"                              TO BAD, YOU LOSE",10,13,10,13,10,13,10,13
db "			  _____          __  __ ______  ",10,13 
db " 			 / ____|   /\   |  \/  |  ____|",10,13 
db " 			| |  __   /  \  | \  / | |__ ",10,13 
db " 			| | |_ | / /\ \ | |\/| |  __| ",10,13 
db "			| |__| |/ ____ \| |  | | |____",10,13 
db "  			 \_____/_/    \_\_|__|_|______|",10,13 
db " 			  / __ \ \    / /  ____|  __ \   ",10,13 
db " 			 | |  | \ \  / /| |__  | |__) |  ",10,13 
db " 			 | |  | |\ \/ / |  __| |  _  /   ",10,13 
db "			 | |__| | \  /  | |____| | \ \   ",10,13 
db " 			  \____/   \/   |______|_|  \_\  ",10,13,10,13,10,13
db "heheheha",13,10,"To play again, press any key. to quit, press Q$"
win_message db "CONGRATULATIONS", 10,13
db " 		__     ______  _    _  __          _______ _   _    ",10,13
db " 		\ \   / / __ \| |  | | \ \        / /_   _| \ | |   ",10,13
db " 		 \ \_/ / |  | | |  | |  \ \  /\  / /  | | |  \| |   ",10,13
db " 		  \   /| |  | | |  | |   \ \/  \/ /   | | | . ` |   ",10,13
db " 		   | | | |__| | |__| |    \  /\  /   _| |_| |\  |   ",10,13
db " 		   |_|  \____/ \____/      \/  \/   |_____|_| \_|   ",10,13
db " __      _______ _____ _______ ____  _______     ___ ",10,13
db " \ \    / /_   _/ ____|__   __/ __ \|  __ \ \   / / |	",10,13
db "  \ \  / /  | || |       | | | |  | | |__) \ \_/ /| |	",10,13
db "   \ \/ /   | || |       | | | |  | |  _  / \   / | |	",10,13
db "    \  /   _| || |____   | | | |__| | | \ \  | |  |_|	",10,13
db "     \/   |_____\_____|  |_|  \____/|_|  \_\ |_|  (_)	",10,13
db "To play again, press any key. to quit, press Q",10,13,"$"
starting_screen_msg db " _______  _        _______  _        _______ ",10,13
db "(  ____ \( (    /|(  ___  )| \    /\(  ____ \ ",10,13
db "| (    \/|  \  ( || (   ) ||  \  / /| (    \/",10,13
db "| (_____ |   \ | || (___) ||  (_/ / | (__    ",10,13
db "(_____  )| (\ \) ||  ___  ||   _ (  |  __)   ",10,13
db "      ) || | \   || (   ) ||  ( \ \ | (      ",10,13
db "/\____) || )  \  || )   ( ||  /  \ \| (____/\ ",10,13
db "\_______)|/    )_)|/     \||_/    \/(_______/",10,13,10,13,10,13
db "by Dror Levy",10,13
db "To pause, press P",10,13
db "If you want to quit, press Q",10,13
db "press any key to start",10,13,"$" 
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
    mov bl, 18
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
proc square5;pushed color, x and then y
	push bp
	mov bp,sp
	push ax
	push bx
	push cx
	push dx
	push si
	push di
	mov si,49
	mov dx,[bp+4]
	mov bx,dx
	add bx,5
	mov cx,[bp+6]
	sub cx,2
	sub dx,2
	mov ax,[bp+8]
draw_loop_square9:;print a square size 13 givn a point (x,y)
	call paint_pix
	inc dx
	cmp dx,bx
	je conti_square9
	dec si
	jmp draw_loop_square9
conti_square9:
	push bx
	sub bx,7
	mov dx,bx
	pop bx
	inc cx
	dec si
	cmp si,0
	jne draw_loop_square9
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
    mov ah, 01H
    int 16H
    jnz keybdpressed
    xor dl, dl
    ret
keybdpressed:
    ;extract the keystroke from the buffer
    mov ah, 00H
    int 16H
    mov [dir],al
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
	cmp [dir],'q'
	je quit_lable
	cmp [dir],'p'
	je pause_tag
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
	jmp end_update
quit_lable:
	mov ax,4c00h
	int 21h
pause_tag:
	push 9663
	call play_beep
	call wait_tenth
	push 9121
	call play_beep
	call wait_tenth
	push 8126
	call play_beep
	call wait_tenth
	call stop_beep
	mov ah,0
	int 16h
	cmp al,'Q'
	je quit_lable
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
start_generate:
	mov ah, 2Ch
	int 21h
	mov cl, al
	mov ch, ah
	xor dh, dl
	mov al, cl
	mul ch
	add ax, dx
	mov cx, ax
  
; Generate random X and Y position
	mov ax, cx
	xor dx, dx
	mov bx,39
	div bx
	xor ah,ah
	mov [apple_x], ax
	mov ax, cx
	xor dx, dx
	mov bx,24
	div bx
	xor ah,ah
	mov [apple_y], ax
	cmp [apple_y],180
	jl conti
	mov [apple_y],160
	cmp [apple_y],26
	jg conti
	mov [apple_y],70
	cmp [apple_x],297
	jl conti
	sub [apple_x],20
	cmp [apple_x],19
	jg conti
	add [apple_x],17
conti:
	push 40
	push [apple_x]
	push [apple_y]
	call square5
	pop bx
	pop cx
	pop dx
	pop ax
	ret  ;get_dir
endp
proc check_snake_hit
	push ax
	push bx
	push cx
	push dx
	push si
	cmp [snake_x],3
	jle died
	cmp [snake_x],317
	jge died
	cmp [snake_y],3
	jle died
	cmp [snake_y],197
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
	sub ax,8
	mov cx,15
apple_x_loop:
	cmp ax,bx
	je apple_y_test
	inc ax
	loop apple_x_loop
	jmp end_check
apple_y_test:
	mov bx,[apple_y]
	mov ax,[snake_y]
	sub ax,8
	mov cx,15
apple_y_loop:
	cmp ax,bx
	je ate_apple
	inc ax
	loop apple_y_loop
	jmp end_check
ate_apple:
	inc [SNAKE_LENGTH]
	push 16
	push [apple_x]
	push [apple_y]
	call square5
	push 2711
	call play_beep
	call wait_tenth
	push 2415
	call play_beep
	call wait_tenth;2031, 2711, 1612, 1,1, 1612
	push 2031
	call play_beep
	call wait_tenth
	push 2711
	call play_beep
	call stop_beep
	mov ax,[snake_max_length]
	cmp [SNAKE_LENGTH],ax
	jl not_win
	call win
not_win:	
	call generate_random_position
end_check:
	pop si
	pop dx
	pop cx
	pop bx
	pop ax
	ret
endp
proc harder
	cmp [SNAKE_LENGTH],9
	jl not_hard
	cmp [SNAKE_LENGTH],16
	jl hard1
	cmp [SNAKE_LENGTH],26
	jl hard2
	cmp [SNAKE_LENGTH],30
	jl hard3
	cmp [SNAKE_LENGTH],38
	jl hard4
not_hard:
	call wait_tenth
	call wait_tenth
	call wait_tenth
	call wait_tenth
	jmp harder_end
hard1:
	call wait_tenth
	call wait_tenth
	call wait_tenth
	jmp harder_end
hard2:
	call wait_tenth
	call wait_tenth
	jmp harder_end
hard3:
	call wait_tenth
	call wait_tenth
	jmp harder_end
hard4:
	call wait_tenth
harder_end:
	ret
endp
proc wait_tenth
    push ax
    push cx
    push dx
    mov ah, 86h
    mov cx, 0001h
    mov dx, 012A0h
    int 15h
    pop dx
    pop cx
    pop ax
    ret
endp
proc play_beep ; divisor
    push bp
    mov bp, sp
    push ax
    in al, 61h ; Open speaker
    or al, 00000011b
    out 61h, al
    mov al, 0B6h ; Send control word to change frequency
    out 43h, al
    mov ax, [bp+4] ; Play divisor
    out 42h, al ; Sending lower byte
    mov al, ah
    out 42h, al ; Sending upper byte
    pop bp
    pop ax
    ret 2
endp
proc stop_beep
    push ax
    in al, 61h
    and al, 11111100b
    out 61h, al
    pop ax
    ret
endp
proc win
	mov ah,0
	mov al,2
	int 10h
; Display game over message
	mov ah, 9
	mov dx, offset win_message
	int 21h
	; 2711, 2415, 2031, 2711, 1612, 1,1, 1612, 1,1, 1809, 1,1,1,1, 2711, 2415, 2031, 2711, 1809, 1,1, 1809, 1,1, 2031, 1, 2152, 2415, 1,1, 2711, 2415, 2031, 2711, 2031, 1,1,1, 1809, 1, 2152, 1,1,1, 2711, 1,1, 2711, 1,1, 1809, 1,1, 2031
    push 2711
    call play_beep
    call wait_tenth
    push 2415
    call play_beep
    call wait_tenth
    push 2031
    call play_beep
    call wait_tenth
    push 2711
    call play_beep
    call wait_tenth
    push 1612
    call play_beep
    call wait_tenth
    push 1
    call play_beep
    call wait_tenth
    push 1
    call play_beep
    call wait_tenth
    push 1612
    call play_beep
    call wait_tenth
    push 1
    call play_beep
    call wait_tenth
    push 1
    call play_beep
    call wait_tenth
    push 1809
    call play_beep
    call wait_tenth
    push 1
    call play_beep
    call wait_tenth
    push 1
    call play_beep
    call wait_tenth
    push 1
    call play_beep
    call wait_tenth
    push 1
    call play_beep
    call wait_tenth
    push 2711
    call play_beep
    call wait_tenth
    push 2415
    call play_beep
    call wait_tenth
    push 2031
    call play_beep
    call wait_tenth
    push 2711
    call play_beep
    call wait_tenth
    push 1809
    call play_beep
    call wait_tenth
    push 1
    call play_beep
    call wait_tenth
    push 1
    call play_beep
    call wait_tenth
    push 1809
    call play_beep
    call wait_tenth
    push 1
    call play_beep
    call wait_tenth
    push 1
    call play_beep
    call wait_tenth
    push 2031
    call play_beep
    call wait_tenth
    push 1
    call play_beep
    call wait_tenth
    push 2152
    call play_beep
    call wait_tenth
    push 2415
    call play_beep
    call wait_tenth
    push 1
    call play_beep
    call wait_tenth
    push 1
    call play_beep
    call wait_tenth
    push 2711
    call play_beep
    call wait_tenth
    push 2415
    call play_beep
    call wait_tenth
    push 2031
    call play_beep
    call wait_tenth
    push 2711
    call play_beep
    call wait_tenth
    push 2031
    call play_beep
    call wait_tenth
    push 1
    call play_beep
    call wait_tenth
    push 1
    call play_beep
    call wait_tenth
    push 1
    call play_beep
    call wait_tenth
    push 1809
    call play_beep
    call wait_tenth
    push 1
    call play_beep
    call wait_tenth
    push 2152
    call play_beep
    call wait_tenth
    push 1
    call play_beep
    call wait_tenth
    push 1
    call play_beep
    call wait_tenth
    push 1
    call play_beep
    call wait_tenth
    push 2711
    call play_beep
    call wait_tenth
    push 1
    call play_beep
    call wait_tenth
    push 1
    call play_beep
    call wait_tenth
    push 2711
    call play_beep
    call wait_tenth
    push 1
    call play_beep
    call wait_tenth
    push 1
    call play_beep
    call wait_tenth
    push 1809
    call play_beep
    call wait_tenth
    push 1
    call play_beep
    call wait_tenth
    push 1
    call play_beep
    call wait_tenth
    push 2031
    call play_beep
    call wait_tenth
	call stop_beep
; Wait for user to press a key
    mov ah, 00h
    int 16h
	cmp al, 'q'
	jne play_againe
	mov ax, 4c00h
	int 21h
endp
proc game_over
	mov ah,0
	mov al,2
	int 10h
; Display game over message
	mov ah, 9
	mov dx, offset game_over_message
	int 21h
	push 9663
	call play_beep
	call wait_tenth
	push 9121
	call play_beep
	call wait_tenth
	push 8126
	call play_beep
	call wait_tenth
	push 1
	call play_beep
	call wait_tenth
	push 12175
	call play_beep
	call wait_tenth
	jmp conti_gameover
play_againe:
	jmp play_again
conti_gameover:
	push 1
	call play_beep
	call wait_tenth
	push 10847
	call play_beep
	call wait_tenth
	push 1
	call play_beep
	call wait_tenth
	push 13666
	call play_beep
	call wait_tenth
	push 1
	call play_beep
	call wait_tenth
	push 14478
	call play_beep
	call wait_tenth
	call stop_beep
; Wait for user to press a key
    mov ah, 00h
    int 16h
	cmp al, 'q'
	jne play_again
	mov ax, 4c00h
	int 21h
endp
proc starting_screen
	push ax
	push dx
	call graphic_mode
	mov ah,9
	mov dx, offset starting_screen_msg
	int 21h
	mov ah,0
	int 16h
	cmp al,"Q"
	jne play_again
	mov ax,4c00h
	int 21h
	pop dx
	pop ax
	ret 
endp
start:
    mov ax, @data
    mov ds, ax
	call starting_screen
play_again:
	mov [snake_x],200
	mov [snake_y],100
	mov [SNAKE_LENGTH],2
	call graphic_mode
	call generate_random_position
	mov ah,0
	int 16h
game_loop:
	call harder
	call update_snake
	call draw_snake
	call check_snake_hit
	push 40
	push [apple_x]
	push [apple_y]
	call square5
	jmp game_loop
exit:
    mov ax, 4C00h
    int 21h
END start
;תם ונשלם
